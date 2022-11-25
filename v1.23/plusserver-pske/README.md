# Conformance tests for plusserver Kubernetes Engine (PSKE)

## plusserver Kubernetes Engine (PSKE)  (base on Kubernetes v1.23.13)

With the plusserver Kubernetes Engine (PSKE), you use a unique solution to orchestrate 
Kubernetes clusters quickly and easily in self-service. Depending on your requirements, 
you can operate and centrally manage your workloads in the GDPR-compliant pluscloud open
or at a hyperscaler. Thanks to integrated day 2 operations and optional professional services, 
you can relieve the burden on your DevOps teams and free up space for your digital innovations. 
You also benefit from high resilience and optimized costs through autoscaling and hibernation.

https://get.plusserver.com/en/managed-kubernetes-free-trial

## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following
command:

```sh
kubectl apply -f sonobuoy.yaml
```

Watch Sonobuoy's logs with:

```
kubectl logs -f -n heptio-sonobuoy e2e sonobuoy
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then
copy the results using `kubectl cp`
