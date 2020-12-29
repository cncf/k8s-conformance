# Run Conformance Test using Sonobuoy on `CAPD` target cluster

## Pre-requisites

- Install [Docker](https://www.docker.com/)
- Install [Kind](https://kind.sigs.k8s.io/)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Disable swap on the VM using `sudo swapoff -a`

## Test Scenario

In order to run conformance tests, we need a minimum 3 nodes kubernetes cluster. To meet this requirement, we deploy a kubernetes cluster of 1 control-plane and 2 worker nodes on `CAPD` provider. The target cluster is deployed with `airshipctl phase run` workflow.

### Steps to deploy control-plane and workers 

Download latest airshipctl 
Download deployment scripts from [PS 763232](https://review.opendev.org/c/airship/airshipctl/+/763232)
```
$rm -rf ~/.airship

$mkdir /tmp/airship

$cd /tmp/airship

$git clone https://review.opendev.org/airship/airshipctl

# Download common scripts, we'd use them to deploy the clusters
$git review -d 763232
```

Set Environment variables in order to run the deployment scripts.
 

```
unset AIRSHIP_SRC KUBECONFIG  WORKERS_COUNT  CONTROLPLANE_COUNT  TEST_SITE  TARGET_CLUSTER_NAME KIND_EXPERIMENTAL_DOCKER_NETWORK
export AIRSHIP_SRC="/tmp/airship"
export KUBECONFIG="$HOME/.airship/kubeconfig"
export WORKERS_COUNT=${WORKERS_COUNT:-"2"}
export CONTROLPLANE_COUNT=${CONTROLPLANE_COUNT:-"1"}
export TEST_SITE=${TEST_SITE:-"docker-test-site"}
export TARGET_CLUSTER_NAME=${TARGET_CLUSTER_NAME:-"target-cluster"}
export KIND_EXPERIMENTAL_DOCKER_NETWORK=bridge
export PROVIDER=default
```

Clean Up existing clusters
```
$kind delete clusters --all
Deleted clusters: []
```

Run deployment scripts

Create a `Kind` cluster
```
$CLUSTER=ephemeral-cluster KIND_CONFIG=./tools/deployment/templates/kind-cluster-with-extramounts ./tools/document/start_kind.sh
cluster name: ephemeral-cluster
config file: ./tools/deployment/templates/kind-cluster-with-extramounts
Creating cluster "ephemeral-cluster" ...
WARNING: Overriding docker network due to KIND_EXPERIMENTAL_DOCKER_NETWORK
WARNING: Here be dragons! This is not supported currently.
 ✓ Ensuring node image (kindest/node:v1.19.1) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Waiting ≤ 2m0s for control-plane = Ready ⏳
 • Ready after 1m8s 💚
Set kubectl context to "kind-ephemeral-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-ephemeral-cluster --kubeconfig /home/stack/.airship/kubeconfig

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
node/ephemeral-cluster-control-plane condition met
Context "ephemeral-cluster" created.
This cluster can be deleted via:
/usr/local/bin/kind delete cluster --name ephemeral-cluster
```

Create `ephemeral-cluster` context and required configuration
```
./tools/deployment/provider_common/03-init-airship-config.sh
+ export KUBECONFIG=/home/stack/.airship/kubeconfig
+ KUBECONFIG=/home/stack/.airship/kubeconfig
+ export AIRSHIP_SRC=/tmp/airship
+ AIRSHIP_SRC=/tmp/airship
+ export TEST_SITE=docker-test-site
+ TEST_SITE=docker-test-site
+ export PROVIDER_MANIFEST=docker_manifest
+ PROVIDER_MANIFEST=docker_manifest
+ rm -rf /home/stack/.airship/config
+ airshipctl config init
+ airshipctl config set-manifest docker_manifest --repo primary --phase --url https://opendev.org/airship/airshipctl --branch master --metadata-path manifests/site/docker-test-site/metadata.yaml --target-path /tmp/airship
Manifest "docker_manifest" created.
+ airshipctl config set-context ephemeral-cluster --manifest docker_manifest
Context "ephemeral-cluster" created.
+ airshipctl config get-context
contextKubeconf: ""
managementConfiguration: default
manifest: default

contextKubeconf: ephemeral-cluster
managementConfiguration: ""
manifest: docker_manifest

+ airshipctl config use-context ephemeral-cluster
Switched to context "ephemeral-cluster".
+ airshipctl phase plan
GROUP    PHASE
group1
         clusterctl-init-ephemeral
         controlplane-ephemeral
         clusterctl-init-target
         clusterctl-move
         workers-target
```

Initialize `capi` and `capd` components in the `ephemeral` cluster
```
$ PROVIDER=default TEST_SITE=docker-test-site PROVIDER_MANIFEST=docker_manifest ./tools/deployment/26_deploy_capi_ephemeral_node.sh

+ export PROVIDER=default
+ PROVIDER=default
+ export KUBECONFIG=/home/stack/.airship/kubeconfig
+ KUBECONFIG=/home/stack/.airship/kubeconfig
+ export KUBECONFIG_EPHEMERAL_CONTEXT=ephemeral-cluster
+ KUBECONFIG_EPHEMERAL_CONTEXT=ephemeral-cluster
+ '[' default = metal3 ']'
+ kubectl --kubeconfig /home/stack/.airship/kubeconfig --context ephemeral-cluster get pods -A
NAMESPACE            NAME                                                      READY   STATUS    RESTARTS   AGE
kube-system          coredns-f9fd979d6-dlkwm                                   1/1     Running   0          2m12s
kube-system          coredns-f9fd979d6-wgl7v                                   1/1     Running   0          2m12s
kube-system          etcd-ephemeral-cluster-control-plane                      1/1     Running   0          2m28s
kube-system          kindnet-qw2bz                                             1/1     Running   0          2m12s
kube-system          kube-apiserver-ephemeral-cluster-control-plane            1/1     Running   0          2m28s
kube-system          kube-controller-manager-ephemeral-cluster-control-plane   1/1     Running   0          2m27s
kube-system          kube-proxy-x6w6w                                          1/1     Running   0          2m12s
kube-system          kube-scheduler-ephemeral-cluster-control-plane            1/1     Running   0          2m28s
local-path-storage   local-path-provisioner-78776bfc44-97q5k                   1/1     Running   0          2m12s
+ echo 'Deploy cluster-api components to ephemeral node'
Deploy cluster-api components to ephemeral node
+ '[' default = metal3 ']'
+ airshipctl phase run clusterctl-init-ephemeral --debug --kubeconfig /home/stack/.airship/kubeconfig
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CABPK_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPD_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPI_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPM3_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPM3_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPO_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPO_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CABPK_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CACPK_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CACPK_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPD_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPI_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/client/client.go:81: Starting cluster-api initiation
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/events/processor.go:61: Received event: {4 2020-11-23 21:49:32.140673381 +0000 UTC m=+7.478310860 {InitType {[]} {<nil>} {ApplyEventResourceUpdate ServersideApplied <nil>} {ResourceUpdateEvent <nil> <nil>} {PruneEventResourceUpdate Pruned <nil>} {DeleteEventResourceUpdate Deleted <nil>}} {<nil>} {ResourceUpdateEvent <nil> <nil>} {0 starting clusterctl init executor} {0 } {0 }}
Installing the clusterctl inventory CRD
Creating CustomResourceDefinition="providers.clusterctl.cluster.x-k8s.io"
Fetching providers
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider cluster-api of type CoreProvider
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: CoreProvider, name: cluster-api
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: CoreProvider, name: cluster-api
Fetching File="components.yaml" Provider="cluster-api" Version="v0.3.7"
[airshipctl] 2020/11/23 21:49:32 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capi/v0.3.7
[airshipctl] 2020/11/23 21:49:33 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type BootstrapProvider
[airshipctl] 2020/11/23 21:49:33 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: BootstrapProvider, name: kubeadm
[airshipctl] 2020/11/23 21:49:33 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: BootstrapProvider, name: kubeadm
Fetching File="components.yaml" Provider="bootstrap-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:49:33 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cabpk/v0.3.7
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type ControlPlaneProvider
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: ControlPlaneProvider, name: kubeadm
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: ControlPlaneProvider, name: kubeadm
Fetching File="components.yaml" Provider="control-plane-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cacpk/v0.3.7
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider docker of type InfrastructureProvider
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: InfrastructureProvider, name: docker
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: InfrastructureProvider, name: docker
Fetching File="components.yaml" Provider="infrastructure-docker" Version="v0.3.11"
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capd/v0.3.11
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider cluster-api of type CoreProvider
Fetching File="metadata.yaml" Provider="cluster-api" Version="v0.3.7"
[airshipctl] 2020/11/23 21:49:35 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capi/v0.3.7
[airshipctl] 2020/11/23 21:49:36 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type BootstrapProvider
Fetching File="metadata.yaml" Provider="bootstrap-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:49:36 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cabpk/v0.3.7
[airshipctl] 2020/11/23 21:49:36 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type ControlPlaneProvider
Fetching File="metadata.yaml" Provider="control-plane-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:49:36 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cacpk/v0.3.7
[airshipctl] 2020/11/23 21:49:37 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider docker of type InfrastructureProvider
Fetching File="metadata.yaml" Provider="infrastructure-docker" Version="v0.3.11"
[airshipctl] 2020/11/23 21:49:37 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capd/v0.3.11
Creating Namespace="cert-manager-test"
Installing cert-manager Version="v0.16.1"
Creating Namespace="cert-manager"
Creating CustomResourceDefinition="certificaterequests.cert-manager.io"
Creating CustomResourceDefinition="certificates.cert-manager.io"
Creating CustomResourceDefinition="challenges.acme.cert-manager.io"
Creating CustomResourceDefinition="clusterissuers.cert-manager.io"
Creating CustomResourceDefinition="issuers.cert-manager.io"
Creating CustomResourceDefinition="orders.acme.cert-manager.io"
Creating ServiceAccount="cert-manager-cainjector" Namespace="cert-manager"
Creating ServiceAccount="cert-manager" Namespace="cert-manager"
Creating ServiceAccount="cert-manager-webhook" Namespace="cert-manager"
Creating ClusterRole="cert-manager-cainjector"
Creating ClusterRole="cert-manager-controller-issuers"
Creating ClusterRole="cert-manager-controller-clusterissuers"
Creating ClusterRole="cert-manager-controller-certificates"
Creating ClusterRole="cert-manager-controller-orders"
Creating ClusterRole="cert-manager-controller-challenges"
Creating ClusterRole="cert-manager-controller-ingress-shim"
Creating ClusterRole="cert-manager-view"
Creating ClusterRole="cert-manager-edit"
Creating ClusterRoleBinding="cert-manager-cainjector"
Creating ClusterRoleBinding="cert-manager-controller-issuers"
Creating ClusterRoleBinding="cert-manager-controller-clusterissuers"
Creating ClusterRoleBinding="cert-manager-controller-certificates"
Creating ClusterRoleBinding="cert-manager-controller-orders"
Creating ClusterRoleBinding="cert-manager-controller-challenges"
Creating ClusterRoleBinding="cert-manager-controller-ingress-shim"
Creating Role="cert-manager-cainjector:leaderelection" Namespace="kube-system"
Creating Role="cert-manager:leaderelection" Namespace="kube-system"
Creating Role="cert-manager-webhook:dynamic-serving" Namespace="cert-manager"
Creating RoleBinding="cert-manager-cainjector:leaderelection" Namespace="kube-system"
Creating RoleBinding="cert-manager:leaderelection" Namespace="kube-system"
Creating RoleBinding="cert-manager-webhook:dynamic-serving" Namespace="cert-manager"
Creating Service="cert-manager" Namespace="cert-manager"
Creating Service="cert-manager-webhook" Namespace="cert-manager"
Creating Deployment="cert-manager-cainjector" Namespace="cert-manager"
Creating Deployment="cert-manager" Namespace="cert-manager"
Creating Deployment="cert-manager-webhook" Namespace="cert-manager"
Creating MutatingWebhookConfiguration="cert-manager-webhook"
Creating ValidatingWebhookConfiguration="cert-manager-webhook"
Waiting for cert-manager to be available...
Updating Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Certificate="selfsigned-cert" Namespace="cert-manager-test"
Deleting Namespace="cert-manager-test"
Deleting Issuer="test-selfsigned" Namespace="cert-manager-test"
Deleting Certificate="selfsigned-cert" Namespace="cert-manager-test"
Installing Provider="cluster-api" Version="v0.3.7" TargetNamespace="capi-system"
Creating shared objects Provider="cluster-api" Version="v0.3.7"
Creating Namespace="capi-webhook-system"
Creating CustomResourceDefinition="clusterresourcesetbindings.addons.cluster.x-k8s.io"
Creating CustomResourceDefinition="clusterresourcesets.addons.cluster.x-k8s.io"
Creating CustomResourceDefinition="clusters.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinedeployments.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinehealthchecks.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinepools.exp.cluster.x-k8s.io"
Creating CustomResourceDefinition="machines.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinesets.cluster.x-k8s.io"
Creating Service="capi-webhook-service" Namespace="capi-webhook-system"
Creating Deployment="capi-controller-manager" Namespace="capi-webhook-system"
Creating Certificate="capi-serving-cert" Namespace="capi-webhook-system"
Creating Issuer="capi-selfsigned-issuer" Namespace="capi-webhook-system"
Creating MutatingWebhookConfiguration="capi-mutating-webhook-configuration"
Creating ValidatingWebhookConfiguration="capi-validating-webhook-configuration"
Creating instance objects Provider="cluster-api" Version="v0.3.7" TargetNamespace="capi-system"
Creating Namespace="capi-system"
Creating Role="capi-leader-election-role" Namespace="capi-system"
Creating ClusterRole="capi-system-capi-aggregated-manager-role"
Creating ClusterRole="capi-system-capi-manager-role"
Creating ClusterRole="capi-system-capi-proxy-role"
Creating RoleBinding="capi-leader-election-rolebinding" Namespace="capi-system"
Creating ClusterRoleBinding="capi-system-capi-manager-rolebinding"
Creating ClusterRoleBinding="capi-system-capi-proxy-rolebinding"
Creating Service="capi-controller-manager-metrics-service" Namespace="capi-system"
Creating Deployment="capi-controller-manager" Namespace="capi-system"
Creating inventory entry Provider="cluster-api" Version="v0.3.7" TargetNamespace="capi-system"
Installing Provider="bootstrap-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-bootstrap-system"
Creating shared objects Provider="bootstrap-kubeadm" Version="v0.3.7"
Creating CustomResourceDefinition="kubeadmconfigs.bootstrap.cluster.x-k8s.io"
Creating CustomResourceDefinition="kubeadmconfigtemplates.bootstrap.cluster.x-k8s.io"
Creating Service="capi-kubeadm-bootstrap-webhook-service" Namespace="capi-webhook-system"
Creating Deployment="capi-kubeadm-bootstrap-controller-manager" Namespace="capi-webhook-system"
Creating Certificate="capi-kubeadm-bootstrap-serving-cert" Namespace="capi-webhook-system"
Creating Issuer="capi-kubeadm-bootstrap-selfsigned-issuer" Namespace="capi-webhook-system"
Creating ValidatingWebhookConfiguration="capi-kubeadm-bootstrap-validating-webhook-configuration"
Creating instance objects Provider="bootstrap-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-bootstrap-system"
Creating Namespace="capi-kubeadm-bootstrap-system"
Creating Role="capi-kubeadm-bootstrap-leader-election-role" Namespace="capi-kubeadm-bootstrap-system"
Creating ClusterRole="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-manager-role"
Creating ClusterRole="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-proxy-role"
Creating RoleBinding="capi-kubeadm-bootstrap-leader-election-rolebinding" Namespace="capi-kubeadm-bootstrap-system"
Creating ClusterRoleBinding="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-manager-rolebinding"
Creating ClusterRoleBinding="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-proxy-rolebinding"
Creating Service="capi-kubeadm-bootstrap-controller-manager-metrics-service" Namespace="capi-kubeadm-bootstrap-system"
Creating Deployment="capi-kubeadm-bootstrap-controller-manager" Namespace="capi-kubeadm-bootstrap-system"
Creating inventory entry Provider="bootstrap-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-bootstrap-system"
Installing Provider="control-plane-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-control-plane-system"
Creating shared objects Provider="control-plane-kubeadm" Version="v0.3.7"
Creating CustomResourceDefinition="kubeadmcontrolplanes.controlplane.cluster.x-k8s.io"
Creating Service="capi-kubeadm-control-plane-webhook-service" Namespace="capi-webhook-system"
Creating Deployment="capi-kubeadm-control-plane-controller-manager" Namespace="capi-webhook-system"
Creating Certificate="capi-kubeadm-control-plane-serving-cert" Namespace="capi-webhook-system"
Creating Issuer="capi-kubeadm-control-plane-selfsigned-issuer" Namespace="capi-webhook-system"
Creating MutatingWebhookConfiguration="capi-kubeadm-control-plane-mutating-webhook-configuration"
Creating ValidatingWebhookConfiguration="capi-kubeadm-control-plane-validating-webhook-configuration"
Creating instance objects Provider="control-plane-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-control-plane-system"
Creating Namespace="capi-kubeadm-control-plane-system"
Creating Role="capi-kubeadm-control-plane-leader-election-role" Namespace="capi-kubeadm-control-plane-system"
Creating Role="capi-kubeadm-control-plane-manager-role" Namespace="capi-kubeadm-control-plane-system"
Creating ClusterRole="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-aggregated-manager-role"
Creating ClusterRole="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-manager-role"
Creating ClusterRole="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-proxy-role"
Creating RoleBinding="capi-kubeadm-control-plane-leader-election-rolebinding" Namespace="capi-kubeadm-control-plane-system"
Creating ClusterRoleBinding="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-manager-rolebinding"
Creating ClusterRoleBinding="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-proxy-rolebinding"
Creating Service="capi-kubeadm-control-plane-controller-manager-metrics-service" Namespace="capi-kubeadm-control-plane-system"
Creating Deployment="capi-kubeadm-control-plane-controller-manager" Namespace="capi-kubeadm-control-plane-system"
Creating inventory entry Provider="control-plane-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-control-plane-system"
Installing Provider="infrastructure-docker" Version="v0.3.11" TargetNamespace="capd-system"
Creating shared objects Provider="infrastructure-docker" Version="v0.3.11"
Creating CustomResourceDefinition="dockerclusters.infrastructure.cluster.x-k8s.io"
Creating CustomResourceDefinition="dockermachinepools.exp.infrastructure.cluster.x-k8s.io"
Creating CustomResourceDefinition="dockermachines.infrastructure.cluster.x-k8s.io"
Creating CustomResourceDefinition="dockermachinetemplates.infrastructure.cluster.x-k8s.io"
Creating ValidatingWebhookConfiguration="capd-validating-webhook-configuration"
Creating instance objects Provider="infrastructure-docker" Version="v0.3.11" TargetNamespace="capd-system"
Creating Namespace="capd-system"
Creating Role="capd-leader-election-role" Namespace="capd-system"
Creating ClusterRole="capd-system-capd-manager-role"
Creating ClusterRole="capd-system-capd-proxy-role"
Creating RoleBinding="capd-leader-election-rolebinding" Namespace="capd-system"
Creating ClusterRoleBinding="capd-system-capd-manager-rolebinding"
Creating ClusterRoleBinding="capd-system-capd-proxy-rolebinding"
Creating Service="capd-controller-manager-metrics-service" Namespace="capd-system"
Creating Service="capd-webhook-service" Namespace="capd-system"
Creating Deployment="capd-controller-manager" Namespace="capd-system"
Creating Certificate="capd-serving-cert" Namespace="capd-system"
Creating Issuer="capd-selfsigned-issuer" Namespace="capd-system"
Creating inventory entry Provider="infrastructure-docker" Version="v0.3.11" TargetNamespace="capd-system"
[airshipctl] 2020/11/23 21:50:56 opendev.org/airship/airshipctl@/pkg/events/processor.go:61: Received event: {4 2020-11-23 21:50:56.359398374 +0000 UTC m=+91.697035853 {InitType {[]} {<nil>} {ApplyEventResourceUpdate ServersideApplied <nil>} {ResourceUpdateEvent <nil> <nil>} {PruneEventResourceUpdate Pruned <nil>} {DeleteEventResourceUpdate Deleted <nil>}} {<nil>} {ResourceUpdateEvent <nil> <nil>} {1 clusterctl init completed successfully} {0 } {0 }}
+ echo 'Waiting for clusterapi pods to come up'
Waiting for clusterapi pods to come up
+ kubectl --kubeconfig /home/stack/.airship/kubeconfig --context ephemeral-cluster wait --for=condition=available deploy --all --timeout=1000s -A
deployment.apps/capd-controller-manager condition met
deployment.apps/capi-kubeadm-bootstrap-controller-manager condition met
deployment.apps/capi-kubeadm-control-plane-controller-manager condition met
deployment.apps/capi-controller-manager condition met
deployment.apps/capi-controller-manager condition met
deployment.apps/capi-kubeadm-bootstrap-controller-manager condition met
deployment.apps/capi-kubeadm-control-plane-controller-manager condition met
deployment.apps/cert-manager condition met
deployment.apps/cert-manager-cainjector condition met
deployment.apps/cert-manager-webhook condition met
deployment.apps/coredns condition met
deployment.apps/local-path-provisioner condition met
+ kubectl --kubeconfig /home/stack/.airship/kubeconfig --context ephemeral-cluster get pods --all-namespaces
NAMESPACE                           NAME                                                             READY   STATUS    RESTARTS   AGE
capd-system                         capd-controller-manager-6bf6bc7587-k6q87                         2/2     Running   0          22s
capi-kubeadm-bootstrap-system       capi-kubeadm-bootstrap-controller-manager-5646d9589c-79dck       2/2     Running   0          44s
capi-kubeadm-control-plane-system   capi-kubeadm-control-plane-controller-manager-759bf846fc-hl8t7   2/2     Running   0          33s
capi-system                         capi-controller-manager-5d6b4d6769-gxkwb                         2/2     Running   0          52s
capi-webhook-system                 capi-controller-manager-548d4869b4-tn44m                         2/2     Running   0          56s
capi-webhook-system                 capi-kubeadm-bootstrap-controller-manager-6949f44db8-sbnmj       2/2     Running   0          48s
capi-webhook-system                 capi-kubeadm-control-plane-controller-manager-7b6c4bf48d-lr7qm   2/2     Running   0          39s
cert-manager                        cert-manager-cainjector-fc6c787db-brwsd                          1/1     Running   0          92s
cert-manager                        cert-manager-d994d94d7-8jpjp                                     1/1     Running   0          92s
cert-manager                        cert-manager-webhook-845d9df8bf-ph452                            1/1     Running   0          91s
kube-system                         coredns-f9fd979d6-dlkwm                                          1/1     Running   0          4m3s
kube-system                         coredns-f9fd979d6-wgl7v                                          1/1     Running   0          4m3s
kube-system                         etcd-ephemeral-cluster-control-plane                             1/1     Running   0          4m19s
kube-system                         kindnet-qw2bz                                                    1/1     Running   0          4m3s
kube-system                         kube-apiserver-ephemeral-cluster-control-plane                   1/1     Running   0          4m19s
kube-system                         kube-controller-manager-ephemeral-cluster-control-plane          1/1     Running   0          4m18s
kube-system                         kube-proxy-x6w6w                                                 1/1     Running   0          4m3s
kube-system                         kube-scheduler-ephemeral-cluster-control-plane                   1/1     Running   0          4m19s
local-path-storage                  local-path-provisioner-78776bfc44-97q5k                          1/1     Running   0          4m3s
```

Deploy the control plane node of the target cluster
```
$CONTROLPLANE_COUNT=1 TEST_SITE=docker-test-site ./tools/deployment/provider_common/30_deploy_controlplane.sh

create control plane
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:129: Getting kubeconfig context name from cluster map
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:134: Getting kubeconfig file information from kubeconfig provider
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:139: Filtering out documents that shouldn't be applied to kubernetes from document bundle
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:147: Using kubeconfig at '/home/stack/.airship/kubeconfig' and context 'ephemeral-cluster'
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:118: WaitTimeout: 33m20s
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:76: Getting infos for bundle, inventory id is controlplane-ephemeral
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:106: Inventory Object config Map not found, auto generating Inventory object
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:113: Injecting Inventory Object: {"apiVersion":"v1","kind":"ConfigMap","metadata":{"creationTimestamp":null,"labels":{"cli-utils.sigs.k8s.io/inventory-id":"controlplane-ephemeral"},"name":"airshipit-controlplane-ephemeral","namespace":"airshipit"}}{nsfx:false,beh:unspecified} into bundle
[airshipctl] 2020/11/23 21:53:25 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:119: Making sure that inventory object namespace airshipit exists
cluster.cluster.x-k8s.io/target-cluster created
dockercluster.infrastructure.cluster.x-k8s.io/target-cluster created
dockermachinetemplate.infrastructure.cluster.x-k8s.io/target-cluster-control-plane created
kubeadmcontrolplane.controlplane.cluster.x-k8s.io/target-cluster-control-plane created
machinehealthcheck.cluster.x-k8s.io/target-cluster-mhc-0 created
5 resource(s) applied. 5 created, 0 unchanged, 0 configured
cluster.cluster.x-k8s.io/target-cluster is NotFound: Resource not found
dockercluster.infrastructure.cluster.x-k8s.io/target-cluster is NotFound: Resource not found
dockermachinetemplate.infrastructure.cluster.x-k8s.io/target-cluster-control-plane is NotFound: Resource not found
kubeadmcontrolplane.controlplane.cluster.x-k8s.io/target-cluster-control-plane is NotFound: Resource not found
machinehealthcheck.cluster.x-k8s.io/target-cluster-mhc-0 is NotFound: Resource not found
cluster.cluster.x-k8s.io/target-cluster is InProgress:
dockercluster.infrastructure.cluster.x-k8s.io/target-cluster is Current: Resource is current
dockermachinetemplate.infrastructure.cluster.x-k8s.io/target-cluster-control-plane is Current: Resource is current
kubeadmcontrolplane.controlplane.cluster.x-k8s.io/target-cluster-control-plane is Current: Resource is current
machinehealthcheck.cluster.x-k8s.io/target-cluster-mhc-0 is Current: Resource is current
cluster.cluster.x-k8s.io/target-cluster is InProgress:
dockercluster.infrastructure.cluster.x-k8s.io/target-cluster is Current: Resource is Ready
cluster.cluster.x-k8s.io/target-cluster is InProgress: Scaling up to 1 replicas (actual 0)
kubeadmcontrolplane.controlplane.cluster.x-k8s.io/target-cluster-control-plane is InProgress: Scaling up to 1 replicas (actual 0)
cluster.cluster.x-k8s.io/target-cluster is Current: Resource is Ready
kubeadmcontrolplane.controlplane.cluster.x-k8s.io/target-cluster-control-plane is Current: Resource is Ready
all resources has reached the Current status
Generate kubeconfig
Generate kubeconfig: /tmp/target-cluster.kubeconfig
add context target-cluster
Context "target-cluster" created.
Check nodes status
node/target-cluster-control-plane-dr7bc condition met
NAME                                 STATUS   ROLES    AGE   VERSION
target-cluster-control-plane-dr7bc   Ready    master   56s   v1.18.6
Waiting for  pods to come up
pod/calico-kube-controllers-5569bdd565-vx5cr condition met
pod/calico-node-2dd9w condition met
pod/coredns-66bff467f8-vhbgm condition met
pod/coredns-66bff467f8-wmqq5 condition met
pod/etcd-target-cluster-control-plane-dr7bc condition met
pod/kube-apiserver-target-cluster-control-plane-dr7bc condition met
pod/kube-controller-manager-target-cluster-control-plane-dr7bc condition met
pod/kube-proxy-lmvsv condition met
pod/kube-scheduler-target-cluster-control-plane-dr7bc condition met
NAMESPACE     NAME                                                         READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-5569bdd565-vx5cr                     1/1     Running   0          76s
kube-system   calico-node-2dd9w                                            1/1     Running   0          76s
kube-system   coredns-66bff467f8-vhbgm                                     1/1     Running   0          85s
kube-system   coredns-66bff467f8-wmqq5                                     1/1     Running   0          85s
kube-system   etcd-target-cluster-control-plane-dr7bc                      1/1     Running   0          97s
kube-system   kube-apiserver-target-cluster-control-plane-dr7bc            1/1     Running   0          97s
kube-system   kube-controller-manager-target-cluster-control-plane-dr7bc   1/1     Running   0          97s
kube-system   kube-proxy-lmvsv                                             1/1     Running   0          85s
kube-system   kube-scheduler-target-cluster-control-plane-dr7bc            1/1     Running   0          97s
NAME                                 PROVIDERID                                      PHASE
target-cluster-control-plane-dr7bc   docker:////target-cluster-control-plane-dr7bc   Running
Get cluster state for target workload cluster
NAME             PHASE
target-cluster   Provisioned
Target Cluster Kubeconfig
/tmp/target-cluster.kubeconfig
```

Initialize `target-cluster` controlplane with `capi` and provider components

```
$ KUBECONFIG=/tmp/target-cluster.kubeconfig ./tools/deployment/provider_common/32_cluster_init_target_node.sh

+ export KUBECONFIG=/tmp/target-cluster.kubeconfig
+ KUBECONFIG=/tmp/target-cluster.kubeconfig
+ export KUBECONFIG_TARGET_CONTEXT=target-cluster
+ KUBECONFIG_TARGET_CONTEXT=target-cluster
+ CONTROL_PLANE_NODES=($(kubectl --kubeconfig $KUBECONFIG get --no-headers=true nodes | grep cluster-control-plane | awk '{print $1}'))
++ grep cluster-control-plane
++ awk '{print $1}'
++ kubectl --kubeconfig /tmp/target-cluster.kubeconfig get --no-headers=true nodes
+ for i in "${CONTROL_PLANE_NODES}"
+ echo untainting node target-cluster-control-plane-dr7bc
untainting node target-cluster-control-plane-dr7bc
+ kubectl taint node target-cluster-control-plane-dr7bc node-role.kubernetes.io/master- --kubeconfig /tmp/target-cluster.kubeconfig --request-timeout 10s
node/target-cluster-control-plane-dr7bc untainted
+ echo 'Deploy CAPI components to target cluster'
Deploy CAPI components to target cluster
+ airshipctl phase run clusterctl-init-target --debug --kubeconfig /tmp/target-cluster.kubeconfig
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPO_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CABPK_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CACPK_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPI_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPI_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPM3_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPO_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CABPK_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CACPK_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPD_AUTH_PROXY is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPD_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/reader.go:109: Verifying that variable CONTAINER_CAPM3_MANAGER is allowed to be appended
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/clusterctl/client/client.go:81: Starting cluster-api initiation
[airshipctl] 2020/11/23 21:58:01 opendev.org/airship/airshipctl@/pkg/events/processor.go:61: Received event: {4 2020-11-23 21:58:01.70847718 +0000 UTC m=+9.470940513 {InitType {[]} {<nil>} {ApplyEventResourceUpdate ServersideApplied <nil>} {ResourceUpdateEvent <nil> <nil>} {PruneEventResourceUpdate Pruned <nil>} {DeleteEventResourceUpdate Deleted <nil>}} {<nil>} {ResourceUpdateEvent <nil> <nil>} {0 starting clusterctl init executor} {0 } {0 }}
Installing the clusterctl inventory CRD
Creating CustomResourceDefinition="providers.clusterctl.cluster.x-k8s.io"
Fetching providers
[airshipctl] 2020/11/23 21:58:02 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider cluster-api of type CoreProvider
[airshipctl] 2020/11/23 21:58:02 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: CoreProvider, name: cluster-api
[airshipctl] 2020/11/23 21:58:02 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: CoreProvider, name: cluster-api
Fetching File="components.yaml" Provider="cluster-api" Version="v0.3.7"
[airshipctl] 2020/11/23 21:58:02 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capi/v0.3.7
[airshipctl] 2020/11/23 21:58:03 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type BootstrapProvider
[airshipctl] 2020/11/23 21:58:03 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: BootstrapProvider, name: kubeadm
[airshipctl] 2020/11/23 21:58:03 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: BootstrapProvider, name: kubeadm
Fetching File="components.yaml" Provider="bootstrap-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:58:03 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cabpk/v0.3.7
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type ControlPlaneProvider
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: ControlPlaneProvider, name: kubeadm
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: ControlPlaneProvider, name: kubeadm
Fetching File="components.yaml" Provider="control-plane-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cacpk/v0.3.7
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider docker of type InfrastructureProvider
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository_client.go:37: Setting up airshipctl provider Components client
Provider type: InfrastructureProvider, name: docker
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/components_client.go:38: Getting airshipctl provider components, skipping variable substitution: false.
Provider type: InfrastructureProvider, name: docker
Fetching File="components.yaml" Provider="infrastructure-docker" Version="v0.3.11"
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capd/v0.3.11
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider cluster-api of type CoreProvider
Fetching File="metadata.yaml" Provider="cluster-api" Version="v0.3.7"
[airshipctl] 2020/11/23 21:58:05 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capi/v0.3.7
[airshipctl] 2020/11/23 21:58:06 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type BootstrapProvider
Fetching File="metadata.yaml" Provider="bootstrap-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:58:06 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cabpk/v0.3.7
[airshipctl] 2020/11/23 21:58:07 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider kubeadm of type ControlPlaneProvider
Fetching File="metadata.yaml" Provider="control-plane-kubeadm" Version="v0.3.7"
[airshipctl] 2020/11/23 21:58:07 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/cacpk/v0.3.7
[airshipctl] 2020/11/23 21:58:07 opendev.org/airship/airshipctl@/pkg/clusterctl/client/factory.go:86: Creating airshipctl repository implementation interface for provider docker of type InfrastructureProvider
Fetching File="metadata.yaml" Provider="infrastructure-docker" Version="v0.3.11"
[airshipctl] 2020/11/23 21:58:07 opendev.org/airship/airshipctl@/pkg/clusterctl/implementations/repository.go:83: Building cluster-api provider component documents from kustomize path at /tmp/airship/airshipctl/manifests/function/capd/v0.3.11
Creating Namespace="cert-manager-test"
Installing cert-manager Version="v0.16.1"
Creating Namespace="cert-manager"
Creating CustomResourceDefinition="certificaterequests.cert-manager.io"
Creating CustomResourceDefinition="certificates.cert-manager.io"
Creating CustomResourceDefinition="challenges.acme.cert-manager.io"
Creating CustomResourceDefinition="clusterissuers.cert-manager.io"
Creating CustomResourceDefinition="issuers.cert-manager.io"
Creating CustomResourceDefinition="orders.acme.cert-manager.io"
Creating ServiceAccount="cert-manager-cainjector" Namespace="cert-manager"
Creating ServiceAccount="cert-manager" Namespace="cert-manager"
Creating ServiceAccount="cert-manager-webhook" Namespace="cert-manager"
Creating ClusterRole="cert-manager-cainjector"
Creating ClusterRole="cert-manager-controller-issuers"
Creating ClusterRole="cert-manager-controller-clusterissuers"
Creating ClusterRole="cert-manager-controller-certificates"
Creating ClusterRole="cert-manager-controller-orders"
Creating ClusterRole="cert-manager-controller-challenges"
Creating ClusterRole="cert-manager-controller-ingress-shim"
Creating ClusterRole="cert-manager-view"
Creating ClusterRole="cert-manager-edit"
Creating ClusterRoleBinding="cert-manager-cainjector"
Creating ClusterRoleBinding="cert-manager-controller-issuers"
Creating ClusterRoleBinding="cert-manager-controller-clusterissuers"
Creating ClusterRoleBinding="cert-manager-controller-certificates"
Creating ClusterRoleBinding="cert-manager-controller-orders"
Creating ClusterRoleBinding="cert-manager-controller-challenges"
Creating ClusterRoleBinding="cert-manager-controller-ingress-shim"
Creating Role="cert-manager-cainjector:leaderelection" Namespace="kube-system"
Creating Role="cert-manager:leaderelection" Namespace="kube-system"
Creating Role="cert-manager-webhook:dynamic-serving" Namespace="cert-manager"
Creating RoleBinding="cert-manager-cainjector:leaderelection" Namespace="kube-system"
Creating RoleBinding="cert-manager:leaderelection" Namespace="kube-system"
Creating RoleBinding="cert-manager-webhook:dynamic-serving" Namespace="cert-manager"
Creating Service="cert-manager" Namespace="cert-manager"
Creating Service="cert-manager-webhook" Namespace="cert-manager"
Creating Deployment="cert-manager-cainjector" Namespace="cert-manager"
Creating Deployment="cert-manager" Namespace="cert-manager"
Creating Deployment="cert-manager-webhook" Namespace="cert-manager"
Creating MutatingWebhookConfiguration="cert-manager-webhook"
Creating ValidatingWebhookConfiguration="cert-manager-webhook"
Waiting for cert-manager to be available...
Updating Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Issuer="test-selfsigned" Namespace="cert-manager-test"
Creating Certificate="selfsigned-cert" Namespace="cert-manager-test"
Deleting Namespace="cert-manager-test"
Deleting Issuer="test-selfsigned" Namespace="cert-manager-test"
Deleting Certificate="selfsigned-cert" Namespace="cert-manager-test"
Installing Provider="cluster-api" Version="v0.3.7" TargetNamespace="capi-system"
Creating shared objects Provider="cluster-api" Version="v0.3.7"
Creating Namespace="capi-webhook-system"
Creating CustomResourceDefinition="clusterresourcesetbindings.addons.cluster.x-k8s.io"
Creating CustomResourceDefinition="clusterresourcesets.addons.cluster.x-k8s.io"
Creating CustomResourceDefinition="clusters.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinedeployments.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinehealthchecks.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinepools.exp.cluster.x-k8s.io"
Creating CustomResourceDefinition="machines.cluster.x-k8s.io"
Creating CustomResourceDefinition="machinesets.cluster.x-k8s.io"
Creating Service="capi-webhook-service" Namespace="capi-webhook-system"
Creating Deployment="capi-controller-manager" Namespace="capi-webhook-system"
Creating Certificate="capi-serving-cert" Namespace="capi-webhook-system"
Creating Issuer="capi-selfsigned-issuer" Namespace="capi-webhook-system"
Creating MutatingWebhookConfiguration="capi-mutating-webhook-configuration"
Creating ValidatingWebhookConfiguration="capi-validating-webhook-configuration"
Creating instance objects Provider="cluster-api" Version="v0.3.7" TargetNamespace="capi-system"
Creating Namespace="capi-system"
Creating Role="capi-leader-election-role" Namespace="capi-system"
Creating ClusterRole="capi-system-capi-aggregated-manager-role"
Creating ClusterRole="capi-system-capi-manager-role"
Creating ClusterRole="capi-system-capi-proxy-role"
Creating RoleBinding="capi-leader-election-rolebinding" Namespace="capi-system"
Creating ClusterRoleBinding="capi-system-capi-manager-rolebinding"
Creating ClusterRoleBinding="capi-system-capi-proxy-rolebinding"
Creating Service="capi-controller-manager-metrics-service" Namespace="capi-system"
Creating Deployment="capi-controller-manager" Namespace="capi-system"
Creating inventory entry Provider="cluster-api" Version="v0.3.7" TargetNamespace="capi-system"
Installing Provider="bootstrap-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-bootstrap-system"
Creating shared objects Provider="bootstrap-kubeadm" Version="v0.3.7"
Creating CustomResourceDefinition="kubeadmconfigs.bootstrap.cluster.x-k8s.io"
Creating CustomResourceDefinition="kubeadmconfigtemplates.bootstrap.cluster.x-k8s.io"
Creating Service="capi-kubeadm-bootstrap-webhook-service" Namespace="capi-webhook-system"
Creating Deployment="capi-kubeadm-bootstrap-controller-manager" Namespace="capi-webhook-system"
Creating Certificate="capi-kubeadm-bootstrap-serving-cert" Namespace="capi-webhook-system"
Creating Issuer="capi-kubeadm-bootstrap-selfsigned-issuer" Namespace="capi-webhook-system"
Creating ValidatingWebhookConfiguration="capi-kubeadm-bootstrap-validating-webhook-configuration"
Creating instance objects Provider="bootstrap-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-bootstrap-system"
Creating Namespace="capi-kubeadm-bootstrap-system"
Creating Role="capi-kubeadm-bootstrap-leader-election-role" Namespace="capi-kubeadm-bootstrap-system"
Creating ClusterRole="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-manager-role"
Creating ClusterRole="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-proxy-role"
Creating RoleBinding="capi-kubeadm-bootstrap-leader-election-rolebinding" Namespace="capi-kubeadm-bootstrap-system"
Creating ClusterRoleBinding="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-manager-rolebinding"
Creating ClusterRoleBinding="capi-kubeadm-bootstrap-system-capi-kubeadm-bootstrap-proxy-rolebinding"
Creating Service="capi-kubeadm-bootstrap-controller-manager-metrics-service" Namespace="capi-kubeadm-bootstrap-system"
Creating Deployment="capi-kubeadm-bootstrap-controller-manager" Namespace="capi-kubeadm-bootstrap-system"
Creating inventory entry Provider="bootstrap-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-bootstrap-system"
Installing Provider="control-plane-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-control-plane-system"
Creating shared objects Provider="control-plane-kubeadm" Version="v0.3.7"
Creating CustomResourceDefinition="kubeadmcontrolplanes.controlplane.cluster.x-k8s.io"
Creating Service="capi-kubeadm-control-plane-webhook-service" Namespace="capi-webhook-system"
Creating Deployment="capi-kubeadm-control-plane-controller-manager" Namespace="capi-webhook-system"
Creating Certificate="capi-kubeadm-control-plane-serving-cert" Namespace="capi-webhook-system"
Creating Issuer="capi-kubeadm-control-plane-selfsigned-issuer" Namespace="capi-webhook-system"
Creating MutatingWebhookConfiguration="capi-kubeadm-control-plane-mutating-webhook-configuration"
Creating ValidatingWebhookConfiguration="capi-kubeadm-control-plane-validating-webhook-configuration"
Creating instance objects Provider="control-plane-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-control-plane-system"
Creating Namespace="capi-kubeadm-control-plane-system"
Creating Role="capi-kubeadm-control-plane-leader-election-role" Namespace="capi-kubeadm-control-plane-system"
Creating Role="capi-kubeadm-control-plane-manager-role" Namespace="capi-kubeadm-control-plane-system"
Creating ClusterRole="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-aggregated-manager-role"
Creating ClusterRole="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-manager-role"
Creating ClusterRole="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-proxy-role"
Creating RoleBinding="capi-kubeadm-control-plane-leader-election-rolebinding" Namespace="capi-kubeadm-control-plane-system"
Creating ClusterRoleBinding="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-manager-rolebinding"
Creating ClusterRoleBinding="capi-kubeadm-control-plane-system-capi-kubeadm-control-plane-proxy-rolebinding"
Creating Service="capi-kubeadm-control-plane-controller-manager-metrics-service" Namespace="capi-kubeadm-control-plane-system"
Creating Deployment="capi-kubeadm-control-plane-controller-manager" Namespace="capi-kubeadm-control-plane-system"
Creating inventory entry Provider="control-plane-kubeadm" Version="v0.3.7" TargetNamespace="capi-kubeadm-control-plane-system"
Installing Provider="infrastructure-docker" Version="v0.3.11" TargetNamespace="capd-system"
Creating shared objects Provider="infrastructure-docker" Version="v0.3.11"
Creating CustomResourceDefinition="dockerclusters.infrastructure.cluster.x-k8s.io"
Creating CustomResourceDefinition="dockermachinepools.exp.infrastructure.cluster.x-k8s.io"
Creating CustomResourceDefinition="dockermachines.infrastructure.cluster.x-k8s.io"
Creating CustomResourceDefinition="dockermachinetemplates.infrastructure.cluster.x-k8s.io"
Creating ValidatingWebhookConfiguration="capd-validating-webhook-configuration"
Creating instance objects Provider="infrastructure-docker" Version="v0.3.11" TargetNamespace="capd-system"
Creating Namespace="capd-system"
Creating Role="capd-leader-election-role" Namespace="capd-system"
Creating ClusterRole="capd-system-capd-manager-role"
Creating ClusterRole="capd-system-capd-proxy-role"
Creating RoleBinding="capd-leader-election-rolebinding" Namespace="capd-system"
Creating ClusterRoleBinding="capd-system-capd-manager-rolebinding"
Creating ClusterRoleBinding="capd-system-capd-proxy-rolebinding"
Creating Service="capd-controller-manager-metrics-service" Namespace="capd-system"
Creating Service="capd-webhook-service" Namespace="capd-system"
Creating Deployment="capd-controller-manager" Namespace="capd-system"
Creating Certificate="capd-serving-cert" Namespace="capd-system"
Creating Issuer="capd-selfsigned-issuer" Namespace="capd-system"
Creating inventory entry Provider="infrastructure-docker" Version="v0.3.11" TargetNamespace="capd-system"
[airshipctl] 2020/11/23 21:59:38 opendev.org/airship/airshipctl@/pkg/events/processor.go:61: Received event: {4 2020-11-23 21:59:38.0087331 +0000 UTC m=+105.771196533 {InitType {[]} {<nil>} {ApplyEventResourceUpdate ServersideApplied <nil>} {ResourceUpdateEvent <nil> <nil>} {PruneEventResourceUpdate Pruned <nil>} {DeleteEventResourceUpdate Deleted <nil>}} {<nil>} {ResourceUpdateEvent <nil> <nil>} {1 clusterctl init completed successfully} {0 } {0 }}
+ echo 'Waiting for pods to be ready'
Waiting for pods to be ready
+ kubectl --kubeconfig /tmp/target-cluster.kubeconfig --context target-cluster wait --all-namespaces --for=condition=Ready pods --all --timeout=600s
pod/capd-controller-manager-5498cfdfb5-nxfqs condition met
pod/capi-kubeadm-bootstrap-controller-manager-556678c94-2mvkm condition met
pod/capi-kubeadm-control-plane-controller-manager-556d47dffd-4vtwn condition met
pod/capi-controller-manager-67859f6b78-wb45h condition met
pod/capi-controller-manager-5c785c685c-glg2z condition met
pod/capi-kubeadm-bootstrap-controller-manager-77658d7745-xn9bq condition met
pod/capi-kubeadm-control-plane-controller-manager-74dcf8b9c-lq6w9 condition met
pod/cert-manager-578cd6d964-xjfd7 condition met
pod/cert-manager-cainjector-5ffff9dd7c-6xj4c condition met
pod/cert-manager-webhook-556b9d7dfd-tzz8s condition met
pod/calico-kube-controllers-5569bdd565-vx5cr condition met
pod/calico-node-2dd9w condition met
pod/coredns-66bff467f8-vhbgm condition met
pod/coredns-66bff467f8-wmqq5 condition met
pod/etcd-target-cluster-control-plane-dr7bc condition met
pod/kube-apiserver-target-cluster-control-plane-dr7bc condition met
pod/kube-controller-manager-target-cluster-control-plane-dr7bc condition met
pod/kube-proxy-lmvsv condition met
pod/kube-scheduler-target-cluster-control-plane-dr7bc condition met
+ kubectl --kubeconfig /tmp/target-cluster.kubeconfig --context target-cluster get pods --all-namespaces
NAMESPACE                           NAME                                                             READY   STATUS    RESTARTS   AGE
capd-system                         capd-controller-manager-5498cfdfb5-nxfqs                         2/2     Running   0          40s
capi-kubeadm-bootstrap-system       capi-kubeadm-bootstrap-controller-manager-556678c94-2mvkm        2/2     Running   0          61s
capi-kubeadm-control-plane-system   capi-kubeadm-control-plane-controller-manager-556d47dffd-4vtwn   2/2     Running   0          52s
capi-system                         capi-controller-manager-67859f6b78-wb45h                         2/2     Running   0          75s
capi-webhook-system                 capi-controller-manager-5c785c685c-glg2z                         2/2     Running   0          83s
capi-webhook-system                 capi-kubeadm-bootstrap-controller-manager-77658d7745-xn9bq       2/2     Running   0          71s
capi-webhook-system                 capi-kubeadm-control-plane-controller-manager-74dcf8b9c-lq6w9    2/2     Running   0          59s
cert-manager                        cert-manager-578cd6d964-xjfd7                                    1/1     Running   0          116s
cert-manager                        cert-manager-cainjector-5ffff9dd7c-6xj4c                         1/1     Running   0          116s
cert-manager                        cert-manager-webhook-556b9d7dfd-tzz8s                            1/1     Running   0          116s
kube-system                         calico-kube-controllers-5569bdd565-vx5cr                         1/1     Running   0          4m19s
kube-system                         calico-node-2dd9w                                                1/1     Running   0          4m19s
kube-system                         coredns-66bff467f8-vhbgm                                         1/1     Running   0          4m28s
kube-system                         coredns-66bff467f8-wmqq5                                         1/1     Running   0          4m28s
kube-system                         etcd-target-cluster-control-plane-dr7bc                          1/1     Running   0          4m40s
kube-system                         kube-apiserver-target-cluster-control-plane-dr7bc                1/1     Running   0          4m40s
kube-system                         kube-controller-manager-target-cluster-control-plane-dr7bc       1/1     Running   0          4m40s
kube-system                         kube-proxy-lmvsv                                                 1/1     Running   0          4m28s
kube-system                         kube-scheduler-target-cluster-control-plane-dr7bc                1/1     Running   0          4m40s
```

Move `CRD`s to the controlplane of target cluster

```
$ ./tools/deployment/provider_common/33_cluster_move_target_node.sh

+ export TIMEOUT=3600
+ TIMEOUT=3600
+ export KUBECONFIG=/home/stack/.airship/kubeconfig
+ KUBECONFIG=/home/stack/.airship/kubeconfig
+ export KUBECONFIG_EPHEMERAL_CONTEXT=ephemeral-cluster
+ KUBECONFIG_EPHEMERAL_CONTEXT=ephemeral-cluster
+ export KUBECONFIG_TARGET_CONTEXT=target-cluster
+ KUBECONFIG_TARGET_CONTEXT=target-cluster
+ export TARGET_KUBECONFIG=/tmp/target-cluster.kubeconfig
+ TARGET_KUBECONFIG=/tmp/target-cluster.kubeconfig
+ echo 'Move Cluster Object to Target Cluster'
Move Cluster Object to Target Cluster
+ KUBECONFIG=/home/stack/.airship/kubeconfig:/tmp/target-cluster.kubeconfig
+ kubectl config view --merge --flatten
+ airshipctl phase run clusterctl-move --kubeconfig /tmp/merged_target_ephemeral.kubeconfig
[airshipctl] 2020/11/23 22:01:06 command 'clusterctl move' is going to be executed
[airshipctl] 2020/11/23 22:01:06 Received event: {4 2020-11-23 22:01:06.251351428 +0000 UTC m=+9.276484343 {InitType {[]} {<nil>} {ApplyEventResourceUpdate ServersideApplied <nil>} {ResourceUpdateEvent <nil> <nil>} {PruneEventResourceUpdate Pruned <nil>} {DeleteEventResourceUpdate Deleted <nil>}} {<nil>} {ResourceUpdateEvent <nil> <nil>} {2 starting clusterctl move executor} {0 } {0 }}
[airshipctl] 2020/11/23 22:01:10 Received event: {4 2020-11-23 22:01:10.999055139 +0000 UTC m=+14.024188154 {InitType {[]} {<nil>} {ApplyEventResourceUpdate ServersideApplied <nil>} {ResourceUpdateEvent <nil> <nil>} {PruneEventResourceUpdate Pruned <nil>} {DeleteEventResourceUpdate Deleted <nil>}} {<nil>} {ResourceUpdateEvent <nil> <nil>} {3 clusterctl move completed successfully} {0 } {0 }}
+ echo 'Waiting for pods to be ready'
Waiting for pods to be ready
+ kubectl --kubeconfig /tmp/target-cluster.kubeconfig --context target-cluster wait --all-namespaces --for=condition=Ready pods --all --timeout=3000s
pod/capd-controller-manager-5498cfdfb5-nxfqs condition met
pod/capi-kubeadm-bootstrap-controller-manager-556678c94-2mvkm condition met
pod/capi-kubeadm-control-plane-controller-manager-556d47dffd-4vtwn condition met
pod/capi-controller-manager-67859f6b78-wb45h condition met
pod/capi-controller-manager-5c785c685c-glg2z condition met
pod/capi-kubeadm-bootstrap-controller-manager-77658d7745-xn9bq condition met
pod/capi-kubeadm-control-plane-controller-manager-74dcf8b9c-lq6w9 condition met
pod/cert-manager-578cd6d964-xjfd7 condition met
pod/cert-manager-cainjector-5ffff9dd7c-6xj4c condition met
pod/cert-manager-webhook-556b9d7dfd-tzz8s condition met
pod/calico-kube-controllers-5569bdd565-vx5cr condition met
pod/calico-node-2dd9w condition met
pod/coredns-66bff467f8-vhbgm condition met
pod/coredns-66bff467f8-wmqq5 condition met
pod/etcd-target-cluster-control-plane-dr7bc condition met
pod/kube-apiserver-target-cluster-control-plane-dr7bc condition met
pod/kube-controller-manager-target-cluster-control-plane-dr7bc condition met
pod/kube-proxy-lmvsv condition met
pod/kube-scheduler-target-cluster-control-plane-dr7bc condition met
+ kubectl --kubeconfig /tmp/target-cluster.kubeconfig --context target-cluster get pods --all-namespaces
NAMESPACE                           NAME                                                             READY   STATUS    RESTARTS   AGE
capd-system                         capd-controller-manager-5498cfdfb5-nxfqs                         2/2     Running   0          102s
capi-kubeadm-bootstrap-system       capi-kubeadm-bootstrap-controller-manager-556678c94-2mvkm        2/2     Running   0          2m3s
capi-kubeadm-control-plane-system   capi-kubeadm-control-plane-controller-manager-556d47dffd-4vtwn   2/2     Running   0          114s
capi-system                         capi-controller-manager-67859f6b78-wb45h                         2/2     Running   0          2m17s
capi-webhook-system                 capi-controller-manager-5c785c685c-glg2z                         2/2     Running   0          2m25s
capi-webhook-system                 capi-kubeadm-bootstrap-controller-manager-77658d7745-xn9bq       2/2     Running   0          2m13s
capi-webhook-system                 capi-kubeadm-control-plane-controller-manager-74dcf8b9c-lq6w9    2/2     Running   0          2m1s
cert-manager                        cert-manager-578cd6d964-xjfd7                                    1/1     Running   0          2m58s
cert-manager                        cert-manager-cainjector-5ffff9dd7c-6xj4c                         1/1     Running   0          2m58s
cert-manager                        cert-manager-webhook-556b9d7dfd-tzz8s                            1/1     Running   0          2m58s
kube-system                         calico-kube-controllers-5569bdd565-vx5cr                         1/1     Running   0          5m21s
kube-system                         calico-node-2dd9w                                                1/1     Running   0          5m21s
kube-system                         coredns-66bff467f8-vhbgm                                         1/1     Running   0          5m30s
kube-system                         coredns-66bff467f8-wmqq5                                         1/1     Running   0          5m30s
kube-system                         etcd-target-cluster-control-plane-dr7bc                          1/1     Running   0          5m42s
kube-system                         kube-apiserver-target-cluster-control-plane-dr7bc                1/1     Running   0          5m42s
kube-system                         kube-controller-manager-target-cluster-control-plane-dr7bc       1/1     Running   0          5m42s
kube-system                         kube-proxy-lmvsv                                                 1/1     Running   0          5m30s
kube-system                         kube-scheduler-target-cluster-control-plane-dr7bc                1/1     Running   0          5m42s
++ date +%s
+ end=1606172473
+ echo 'Waiting 3600 seconds for crds to be created.'
Waiting 3600 seconds for crds to be created.
+ true
+ kubectl --request-timeout 20s --kubeconfig /tmp/target-cluster.kubeconfig --context target-cluster get cluster target-cluster -o json
+ jq .status.controlPlaneReady
+ grep -q true
+ echo -e '\nGet CRD status'

Get CRD status
+ kubectl --kubeconfig /tmp/target-cluster.kubeconfig --context target-cluster get machines
NAME                                 PROVIDERID                                      PHASE
target-cluster-control-plane-dr7bc   docker:////target-cluster-control-plane-dr7bc   Running
+ kubectl --kubeconfig /tmp/target-cluster.kubeconfig --context target-cluster get clusters
NAME             PHASE
target-cluster   Provisioned
```

Deploy 2 `worker` nodes in the target cluster

```
$WORKERS_COUNT=2 KUBECONFIG=/tmp/target-cluster.kubeconfig TEST_SITE=docker-test-site ./tools/deployment/provider_common/34_deploy_worker_node.sh

+ export TIMEOUT=3600
+ TIMEOUT=3600
+ export KUBECONFIG=/tmp/target-cluster.kubeconfig
+ KUBECONFIG=/tmp/target-cluster.kubeconfig
+ export TARGET_KUBECONFIG=/tmp/target-cluster.kubeconfig
+ TARGET_KUBECONFIG=/tmp/target-cluster.kubeconfig
+ export KUBECONFIG_TARGET_CONTEXT=target-cluster
+ KUBECONFIG_TARGET_CONTEXT=target-cluster
+ export TEST_SITE=docker-test-site
+ TEST_SITE=docker-test-site
+ export WORKERS_COUNT=2
+ WORKERS_COUNT=2
+ export AIRSHIP_SRC=/tmp/airship
+ AIRSHIP_SRC=/tmp/airship
+ sed -i '/value.*/s//value": 2 }/g' /tmp/airship/airshipctl/manifests/site/docker-test-site/target/workers/machine_count.json
+ echo 'Stop/Delete ephemeral node'
Stop/Delete ephemeral node
+ kind delete cluster --name ephemeral-cluster
Deleting cluster "ephemeral-cluster" ...
+ echo 'Deploy worker node'
Deploy worker node
+ airshipctl phase run workers-target --debug --kubeconfig /tmp/target-cluster.kubeconfig
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:129: Getting kubeconfig context name from cluster map
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:134: Getting kubeconfig file information from kubeconfig provider
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:139: Filtering out documents that shouldn't be applied to kubernetes from document bundle
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:147: Using kubeconfig at '/tmp/target-cluster.kubeconfig' and context 'target-cluster'
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/executor.go:118: WaitTimeout: 33m20s
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:76: Getting infos for bundle, inventory id is workers-target
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:106: Inventory Object config Map not found, auto generating Inventory object
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:113: Injecting Inventory Object: {"apiVersion":"v1","kind":"ConfigMap","metadata":{"creationTimestamp":null,"labels":{"cli-utils.sigs.k8s.io/inventory-id":"workers-target"},"name":"airshipit-workers-target","namespace":"airshipit"}}{nsfx:false,beh:unspecified} into bundle
[airshipctl] 2020/11/23 22:01:43 opendev.org/airship/airshipctl@/pkg/k8s/applier/applier.go:119: Making sure that inventory object namespace airshipit exists
dockermachinetemplate.infrastructure.cluster.x-k8s.io/target-cluster-md-0 created
kubeadmconfigtemplate.bootstrap.cluster.x-k8s.io/target-cluster-md-0 created
machinedeployment.cluster.x-k8s.io/target-cluster-md-0 created
3 resource(s) applied. 3 created, 0 unchanged, 0 configured
dockermachinetemplate.infrastructure.cluster.x-k8s.io/target-cluster-md-0 is NotFound: Resource not found
kubeadmconfigtemplate.bootstrap.cluster.x-k8s.io/target-cluster-md-0 is NotFound: Resource not found
machinedeployment.cluster.x-k8s.io/target-cluster-md-0 is NotFound: Resource not found
dockermachinetemplate.infrastructure.cluster.x-k8s.io/target-cluster-md-0 is Current: Resource is current
kubeadmconfigtemplate.bootstrap.cluster.x-k8s.io/target-cluster-md-0 is Current: Resource is current
machinedeployment.cluster.x-k8s.io/target-cluster-md-0 is Current: Resource is current
all resources has reached the Current status
+ kubectl wait --for=condition=ready node --all --timeout=1000s --context target-cluster --kubeconfig /tmp/target-cluster.kubeconfig -A
node/target-cluster-control-plane-dr7bc condition met
```


Check for machine states in the target cluster

```
$ kubectl get machines --kubeconfig /tmp/target-cluster.kubeconfig

NAME                                   PROVIDERID                                        PHASE
target-cluster-control-plane-dr7bc     docker:////target-cluster-control-plane-dr7bc     Running
target-cluster-md-0-84db44cdff-ttl9k   docker:////target-cluster-md-0-84db44cdff-ttl9k   Running
target-cluster-md-0-84db44cdff-vjsvr   docker:////target-cluster-md-0-84db44cdff-vjsvr   Running
```

At this point, we have a 3 node kubernetes cluster using `airshipctl` on `capd` provider.

We're ready to proceed with running conformance test using `sonobuoy` on the target-cluster.

### Steps to run conformance test

### Pre-requisite

- Install `sonobuoy`

```
$ export SONOBUOY_VERSION=0.18.2
$ export URL="https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz"
$ rm -rf /tmp/sonobuoy
$ mkdir /tmp/sonobuoy
$ sudo -E curl -sSLo "/tmp/sonobuoy/sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz" ${URL}
stack@airship:~$ tar xvf /tmp/sonobuoy/sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz -C /tmp/sonobuoy/
LICENSE
sonobuoy
$ sudo install -m 755 -o root /tmp/sonobuoy/sonobuoy /usr/local/bin
$ sonobuoy version --kubeconfig /tmp/target-cluster.kubeconfig
Sonobuoy Version: v0.18.2
MinimumKubeVersion: 1.16.0
MaximumKubeVersion: 1.18.99
GitSHA: f13b4cc6bbb9ed38a4bf593fd822886494cb6a92
API Version:  v1.18.6
```

The `kubeconfig` of the `target-cluster` is available at `/tmp/target-cluster.kubeconfig` location.

### Run Tests

- Run `sonobuoy` e2e-conformance tests with the `kubeconfig` of the `target-cluster` with `mode` set to `certified-conformance`.

```
$time sonobuoy run --wait --mode=certified-conformance --kubeconfig /tmp/target-cluster.kubeconfig


INFO[0000] created object                                name=sonobuoy namespace= resource=namespaces
INFO[0000] created object                                name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
INFO[0000] created object                                name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
INFO[0000] created object                                name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
INFO[0000] created object                                name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
INFO[0000] created object                                name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
INFO[0000] created object                                name=sonobuoy namespace=sonobuoy resource=pods
INFO[0000] created object                                name=sonobuoy-master namespace=sonobuoy resource=services

real    81m40.455s
user    0m0.969s
sys     0m0.194s
```

- Extract the results of the `conformance` tests


```
$sonobuoy retrieve --kubeconfig /tmp/target-cluster.kubeconfig
202011181944_sonobuoy_1f70ab57-a01a-44bb-bd1a-a7ed0a68f890.tar.gz

$sonobuoy results 202011181944_sonobuoy_1f70ab57-a01a-44bb-bd1a-a7ed0a68f890.tar.gz

Plugin: systemd-logs
Status: passed
Total: 3
Passed: 3
Failed: 0
Skipped: 0

Plugin: e2e
Status: passed
Total: 4992
Passed: 277
Failed: 0
Skipped: 4715
```

- To see all `passed` tests, use the below command. It shows all 277 conformance tests that passed

```
sonobuoy results 202011181944_sonobuoy_1f70ab57-a01a-44bb-bd1a-a7ed0a68f890.tar.gz --plugin e2e --mode=detailed | jq 'select(.status=="passed")' | jq

```

<style>.markdown-body { max-width: 1200px; }</style>