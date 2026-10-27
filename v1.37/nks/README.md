# Conformance testing Nscale Managed Kubernetes (NKS)

## Create an NKS cluster

The following steps use the [Nscale CLI](https://docs.nscale.com/docs/platform-services/managed-kubernetes) to create a cluster.

### 1. Set a CLI context

Create a context that pins the organization, project and region to use. Region IDs can be listed with `nscale regions list`.

```
nscale contexts set --name nks-conformance --user default \
    --org <organization-id> \
    --project <project-id> \
    --region <region-id> \
    --ci
```

### 2. Choose a Kubernetes release

List the available NKS releases and pick the non-deprecated v1.37 release (`v1.37.0-nks.1`, matching `PRODUCT.yaml`):

```
nscale k8s release list --context nks-conformance
```

### 3. Choose a node flavor

List the instance flavors available in the region and pick one for the worker nodes:

```
nscale flavors list --context nks-conformance
```

### 4. Write the cluster spec

Describe the cluster in a JSON file. It references an existing network in the project (`networkId`, listed with `nscale networks list`) and the release chosen above. The API server is given a public IP so the conformance tooling can reach it:

```json
{
  "metadata": { "name": "conformance-testing" },
  "spec": {
    "networkId": "<network-id>",
    "platformReleaseId": "v1.37.0-nks.1",
    "apiServer": { "publicIP": true, "allowedCidrs": ["0.0.0.0/0"] }
  }
}
```

### 5. Create the cluster

Optionally validate the payload with `--dry-run`, then create the cluster. `--wait` blocks until the cluster is ready:

```
nscale k8s cluster create --context nks-conformance --file ./cluster.json --dry-run
nscale k8s cluster create --context nks-conformance --file ./cluster.json --yes --wait
```

This takes a few minutes and provisions a highly-available (3 replica) control plane running Kubernetes v1.37.0, with Cilium as the CNI. The cluster has no worker nodes at this point. The output includes the cluster ID, which later steps use.

### 6. Write the node pool spec

Describe a pool of worker nodes for the cluster, using the cluster ID from the previous step and a flavor ID from step 3. The cluster for this submission used 5 replicas of `g.4.standard.80s` (4 vCPU, 16 GB RAM, 80 GB disk):

```json
{
  "metadata": { "name": "default" },
  "spec": {
    "clusterId": "<cluster-id>",
    "provisioningMode": "compute",
    "replicas": 5,
    "compute": { "flavorId": "<flavor-id>" }
  }
}
```

### 7. Create the node pool

```
nscale k8s nodepool create --context nks-conformance --file ./nodepool.json --yes --wait
```

`--wait` blocks until all worker nodes have joined the cluster and are ready.

### 8. Get a kubeconfig

Fetch a kubeconfig for the cluster (using the **cluster** ID, not the node pool ID) and point `kubectl` at it:

```
nscale k8s kubeconfig get --context nks-conformance --cluster <cluster-id> > kubeconfig.yaml
export KUBECONFIG=$(pwd)/kubeconfig.yaml
```

The kubeconfig holds no credentials of its own. It uses `nscale k8s token` as a client-go exec plugin, so `kubectl` obtains a fresh token from the CLI as needed.

### 9. Verify the cluster

Check that the worker nodes are `Ready` and running v1.37.0:

```
kubectl get nodes -o wide
```

The control plane is managed by Nscale and is not visible as nodes, so only the workers are listed.

## Run the conformance tests

Reproduce the conformance run using [hydrophone](https://github.com/kubernetes-sigs/hydrophone) with the following steps:

```
go install sigs.k8s.io/hydrophone@latest
hydrophone --conformance
```
