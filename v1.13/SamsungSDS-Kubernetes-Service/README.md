# Conformance tests for SamsungSDS-Kubernetes-Service

## Install  SamsungSDS Kubernetes Service v1.13 (base on Kubernetes v1.13.1)

SamsungSDS Kubernetes Service is a kubernetes provisioner that auto-provisions a fully functioning hosted cluster for Private Cloud Environment.


## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following command (use private yaml): 

```sh
kubectl apply -f sonobuoy.yaml
```

Watch Sonobuoy's logs with:

```
kubectl logs -f -n heptio-sonobuoy e2e sonobuoy
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then copy the results using `kubectl cp`
