# Conformance tests for Cyso Managed Kubernetes

## Managed Kubernetes (based on Kubernetes v1.32)

Cyso's Managed Kubernetes is a GDPR-compliant solution for managing Kubernetes clusters. It offers self-service orchestration, centralized management, and optional professional services. Create clusters using cloud-native tools, and benefit from high resilience and optimized costs through autoscaling and hibernation. Managed Kubernetes is a robust and reliable solution with a touch of Dutch innovation.

## 1. Create an account
Create a Cyso Cloud Account on [https://my.cyso.cloud](https://my.cyso.cloud).

## 2. Create Kubernetes Cluster

Login to the Cyso Cloud Dashboard to create Kubernetes Clusters on OpenStack. To do this navigate to "EMK" in the sidebar or follow this link [https://my.cyso.cloud/managed-kubernetes](https://my.cyso.cloud/managed-kubernetes).

In the "Clusters" menu, select the "Create cluster +". A new page appears to create a new Kubernetes cluster.
- Select the region of your cluster
- Choose the name of your cluster
- Select the Kubernetes version
- Select the networking type of your cluster (we validated the conformance with calico)
- Configure a worker pool (our validation for the conformance is done with 3 to 5 worker at emk1.medium)

## 3. Get access to the cluster

See our documentation about accessing the cluster or visit the Cyso Cloud dashboard and download a Time-Limited kubeconfig.

At the Cyso Cloud dashboard, visit the "EMK" tab and select your cluster. View "access" to download your your Time-Limited kubeconfig.

## 4. Install Sonobuoy

On the new Kubernetes cluster run the conformance tests using the following
commands:

```sh
$ go install github.com/vmware-tanzu/sonobuoy@latest

```

## 5. Run conformance Test

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
            e2e   complete   passed       1   Passed:411, Failed:  0, Remaining:  0
   systemd-logs   complete   passed       6                                        

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Check Sonobuoy's logs with:
```sh
$ sonobuoy retrieve
202505280000_sonobuoy_2b474c98-ea91-4272-ab70-18f5bec5c921.tar.gz
```