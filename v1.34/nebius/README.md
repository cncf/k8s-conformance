# Kubernetes conformance tests on Managed Service for Kubernetes

## Create a cluster

Install and configure [kubectl](https://kubernetes.io/docs/tasks/tools/), [jq](https://jqlang.github.io/jq/download/), and the [Nebius CLI](https://docs.nebius.com/cli/install). Authenticate and select the Nebius project in which to create the cluster:

```sh
nebius profile create
nebius config set parent-id <project_ID>
```

Get the default subnet, then create a Kubernetes 1.34 cluster with a public control-plane endpoint:

```sh
export SUBNET_ID=$(nebius vpc subnet list \
  --format json | jq -r '.items[0].metadata.id')

export CLUSTER_ID=$(nebius mk8s cluster create \
  --name conformance-1-34 \
  --control-plane-version 1.34 \
  --control-plane-subnet-id "$SUBNET_ID" \
  --control-plane-endpoints-public-endpoint true \
  --format json | jq -r '.metadata.id')
```

Create a two-node CPU node group:

```sh
nebius mk8s node-group create \
  --name conformance-1-34-nodes \
  --parent-id "$CLUSTER_ID" \
  --fixed-node-count 2 \
  --template-resources-platform cpu-e2 \
  --template-resources-preset 2vcpu-8gb \
  --template-boot-disk-type network_ssd \
  --template-boot-disk-size-bytes 137438953472 \
  --template-network-interfaces "[{\"public_ip_address\": {}, \"subnet_id\": \"$SUBNET_ID\"}]"
```

Generate kubeconfig credentials and verify access:

```sh
nebius mk8s cluster get-credentials --id "$CLUSTER_ID" --external
kubectl cluster-info
kubectl get nodes
```

For more information, see the [Managed Service for Kubernetes quickstart](https://docs.nebius.com/kubernetes/quickstart).

## Run the conformance tests

The submitted results were generated with [Sonobuoy v0.57.3](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.57.3) against Kubernetes v1.34.8. Install that Sonobuoy release, then run:

```sh
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir results
tar xzf "$outfile" -C results
```

The submitted `e2e.log` and `junit_01.xml` are from `results/plugins/e2e/results/global/`.
