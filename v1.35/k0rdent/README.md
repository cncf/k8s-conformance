# k0rdent - Kubernetes Conformance

## Product Information

- **Product:** k0rdent v1.8.0 (KCM - k0rdent Cluster Manager)
- **Kubernetes Version:** v1.35.2+k0s.0
- **Infrastructure:** Azure (child cluster), kind (management cluster)

## Prerequisites

- [kind](https://kind.sigs.k8s.io/) v0.31.0+
- [kubectl](https://kubernetes.io/docs/tasks/tools/) v1.34+
- [Helm](https://helm.sh/) v4.0+
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) v2.x
- [Sonobuoy](https://sonobuoy.io/) latest
- An Azure subscription with Contributor access

## Step 1: Create the Management Cluster

Create a local Kubernetes cluster using kind. kind v0.31.0 defaults to Kubernetes v1.35.0.

```bash
kind create cluster --name k0rdent-mgmt
```

Verify the cluster is running:

```bash
kubectl get nodes
```

## Step 2: Install k0rdent (KCM)

Install k0rdent Cluster Manager using Helm:

```bash
helm install kcm oci://ghcr.io/k0rdent/kcm/charts/kcm \
  --version 1.8.0 \
  -n kcm-system \
  --create-namespace
```

Wait for all pods to be ready:

```bash
kubectl -n kcm-system get pods --watch
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

### 3.4 Create the Azure Secret

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: azure-cluster-identity-secret
  namespace: kcm-system
  labels:
    k0rdent.mirantis.com/component: "kcm"
stringData:
  clientSecret: <SERVICE_PRINCIPAL_PASSWORD>
type: Opaque
EOF
```

### 3.5 Create the AzureClusterIdentity

```bash
cat <<EOF | kubectl apply -f -
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
EOF
```

### 3.6 Create the k0rdent Credential

```bash
cat <<EOF | kubectl apply -f -
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

### 3.7 Create the Azure Cloud Provider ConfigMap

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

Create a ClusterDeployment using the Azure standalone control plane template with k0s v1.35.2:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: k0rdent.mirantis.com/v1beta1
kind: ClusterDeployment
metadata:
  name: k0rdent-conformance
  namespace: kcm-system
spec:
  template: azure-standalone-cp-1-0-23
  credential: azure-cluster-identity-cred
  config:
    clusterLabels: {}
    location: eastus
    subscriptionID: <YOUR_SUBSCRIPTION_ID>
    controlPlane:
      vmSize: Standard_A4_v2
    worker:
      vmSize: Standard_A4_v2
    k0s:
      version: "v1.35.2+k0s.0"
EOF
```

Wait for the cluster to be provisioned:

```bash
kubectl -n kcm-system get clusterdeployment k0rdent-conformance --watch
```

## Step 5: Retrieve the Child Cluster Kubeconfig

Once the ClusterDeployment reaches a ready state:

```bash
kubectl -n kcm-system get secret k0rdent-conformance-kubeconfig \
  -o jsonpath='{.data.value}' | base64 -d > kubeconfig.yaml
export KUBECONFIG=kubeconfig.yaml
```

Verify the child cluster nodes are ready:

```bash
kubectl get nodes
```

Expected output: 3 control plane nodes and 2 worker nodes running Kubernetes v1.35.2+k0s.

## Step 6: Run Conformance Tests

Install and run Sonobuoy:

```bash
go install github.com/vmware-tanzu/sonobuoy@latest
sonobuoy run --mode=certified-conformance --wait
```

This takes approximately 2 hours.

## Step 7: Retrieve and Verify Results

```bash
outfile=$(sonobuoy retrieve)
sonobuoy results $outfile
```

Extract the results:

```bash
tar xzf $outfile
```

The required files are located at:
- `plugins/e2e/results/global/e2e.log`
- `plugins/e2e/results/global/junit_01.xml`

All 441 conformance tests must pass with 0 failures.
