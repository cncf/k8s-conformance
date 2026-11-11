# Conformance tests for Gardener provisioned by Open Sovereign Cloud

## Create an OSC User and Project

1. Sign in to the OSC Dashboard.
2. Create a user with permission to create and manage Gardener Shoot clusters.
3. Create or select a project for the conformance test environment.

For detailed instructions, see the [OSC Getting Started guide](https://docs.osc.live/v1.0.4/osc-gardener-user-documentation/01-Get_Started/user-creation.html).

## Create the Kubernetes Cluster

The Kubernetes cluster used for the conformance tests is deployed as a Gardener Shoot cluster on Open Sovereign Cloud (OSC).

1. Open the Gardener cluster management interface in the OSC Dashboard.
2. Create a new Shoot cluster in the project created above.
3. Configure the Shoot with the following settings:
   - Kubernetes version: `1.35.5`
   - Worker OS/image: `gardenlinux 2150.12.0`
4. Keep all other configuration at the OSC/Gardener defaults unless explicitly stated above.
5. Create the Shoot and wait until it reaches the **Healthy** state.
6. Download the cluster kubeconfig. The user running the conformance tests requires sufficient Kubernetes RBAC permissions to create and manage the resources required by the conformance test suite.

For additional details on Shoot creation and configuration, see the [OSC Shoot Creation guide](https://docs.osc.live/v1.0.4/osc-gardener-user-documentation/01-Get_Started/shoots-creation.html).


## Run conformance tests

To verify that your OSC Gardener Shoot cluster is indeed conformant, you
can download sonobuoy from
[github.com/vmware-tanzu/sonobuoy/releases](https://github.com/vmware-tanzu/sonobuoy/releases)
and run the test in your cluster:

```
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

You can find the result files in `results/plugins/e2e/results/global/`.