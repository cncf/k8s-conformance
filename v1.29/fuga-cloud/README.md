# Conformance tests for Fuga Cloud Enterprise Managed Kubernetes (EMK)

## Enterprise Managed Kubernetes (EMK) (based on Kubernetes v1.29)

Fuga Cloud's Enterprise Managed Kubernetes (EMK) is a GDPR-compliant solution for managing Kubernetes clusters. It offers self-service orchestration, centralized management, and optional professional services. Create clusters using cloud-native tools, and benefit from high resilience and optimized costs through autoscaling and hibernation. EMK is a robust and reliable solution with a touch of Dutch innovation.

## 1. Create an account
Create a Fuga Cloud Account on [https://my.fuga.cloud](https://my.fuga.cloud).

## 2. Create Kubernetes Cluster

Login to the Fuga Cloud Dashboard to create a Kubernetes Clusters on OpenStack. To do this navigate to "EMK" in the sidebar or follow this link [https://my.fuga.cloud/managed-kubernetes](https://my.fuga.cloud/managed-kubernetes).

In the "Clusters" menu, select the "Create cluster +". A new page appears to create a new Kubernetes cluster.
- Select the region of your cluster
- Choose the name of your cluster
- Select the Kubernetes version
- Select the networking type of your cluster (we validated the conformance with calico)
- Configure a worker pool (our validation for the conformance is done with 3 to 5 worker at emk1.medium)

## 3. Get the kubeconfig

### below version v1.27

Follow these steps with static kubeconfig enabled, otherwise follow the ones for v1.27 and newer.

Go to the "EMK" tab and select your cluster, view "access" to copy or download your kubeconfig.

### version v1.27 and newer

From version v1.27 it is not allowed to use static kubeconfigs.

To get access the cluster some extra steps are required. From now on it is only possible to request a temporary or known as dynamic kubeconfig.

Go to the "EMK" tab and select the "Service Accounts" sub tab. Here you can use the already created "default" or create one yourself. It is required to have the `admin` role enabled. Download the service account kubeconfig.

Then create the file `kubeconfig-request.json`:
```bash
% cat > kubeconfig-request.json <<EOF
{
    "apiVersion": "authentication.gardener.cloud/v1alpha1",
    "kind": "AdminKubeconfigRequest",
    "spec": {
        "expirationSeconds": 3600
    }
}
EOF
```
Then request a cluster kubeconfig that has an expiration time for 1h:
```bash
% NAMESPACE=garden-<your_emk_project_name>
% SHOOT=<your_shoot_name>

% kubectl create \
    --kubeconfig service-account-kubeconfig.yaml \
    --filename ./kubeconfig-request.json \
    --raw /apis/core.gardener.cloud/v1beta1/namespaces/${NAMESPACE}/shoots/${SHOOT}/adminkubeconfig \
    | jq -r ".status.kubeconfig | @base64d" \
    > config-${SHOOT}.yaml
```
Then access to the cluster is possible through the `config-<shoot>.yaml` kubeconfig.

## 4. Install Sonobuoy

On the new kubernetes cluster run the Conformance tests using the following
commands:

```sh
$ go install github.com/vmware-tanzu/sonobuoy@latest

```

## 5. Run Conformance Test

```sh
$ sonobuoy run --mode=certified-conformance
INFO[0000] create request issued                         name=sonobuoy namespace= resource=namespaces
INFO[0000] create request issued                         name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
INFO[0000] create request issued                         name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
INFO[0000] create request issued                         name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
INFO[0000] create request issued                         name=sonobuoy namespace=sonobuoy resource=pods
INFO[0000] create request issued                         name=sonobuoy-aggregator namespace=sonobuoy resource=services
```

Watch Sonobuoy's status with:

```sh
$ sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT                                PROGRESS
            e2e   complete   passed       1   Passed:388, Failed:  0, Remaining:  0
   systemd-logs   complete   passed       6                                        

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Check Sonobuoy's logs with:
```sh
$ sonobuoy retrieve
202404201110_sonobuoy_2b474c98-ea91-4272-ab70-18f5bec5c921.tar.gz
```