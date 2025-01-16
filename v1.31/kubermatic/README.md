# To reproduce

## Set up the cluster

1. Login to https://dev.kubermatic.io/.
2. Press the "Create Cluster" button.
3. Pick Kubernetes version v1.31.x.
4. Select "iptables" Proxy Mode from "Advanced Network Configuration".
5. Complete the create cluster wizard with either DigitalOcean, Hetzner or AWS;
   * Choose Canal as your CNI, as Cilium fails to pass the full conformance test suite (cilium/cilium#29913).
   * Ensure "Allowed IP Range for NodePorts" is set to `0.0.0.0/0` to allow all inbound traffic.
   * Choose node sizes that can comfortably fit the pods created during the conformance tests, a 1vCPU/2GB machine is for example too small.

When the cluster is up and running,

1. Download the kubeconfig file.
2. Set the KUBECONFIG environment variable `export KUBECONFIG=$PWD/kubeconfig`.

## Run the conformance test

Download a [binary release](https://github.com/kubernetes-sigs/hydrophone/releases) for Hydrophone on GitHub. Hydrophone is a modern, lightweight runner for the Kubernetes conformance tests.

Start the conformance tests by running `hydrophone` to deploy a Pod into your cluster:

```bash
$ hydrophone --conformance
```

Be patient and wait until the tests have completed. This can take up to two hours, depending on your cluster's capacity. Once the tests have completed, `hydrophone` will write an `e2e.log` and a `junit_01.xml`.
