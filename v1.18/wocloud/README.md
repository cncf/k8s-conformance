# WoCloud Container Platform

A container management platform based on Kubernetes.

## How To Reproduce:

### Ready For WoCloud Container Platform

1. WoCloud Container Platform is a business software, connect to the vendor to get install package (wocloud.tar.gz).

2. Copy wocloud.tar.gz to master and unpackage it.
    ```sh
    tar -zxvf wocloud.tar.gz 
    ```
3. Configure the cluster config file.
    ```sh
    cd wocloud
    vim config 
    ```

    ```
    cluster_name=$CLUSTER_NAME
    kube_apiserver=$KUBE_APISERVER_ADDRESS
    etcd_servers=$ETCD_SERVERS_ADDRESS
    kubernetes_version="1.18.3"

    #Choose network, support flannel and calico
    network=flannel

    [masters]
    $MASTER1_ADDRESS
    $MASTER2_ADDRESS
    $MASTER3_ADDRESS
    
    [ingress]
    $INGRESS1_ADDRESS
    $INGRESS2_ADDRESS
    $INGRESS3_ADDRESS

    [nodes]
    $NODE1_ADDRESS
    ...
    $NODEN_ADDRESS

4. Install the cluster with root user.
    ```sh
    ./install
    ```

5. When WoCloud Container Platform is ready, login to the k8s master.


### Run Conformance Test
1. Download a sonobuoy [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:
    ```sh
    $ go get -u -v github.com/vmware-tanzu/sonobuoy
    ```

1. Configure your kubeconfig file by running:
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
    $ sonobuoy retrieve
    ```
