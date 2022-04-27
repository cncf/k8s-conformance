# Conformance tests for Scaleway's Kubernetes

## Setup the Scaleway Kubernetes cluster

First create a cluster as mentionned in the [documentation](https://developers.scaleway.com/en/products/k8s/api/), download the kubeconfig and configure `kubectl` to use this config file.

## Run Conformance Test

1. Download a binary release of [sonobuoy](https://github.com/heptio/sonobuoy/releases), or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

2. Run sonobuoy:
```sh
$ sonobuoy run
```

3. Check the status:
```sh
$ sonobuoy status
```

4. Once the status shows the run as completed, you can download the results archive by running:
```sh
$ sonobuoy retrieve
```
