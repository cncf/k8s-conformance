# Kubernetes Conformance tests on Metal Stack Cloud

## Setup a Metal Stack Cloud account

To use our platform, you need an existing Github account and a valid email address. With a OAuth authentication flow you can then [register and login to our platform](https://console.metalstack.cloud).

For more information please refer to our [documentation](https://metalstack.cloud/de/documentation/UserManual).

## Creating a Cluster

If you want to create a new cluster, you first have to navigate to the cluster overview by clicking on Kubernetes in the navigation. Then click on the Create Cluster Button. Select the version of Kubernetes that you require to run your cluster. Then you have to specify a name and choose a location, the different server types and number of nodes for the cluster.

The name must be between two and 10 characters long, in lower case, and no special characters are allowed, except ’-‘. Whitespace and special characters are not supported. This restriction is necessary due to DNS constraints of your API server.

Your cluster should be ready within 7 minutes. After that you are able to download the Kubeconfig from the cluster overview to work with with it.

## Run conformance tests

Download sonobuoy from [github.com/vmware-tanzu/sonobuoy/releases](https://github.com/vmware-tanzu/sonobuoy/releases)

```bash
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

Required files are located in `results/plugins/e2e/results/global/`