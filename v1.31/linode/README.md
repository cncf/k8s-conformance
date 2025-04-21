# Linode Kubernetes Engine

## Create a Linode account

To get started, you will first need to set up a Linode account and log into Cloud Manager. Refer to the Linode [getting
started guide](https://techdocs.akamai.com/cloud-computing/docs/getting-started) for this step. Once you have
logged in, continue with the steps below to create a cluster and run the
conformance tests.

## Create a cluster

To create a cluster with Linode Kubernetes Engine, click **Kubernetes** from the
**Create** menu at the top of any page in Cloud Manager. You will arrive at
the [cluster creation page](https://cloud.linode.com/kubernetes/create) where
you can select the label, region, node pools, and Kubernetes version for your
cluster. From there, you will be redirected to your cluster's details page, and
after a few seconds, you can click to download a `kubectl` config file for your
cluster. For the most up-to-date instructions with screenshots, refer to the [cluster creation
guide](https://techdocs.akamai.com/cloud-computing/docs/create-a-cluster).
For the next section, ensure that you have exported your `KUBECONFIG`
environment variable or have otherwise [configured
your `kubectl`
context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/),
as `sonobuoy` uses this same configuration to connect to your cluster.

## Run conformance tests

Follow the k8s-conformance
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)
to run the conformance tests.

The output here was obtained with Sonobuoy 0.57.3 running on a Kubernetes 1.31.6 cluster.
