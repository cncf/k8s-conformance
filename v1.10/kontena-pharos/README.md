# Conformance testing Kontena Pharos

## Setup Kontena Pharos cluster

Setup Kontena Pharos cluster as per the [Pharos documentation](https://www.pharos.sh/docs/). To run conformance tests, we recommend that you use a cluster that provides sufficient resources.

## Run conformance tests

Start the conformance tests on your Kontena Pharos cluster

```sh
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line no-exit was specified, sonobuoy is now blocking, which signals the end of the testing.

```sh
kubectl logs -f sonobuoy -n sonobuoy
```

Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```sh
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```