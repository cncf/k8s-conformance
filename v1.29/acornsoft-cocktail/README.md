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

3. Edit cubectl.toml
    ```sh
    $ vi cubectl.toml
[cubectl]
## Required
## - local-repository-install: local repository installation activate. (Required when selecting the closed network.)
##                             It is installed on the registry host.
## - local-repository-port: Port number used as local repository. (Required when selecting the closed network.)
##                          If you use the default value, you can skip it. (default: 8080)
## - local-repository-url: local repository service url (Required when selecting the closed network.)
##                         If you are installing a private repository, you can skip it. (default: registry-ip)
## Optional
## - cluster-name: use cluster name in config context (default: "kubernetes")
## - install-dir: installation scripts(harbor, shell scripts) save directory (default: "/var/lib/cubectl")
## - cert-validity-days: SSL validity days(default: 36500)
## - debug-mode: Check mode is just a simulation, and if you have steps that use conditionals that depend on the results of prior commands,
## it may be less useful for you. (default: false)
## - closed-network: Enable Air Gap (default: false)
#cluster-name = "kubernetes"
#install-dir = "/var/lib/cubectl"
#cert-validity-days = 36500
#closed-network = false
#local-repository-install = false
#local-repository-port = 8080
#local-repository-url = "http://x.x.x.x"

[kubernetes]
## Required
## -
## Optional
## - version: Kubernetes version (default: "latest")
##            If you input only the major version, the minor version automatically selects the last version.
## - kube-proxy-mode: use k8s proxy mode [iptables | ipvs] (default: "ipvs")
## - service-cidr: k8s service network cidr (default: "10.96.0.0/20")
## - pod-cidr: k8s pod network cidr (default: "10.4.0.0/24")
## - node-port-range: k8s node port network range (default: "30000-32767")
## - audit-log-enable: k8s audit log enabled (default: true)
## - api-sans: Add k8s apiserver SAN [--apiserver-cert-extra-sans same as setting] (default: master[0] ip address)
version = "v1.29.5"
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
  

6. Once the status commands shows the run as completed, you can download the results tar.gz file:
    ```sh
    $ sonobuoy retrieve ./results
    ```
