# k0rdent - Kubernetes Conformance

## Product Information

- **Product:** k0rdent v1.11.0 (KCM - k0rdent Cluster Manager)
- **Kubernetes Version:** v1.36.3+k0s (k0s v1.36.3+k0s.0, pinned by the `azure-standalone-cp-1-0-43` cluster template)
- **Infrastructure:** Azure (child cluster: 3 control plane + 2 worker `Standard_A4_v2` VMs), kind (management cluster)

These results were produced by an [automated run](https://github.com/Mirantis/cncf-conformance/actions/runs/35838211464) of the steps below, from [Mirantis/cncf-conformance](https://github.com/Mirantis/cncf-conformance).

## Automated reproduction

```bash
git clone https://github.com/Mirantis/cncf-conformance
cd cncf-conformance
az login
export AZURE_CLIENT_ID=<SERVICE_PRINCIPAL_APP_ID> AZURE_TENANT_ID=<TENANT_ID> AZURE_CLIENT_SECRET=<SERVICE_PRINCIPAL_PASSWORD>
./run.sh --product k0rdent --suite k8s --version v1.11.0
```

The run creates the management and child clusters, runs Sonobuoy, writes `e2e.log` and `junit_01.xml` to `artifacts/<timestamp>/submission/` and deletes both clusters.
The manual steps are below.

## Prerequisites

- [kind](https://kind.sigs.k8s.io/) v0.33.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/) v1.36+
- [Helm](https://helm.sh/) v3.8+ or v4
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) v2.x
- [Sonobuoy](https://sonobuoy.io/) v0.57.5
- An Azure subscription with Contributor access

## Step 1: Create the Management Cluster

```bash
kind create cluster --name k0rdent-mgmt
kubectl get nodes
```

## Step 2: Install k0rdent (KCM)

Install k0rdent Cluster Manager with Helm, then create a `Management` object with the providers an Azure child cluster needs (k0smotron, Azure, Sveltos). Without `controller.createManagement=false` the chart creates a `Management` with every provider, which also works on a larger management cluster.

The chart creates the `Release` object `kcm-1-11-0` (`kubectl get release`), which the `Management` references.

```bash
helm install kcm oci://ghcr.io/k0rdent/kcm/charts/kcm \
  --version 1.11.0 \
  -n kcm-system \
  --create-namespace \
  --set controller.createManagement=false \
  --wait --timeout 15m

cat <<EOF | kubectl apply -f -
apiVersion: k0rdent.mirantis.com/v1beta1
kind: Management
metadata:
  name: kcm
spec:
  release: kcm-1-11-0
  providers:
    - name: cluster-api-provider-k0sproject-k0smotron
    - name: cluster-api-provider-azure
    - name: projectsveltos
EOF
```

Wait until the Management is ready and the Azure cluster template is valid:

```bash
kubectl wait management kcm --for=condition=Ready --timeout=15m
kubectl -n kcm-system get clustertemplate azure-standalone-cp-1-0-43
```

## Step 3: Configure Azure Credentials

### 3.1 Login to Azure and note your Subscription ID

```bash
az login
az account list -o table
```

### 3.2 Register required resource providers

```bash
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Authorization
```

### 3.3 Create a Service Principal

```bash
az ad sp create-for-rbac --role contributor \
  --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

Save the output values: `appId`, `password`, `tenant`.

### 3.4 Create the Azure Secret, AzureClusterIdentity and Credential

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: azure-cluster-identity-secret
  namespace: kcm-system
  labels:
    k0rdent.mirantis.com/component: "kcm"
type: Opaque
stringData:
  clientSecret: <SERVICE_PRINCIPAL_PASSWORD>
---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureClusterIdentity
metadata:
  name: azure-cluster-identity
  namespace: kcm-system
  labels:
    clusterctl.cluster.x-k8s.io/move-hierarchy: "true"
    k0rdent.mirantis.com/component: "kcm"
spec:
  allowedNamespaces: {}
  clientID: <SERVICE_PRINCIPAL_APP_ID>
  clientSecret:
    name: azure-cluster-identity-secret
    namespace: kcm-system
  tenantID: <SERVICE_PRINCIPAL_TENANT_ID>
  type: ServicePrincipal
---
apiVersion: k0rdent.mirantis.com/v1beta1
kind: Credential
metadata:
  name: azure-cluster-identity-cred
  namespace: kcm-system
spec:
  identityRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
    kind: AzureClusterIdentity
    name: azure-cluster-identity
    namespace: kcm-system
EOF
```

### 3.5 Create the Azure Cloud Provider ConfigMap

Without it the cloud controller manager on the child cluster does not start and the nodes keep their `uninitialized` taint.

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: azure-cluster-identity-resource-template
  namespace: kcm-system
  labels:
    k0rdent.mirantis.com/component: "kcm"
  annotations:
    projectsveltos.io/template: "true"
data:
  configmap.yaml: |
    {{- $cluster := .InfrastructureProvider -}}
    {{- $identity := (getResource "InfrastructureProviderIdentity") -}}
    {{- $secret := (getResource "InfrastructureProviderIdentitySecret") -}}
    {{- $subnetName := "" -}}
    {{- $securityGroupName := "" -}}
    {{- $routeTableName := "" -}}
    {{- range $cluster.spec.networkSpec.subnets -}}
      {{- if eq .role "node" -}}
        {{- $subnetName = .name -}}
        {{- $securityGroupName = .securityGroup.name -}}
        {{- $routeTableName = .routeTable.name -}}
        {{- break -}}
      {{- end -}}
    {{- end -}}
    {{- $cloudConfig := dict
      "aadClientId" $identity.spec.clientID
      "aadClientSecret" (index $secret.data "clientSecret" | b64dec)
      "cloud" $cluster.spec.azureEnvironment
      "loadBalancerName" ""
      "loadBalancerSku" "Standard"
      "location" $cluster.spec.location
      "maximumLoadBalancerRuleCount" 250
      "resourceGroup" $cluster.spec.resourceGroup
      "routeTableName" $routeTableName
      "securityGroupName" $securityGroupName
      "securityGroupResourceGroup" $cluster.spec.networkSpec.vnet.resourceGroup
      "subnetName" $subnetName
      "subscriptionId" $cluster.spec.subscriptionID
      "tenantId" $identity.spec.tenantID
      "useInstanceMetadata" true
      "useManagedIdentityExtension" false
      "vmType" "vmss"
      "vnetName" $cluster.spec.networkSpec.vnet.name
      "vnetResourceGroup" $cluster.spec.networkSpec.vnet.resourceGroup
    -}}
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: azure-cloud-provider
      namespace: kube-system
    type: Opaque
    data:
      cloud-config: {{ $cloudConfig | toJson | b64enc }}
EOF
```

## Step 4: Deploy the Child Cluster on Azure

The `azure-standalone-cp-1-0-43` template shipped with k0rdent v1.11.0 deploys k0s v1.36.3+k0s.0.

```bash
cat <<EOF | kubectl apply -f -
apiVersion: k0rdent.mirantis.com/v1beta1
kind: ClusterDeployment
metadata:
  name: k0rdent-conformance
  namespace: kcm-system
spec:
  template: azure-standalone-cp-1-0-43
  credential: azure-cluster-identity-cred
  config:
    location: southindia
    subscriptionID: <YOUR_SUBSCRIPTION_ID>
    controlPlaneNumber: 3
    workersNumber: 2
    controlPlane:
      vmSize: Standard_A4_v2
    worker:
      vmSize: Standard_A4_v2
EOF
```

Wait for the cluster to be provisioned (about 20 minutes):

```bash
kubectl -n kcm-system wait clusterdeployment k0rdent-conformance --for=condition=Ready --timeout=45m
```

## Step 5: Retrieve the Child Cluster Kubeconfig

```bash
kubectl -n kcm-system get secret k0rdent-conformance-kubeconfig \
  -o jsonpath='{.data.value}' | base64 -d > kubeconfig.yaml
export KUBECONFIG=kubeconfig.yaml
kubectl get nodes
```

Expected output: 3 control plane nodes and 2 worker nodes, all `Ready`, running Kubernetes v1.36.3+k0s.

## Step 6: Run Conformance Tests

```bash
sonobuoy run --mode=certified-conformance --wait
```

This takes approximately 2 hours.

## Step 7: Retrieve and Verify Results

```bash
outfile=$(sonobuoy retrieve)
sonobuoy results $outfile
tar xzf $outfile
```

The required files are located at:

- `plugins/e2e/results/global/e2e.log`
- `plugins/e2e/results/global/junit_01.xml`

All 446 conformance tests must pass with 0 failures.
