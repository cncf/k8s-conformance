# Conformance tests for Scaleway's Kubernetes

## Setup the Scaleway Kubernetes cluster

We'll use the [Scaleway CLI](https://github.com/scaleway/scaleway-cli/) to create the cluster. Please be sure to have at least version v2.4.0.
Once the CLI is configured (typing `scw init` and following the questions), you can type:
```bash
scw k8s cluster create cni=calico name=conformance pools.0.size=2 pools.0.node-type=dev1_l version=1.24.7 --wait
```

Once the command returns, install the Kubeconfig by typing:
```bash
scw k8s kubeconfig install <id-of-the-cluster>
```

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
