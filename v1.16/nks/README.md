# To reproduce:

## Create a cluster

1. Sign up and log in to https://nks.netapp.io
2. Click on "Add Cluster"
3. Choose the provider you would like to use
4. Add your credentials for the provider in "Configure your provider"
5. Select the appropriate Kubernetes version in "Configure your cluster" under "Orchestration"
6. Once you've submitted the cluster for creation, click the "kubeconfig" link under "Clusters" listing page to download credentials

## Run the conformance test

The standard tool for running these tests is [Sonobuoy](https://github.com/heptio/sonobuoy). Sonobuoy is regularly built and kept up to date to execute against all currently supported versions of kubernetes.

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```console
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```console
$ sonobuoy run --mode=certified-conformance
```

View actively running pods:

```console
$ sonobuoy status
```

To inspect the logs:

```console
$ sonobuoy logs
```

Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

```console
$ sonobuoy retrieve .
```

This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

```console
mkdir ./results; tar xzf *.tar.gz -C ./results
```

NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:

```console
sonobuoy delete
```
