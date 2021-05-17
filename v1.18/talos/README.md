# Talos

## How to reproduce the results

**NOTE**: These steps are a reproduction of our README in the [cluster-api-boostrap-provider-talos](https://github.com/talos-systems/cluster-api-bootstrap-provider-talos/blob/master/docs/GCP.md) repo.

# cluster-api-bootstrap-provider-talos on GCP

This guide will detail how to deploy the Talos provider into an existing Kubernetes cluster, as well as how to configure it to create Clusters and Machines in GCP.

#### Import Image

To import the image, you must download a .tar.gz talos release, add it to Google storage, and import it as an image.

- Download the `gcp.tar.gz` image from our [Github releases](https://github.com/talos-systems/talos/releases).

- Follow the [Google instructions](https://cloud.google.com/compute/docs/images/import-existing-image#import_image) on importing an image using cloud storage.

#### Prepare bootstrap cluster

In your cluster that you'll be using to create other clusters, you must prepare a few bits.

##### Install GCP Provider

- Git clone the [GCP infrastructure provider](https://github.com/kubernetes-sigs/cluster-api-provider-gcp). Because the GCP provider is being actively developed, it's currently best to build the manifests we need instead of relying on releases.

- In GCP, create a service account and generate keys for the account. This will result in a JSON file containing the keys. General instructions for generating the key can be found [here](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

- In the repo you checked out above, set your environment variables and generate the manifests:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
export GCP_REGION=us-central1
export GCP_PROJECT=my-gcp-project

make generate-examples
```

- Deploy the generated infrastructure components with:

```bash
kubectl create -f examples/_out/provider-components.yaml
```

- Because this ships with the kubeadm bootstrapper, we'll delete that deployment. It's not needed.

```bash
kubectl delete deploy -n cabpk-system cabpk-controller-manager
```

##### Install Talos Bootstrap Provider

- Git clone this repo

- In the directory, apply the manifests using kustomize:

```bash
kustomize build config/default/ | kubectl apply -f -
```

#### Create new clusters

There are sample manifests in [config/samples/cluster-deployment/gcp](../config/samples/cluster-deployment/gcp) for deploying clusters. These will be our starting point.

- Edit `gcp-cluster.yaml`, `gcp-controlplane.yaml`, and `gcp-workers.yaml` with your relevant data. You will specifically want to edit the GCP image, as well as your GCP project.

- From `config/samples/cluster-deployment/gcp` issue `kubectl apply -f .`.

- The talos config for your controlplane-0 node can be found with `kubectl get talosconfig -o yaml test1-controlplane-0 -o jsonpath='{.status.talosConfig}'`.

- You must target the public IP of the controlplane-0 node (found in GCP console) with `osctl config endpoint $EXTERNAL_IP` before osctl will work.

## Running e2e tests

```
go get -u -v github.com/heptio/sonobuoy
sonobuoy run --wait --skip-preflight --mode=certified-conformance --plugin e2e --plugin-env e2e.E2E_USE_GO_RUNNER=true
results=$(sonobuoy retrieve)
sonobuoy e2e $results
mkdir ./results; tar xzf ${results} -C ./results
```
