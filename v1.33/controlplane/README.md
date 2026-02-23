# Control Plane Managed Kubernetes

This conformance report was generated using [Control Plane Managed Kubernetes](https://docs.controlplane.com/mk8s/overview) service. 

Follow the instructions below to reproduce the test results.

## Create a cluster

1. Sign up for a Control Plane account at https://controlplane.com/
2. Once logged in, navigate to the `Kubernetes` page and create a new cluster.
3. Choose the infrastructure provider. The worker nodes of the cluster will be managed there based on your specifications.
4. Follow the steps in the UI for creating the cluster on the infrastructure of your choice. Use the [documentation search and AI chat](https://docs.controlplane.com/mk8s/overview) for additional details.
   At any step, please don't hesitate to contact us with any questions using the provided email: `support@controlplane.com`.
5. Wait a few moments for the cluster to be initialized and the worker nodes to be provisioned.
6. Obtain the Kubeconfig file using the instructions in the UI or the [CLI](https://docs.controlplane.com/mk8s/aws#step-3-accessing-the-cluster).


## Deploy Sonobuoy Conformance Test

Once the cluster is healthy, you should be able to connect to the Kubernetes API using the `kubectl` command.
Follow the [conformance test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to reproduce the results.