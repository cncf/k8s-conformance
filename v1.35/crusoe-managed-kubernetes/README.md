# Crusoe Managed Kubernetes (CMK)

Crusoe Managed Kubernetes is a hosted Kubernetes platform on Crusoe Cloud.
This guide shows how to create a CMK cluster and reproduce the conformance results in this directory.

## Prerequisites

- A Crusoe Cloud account and project. Sign up at <https://console.crusoecloud.com>.
- The Crusoe CLI (`crusoe`). See <https://docs.crusoecloud.com/orchestration/cmk/overview>.
- An API access key. Export `CRUSOE_ACCESS_KEY_ID` and `CRUSOE_SECRET_KEY`, or set them in the CLI config file.
- An SSH public key file for the worker nodes.
- `kubectl`.
- `hydrophone` v0.8.0. Install it with `go install sigs.k8s.io/hydrophone@v0.8.0`.

## Create the cluster

1. Create the cluster. The platform selects the current 1.35 patch.

   ```sh
   crusoe kubernetes clusters create \
     --name conformance-1-35 \
     --cluster-version 1.35 \
     --location us-east1-a \
     --project-name <your project>
   ```

2. Create a node pool. The conformance suite does not need GPUs, so a CPU type is enough. List types with `crusoe compute vms types`.

   ```sh
   crusoe kubernetes nodepools create \
     --name conformance-workers \
     --cluster-name conformance-1-35 \
     --count 2 \
     --type c1a.4x \
     --keyfile <path to SSH public key> \
     --project-name <your project>
   ```

3. Download the kubeconfig and confirm that all nodes are `Ready`.

   ```sh
   crusoe kubernetes clusters get-credentials conformance-1-35 \
     --project-name <your project> \
     --kubeconfig-path ./conformance-1-35.yaml
   kubectl --kubeconfig ./conformance-1-35.yaml get nodes
   ```

## Run the conformance tests

```sh
hydrophone --conformance \
  --kubeconfig ./conformance-1-35.yaml \
  --conformance-image registry.k8s.io/conformance:v1.35.8 \
  --parallel 4 \
  --output-dir .
```

The run takes about 45 minutes. It writes `e2e.log` and `junit_01.xml` to the output directory.

## Clean up

```sh
hydrophone --cleanup --kubeconfig ./conformance-1-35.yaml
crusoe kubernetes clusters delete conformance-1-35 --project-name <your project>
```
