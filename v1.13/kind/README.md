# kind

https://github.com/kubernetes-sigs/kind

By following these steps you may reproduce the kind Conformance e2e
results.

## Requirements

1) The [Docker](https://www.docker.com/) CLI must be installed and must have
access to a running Docker daemon.

Note: you may need to increase the memory allocated to Docker on docker desktop.
See [our docs](https://github.com/kubernetes-sigs/kind/tree/c84d4dccebec84c97b13beafba8552ac6e04919a/docs/user#creating-a-cluster)
for more on this.

2) `kind` should be installed, version [0.1.0](https://github.com/kubernetes-sigs/kind/releases/tag/0.1.0)
was used for these tests. To install place the binary for your platform in `$PATH`
and name it `kind`.   

Alternatively it may be installed from source with [go](https://golang.org/) 1.11+ via the following:
```console
go get -d sigs.k8s.io/kind
cd $(go env GOPATH)/src/sigs.k8s.io/kind
git checkout 0.1.0
go install .
```

3) [Sonobuoy](https://github.com/heptio/sonobuoy) must be installed to run the tests.

## Provision a Cluster

First create a config file `kind-multinode.yaml` with the following contents:

```yaml
kind: Config
apiVersion: kind.sigs.k8s.io/v1alpha2
# one control plane node and two workers
nodes:
- role: control-plane
- role: worker
  replicas: 2
```

Then you can create the cluster with:
```bash
kind create cluster --name=conformance --config=./kind-multinode.yaml
```

And select the generated KUBECONFIG with:
```bash
export KUBECONFIG="$(kind get kubeconfig-path --name="conformance")"
```

## Run Sonobuoy

From this point on we follow [the official conformance instructions](https://github.com/cncf/k8s-conformance/blob/fcedf22631ea53912232a235633407242a65cb07/instructions.md).

Running all the conformance tests often takes about an hour.

```bash
# start sonobuoy
sonobuoy run
# wait for the run to complete
sonobuoy logs -f
```

## Obtain the Conformance Results

When you see `level=info msg="no-exit was specified, sonobuoy is now blocking"`
in the sonobuoy logs, you can fetch your test results.

```bash
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Your untarred results should now be in `results` on your host machine.

The needed test files are:
- `results/plugins/e2e/results/plugins/e2e/results/e2e.log`
- `results/plugins/e2e/results/plugins/e2e/results/junit_01.xml`

## Cleanup

Delete the cluster with
```bash
kind delete cluster --name=conformance
```
