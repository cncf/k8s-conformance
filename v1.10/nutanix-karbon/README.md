Nutanix Karbon
===

To Reproduce
---

On Nutanix Prism Central enable Karbon (managed Kubernetes offering) by following
[this document](https://portal.nutanix.com/#/page/docs/details?targetId=Karbon-v08:kar-containers-install-t.html)
Next follow the steps to install a fresh cluster choosing `v1.10` as the Kubernetes
version and `centos` as the base image.

Once it is deployed you can download the kubeconfig to your local machine using
the steps described [here](https://portal.nutanix.com/#/page/docs/details?targetId=Karbon-v08:kar-containers-download-kubeconfig-t.html)
and move it to ~/.kube/config file.
Then download sonobouy release [0.11.6](https://github.com/heptio/sonobuoy/releases/tag/v0.11.6).
Untar this release and run `sonobouy run` which will initiate the tests to run on
this deployed cluster.

Use `sonobuoy status` to track the status of the test run. Once it completes you
can inspect the logs using `sonobuoy logs` or retrieve it using `sonobuoy retrieve`