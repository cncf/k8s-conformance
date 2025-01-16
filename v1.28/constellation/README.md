# Reproducing Conformance Test Results

## Prerequisites

[Follow the docs on how to set up cloud credentials for GCP](https://docs.edgeless.systems/constellation/getting-started/install#set-up-cloud-credentials)

[Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) for working with Kubernetes

Additionally, [Sonobuoy CLI is required.](https://github.com/vmware-tanzu/sonobuoy/releases)
These tests results were produced using Sonobuoy v0.57.1.

Download the Constellation CLI v2.16.4:

```shell
curl -fsSLO https://github.com/edgelesssys/constellation/releases/download/v2.16.4/constellation-linux-amd64
mv constellation-linux-amd64 constellation
chmod +x constellation-linux-amd64
```

## Start a Constellation cluster

### Create a config file

```shell
./constellation config generate gcp
```

### Create IAM resources

```sh
./constellation iam create gcp \
    --projectID=XXXXXXXXXXXXXX \
    --serviceAccountID=conform \
    --zone=europe-west3-b \
    --update-config \
    -y
```

### Provision Constellation Cluster

Set the number of worker nodes to 2 (minimum for conformance tests):

```sh
yq -i '.nodeGroups.worker_default.initialCount = 5' constellation-conf.yaml
```

Create the cluster:

```sh
./constellation apply --conformance -y
export KUBECONFIG="$PWD/constellation-admin.conf"
```

## Run Conformance Tests

```sh
# Runs for ~2 hours.
sonobuoy run --mode certified-conformance --wait
# ... download & display results.
outfile=$(sonobuoy retrieve)
sonobuoy results $outfile
```

## Cleanup

```sh
# Remove test deployments
sonobuoy delete --wait
# Or, shutdown cluster
./constellation terminate -y
rm constellation-mastersecret.json
```
