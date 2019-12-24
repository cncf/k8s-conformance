# To reproduce

## Set up the cluster

1. Create an account at https://joyent.com/
2. Download and install `triton-kubernetes`
3. Create a new cluster manager and cluster using `triton-kubernetes`.

### Install `triton-kubernetes`

* [Build and Install from the source](https://github.com/joyent/triton-kubernetes/blob/master/docs/guide/building-cli.md)
* [How to use](https://github.com/joyent/triton-kubernetes#working-with-the-cli)
* [Examples](https://github.com/joyent/triton-kubernetes/tree/master/examples)

When the cluster is up and running,

1. Download the kubeconfig file.
2. Set the `KUBECONFIG` environment variable `export KUBECONFIG=$(pwd)/kubeconfig`.

## Run Conformance Test

Follow the
[instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)
as found in the [CNCF K8s Conformance repository](https://github.com/cncf/k8s-conformance).
* Note that the Sonobouy e2e test suite currently requires the master nodes to be schedulable, by default triton-kubernetes taints the master nodes to be unschedulable.