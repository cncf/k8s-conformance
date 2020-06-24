# Cocktail Cloud Enterprise 
Build your on Cloud

The Cocktail Cloud is the flagship all-in-one container management platform product that enables enterprise customers to build and deploy a cloud-native platform
that allows them to freely deploy and operate container based applications in any type of infrastructure, including public, private, and hybrid cloud, multi-cloud, and bare metal.
Cocktail Cloud not only manages the clusters that run the application in detail, but also provides an integrated environment for application lifecycle management.
You just have to choose the cloud infrastructure to use. For more information about the features offered by Cocktail Cloud products, please visit the Cocktail Cloud's homepage (http://www.cocktailcloud.io/).

A cocktail cloud is a container application management platform that provides a continuous development/deployment/operating environment for container-based applications. Integrated management of cloud infrastructure, automated continuous integration/deployment (CI/CD) operations required for development/operating container applications, service catalogs, auto scaling on load, and dynamic resource management are provided through easy and convenient GUI.

## To Reproduce:
1. Create a kubernetes cluster, download the kubeconfig and configure `kubectl` to use this config file.

2. Install Cocktail Cloud Enterprise.

3. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
    ```sh
    $ go get -u -v github.com/vmware-tanzu/sonobuoy
    ```

4. Configure your kubeconfig file by running:
    ```sh
    $ export KUBECONFIG="/path/to/your/cluster/config"
    ```

5. Run sonobuoy:
    ```sh
    $ sonobuoy run --mode=certified-conformance
    ```

6. Watch the logs:
    ```sh
    $ sonobuoy logs
    ```

7. Check the status:
    ```sh
    $ sonobuoy status
    ```

8. Once the status commands shows the run as completed, you can download the results tar.gz file:
    ```sh
    $ sonobuoy retrieve
    ```
