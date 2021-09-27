# To reproduce

## Set up the cluster

1. Create an account at https://joyent.com/
2. Install `triton-kubernetes`
3. Create a new cluster manager and cluster using `triton-kubernetes`.

### Install `triton-kubernetes`
* [Download and Install Go](https://github.com/golang/go#download-and-install)
* Clone [this](https://github.com/joyent/triton-kubernetes) repository into $GOPATH/src/github.com/joyent/triton-kubernetes
* cd $GOPATH/src/github.com/joyent/triton-kubernetes
* go install

### Create a new cluster manager
Download sample cluster manager yaml configuration [here](https://github.com/joyent/triton-kubernetes/blob/master/examples/silent-install/triton/manager-on-triton.yaml). Alternatively follow the cli prompts.
* `triton-kubernetes create manager`

### Create a new cluster
Download sample cluster yaml configuration [here](https://github.com/joyent/triton-kubernetes/blob/master/examples/silent-install/triton/cluster-triton-ha.yaml). Alternatively follow the cli prompts.
* `triton-kubernetes create cluster`

When the cluster is up and running,

1. Download the kubeconfig file from the rancher cluster.
2. Set the `KUBECONFIG` environment variable `export KUBECONFIG=$(pwd)/kubeconfig`.

## Run Conformance Test

Follow the
[instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)
as found in the [CNCF K8s Conformance repository](https://github.com/cncf/k8s-conformance).

* Note that the Sonobouy e2e test suite currently requires the master nodes to be schedulable, by default triton-kubernetes taints the master nodes to be unschedulable.

The following modifications are needed to the master nodes in order to run the tests:

```
# ETC_NODE_NAME=tri-k8s-etcd-1
# CORE_NODE_NAME=tri-k8s-core-1
kubectl taint nodes $ETC_NODE_NAME "node-role.kubernetes.io/etcd":NoExecute-
kubectl taint nodes $CORE_NODE_NAME "node-role.kubernetes.io/controlplane":NoSchedule-
```

The procedure described here also works for any [Triton](https://github.com/joyent/triton) setup, not only the main one run by Joyent. Even for development setups. The only condition is to have the Triton environment variables `TRITON_URL`, `TRITON_ACCOUNT` and `TRITON_KEY_ID` properly configured. Examples of how to configure and use these variables can be found either on [node-triton](https://github.com/joyent/node-triton) or [triton-go](https://github.com/joyent/triton-go) documentation.
