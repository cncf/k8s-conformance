# Conformance tests for BOARD Kubernetes cluster

## Deploy BOARD and Kubernetes cluster

Follow the instruction at [https://github.com/inspursoft/board/blob/master/README.md](https://github.com/inspursoft/board/blob/master/README.md) to deploy BOARD and Kubernetes cluster.

## Run conformance tests

Follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
$ sonobuoy run --wait
$ sonobuoy status
$ sonobuoy retrieve
```
