Nutanix Karbon
===
 To Reproduce
---
 On Nutanix Prism Central, enable Karbon (managed Kubernetes offering of Nutanix) by following
[this document](https://portal.nutanix.com/#/page/docs/details?targetId=Karbon-v08:kar-containers-install-t.html).
 
Next, follow the steps to install a fresh cluster, choosing `v1.13` as the Kubernetes
version and `centos` as the base image.

 Once the cluster is deployed, you can download the kubeconfig to your local machine using
the steps described [here](https://portal.nutanix.com/#/page/docs/details?targetId=Karbon-v08:kar-containers-download-kubeconfig-t.html) and move it to ~/.kube/config file.

Then, build Sonobuoy(the standard tool for running these tests) by running `go get -u -v github.com/heptio/sonobuoy`.
This would build the latest Sonobuoy release [0.13.0](https://github.com/heptio/sonobuoy/releases/tag/v0.13.0).

Deploy a Sonobuoy pod to the deployed cluster using `sonobuoy run`, which will initiate the tests to run on
the cluster. Use `sonobuoy status` to track the status of the test run. Once it completes, you
can inspect the logs using `sonobuoy logs` and/or retrieve it using `sonobuoy retrieve` 
to copy from the main Sonobuoy pod to a local directory.
