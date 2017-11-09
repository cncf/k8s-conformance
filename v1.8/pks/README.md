# PKS (Pivotal Container Services)

Pivotal Container Services (PKS) utilizes [KUBO](https://pivotal.io/partners/kubo) to deploy and manage your Kubernetes cluster.

A Kubernetes cluster can be deployed to your choice of IaaS. Please follow the guide [here](https://docs-pks.cfapps.io/pks/installing.html) to install it on GCP, vSphere.

## Running the k8s conformance tests

Set your kubectl to point your CLI to the deployed kubernetes cluster. See the instructions [here](https://docs-pks.cfapps.io/pks/managing.html) for steps to access your cluster.

You can then run the k8s conformance test by running:

1. Delete the RBAC related service accounts and cluster roles. See the example [here](https://raw.githubusercontent.com/afong94/k8s-conformance/pks/sonobuoy-conformance.yaml)
```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

Alternatively, the sonobuoy-conformance.yaml file from [here](https://raw.githubusercontent.com/afong94/k8s-conformance/pks/sonobuoy-conformance.yaml) can also be directly used by running:
```
curl -L https://raw.githubusercontent.com/afong94/k8s-conformance/pks/sonobuoy-conformance.yaml | kubectl apply -f -
```

