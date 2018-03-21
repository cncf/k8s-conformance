To reproduce:

```console
# Install AKS based on https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough

$ az login

$ az provider register -n Microsoft.ContainerService # if you have not done this already

$ az group create --name aksgroup --location eastus # create the resource group

$ az aks create -g aksgroup -n aksconformance -k 1.9.2 --agent-count 1 --generate-ssh-keys

$ az aks get-credentials --resource-group aksgroup --name aksconformance

$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs f -n sonobuoy sonobuoy

# wait for "no-exit was specified, sonobuoy is now blocking"

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
