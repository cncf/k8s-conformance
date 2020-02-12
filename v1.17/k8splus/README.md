# Conformance tests for ks8plus's Kubernetes

## Setup the k8splus and the Kubernetes cluster
First install k8splus, them create a cluster with k8splus in the [documentation](https://lionelpang.github.io/k8splus/docs/index.html).

## Run Conformance Test

1. Download a binary release of [sonobuoy](https://github.com/heptio/sonobuoy/releases), or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

2. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

3. Check the status:
```sh
$ sonobuoy status
```

4. Once the status shows the run as completed, you can download the results archive by running:
```sh
$ sonobuoy retrieve
```
