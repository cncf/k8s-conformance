# PKS (Pivotal Container Services)

Pivotal Container Services (PKS) utilizes [CFCR](https://pivotal.io/partners/kubo) to deploy and manage your Kubernetes cluster.

A Kubernetes cluster can be deployed to your choice of IaaS. Please follow the guide [here](https://docs-pks.cfapps.io/pks/installing.html) to install it with GCP or vSphere. An environment with Ops Manager will be needed.

Upon deploying Ops man with the PKS tile, follow instructions in the documentaton to [create](https://docs-pks.cfapps.io/pks/using.html#create-cluster) and [bind](https://docs-pks.cfapps.io/pks/using.html#get-credentials) to a cluster

## Running the k8s conformance tests

Set your kubectl to point your CLI to the deployed kubernetes cluster. See the instructions [here](https://docs-pks.cfapps.io/pks/using.html) for steps to access your cluster.

You can then run the k8s conformance test by running the following command:

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

