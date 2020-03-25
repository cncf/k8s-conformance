# Conformance Testing Cloud 66 Maestro

## To Reproduce:

Note: to reproduce you need a Cloud 66 account.

### Create cluster

Login to Cloud 66 and signup for a Cloud 66 Maestro trial (free).

This is a 5 min guide on creating a single cluster (please create a 5 node cluster with 8 core CPUs)
https://help.cloud66.com/maestro/quickstarts/getting_started_with_clusters.html

To create a sample 3 master, 2 node cluster:
1. Create a single cluster with three nodes (This will include a single dedicated master and two nodes)
2. Once the cluster is ready, click on the "+" and add two additional master nodes to the cluster.

### Get Credentials

Open up the firewall from your IP to the cluster for kubectl:
Head to Network Settings, add a new rule and enter your IP address (from), Kubernetes servers (to) and TCP (protocol) 6443 (port).

From the master node page, download the `kubectl` file and check the cluster and your access:

```bash
export KUBECONFIG=~/Downloads/kubeconfig
kubectl get nodes
```

### Run the tests

https://github.com/cncf/k8s-conformance/blob/master/instructions.md

### Destroy the cluster

Click on the "Delete Cluster" button