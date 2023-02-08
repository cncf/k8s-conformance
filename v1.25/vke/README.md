# Conformance Tests for Vultr Kubernetes Engine

## Create a cluster

You can deploy a new VKE cluster in a few clicks. Here's how to get started.

1. Navigate to [the Kubernetes page in the Customer Portal](https://my.vultr.com/kubernetes/).
1. Click **Add Cluster**.
1. Enter a descriptive label for the **Cluster Name**.
1. Select the Kubernetes version.
1. Choose a deployment location.
1. Create a Node Pool.

    **About Node Pools**

    When creating a VKE cluster, you can assign one or more Node Pools with multiple nodes per pool. For each Node Pool, you'll need to make a few selections.

    ![Node Pools Screenshot](https://www.vultr.com/vultr-docs-graphics/6438/NodePools.png)

    * **Node Pool Name**: Enter a descriptive label for the node pool.
    * **Node Pool Type**: Choose a [Cloud Compute](https://www.vultr.com/products/cloud-compute/) or [High Frequency Compute](https://www.vultr.com/products/high-frequency-compute/) type.
    * **Plan**: All nodes in the pool will be the same plan. Choose a size appropriate for your workload.
    * **Amount of Nodes**: Choose how many nodes should be in this pool. It's strongly recommended to use more than one node.

    The monthly rate for the node pool is calculated as you make your selections. If you want to deploy more than one, click **Add Another Node Pool**.

1. When ready, click **Deploy Now**.

**Note:** You'll notice that the cluster status reports **Running** soon after deployment, which indicates that the nodes have booted. However, Kubernetes requires additional time to inventory and configure the nodes. Please allow several minutes for VKE to complete the configuration. We will correct the status reporting before the final release. To verify the status of your cluster, please download your `kubeconfig` file (as described in the next section) and run:

        $ kubectl --kubeconfig={PATH TO THE FILE} cluster-info

> Additonal information can be found [here](https://www.vultr.com/docs/vultr-kubernetes-engine)

## Run conformance tests

Follow the k8s-conformance [test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance tests.
The output here was obtained with Sonobuoy 0.56.11 running on a Kubernetes 1.25.4 cluster.
