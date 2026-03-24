# How to reproduce

## How to set up cluster

1. Log in to breqwatr UI
2. Go to `Menu -> <project name> -> Cluster`
3. Click on + (Create) button.
4. Set the following values in the `Create Cluster` window:
   - Name
   - Number of NodesMaster
   - Number of NodesWorker (Must be greater than 1)
   - Master Flavor
   - Worker Flavor
   - Volume Type
   - Volume Size
   - Cluster template (Image is Rocky 9)
   - Keypair
5. Click on `Create Cluster` button.
6. Click on Download button once the status of this cluster is `CREATE_COMPLETE`.
7. Set KUBECONFIG variable `export KUBECONFIG=<Download path>/<cluster name>.kubeconfig`
8. Run the conformance test

## How to run tests
Follow https://github.com/cncf/k8s-conformance/blob/master/instructions.md#sonobuoy for running conformance tests.
