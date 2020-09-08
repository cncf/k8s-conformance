Nutanix Karbon
===
 To Reproduce
---
 On Nutanix Prism Central, enable Karbon (managed Kubernetes offering of Nutanix) by following
the instructions mentioned below:
1. Log on to Prism Central.
2. Click the menu icon.
3. In the Services option, click Karbon.
4. `Karbon is successfully enabled` message will indicate that Karbon has been enabled successfully.
5. In the Karbon Console, a message directs you to download a node OS image.
6. Once image download completes successfully, use the UI cluster create wizard
   to fill up all the necessary information:
     a) Name of cluster
     b) Network to be used.
     c) Choose development cluster or production cluster.
     d) Choose the K8s version to be deployed to 1.18.*
     e) Select the storage container.
     f) Initiate cluster creation.
     g) UI will display the status of deployment.

Next, follow the steps to install a fresh cluster, choosing `v1.18` as the Kubernetes
version and `centos` as the base image.

Once the cluster is deployed, you can download the kubeconfig to your local machine using
the steps described:
1. In the Clusters view, select a cluster from the list by checking the adjacent box.
2. Click the Actions drop-down.
3. Click Download Kubeconfig
4. Under Instructions, click Download.
5. Once the file is downloaded(example: prod1-kubectl.cfg), run the following command:
    `export KUBECONFIG=/path/to/prod1-kubectl.cfg`
6. Run the following command to test the cluster:
    `kubectl cluster-info`

Then, build Sonobuoy(the standard tool for running these tests) by running `go get -u -v github.com/heptio/sonobuoy`.
This would build the latest Sonobuoy release [v0.19.0](https://github.com/heptio/sonobuoy/releases/tag/v0.19.0).

Deploy a Sonobuoy pod to the deployed cluster using `sonobuoy run`, which will initiate the tests to run on
the cluster. Use `sonobuoy status` to track the status of the test run. Once it completes, you
can inspect the logs using `sonobuoy logs` and/or retrieve it using `sonobuoy retrieve`
to copy from the main Sonobuoy pod to a local directory.
