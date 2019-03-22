# To reproduce

## Provision Cluster

Log into admin control dashboard and create a kubernetes cluster. Once cluster creation has completed, download environment config file to access tenant cluster.

## Launch E2E Conformance Tests

`curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -`

Follow instructions descrbed [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to retrieve results

