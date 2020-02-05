# Kubernetes conformance tests on AKS

### Setup AKS cluster

Provision an AKS cluster using the following [quickstart documentation](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough).

### Run conformance tests

Once the AKS cluster has been provisioned, connect to the cluster and commence the conformance test by following these steps:

```console
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
