# To reproduce

## Set up the cluster

1. Create account at https://joyent.com/
1. Download and install `triton-kubernetes`
1. Create new cluster manager and cluster using `triton-kubernetes`.

### Install `triton-kubernetes`

 * [Build and Install from the source](https://github.com/joyent/triton-kubernetes/blob/master/docs/guide/building-cli.md)
 * [Install from pre-built packages](https://github.com/joyent/triton-kubernetes/blob/master/docs/guide/installing-cli.md)

When the cluster is up and running,

1. Download the kubeconfig file.
2. Set the `KUBECONFIG` environment variable `export KUBECONFIG=$(pwd)/kubeconfig`.

### `triton-kubernetes`

* [How to use](https://github.com/joyent/triton-kubernetes#working-with-the-cli)
* [Examples](https://github.com/joyent/triton-kubernetes/tree/master/examples)

## Run the conformance test

```
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f -n sonobuoy sonobuoy

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

$ untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
```