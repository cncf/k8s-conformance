# Reproducing the test results

## Run minikube with docker driver

Install [docker](https://docs.docker.com/engine/install/)
Install [kubectl](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-kubectl/) 
Clone the [minikube repo](https://github.com/kubernetes/minikube)

```console
% cd <minikube dir>
% make
go build  -tags "go_getter_nos3 go_getter_nogcs" -ldflags="-X k8s.io/minikube/pkg/version.version=v1.15.1 -X k8s.io/minikube/pkg/version.isoVersion=v1.15.0 -X k8s.io/minikube/pkg/version.isoPath=minikube/iso -X k8s.io/minikube/pkg/version.gitCommitID="640e1cb255210abb49eb7aab8001b9b425f1a161-dirty" -X k8s.io/minikube/pkg/version.storageProvisionerVersion=v3" -o out/minikube k8s.io/minikube/cmd/minikube

## make sure all tests could pass
% make integration-functional-only
```

Also you could try to verify minikube via deploying application and interact with cluster locally:
https://minikube.sigs.k8s.io/docs/start/


## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):
Run minikube with 2 nodes and containerd runtime.
For now, docker run time is not conformrant and "containerd" is required. We are still investigating docker run time issue.

```console
% cd <minikube dir>
% hack/conformance_tests.sh ./out/minikube -n 2 --kubernetes-version=v1.19.4 --container-runtime=containerd
```