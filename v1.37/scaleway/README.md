# Conformance tests for Scaleway's Kubernetes

## Setup the Scaleway Kubernetes cluster

We'll use the [Scaleway CLI](https://github.com/scaleway/scaleway-cli/) to create the cluster. Please be sure to have at least version `v2.61.0`.
Once the CLI is configured (typing `scw init` and following the questions), you can type:

```bash
scw k8s cluster create cni=cilium name=conformance pools.0.name=default pools.0.size=3 pools.0.node-type=pop2_2c_8g version=1.37.0 --wait
```

Once the command returns, install the Kubeconfig by typing:

```bash
scw k8s kubeconfig install <id-of-the-cluster>
```

## Run Conformance Test

1. Download a binary release of [hydrophone](https://github.com/kubernetes-sigs/hydrophone), or install it using go:

    ```bash
    go install sigs.k8s.io/hydrophone@v0.7.0
    ```

2. Run hydrophone:

    ```bash
    hydrophone --conformance
    ```
