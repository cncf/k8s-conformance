# Conformance tests for Rancher 2.0 Kubernetes

## Install Rancher Server

As per [documentation](https://rancher.com/docs/rancher/v2.x/en/installation/) install Rancher server on either a single node or HA mode.

## Run Kubernetes Cluster

After running Rancher server, access Rancher server UI at `https://<ip>` and create new Cluster, please refer to the [documentation](https://rancher.com/docs/rancher/v2.x/en/quick-start-guide/#create-the-cluster) for more information about how to create a cluster.

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
