# kind

https://kind.sigs.k8s.io/

By following these steps you may reproduce the kind Conformance e2e
results.

## Requirements

1) The [Docker](https://www.docker.com/) CLI must be installed and must have
access to a running Docker daemon.

Note: you may need to increase the memory allocated to Docker on docker desktop.
See [our docs](https://github.com/kubernetes-sigs/kind/tree/c84d4dccebec84c97b13beafba8552ac6e04919a/docs/user#creating-a-cluster)
for more on this.

2) `kind` should be installed, version [0.2.0](https://github.com/kubernetes-sigs/kind/releases/tag/0.2.0)
was used for these tests. To install place the binary for your platform in `$PATH`
and name it `kind`.   

Alternatively it may be installed from source with [go](https://golang.org/) 1.11+ via the following:
```console
go get -d sigs.k8s.io/kind
cd $(go env GOPATH)/src/sigs.k8s.io/kind
git checkout 0.2.0
go install .
```

3) [kubetest](https://github.com/kubernetes/test-infra/tree/master/kubetest)

`kubetest` must be installed to PATH, this may be done with `go get -i k8s.io/test-infra/kubetest`

4) [Install Go](https://golang.org/doc/install) 1.12.1

5) Install [git](https://git-scm.com/)


## Provision a Cluster

First create a config file `kind-multinode.yaml` with the following contents:

```yaml
kind: Cluster
apiVersion: kind.sigs.k8s.io/v1alpha3
# one control plane node and two workers, each with kubernetes 1.14.0
nodes:
- role: control-plane
  image: kindest/node:v1.14.0
- role: worker
  image: kindest/node:v1.14.0
- role: worker
  image: kindest/node:v1.14.0
```

Then you can create the cluster with:
```bash
kind create cluster --name=conformance --config=./kind-multinode.yaml
```

And select the generated KUBECONFIG with:
```bash
export KUBECONFIG="$(kind get kubeconfig-path --name="conformance")"
```


## Run the Conformance Tests

1. Clone Kubernetes locally with `git clone https://github.com/kubernetes/kubernetes`
2. Checkout the v1.14.0 release with `cd kubernetes && git checkout v1.14.0`
3. build `kubectl` and the tests with:

```bash
make WHAT="test/e2e/e2e.test cmd/kubectl vendor/github.com/onsi/ginkgo/ginkgo"
```


4. Run the conformance tests with the following command:

```bash
mkdir -p ./_artifacts && \
export KUBERNETES_CONFORMANCE_TEST=y && \
kubetest \
    --provider=skeleton \
    --test \
    --check-version-skew=false \
    --test_args="--ginkgo.focus=\[Conformance\] --ginkgo.skip=Alpha|Kubectl|\[(Disruptive|Feature:[^\]]+|Flaky)\] --report-dir=${PWD}/_artifacts --disable-log-dump=true --num-nodes=2" \
    | tee ./_artifacts/e2e.log
```


## Obtain the Conformance Results

The results will be in `./_artifacts`, collect `e2e.log` and `junit_01.xml`.


## Cleanup

Delete the cluster with
```bash
kind delete cluster --name=conformance
```
