# Pivotal Container Service v1.1
Pivotal Container Service (PKS) provides both cloud and on-prem Kubernetes as a service. 

## Installing PKS
To get started, follow the guide [here](https://docs.pivotal.io/runtimes/pks). The guide includes instructions on how to provision and manage the PKS control plane. 

## Creating a Kubernetes Cluster
```
pks create-cluster CLUSTER-NAME -e HOSTNAME -p PLAN_NAME
pks get-credentials CLUSTER-NAME
```

## Running Conformance Tests
To run the conformance tests:

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

To monitor the conformance tests, tail the sonobuoy logs. Once `sonobuoy is now blocking` is shown, the conformance tests are complete.

```
kubectl logs -f -n sonobuoy sonobuoy 
```

The logs can then be retrieved via the following command:
```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```
