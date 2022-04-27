# Conformance tests for CKE Kubernetes cluster

## Deploy CKE and Kubernetes cluster

Follow the instruction at [https://github.com/cybozu-go/cke/blob/master/example/README.md](https://github.com/cybozu-go/cke/blob/master/example/README.md) 
to deploy CKE and Kubernetes cluster.

## Run conformance tests

Get a configuration file of kubectl to access Kubernetes cluster with the following command.

```sh
$ cd $GOPATH/src/github.com/cybozu-go/cke/example
$ ./bin/ckecli --config=./cke.config kubernetes issue > kube_config.yaml
$ export KUBECONFIG="kube_config.yaml"
```

Follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
$ sonobuoy run --wait
$ sonobuoy status
$ sonobuoy retrieve
```
