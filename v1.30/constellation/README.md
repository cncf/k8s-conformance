# Reproducing Conformance Test Results

## Prerequisites

1. [Follow the docs on how to set up cloud credentials for Azure](https://docs.edgeless.systems/constellation/getting-started/install#set-up-cloud-credentials).
2. [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) for working with Kubernetes.

3. [Install Sonobuoy.](https://github.com/vmware-tanzu/sonobuoy/releases)
   These tests results were produced using Sonobuoy v0.57.2.

Download the Constellation CLI v2.17.0:

```shell
curl -fsSLO https://github.com/edgelesssys/constellation/releases/download/v2.17.0/constellation-linux-amd64
mv constellation-linux-amd64 constellation
chmod +x constellation
```

## Start a Constellation cluster

### Create a config file

```shell
./constellation config generate azure --kubernetes v1.30
```

### Create IAM resources

```sh
./constellation iam create azure --update-config --yes --region westeurope --resourceGroup k8s-conf-1-30 --servicePrincipal k8s-conf-1-30
```

### Provision Constellation Cluster

Set the number of worker nodes to 2 (minimum for conformance tests):

```sh
yq -i '.nodeGroups.worker_default.initialCount = 2' constellation-conf.yaml
```

Create the cluster:

```sh
./constellation apply --conformance --yes
export KUBECONFIG="$PWD/constellation-admin.conf"
```

Work around Cilium conformance issues (kubernetes/kubernetes#120069):

```sh
kubectl -n kube-system patch configmap cilium-config --type=json --patch '[{"op": "add", "path": "/data/k8s-service-proxy-name", "value": "cilium"  }]'
kubectl -n kube-system rollout restart daemonset/cilium
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
