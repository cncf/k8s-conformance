# Aruba Kubernetes Conformance
## Connect to Aruba Cloud Management Platform
Go to https://my.arubacloud.com/ and sign in with you cloud account.
From your dashboard, navigate to the "Managed Kubernetes" Section and create you cluster.

![image](https://github.com/engineeringdatacenter/k8s-conformance/assets/123960000/344497be-acc6-4821-98ab-f465257b1a53)

## Create Aruba Managed Kubernetes cluster (based on Kubernetes v1.29.2)
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
    - Select which **version of Kubernetes** you want to use (1.28 in this case)
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
$ k get no -o wide
NAME                                               STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
66ed456ce21e951cc78caa88--osmt-np01--v1292-vmsnc   Ready    <none>   7d3h   v1.29.2   10.10.43.212   <none>        Ubuntu 22.04.4 LTS   5.15.0-113-generic   containerd://1.7.13
66ed456ce21e951cc78caa88--osmt-np01--v1292-vqpkl   Ready    <none>   7d3h   v1.29.2   10.10.43.233   <none>        Ubuntu 22.04.4 LTS   5.15.0-113-generic   containerd://1.7.13

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