# How to Reproduce in Ionos Cloud

## Prerequisites

- Access to Ionos Cloud
- One of the following role:
  - Contract Owner
  - Administrator
  - User having Create Kubernetes Clusters permission

## Procedure

If you prefer to using the DCD (Web interface for IONOS Cloud) follow the [IONOS Cloud docs](https://docs.ionos.com/cloud/managed-services/managed-kubernetes/how-tos).

```bash
# Login to ionos cloud
ionosctl auth login

# Create a cluster and notice the cluster-id
ionosctl k8s cluster create --name k8s-conformance-1.27 --k8s-version 1.27.8 --wait-for-state

# Create a Data Center for your Nodes and notice the datacenter-id
ionosctl datacenter create --name k8s-conformance-1.27-dc --location de/fra --wait-for-request

# Create a Node Pool
ionosctl k8s nodepool create --datacenter-id <datacenter-id> \ 
  --name k8s-conformance-1.27-nodepool  --cluster-id <cluster-id> \ 
  --node-count 3 --cpu-family INTEL_SKYLAKE --k8s-version 1.27.8 --wait-for-state

# Get the kubeconfig
ionosctl k8s kubeconfig get --cluster-id <cluster-id>

# Run the k8s-conformance tests
sonobuoy run --mode=certified-conformance
```
