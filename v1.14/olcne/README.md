For simple reproduction follow the Vagrant example at the bottom of the document.
***
Oracle Linux Cloud Native Environment uses three open source tools to simplify the installation and management of Kubernetes and other CNCF projects as objects called modules.
These include: Platform API Server `olcne-api-server`, Platform Agent `olcne-agent` and Platform Command-Line Interface `olcnectl`

1. Complete the prerequisite and software installation steps documented in the [Getting Started](https://docs.oracle.com/en/operating-systems/olcne/start/) guide
2. Define site-specific variables
~~~
export certificate_dir="/etc/olcne/testing/configs/certificates"
export api_server=100.100.231.203:8091
export master_ips=100.100.231.203:8090,100.100.231.202:8090,100.100.231.201:8090
export worker_ips=100.100.231.205:8090,100.100.231.200:8090
export extra_flags="--load-balancer 100.100.231.203:6443"
~~~
3. Create an environment, an instance of a Oracle Linux Cloud Native Environment deployment
~~~
olcnectl \
    --api-server $api_server \
    --olcne-ca-path ${certificate_dir}/ca.cert \
    --olcne-node-cert-path ${certificate_dir}/mynode.cert \
    --olcne-node-key-path ${certificate_dir}/mynode.key \
    --update-config \
    environment create \
        --environment-name test-environment
~~~
4. Create the Kubernetes module definition within that environment
~~~
olcnectl module create \
    --environment-name test-environment \
    --module kubernetes \
    --kube-version v1.14.8 \
    --name test-module-kube \
    --master-nodes $master_ips \
    --worker-nodes $worker_ips \
    ${extra_flags}
~~~
5. Deploy the Kubernetes module within that environment
~~~
olcnectl module install \
    --environment-name test-environment \
    --name test-module-kube -g
~~~
6. Verify Kubernetes state before executing conformance test
~~~
[root@olcne-conformance-001 ~]# kubectl get nodes
NAME                    STATUS   ROLES    AGE     VERSION
olcne-conformance-001   Ready    master   4h33m   v1.14.8+1.0.2.el7
olcne-conformance-002   Ready    master   4h31m   v1.14.8+1.0.2.el7
olcne-conformance-003   Ready    master   4h32m   v1.14.8+1.0.2.el7
olcne-conformance-004   Ready    <none>   4h30m   v1.14.8+1.0.2.el7
olcne-conformance-005   Ready    <none>   4h30m   v1.14.8+1.0.2.el7

[root@olcne-conformance-001 ~]# sonobuoy version
Sonobuoy Version: v0.14.3
MinimumKubeVersion: 1.12.0
MaximumKubeVersion: 1.14.99

[root@olcne-conformance-001 ~]# kubectl version --short
Client Version: v1.14.8+1.0.2.el7
Server Version: v1.14.8+1.0.2.el7
~~~
***
To simplify reproduction under VirtualBox you may use (https://github.com/oracle/vagrant-boxes/)
1. `git clone https://github.com/oracle/vagrant-boxes/`
2. `cd vagnrant-boxes/OLCNE`
3. `vagrant plugin install vagrant-env vagrant-hosts`
4. `echo "MULTI_MASTER=true" > .env.local`
5. `vagrant up`
6. `vagrant ssh master1`
7. `export SONOBUOY_VERSION="0.16.5"`
8. `export SONOBUOY_FILENAME="sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz"`
9. `curl -LO https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/${SONOBUOY_FILENAME}`
10. `tar zxf ${SONOBUOY_FILENAME}`
11. `./sonobuoy run --mode=certified-conformance`
12. `./sonobuoy status`
