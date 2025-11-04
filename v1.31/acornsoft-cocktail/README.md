# Cocktail Cloud Enterprise
Build your on Cloud

The Cocktail Cloud is the flagship all-in-one container management platform product that enables enterprise customers to build and deploy a cloud-native platform
that allows them to freely deploy and operate container based applications in any type of infrastructure, including public, private, and hybrid cloud, multi-cloud, and bare metal.
Cocktail Cloud not only manages the clusters that run the application in detail, but also provides an integrated environment for application lifecycle management.
You just have to choose the cloud infrastructure to use. For more information about the features offered by Cocktail Cloud products, please visit the Cocktail Cloud's homepage (http://www.cocktailcloud.io/).

A cocktail cloud is a container application management platform that provides a continuous development/deployment/operating environment for container-based applications. Integrated management of cloud infrastructure, automated continuous integration/deployment (CI/CD) operations required for development/operating container applications, service catalogs, auto scaling on load, and dynamic resource management are provided through easy and convenient GUI.

## Install Cocktail Cloud Enterprise.

The following instructions will help you configure and create a Kubernetes cluster:

1. Download Cocktail Cloud CLI

   If you are a registered user, you can download using the download URL provided in the email.

2. Prepare 1 Control Plane Node and 1 Node Worker Node.

3. Edit cube.toml
    ```sh
    $ vi cube.toml
    [cubectl]
    ## Required
    ## - local-repository-install: local repository installation activate. (Required when selecting the closed network.)
    ##                             It is installed on the registry host.
    ## - local-repository-url: local repository service url (Required when selecting the closed network.)
    ##                         If you are installing a private repository, you can skip it. (default: registry-ip)
    ## Optional
    ## - cluster-name: use cluster name in config context (default: "kubernetes")
    ## - install-dir: installation scripts(harbor, shell scripts) save directory (default: "/var/lib/cubectl")
    ## - cert-validity-days: SSL validity days(default: 36500)
    ## - closed-network: Enable Air Gap (default: false)
    # cluster-name = "vm3-cluster"
    #install-dir = "/var/lib/cubectl"
    #cert-validity-days = 36500
   
   
    [kubernetes]
    ## Required
    ## -
    ## Optional
    ## - version: Kubernetes version (default: "latest")
    ##            If you input only the major version, the minor version automatically selects the last version.
    ## - kube-proxy-mode: use k8s proxy mode [iptables | ipvs] (default: "ipvs")
    ## - service-cidr: k8s service network cidr (default: "10.96.0.0/20")
    ## - pod-cidr: k8s pod network cidr (default: "10.4.0.0/16")
    ## - node-port-range: k8s node port network range (default: "30000-32767")
    ## - audit-log-enable: k8s audit log enabled (default: true)
    ## - api-sans: Add k8s apiserver SAN [--apiserver-cert-extra-sans same as setting] (default: master[0] ip address)
    version = "v1.31.4"
    kube-proxy-mode = "ipvs"
    service-cidr = "172.49.0.0/16"
    pod-cidr = "10.49.0.0/16"
    node-port-range = "30000-32767"
    audit-log-enable = true
    api-sans = ["192.xxx.0.167"]
    
    [kubernetes.calico]
    ## Required
    ## -
    ## Optional
    ## - vxlan-mode: calico VXLAN mode activate (default: false)
    #vxlan-mode = true
    
    [node-pool]
    ## Required
    ## -
    ## Optional
    ## - data-dir: data(backup, docker, log, kubelet, etcd, k8s-audit, containerd) root dir (default: "/data")
    ## - ssh-port: Node ssh port (default: 22)
    #data-dir = "/data"
    data-dir = "/var/lib"
    #ssh-port = 22
    
    [node-pool.master]
    ## Required
    ## - ip: k8s control plane nodes ip address.
    ## - private-ip: K8s control plane nodes private ip address.
    ##               If you use the same IP address, you can skip it.
    ## Optional
    ## - lb-ip: loadbalancer ip address (default: master[0] node ip address)
    ## - isolated: K8s control plane nodes isolated (default: true)
    ## - lb-ip: Enter the IP address when using a load balancer (default: master[0] ip address)
    ## - lb-port: Enter the port when using a load balancer (default: 6443)
    #ip = ["x.x.x.x","x.x.x.x","x.x.x.x"]
    #private-ip = ["10.10.3.89"]
    #isolated = true
    lb-ip = "xxxxxx"
    #lb-port = 6443
    [node-pool.node]
    ## Required
    ## - ip: k8s work nodes ip address.
    ## - private-ip: K8s work nodes private ip address.
    ##               If you use the same IP address, you can skip it.
    ## Optional
    #private-ip = ["10.10.3.62"]
    #private-ip = ["x.x.x.x", "x.x.x.x"]
    
    [private-registry]
    ## Required
    ## - registry-ip: Public IP address of the private registry node.
    ##                This is a required entry used when installing a private registry.
    ## - private-ip: Private IP address of the private registry node.
    ##               This is a required entry used when installing a private registry.
    ##               If you use the same IP address, you can skip it.
    ## Optional
    ## - install: private registry install (default: false)
    ## - registry-domain: If using a domain, please enter the domain. (default: registry-ip)
    ## - data-dir: private registry data directory (default: "/data/harbor")
    ## - public-cert: public cert activate (default: false)
    #install = false
  
    
    [private-registry.cert-file]
    ## Required
    ## - ssl-certificate: The certificate path used when using public-cert.
    ##                    This is a required field used when using a public certificate.
    ## - ssl-certificate-key: The certificate-key used when using public-cert.
    ##                        This is a required field used when using a public certificate.
    ## Optional
    
    [shared-storage]
    ## Required
    ## - storage-ip: Storage node ip address.
    ##               This is a required field used when installing the nfs server.
    ##               (this is using it to generate an inventory and generate an extra vars)
    ## - private-ip: Storage node ip address.
    ##               This is a required field used when installing the nfs server.
    ##               If you use the same IP address, you can skip it.
    ##               (this is using it to generate an inventory)
    ## - volume-dir: Storage node data directory. (default: /data/storage)
    ##               This is a required field used when installing the nfs server.
    ##               (this is using it to generate an extra vars)
    ## Optional
    ## - install: NFS Server Installation (default: false)
    #install = false

    ```
4. Install cluster
    ```sh
    $ cubectl create -p ~/id_rsa -u ubuntu -c cncf-cluster --container-runtime xxx
    ```

## Run Conformance test

1. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
    ```sh
    $ go get -u -v github.com/vmware-tanzu/sonobuoy
    ```

2. Configure your kubeconfig file by running:
    ```sh
    $ export KUBECONFIG="/path/to/your/cluster/config"
    ```

3. Run sonobuoy:
    ```sh
    $ sonobuoy run --mode=certified-conformance
    ```

4. Watch the logs:
    ```sh
    $ sonobuoy logs
    ```

5. Check the status:
    ```sh
    $ sonobuoy status
    ```

6. Once the status commands shows the run as completed, you can download the results tar.gz file:
    ```sh
    $ sonobuoy retrieve ./results
    ```
