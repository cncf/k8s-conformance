# Kubernetes conformance tests on AKS

### Setup AKS cluster

The following commands create an AKS cluster for running the Kubernetes conformance tests. For further instructions, refer to the [quickstart documentation](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough).

```console
$ az login

$ az provider register -n Microsoft.ContainerService # if you have not done this already

$ az group create --name autogen-k8s-conformance-wenhug-v1.37.0-20260923 --location eastus2 # create the resource group

$ az aks create -g autogen-k8s-conformance-wenhug-v1.37.0-20260923 -n aks -k 1.37.0 --node-count 2 --generate-ssh-keys # create a two node AKS cluster

$ az aks get-credentials --resource-group autogen-k8s-conformance-wenhug-v1.37.0-20260923 --name aks # get the AKS cluster Kubernetes credentials for use with kubectl
```

### Run conformance tests

The tests were run with [Sonobuoy v0.57.5](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.57.5). Once the AKS cluster has been provisioned, connect to the cluster and commence the conformance test by following these steps:

```console
$ sonobuoy run --mode=certified-conformance --kubernetes-version=v1.37.0 --wait

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
