To reproduce:

```
# Install Azure CLI and connect to Azure Stack based on https://docs.microsoft.com/en-us/azure/azure-stack/user/azure-stack-version-profiles-azurecli2

# [Optional] To learn details on how to use the ACS Engine see "Usage" in https://github.com/msazurestackworkloads/acs-engine/blob/master/docs/acsengine.md

# To install the Azure Stack ACS Engine use the curl command below and unpack content
curl -L -o acs-engine.tgz https://raw.githubusercontent.com/msazurestackworkloads/acs-engine/acs-engine-v0206/examples/azurestack/acs-engine.tgz 

# Get the Kubernetes 1.11 install json

curl -o kubernetes1.11.json https://raw.githubusercontent.com/msazurestackworkloads/acs-engine/acs-engine-v0206/examples/azurestack/azurestack-kubernetes1.11.json

# To run the sonobuoy tests follow these steps:

# 1. Get the current Azure Stack subscription ID 

$ az login

$ SUBID=`az account list --all -o table |grep True |awk -F '  ' '{print $3}'`

# 2. Deploy the kubernetes cluster

$ acs-engine deploy --subscription-id $SUBID \
    --dns-prefix conformance --location westus2 \
    --auto-suffix --api-model kubernetes1.11.json 

# 3. Run the tests

$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f -n sonobuoy sonobuoy

# wait for "no-exit was specified, sonobuoy is now blocking"

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}