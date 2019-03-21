# Conformance testing DigitalOcean Kubernetes

### Setup DigitalOcean Kubernetes cluster

Get started by creating a cluster as outlined in our [product documentation](https://www.digitalocean.com/docs/kubernetes/how-to/create-cluster/).

For running the conformance tests, we use a 3 nodes configured with the `s-4vcpu-8gb` (4 vCPU / 8gb memory) plan.

### Run the conformance tests

Once you've created a cluster, downloaded the kubeconfig and configured your kubectl to use it, you reproduce the conformance run with the following steps:

```
# Download a binary release of the sonobuoy (https://github.com/heptio/sonobuoy/releases), or build it yourself by running:
$ go get -u -v github.com/heptio/sonobuoy

# Deploy a Sonobuoy pod to your cluster with:
$ sonobuoy run

# View actively running pods:
$ sonobuoy status

# To inspect the logs:
$ sonobuoy logs

# Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
$ sonobuoy retrieve .

# This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
$ mkdir ./results; tar xzf *.tar.gz -C ./results

# Afterwards you can inspect (and submit) the results from:
# results/plugins/e2e/results/e2e.log
# results/plugins/e2e/results/junit_01.xml
```
