# Conformance testing Wavestack Kubernetes Engine (WKE)

Wavestack Kubernetes Engine (WKE) implements the automated management
and operation of Kubernetes clusters as a service.

## Prerequisites

In order to follow this guide, the following tools have to be installed:

- kubectl - https://kubernetes.io/docs/tasks/tools/
- gardenlogin - https://github.com/gardener/gardenlogin
- kubelogin - https://github.com/int128/kubelogin

## Create an account

You can easily sign-up for an account by clicking **Sign Up** on https://wavestack.cloud/

If you have any questions or require help you can also contact
[wavestack-support@wavecon.de](mailto:wavestack-support@wavecon.de).

## Setup WKE Cluster

Log into the Wavestack Kubernetes Engine dashboard on
https://dashboard.gardener.wavestack.cloud/ with your Wavestack
credentials.

Click the **+** button at the top to start the creation of a new
Kubernetes cluster.

We used the following configuration for the conformance tests:

- Openstack infrastructure
- Kubernetes version `1.26.5`
- Calico networking
- Worker group of 2 instances with 4 vCPU and 8 GiB memory

Create the cluster by clicking **Create** in the bottom right corner.

## Access the Cluster

Once your new cluster has finished bootstrapping, you can configure
access to it via kubectl.

### Configure gardenlogin

Create `~/.garden/gardenlogin.yaml` with the following content:

```yaml
gardens:
  - identity: wavestack
    kubeconfig: ~/.garden/gardenctl-v2.yaml
```

Navigate to your account on the Gardener dashboard and download the
kubeconfig to the garden cluster. Save it as
`~/.garden/gardenctl-v2.yaml`.

### Use kubectl

Download the **Kubeconfig - Gardenlogin** file for your cluster from
the cluster overview or cluster details page.

The file will be named similar to
`kubeconfig-gardenlogin--<project_id>--<cluster_name>.yaml`. Save the downloaded
file in the `~/.kube/` directory.

Set the `KUBECONFIG` environment variable:

```cli
❯ export KUBECONFIG=~/.kube/kubeconfig-gardenlogin--<project_id>--<cluster_name>.yaml
```

## Sonobuoy

Download and install a binary release of
[sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases/).

## Run conformance tests

Start the conformance tests on your WKE cluster

```bash
sonobuoy run --mode=certified-conformance
```

Upon completion of the tests you can obtain the results by copying
them off the sonobuoy pod.

```bash
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results
tar xzf $outfile -C ./results
```

The two files required for submission are:

- `plugins/e2e/results/global/e2e.log`
- `plugins/e2e/results/global/junit_01.xml`
