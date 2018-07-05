# Conformance testing Agile Stacks Kubernetes Stack.

## Setup Agile Stacks Kubernetes Stack

Deploy Agile Stacks Kubernetes Stack as per the Agile Stacks documentation. Use at least 1 master and 1 worker node. We ran our conformance tests on a cluster with 2 r4.large worker instances.

## Run conformance tests

Start the conformance tests on your Agile Stacks Kubernetes Stack
```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
````

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line `no-exit was specified, sonobuoy is now blocking`, which signals the end of the testing.

```
kubectl logs -f sonobuoy -n sonobuoy
```

Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```
