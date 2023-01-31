The latest prerequisite and software installation steps are documented in the [Getting Started](https://docs.oracle.com/en/operating-systems/olcne/start/) guide. 
This is a site-specific example to validate conformance and not to be used in production. Users should review the _Getting Started_ guide to understand the reasoning behind the choices made, especially in relation to security. 
***
Oracle Cloud Native Environment uses three open source tools to simplify the installation and management of Kubernetes and other CNCF projects as objects called modules.
These include: Platform API Server `olcne-api-server`, Platform Agent `olcne-agent` and Platform Command-Line Interface `olcnectl`

This deployment uses six Oracle Linux 8 nodes; one operator node, three control plane nodes and two worker nodes.
It is expected that an administrator user opc is present on each node.
1. (On all nodes) Enable necessary dnf repositories
    ~~~
    sudo dnf install -y oracle-olcne-release-el8
    sudo dnf config-manager --enable ol8_olcne_15 ol8_addons ol8_baseos_latest ol8_UEKR6
    sudo dnf config-manager --disable ol8_olcne_14
    ~~~
2. Install RPMS
    - On operator node
        `sudo dnf install -y olcnectl olcne-api-server olcne-utils`
    - On control plane and worker nodes
        `sudo dnf install -y olcne-agent olcne-utils`
3. Configure Firewalls
    - On operator node
    ~~~
    sudo firewall-cmd --add-port=8091/tcp --permanent
    sudo firewall-cmd --reload
    ~~~
    - On control plane nodes
    ~~~
    sudo firewall-cmd --add-interface=cni0 --zone=trusted --permanent 
    sudo firewall-cmd --add-port=8090/tcp --permanent
    sudo firewall-cmd --add-port=10250/tcp --permanent
    sudo firewall-cmd --add-port=10255/tcp --permanent
    sudo firewall-cmd --add-port=8472/udp --permanent
    sudo firewall-cmd --add-port=10252/tcp --permanent
    sudo firewall-cmd --add-port=10251/tcp --permanent
    sudo firewall-cmd --add-port=2379/tcp --permanent
    sudo firewall-cmd --add-port=2380/tcp --permanent
    sudo firewall-cmd --add-port=6443/tcp --permanent
    sudo firewall-cmd --add-port=6444/tcp --permanent
    sudo firewall-cmd --add-protocol=vrrp --permanent
    sudo firewall-cmd --reload
    ~~~
    - On worker nodes
    ~~~
    sudo firewall-cmd --add-interface=cni0 --zone=trusted --permanent 
    sudo firewall-cmd --add-port=8090/tcp --permanent
    sudo firewall-cmd --add-port=10250/tcp --permanent
    sudo firewall-cmd --add-port=10255/tcp --permanent
    sudo firewall-cmd --add-port=8472/udp --permanent
    sudo firewall-cmd --reload
    ~~~
4. Configure and start services
    - On operator node
    ~~~
    sudo systemctl enable --now olcne-api-server.service
    ~~~
5. Configure example X.509 certificates
    - On the operator node
    ~~~
    cd /etc/olcne
    sudo ./gen-certs-helper.sh \
       --cert-request-organization-unit "My Company Unit" \
       --cert-request-organization "My Company" \
       --cert-request-locality "My Town" \
       --cert-request-state "My State" \
       --cert-request-country US \
       --cert-request-common-name cloud.example.com \
       --nodes operator.example.com,cpln1.example.com,cpln2.example.com,cpln3.example.com,wkr1.example.com,wkr2.example.com
    ~~~
6. Distribute example X.509 certificates
    - On the operator node
    ~~~
    ssh-keygen -N '' -f ~/.ssh/id_rsa
    for HOST in operator.example.com cpln1.example.com cpln2.example.com cpln3.example.com \
                wkr1.example.com wkr2.example.com
    do
        ssh-copy-id ${HOST}
    done
    bash -ex /etc/olcne/configs/certificates/olcne-tranfer-certs.sh
    ~~~
7. [Configure X.509 certificates for externalIPs Kubernetes Service](https://docs.oracle.com/en/operating-systems/olcne/start/install.html#certs-setup-ext-ips) 
8. Initialize `olcne-api-server` and `olcne-agent` services
    - On operator node
        `sudo /etc/olcne/bootstrap-olcne.sh --secret-manager-type file --olcne-node-cert-path /etc/olcne/configs/certificates/production/node.cert --olcne-ca-path /etc/olcne/configs/certificates/production/ca.cert --olcne-node-key-path /etc/olcne/configs/certificates/production/node.key --olcne-component api-server`
    - On control plane nodes
        `sudo /etc/olcne/bootstrap-olcne.sh --secret-manager-type file --olcne-node-cert-path /etc/olcne/configs/certificates/production/node.cert --olcne-ca-path /etc/olcne/configs/certificates/production/ca.cert --olcne-node-key-path /etc/olcne/configs/certificates/production/node.key --olcne-component agent`
    - On worker nodes
        `sudo /etc/olcne/bootstrap-olcne.sh --secret-manager-type file --olcne-node-cert-path /etc/olcne/configs/certificates/production/node.cert --olcne-ca-path /etc/olcne/configs/certificates/production/ca.cert --olcne-node-key-path /etc/olcne/configs/certificates/production/node.key --olcne-component agent`
9. Define site-specific variables
    - On the operator node
    ~~~
    export certificate_dir="/etc/olcne/configs/certificates/production/"
    export externalip_certs_dir="/etc/olcne/configs/certificates/restrict_external_ip/production/"
    export api_server=operator.example.com:8091
    export control_plane_addr=cpln1.example.com:8090,cpln2.example.com:8090,cpln3.example.com:8090
    export worker_addr=wkr1.example.com:8090,wkr2.example.com:8090
    export lb_ip=100.100.231.203
    ~~~
10. Create an environment, an instance of a Oracle Cloud Native Environment deployment
    - On the operator node
    ~~~
    olcnectl \
        --api-server $api_server \
        --olcne-ca-path ${certificate_dir}/ca.cert \
        --olcne-node-cert-path ${certificate_dir}/node.cert \
        --olcne-node-key-path ${certificate_dir}/node.key \
        --update-config \
        environment create \
            --environment-name test-environment
    ~~~
11. Create the Kubernetes module definition within that environment
    - On the operator node
    ~~~
    olcnectl module create \
        --environment-name test-environment \
        --module kubernetes \
        --name test-module-kube \
        --container-registry container-registry.oracle.com/olcne \
        --master-nodes ${control_plane_addr} \
        --worker-nodes ${worker_addr} \
        --virtual-ip ${lb_ip} \
        --restrict-service-externalip=true \
        --restrict-service-externalip-ca-cert=${externalip_certs_dir}/ca.cert \
        --restrict-service-externalip-tls-cert=${externalip_certs_dir}/node.cert \
        --restrict-service-externalip-tls-key=${externalip_certs_dir}/node.key \
        --selinux enforcing
    ~~~
12. Validate and deploy the Kubernetes module within that environment
    - On the operator node
    ~~~
    olcnectl --environment-name test-environment \
        --name test-module-kube \
        module validate
    olcnectl --environment-name test-environment \
        --name test-module-kube \
        module install
    ~~~
    1. Verify Kubernetes state before executing conformance test
       - On the operator node
       Configure `kubectl`
       ~~~
       mkdir "$HOME/.kube"
       olcnectl module property get \
           --environment-name test-environment \
           --name test-module-kube \
           --property kubecfg | base64 -d > "$HOME/.kube/config"
       kubectl get nodes
       NAME                  STATUS   ROLES    	      AGE     VERSION
       cpln1.example.com     Ready    control-plane,master   4h33m   v1.24.5+1.el8
       cpln2.example.com     Ready    control-plane,master   4h31m   v1.24.5+1.el8
       cpln3.example.com     Ready    control-plane,master   4h32m   v1.24.5+1.el8
       wkr1.example.com      Ready    <none>                 4h30m   v1.24.5+1.el8
       wkr2.example.com      Ready    <none>                 4h30m   v1.24.5+1.el8
       ~~~
       Obtain sonobuoy
       ~~~
       export SONOBUOY_VERSION="0.56.10"
       export SONOBUOY_FILENAME="sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz"
       curl -LO https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/${SONOBUOY_FILENAME}
       tar zxf ${SONOBUOY_FILENAME}
       ~~~
       Begin test
       ~~~
       ./sonobuoy version --kubeconfig ~/.kube/config
       Sonobuoy Version: v0.56.10
       MinimumKubeVersion: 1.17.0
       MaximumKubeVersion: 1.99.99
       GitSHA: 551bf68c694927839c3add25a2512f880902ee9b
       GoVersion: go1.18.5
       Platform: linux/amd64
       API Version:  v1.24.5+1.el8
       ./sonobuoy run --mode=certified-conformance
       ~~~
       
    