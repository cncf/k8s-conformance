# PKS (Pivotal Container Services)

Pivotal Container Services (PKS) utilizes [KUBO](https://pivotal.io/partners/kubo) to deploy and manage your Kubernetes cluster.

A Kubernetes cluster can be deployed to your choice of IaaS. Please follow the guide [here](https://docs-pks.cfapps.io/pks/installing.html) to install it with GCP or vSphere. A PCF (Pivotal Cloud Foundry) environment with Ops Manager will be needed.

## Running the k8s conformance tests

Set your kubectl to point your CLI to the deployed kubernetes cluster. See the instructions [here](https://docs-pks.cfapps.io/pks/using.html) for steps to access your cluster.

You can then run the k8s conformance test by running the following command:

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

