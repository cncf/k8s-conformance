# STACKIT Kubernetes Engine Conformance

## Sign in at the STACKIT portal and select a Project

Visit the [STACKIT Portal](https://portal.stackit.cloud/) and sign in with your
STACKIT account. From your account, pick or create a project at the top right.

You can find more infos on how to create a project in the [STACKIT documentation](https://docs.stackit.cloud/stackit/en/create-project-117244204.html).

## Create a STACKIT Kubernetes Engine cluster

Follow the [documentation on how to create a STACKIT Kubernetes Engine cluster](https://docs.stackit.cloud/stackit/en/step-1-create-a-kubernetes-cluster-ske-10125556.html).  
This guide should always reflect the up-to-date steps necessary to set up a
cluster.

You can find more infos on how to create a project in the [docs](https://docs.stackit.cloud/stackit/en/create-project-117244204.html).

## Create a STACKIT Kubernetes Engine cluster

Follow this guide on how to create a STACKIT Kubernetes Engine cluster (<https://docs.stackit.cloud/stackit/en/step-1-create-a-kubernetes-cluster-ske-10125556.html>)

1. Select **Kubernetes Engine** in the **Runtimes** section in the navigation bar on the left side
2. Click **Create New** to enable Kubernetes for your project.
3. Click **Create cluster** to create a new Kubernetes cluster and enter the needed details:
    - **Cluster name** (optional): Name of your cluster, will be auto-generated if not changed.
    - **Kubernetes version** (optional): Defaults to the latest Kubernetes version supported by us if not specified.
4. Click **Create node pool** to create a new node pool. Specify your node pool configuration:
    - Node pool name: Name to identify your node pool
    - Availability zone: Specify the zone of your node pool
    - Node minimum
    - Node maximum
    - Maximum surge
    - Operating system
    - Version: Version of your selected operating system
    - Machine type: select one that fits your needs
    - Performance class: Select the performance class of your disk volume
    - Volume size: Volume size (in GB) for your disk
    - Click **Save** to save your node pool configuration
5. You can see your Monthly price estimate at the right and confirm your order with **Order fee-based**

STACKIT Kubernetes Engine provides optional configuration options, such as
**ACL Restriction** or **Monitoring Integration**. These are not described here,
as they are not needed to create a simple cluster. For more information on
advanced topics and integrations, see the
[Tutorials Overview](https://docs.stackit.cloud/stackit/en/tutorials-ske-66683162.html).

Download your kubeconfig and verify your cluster is up and running:

```
~ kubectl get nodes -o wide

NAME                                                            STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION   CONTAINER-RUNTIME
shoot--d0df460fd5--cl-bcjiib8g-pool-e56774tagx-z1-5f867-7kfgt   Ready    <none>   6h34m   v1.32.4   10.250.1.73   <none>        Flatcar Container Linux by Kinvolk 4152.2.3 (Oklo)   6.6.88-flatcar   containerd://1.7.23
shoot--d0df460fd5--cl-bcjiib8g-pool-e56774tagx-z1-5f867-wvz4n   Ready    <none>   7h25m   v1.32.4   10.250.2.55   <none>        Flatcar Container Linux by Kinvolk 4152.2.3 (Oklo)   6.6.88-flatcar   containerd://1.7.23
```

## Run conformance tests

To verify that your STACKIT Kubernetes Engine cluster is indeed conformant, you
can download sonobuoy from
[github.com/vmware-tanzu/sonobuoy/releases](https://github.com/vmware-tanzu/sonobuoy/releases)
and run the test in your cluster:

```
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

You can find the result files in `results/plugins/e2e/results/global/`.
