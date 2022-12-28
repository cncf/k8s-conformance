# Linode Kubernetes Engine

To get started, you'll first need to set up a Linode account and log into the
Cloud Manager UI. Please refer to the Linode [getting
started](https://www.linode.com/docs/getting-started/) guide for this step. Once you have
logged in, continue with the steps below to create a cluster and run the
conformance tests.

## Create a cluster

To create a cluster with Linode Kubernetes Engine, click Kubernetes from the
"Create" menu at the top of any page in the Cloud Manager. You will arrive on
the [cluster creation page](https://cloud.linode.com/kubernetes/create) where
you can select the region, node pools, label, and Kubernetes version for your
cluster. From there, you will be redirected to your cluster's details page, and
after a few seconds you can click to download a `kubectl` config file for your
cluster. For the most up-to-date instructions with screenshots, please refer to
to the [deployment
documentation](https://www.linode.com/docs/kubernetes/deploy-and-manage-a-cluster-with-linode-kubernetes-engine-a-tutorial/).
For the next section please ensure that you have exported your `KUBECONFIG`
environment variable as instructed in this guide, or have otherwise [configured
your `kubectl`
context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/),
as `sonobuoy` uses this same configuration to connect to your cluster.

## Run conformance tests

Follow the k8s-conformance
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests.

The output here was obtained with Sonobuoy 0.56.12 running on a Kubernetes 1.24.8 cluster.
