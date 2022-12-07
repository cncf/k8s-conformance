# Kubernetes conformance tests on AKS

### Setup AKS cluster

The following commands were used to create an AKS cluster for the purposes of running the Kubernetes conformance tests. Should you need further instructions please refer to the [quickstart documentation](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough).

```console
$ az login

$ az provider register -n Microsoft.ContainerService # if you have not done this already

$ az group create --name aksgroup --location eastus # create the resource group

$ az aks create -g aksgroup -n aksconformance -k v1.25.2 --node-count 2 --generate-ssh-keys # create a single node AKS cluster

$ az aks get-credentials --resource-group aksgroup --name aksconformance # get the AKS cluster Kubernetes credentials for use with kubectl
```

### Run conformance tests

Once the AKS cluster has been provisioned, connect to the cluster and commence the conformance test by following these steps:

```console
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
