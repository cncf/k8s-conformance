# Conformance tests for Mia-Platform Magellano Distribution

## Requirements

- [`vab` CLI](https://github.com/mia-platform/vab)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

## Environment

[This repository](https://github.com/mia-platform/k8s-conformance-cluster) includes Terraform
resources and steps to create a Kubernetes cluster hosted on GCP where you can apply the distribution.  
To create a 1.28 version of kubernetes launch the plan with `-var 'cluster_version=1.28'`

## Deploy the distribution

Install the `vab` cli using the binary available [here](https://github.com/mia-platform/vab/releases/tag/v0.9.0).
Presuming that your system is Linux on amd64 you can install it with something like:

```shell
curl -fsSL https://github.com/mia-platform/vab/releases/download/v0.9.0/vab-linux-amd64 > /tmp/vab
install -g root -o root /tmp/vab /usr/local/bin
````

Create project and change the directory:

```shell
vab init --name base-installation
cd base-installation
```

Download this `vab` configuration to overwrite the `config.yaml` and setting up the correct version of the
distribution.

```shell
curl -fsSL https://raw.githubusercontent.com/mia-platform/distribution/v1.28.1/examples/base/config.yaml > config.yaml
```

Synchronize the resources:

```shell
vab sync
```

Before proceeding, make sure the name of your local **Kubernetes context** is the same as the one specified
in the `config.yaml` file (default: `base-installation`). Otherwise, the `build` and `apply` command
may fail or behave unexpectedly.  
If you want to check what resourcres will be deployed, you can run the following command:

```shell
vab build base-installation .
```

To deploy the resources on the cluster:

```shell
vab apply base-installation .
```

To see when all the deployed resources are done launch the following command and wait until no resources are returned:

```shell
kubectl get pods -A --field-selector status.phase!=Running,status.phase!=Succeeded
```

## Run conformance tests

Download [Sonobuoy](https://github.com/vmware-tanzu/sonobuoy).

Deploy Sonobuoy to the Kubernetes cluster:

```shell
sonobuoy run --mode=certified-conformance
```

You can monitor the progress with:

```shell
sonobuoy status
```

Or check the logs with:

```shell
sonobuoy logs
```

When the run has completed, you can download the results by running the following:

```shell
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```
