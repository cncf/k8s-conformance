## To reproduce:

#### Create Kubernetes Cluster

- Login to [HUAWEI CLOUD Cloud Container Engine](https://console.huaweicloud.com/cce2.0) web console
and create a Kubernetes cluster
    * Select `CN North-Beijing4` region.
    * In the right pane, click `Buy Cluster` and then follow the instructions to create a cluster.
      Make sure to select `Version` as `v1.19.3` and at least two nodes.
    * Wait for the cluster to be in 'ready state'. This might take a while.

- Prepare for Conformance test
    * Make sure VPN is configured appropriately
    * Download kubectl configuration file from `cluster dashboard` and upload to every node. More details please refer to `Cluster Management` --> `Cluster Details`

#### Deploy sonobuoy Conformance test 

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/32dcd214d1be11b00bee560e6a45ba82f67b5595/instructions.md) to test it.
