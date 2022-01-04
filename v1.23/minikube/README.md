# Reproducing the test results

## Run minikube with docker driver

Install [docker](https://docs.docker.com/engine/install/)
Install [kubectl](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-kubectl/)
Clone the [minikube repo](https://github.com/kubernetes/minikube)

## Compile the latest minikube binary
```console
% cd <minikube dir>
% make
```

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
% cd <minikube dir>
./hack/conformance_tests.sh out/minikube -p k8sconformance --driver=docker --container-runtime=docker --cni=kindnet --kubernetes-version=v1.23.0
```

This script will run sonobuoy against a minikube cluster with two nodes and the provided parameters.
