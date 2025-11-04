# Reproducing conformance tests on Switch Cloud Kubernetes

## Set up SCK cluster

1. Login to [https://sck.cloud.switch.ch](https://sck.cloud.switch.ch).
2. Choose your desired project.
3. Press the "Create Cluster" button.
4. Follow the wizard. Unless specified in the list below, go with the default or, if a selection/value is required but no default is provided, your own preference.
   - In step 2 ("Cluster"):
     - Choose "Control Plane Version" "1.32.3" (or newer).
     - Choose Canal instead of Cilium as the CNI, as Cilium is not currently conformant (see cilium/cilium#29913, cilium/cilium#9207, and cilium/cilium#33434 for more information - fix will be in Cilium 1.17).
     - After expanding the "Advanced Network Configuration" section:
       - Choose "iptables" as the "Proxy Mode" under "Advanced Network Configuration".
       - Ensure "Allowed IP Range for NodePorts" is set to `0.0.0.0/0` to allow all inbound traffic.
   - In step 4 ("Initial Nodes"):
     - Set "Replicas" to "2" (or more).
     - Set "Flavor" to "c002r004" (or larger).
     - Set "Disk Size in GB" to "20" (or larger).

When the cluster and all its nodes are shown with a green status indicater in the web interface, download the kubeconfig by clicking on the "Get Kubeconfig" button.
Then set the `KUBECONFIG` environment variable to point at the downloaded file.

## Run the conformance test using hydrophone

### Prerequisites

Ensure you have Go installed on your system and the `GOPATH` is set. You will also need access to a Kubernetes cluster.

### Install

Install Hydrophone using the following command:

```bash
go install sigs.k8s.io/hydrophone@latest
```

Alternatively you can download the latest release from the [releases page](https://github.com/kubernetes-sigs/hydrophone/releases)

### Running Tests

Ensure there is a `KUBECONFIG` environment variable specified or `$HOME/.kube/config` file present before running `hydrophone` Alternatively, you can specify the path to the kubeconfig file with the `--kubeconfig` option.

To run conformance tests use:

```bash
hydrophone --conformance
```

### Tips

We recommend running with more than 2 replicas and adding the parameter `--parallel N` to the above command, where N should be the number of replicas, to speed up the test execution.

Furthermore, we recommend adding the parameter `--extra-ginkgo-args '--flake-attempts=N'` in order to automatically retry failed tests N times. Our backend is very dynamic and might reschedule etcd or kube-apiserver components at any time, which can lead to false negatives due to connections to the Kubernetes API being closed unexpectedly.

Thus our recommended command looks something like this, assuming the cluster has 5 worker nodes:

```bash
hydrophone --conformance --parallel 5 --extra-ginkgo-args '--flake-attempts=3'
```

Additionally, due to the flakiness explained above, hydrophone might wrongly assume the test suite has finished when it hasn't, and attempt to download the log files prematurely, which will fail. This has been raised in kubernetes-sigs/hydrophone#224 and will be fixed in a future version of hydrophone. In the meantime, you can reconnect to the still running test suite simply by executing the following:

```bash
hydrophone --continue
```
