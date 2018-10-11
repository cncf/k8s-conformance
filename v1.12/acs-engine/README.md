To reproduce:

```
# Install ACS Engine based on https://github.com/Azure/acs-engine/blob/master/docs/kubernetes.md

curl -L -o acs-engine-darwin.zip https://github.com/Azure/acs-engine/releases/download/v0.23.0/acs-engine-v0.23.0-darwin-amd64.zip

# Get the Kubernetes 1.12 install json

curl -o kubernetes1.12.json https://raw.githubusercontent.com/Azure/acs-engine/master/examples/kubernetes-releases/kubernetes1.12.json

# Get the current Azure subscription ID 

$ az login

$ SUBID=`az account list --all -o table |grep True |awk -F '  ' '{print $3}'`

$ acs-engine deploy --subscription-id $SUBID \
    --dns-prefix conformance --location westus2 \
    --auto-suffix --api-model kubernetes1.11.json 

$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f -n sonobuoy sonobuoy

# wait for "no-exit was specified, sonobuoy is now blocking"

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
