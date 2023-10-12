# Conformance test for CeaKE

## Create a cluster

1. Prepare The Nodes
- Ceake has three types of nodes: bootstrap nodes, master nodes, and worker nodes. Bootstrap nodes are responsible for cluster deployment and bootstrapping the cluster to start working. Masters serve as the control plane for the cluster, while worker nodes handle the cluster's workload. 
- Once the node role is planned, the next step is to install the operating system. The operating system supported by Ceake, such as Kylin OS, should be installed.

2. Deploy Cluster
- After the operating system is installed, the cluster deployment process can begin. To do this, copy the Ceake installation package to the bootstrap node and unzip it. Then, execute script located in the cluster-installer/deploy directory.
```
sh bootstrap_init.sh kylin_v10sp2
```
- Wait for the installation and deployment to complete.

## Run conformance tests

1. Deploy a Sonobuoy pod to CeaKE cluster with:

```
sonobuoy run --mode=certified-conformance --dns-namespace=ccos-kni-infra --dns-pod-labels app=kni-infra-mdns 
```

2. View actively running pods:

```
sonobuoy status
```

3. Once conformance testing is completed, run:

```
sonobuoy retrieve
sonobuoy delete
```