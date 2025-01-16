# Aruba Kubernetes Conformance
## Connect to Aruba Cloud Management Platform
Go to https://my.arubacloud.com/ and sign in with you cloud account.
From your dashboard, navigate to the "Containers", select "Aruba Managed Kubernetes" and create you cluster.


## Create Aruba Managed Kubernetes cluster (based on Kubernetes v1.30.7)
Follow this guide to crete the cluster (https://kb.cloud.it/cmp/container/kubernetes/creare-cluster-kubernetes.aspx)

1. Select **Manage > Container** from **MY SERVICES** in the vertical menu on the left;
2. in the **Kubernetes Clusters** area, click on **Create new cluster**.
3. Create a new Kubernetes cluster requires the following details:
    - **Cluster name**: the name that will identify the cluster (rules for naming).\n
    - Tags (optional): tags can be applied to each cluster created to make searching in the list of Kubernetes clusters easier.
    - **Project**: each cluster must be assigned to a project, and if no project is selected, the system will automatically assign the cluster to the default project.
    - Click on **Next**
5. Location
    - Select the **Region** in which the Kubernetes cluster will be located
    - Click on **Next**
6. Kubernetes version
    - Select which **version of Kubernetes** you want to use (1.30 in this case)
    - Click on **Next**
7. Configuration
    - **Node Pool** name: the name that will be used to identify the Node Pool (rules for naming).
    - **Number of nodes**: select the number of nodes (worker nodes) you want to use, (min. 1, max. 2).
    - **Categor**y: select the type of cluster according to the CPU/RAM ratio.
    - **Zones**: specify the Zone in the Region.
    - **Control Plane in HA**: allows you to protect your cluster, replicating it on 3 availability zones within the selected Region. Can be enabled after a Kubernetes cluster has been created.
    - Click on **Next**
8. Networking: in this step, the cluster being created must be paired with a **VPC Network**:
    - if you do not have a VPC Network configured, you can create one manually or automatically;
    - If you already have VPC Networks, you can choose which one to select from the ones suggested, or create a new one manually by clicking on Create new VPC Network.
    - Click on **Next**
9. Price plan
    - Choose the price plan for the service, either hourly or 30 day monthly.
    - Click on **Next**
    - Click on **Confirm**

Download your kubeconfig and ensure that your cluster is properly running:
```
# kubectl get no -o wide
NAME                                                STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
67813c4f0d10c7640b428826--osmt-pool1--v1307-llssc   Ready    <none>   2d17h   v1.30.7   172.30.0.72   <none>        Ubuntu 22.04.5 LTS   5.15.0-126-generic   containerd://1.7.20

```

## Run Conformance Tests
Execute the following commands from your local machine:

```
##
# Env setup

$ export KUBECONFIG=your-k8s.conf

##
# Download a binary release of the CLI
$ go get -u -v github.com/vmware-tanzu/sonobuoy

##
# Run the tests

$ sonobuoy run --mode=certified-conformance

$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results
```