# Conformance tests for plusserver Kubernetes Engine (PSKE)

## plusserver Kubernetes Engine (PSKE)  (base on Kubernetes v1.24.7)

With the plusserver Kubernetes Engine (PSKE), you use a unique solution to orchestrate 
Kubernetes clusters quickly and easily in self-service. Depending on your requirements, 
you can operate and centrally manage your workloads in the GDPR-compliant pluscloud open
or at a hyperscaler. Thanks to integrated day 2 operations and optional professional services, 
you can relieve the burden on your DevOps teams and free up space for your digital innovations. 
You also benefit from high resilience and optimized costs through autoscaling and hibernation.

https://get.plusserver.com/en/managed-kubernetes-free-trial

## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following
commands:

```sh
$ go install github.com/vmware-tanzu/sonobuoy@latest
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
            e2e   complete   passed       1   Passed:346, Failed:  0, Remaining:  0
   systemd-logs   complete   passed       4                                        

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Check Sonobuoy's logs with:
```sh
$ sonobuoy retrieve
-202211081211_sonobuoy_450a994d-918e-4c02-8cae-047f6e34c0b4.tar.gz
```
