# Conformance tests for plusserver Kubernetes Engine (PSKE)

## plusserver Kubernetes Engine (PSKE)  (base on Kubernetes v1.25.5)

With the plusserver Kubernetes Engine (PSKE), you use a unique solution to orchestrate 
Kubernetes clusters quickly and easily in self-service. Depending on your requirements, 
you can operate and centrally manage your workloads in the GDPR-compliant pluscloud open
or at a hyperscaler. Thanks to integrated day 2 operations and optional professional services, 
you can relieve the burden on your DevOps teams and free up space for your digital innovations. 
You also benefit from high resilience and optimized costs through autoscaling and hibernation.

https://get.plusserver.com/en/managed-kubernetes-free-trial


## 1. Create an account
Create a plusserver Kubernetes Engine (PSKE) Account on [https://get.plusserver.com/en/managed-kubernetes-free-trial](https://get.plusserver.com/en/managed-kubernetes-free-trial).

## 2. Create Kubernetes Cluster

Login to plusserver Kubernetes Engine (PSKE) Dashboard to create a Kubernetes Clusters on OpenStack (pluscloud-open) cloud provider.

https://dashboard.prod.gardener.get-cloud.io/login

In the "Clusters" menu, select the plus symbol for "Kubernetes Clusters". The input mask for cluster creation appears.
- Select the infrastructure (we validated the conformance with pluscloud-open)
- Choose the name of your cluster
- Select the 1.25.5 version of Kubernetes
- Select the region of your cluster
- Select the networking type of your cluster (we validated the conformance with cilium)
- Configure a worker pool (we validated the conformance with a pool of 2 "SCS-4V:16:100" worker types and "containerd" as container runtime)

## 3. Get the kubeconfig

From the clusters list, click on the cluster you just created and download the kubeconfig file from the top-right of the "Access" tab.

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
         PLUGIN     STATUS   RESULT   COUNT                 PROGRESS
            e2e   complete   passed       1   Passed:362, Failed:  0
   systemd-logs   complete   passed       4                         

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Check Sonobuoy's logs with:
```sh
$ sonobuoy retrieve
-202301050906_sonobuoy_fbb189db-4172-4c3b-990c-9f8a6a546728.tar.gz
```
