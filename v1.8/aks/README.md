To reproduce:

```
# Install AKS based on https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough

$ az login

$ az provider register -n Microsoft.ContainerService # if you have not done this already

$ az group create --name aksgroup --location eastus # create the resource group

$ az aks create -g aksgroup -n aksconformance --agent-count 1 --generate-ssh-keys

$ az aks get-credentials --resource-group aksgroup --name aksconformance

# Go to https://scanner.heptio.com and generate a unique scan token and yaml, save to aksscan.yaml

$ kubectl apply -f ./aksscan.yaml 

# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
