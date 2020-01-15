To reproduce:

```console
# Install AKS based on https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough

$ az login

$ az provider register -n Microsoft.ContainerService # if you have not done this already

$ az group create --name aksgroup --location eastus # create the resource group

$ az aks create -g aksgroup -n aksconformance -k 1.17.0 --node-count 1 --generate-ssh-keys

$ az aks get-credentials --resource-group aksgroup --name aksconformance

$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
