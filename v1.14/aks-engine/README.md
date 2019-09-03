To reproduce:

```
# Install AKS Engine based on https://github.com/Azure/aks-engine/blob/master/docs/tutorials/quickstart.md

curl -L -o aks-engine-darwin.tar.gz https://github.com/Azure/aks-engine/releases/download/v0.36.2/aks-engine-v0.36.2-darwin-amd64.tar.gz

# Get the Kubernetes 1.14 install json

curl -o kubernetes1.14.json https://github.com/Azure/aks-engine/blob/master/examples/kubernetes-releases/kubernetes1.14.json

# Get the current Azure subscription ID 

$ az login

$ SUBID=`az account list --all -o table |grep True |awk -F '  ' '{print $3}'`

# Manually create a service principal

$ az ad sp create-for-rbac --skip-assignment

# With the output of the command above set the CLIENTID and CLIENTSECRET from the appId and password fields respectively

$ aks-engine deploy --subscription-id $SUBID \
    --client-id $CLIENTID --client-secret $CLIENTSECRET \ 
    --dns-prefix conformance --location westus2 \
    --auto-suffix --api-model kubernetes1.14.json 

$ go get -u -v github.com/heptio/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
