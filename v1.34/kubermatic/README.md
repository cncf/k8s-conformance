# To reproduce

## Set up the cluster

1. Login to https://dev.kubermatic.io/.
2. Press the "Create Cluster" button.
3. Pick Kubernetes version v1.34.x.
4. Complete the create cluster wizard with either DigitalOcean, Hetzner or AWS;
   * Ensure "Allowed IP Range for NodePorts" under "Advanced Network Configuration" is set to `0.0.0.0/0` to allow all inbound traffic.
   * Choose node sizes that can comfortably fit the pods created during the conformance tests, a 1vCPU/2GB machine is for example too small.

When the cluster is up and running,

1. Download the kubeconfig by clicking on the "Get Kubeconfig" button and select the option "OIDC via oidc-login plugin"
2. Set the KUBECONFIG environment variable `export KUBECONFIG=$PWD/kubeconfig`.

## Run the conformance test

Download a [binary release](https://github.com/kubernetes-sigs/hydrophone/releases) for Hydrophone on GitHub. Hydrophone is a modern, lightweight runner for the Kubernetes conformance tests.

Start the conformance tests by running `hydrophone` to deploy a Pod into your cluster:

```bash
$ hydrophone --conformance
```

Be patient and wait until the tests have completed. This can take up to two hours, depending on your cluster's capacity. Once the tests have completed, `hydrophone` will write an `e2e.log` and a `junit_01.xml`.

If your cluster has capacity, you can speed up the tests by setting `--parallel N`, with N roughly being the number of worker nodes that exist exclusively for the conformance tests and do not run any other workload.

If you experience random test failures (often because of interrupted watch commands), try increasing flakeAttempts by using setting `--extra-ginkgos-args '--flakeAttempts=N'`. This will make Ginkgo automatically retry failed subtests immediately, instead of you having to re-run the entire conformance suite.
