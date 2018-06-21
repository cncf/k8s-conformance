# Conformance tests for WiseCloud v1.4.9 Kubernetes

## Install WiseCloud Server v1.4.9 (base on Kubernetes v1.10.4)

## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following command:

```sh
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

Watch Sonobuoy's logs with:

```
kubectl logs -f -n sonobuoy sonobuoy
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then copy the results using `kubectl cp`

