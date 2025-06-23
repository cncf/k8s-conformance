# Conformance tests for Fuga Cloud Enterprise Managed Kubernetes (EMK)

## Enterprise Managed Kubernetes (EMK) (based on Kubernetes v1.30)

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

From version v1.27 it is not allowed to use static kubeconfigs. There for it is only possible from the interface to download a time limited access kubeconfig.

Go to the "EMK" tab and select your cluster, view "access" to copy or download your kubeconfig.

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