# Kubernetes conformance tests on AKS-Engine

## Setup AKS-Engine cluster

Download AKS Engine.

```bash
VERSION=v0.82.1
curl -L -o aks-engine-azurestack-darwin.tar.gz https://github.com/Azure/aks-engine-azurestack/releases/download/${VERSION}/aks-engine-azurestack-${VERSION}-darwin-amd64.tar.gz
mkdir ./aks-engine-azurestack; tar xzf aks-engine-azurestack-darwin.tar.gz -C ./aks-engine-azurestack
```

Create a file called kubernetes1.30.json, the contents of the file should be the following cluster definition template:

```json
{
    "apiVersion": "vlabs",
    "location": "",
    "properties": {
        "orchestratorProfile": {
            "orchestratorRelease": "1.30",
            "kubernetesConfig": {
                "useInstanceMetadata": false,
                "useCloudControllerManager": true,
                "networkPlugin": "kubenet"
            }
        },
        "customCloudProfile": {
            "portalURL": "",
            "identitySystem": ""
        },
        "masterProfile": {
            "dnsPrefix": "",
            "distro": "ubuntu-22.04",
            "count": 3,
            "vmSize": "Standard_D2_v2"
        },
        "agentPoolProfiles": [
            {
                "name": "linuxpool",
                "count": 3,
                "vmSize": "Standard_D2_v2",
                "distro": "ubuntu-22.04",
                "availabilityProfile": "AvailabilitySet",
                "AcceleratedNetworkingEnabled": false
            }
        ],
        "linuxProfile": {
            "adminUsername": "azureuser",
            "ssh": {
                "publicKeys": [
                    {
                        "keyData": ""
                    }
                ]
            }
        },
        "servicePrincipalProfile": {
            "clientId": "",
            "secret": ""
        }
    }
}
```

Create a service principal (client) and assign the Contributor role to it in the target subscription. Set the following variables:

```bash
export AZURE_LOCATION=""
export AZURE_CLIENT_ID=""
export AZURE_CLIENT_SECRET=""
export AZURE_SUBSCRIPTION_ID=""
export IDENTITY_SYSTEM="" # azure_ad or adfs
export SSH_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)"
export PORTAL_URL=""
```

Execute `aks-engine-azurestack deploy`

```bash
./aks-engine-azurestack/aks-engine-azurestack-${VERSION}-darwin-amd64/aks-engine-azurestack deploy \
    --location ${AZURE_LOCATION} \
    --api-model kubernetes1.30.json \
    --resource-group conformance \
    --client-id ${AZURE_CLIENT_ID} \
    --client-secret ${AZURE_CLIENT_SECRET} \
    --subscription-id ${AZURE_SUBSCRIPTION_ID} \
    --dns-prefix conformance \
    --identity-system "$IDENTITY_SYSTEM" \
    --set linuxProfile.ssh.publicKeys[0].keyData="$SSH_PUB_KEY" \
    --set servicePrincipalProfile.clientId="$AZURE_CLIENT_ID" \
    --set servicePrincipalProfile.secret="$AZURE_CLIENT_SECRET" \
    --set customCloudProfile.portalURL="$PORTAL_URL" \
    --set customCloudProfile.identitySystem="$IDENTITY_SYSTEM" \
    --azure-env AzureStackCloud
```

## Run conformance tests

Once the AKS-Engine cluster has been provisioned, connect to the cluster and commence the conformance test by following these steps:

```bash
VERSION=0.57.3
curl -L -o sonobuoy-darwin.tar.gz https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_darwin_amd64.tar.gz
mkdir ./sonobuoy; tar xzf sonobuoy-darwin.tar.gz -C ./sonobuoy

export KUBECONFIG=_output/conformance/kubeconfig/kubeconfig.${AZURE_LOCATION}.json
./sonobuoy/sonobuoy run --mode=certified-conformance --wait
./sonobuoy/sonobuoy retrieve ./results
```
