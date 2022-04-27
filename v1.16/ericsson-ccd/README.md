# Conformance tests for Ericsson Cloud Container Distribution

## Install Ericsson CCD 2.6.0 (base on Kubernetes v1.16.2)

Ericsson Cloud Container Distribution provides container management and
orchestration for the Ericsson Telco applications that have been adopted to Cloud Native based Architecture and run in a container environment.

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
