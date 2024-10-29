# Reproducing conformance tests on Switch Cloud Kubernetes

## Set up SCK cluster

1. Login to [https://sck.cloud.switch.ch](https://sck.cloud.switch.ch).
2. Choose your desired project.
3. Press the "Create Cluster" button.
4. Follow the wizard. Unless specified in the list below, go with the default or, if a selection/value is required but no default is provided, your own preference.
   - In step 2 ("Cluster"):
     - choose Canal instead of Cilium as the CNI, as Cilium is not currently conformant (see cilium/cilium#29913, cilium/cilium#9207, and cilium/cilium#33434 for more information - fix will be in Cilium 1.17).
     - choose "Control Plane Version" "1.31.1" (or newer)
     - choose "iptables" as the "Proxy Mode" under "Advanced Network Configuration"
   - In step 4 ("Initial Nodes"):
     - set "Replicas" to "2" (or more)
     - set "Flavor" to "c002r004" (or larger)
     - set "Disk Size in GB" to "20" (or larger)

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
