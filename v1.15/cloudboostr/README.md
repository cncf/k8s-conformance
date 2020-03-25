# Cloudboostr 1.3.1

Clouboostr is an enterprise multicloud Kubernetes distribution.

## Installing Cloudboostr

Follow the instructions available [here](https://docs.cloudboostr.com/installation/aws/installation_steps/).

## Running conformance tests

1. Log in into kubernetes environment. For credentials follow instructions available [here](https://docs.cloudboostr.com/developer_guide/kubernetes/)
2. Download a [sonobuoy release](https://github.com/heptio/sonobuoy/releases)
3. Deploy a Sonobuoy pod

```
$ sonobuoy run --wait
```

4. Wait for the test to finish
5. Clean up the remains of the test framework:

```
sonobuoy delete --wait
```

Official instructions available [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).
