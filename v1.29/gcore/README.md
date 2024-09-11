# Gcore Managed Kubernetes

To get started, you first need to create a Gcore Platform account. Please refer to the [Gcore documentation](https://gcore.com/docs/account-settings/create-an-account-for-an-individual-or-legal-entity) for that step. Once you have signed in, continue with the steps below to create a cluster and run the conformance tests.

## Create a cluster

To create a cluster with Gcore Managed Kubernetes, select Kubernetes from the Cloud section on your Gcore dashboard and click "Create Cluster". You will arrive on the cluster creation page where you can select the region, Kubernetes version, configure node pools, ssh key and network settings. When everything is correct, click "Create Cluster" to start the provisioning process. In a few seconds the cluster will be provisioned and you can go to the cluster details page to download the kubectl config file. For the most up-to-date instructions with screenshots, please refer to the [cluster creation documentation](https://gcore.com/docs/cloud/kubernetes/clusters/create-a-kubernetes-cluster).

For the next steps, please ensure that you have either exported your KUBECONFIG environment variable pointing to the kubectl config file you downloaded or have otherwise [configured your kubectl context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters). Sonobuoy uses the same configuration to connect to your cluster.

## Run conformance tests

Download a binary release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases). Extract the tarball and move the `sonobuoy` executable to somewhere on your `PATH`.

Run the tests:

```sh
sonobuoy run --mode=certified-conformance --wait
sonobuoy retrieve
```

The output here was obtained with Sonobuoy v0.57.1.
