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
    [cube]
    version = "4.6.6"
    provider = false
    cluster-name = "conformance"
    cluster-description = "conformance test cluster"
    cluster-type = "small"
    cluster-id = "conformance"
    alert-language = "ko"                # alert message language code [ko | en]
    debug-mode = false

    [kubernetes]
    version ="1.23.5"                    # Kubernete Version
    service-cidr = "172.0.0.0/16"        # Kubernete Service CIDR
    pod-cidr = "172.128.0.0/16"            # Kubernete Pod CIDR
    kube-proxy-mode = "iptables"             # kube-proxy mode [iptables(default) | ipvs]
    container-runtime = "containerd"     # container runtime [containerd(default) | docker]
      [kubernetes.etcd]
      ip = ["111.111.111.111"]           # etcd public ip
      private-ip = ["192.168.0.11"]      # etcd private ip

    [node-pool]
    data-dir = "/data"
      [node-pool.provider]
      name = "onpremise"
      location = "default"
      [node-pool.security]
      ssh-user-id = "root"
      private-key-path = "id_rsa"
      [node-pool.master]
      ip = ["111.111.111.111"]           # kubernete controlplane node public ip
      private-ip = ["192.168.0.11"]      # kubernete controlplane node private ip
      internal-lb = "111.111.111.111"    # Internal load-balancer ip
      external-lb = "111.111.111.111"    # External load-balancer ip
      node-port-url = "111.111.111.111"  #
      node-portrange = "30000-32767"     #
      isolated = true                    # if true, no pods will be able to scheduler master node unless it has a matching toleration
      haproxy-install = true             # if true, haproxy performs as internal load-balancer
      [[node-pool.nodes]]
      ip = ["111.111.111.112"]           # kubernetes worker node public ip
      private-ip = ["192.168.0.12"]      # kubernetes worker node private ip
      ...

    ```
4. Install cluster
    ```sh
    $ cube create
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
