# Banzai Cloud Pipeline Kubernetes Engine (PKE)

PKE is the preferred Kubernetes distribution of the Banzai Cloud Pipeline platform which supercharges the development, deployment and scaling of container-based applications with native support for multi-, hybrid-, and edge-cloud environments.


## Hosted environment

Banzai Cloud offers a free preview environment for its platform which makes launching PKE clusters easy.

Head to the [Quickstart guide](https://banzaicloud.com/docs/pipeline/quickstart/install-pipeline/try/) to setup a Banzai Cloud preview account.

**We installed PKE on AWS to run the conformance tests, but it can run on any cloud, on-prem or bare metal.**

**Important:** Before running the conformance test suite, make sure to enable inbound traffic for the service node port range (`30000 - 32767`) in the worker security group.

### CLI

Install the [CLI tool](https://banzaicloud.com/docs/pipeline/cli/install/) then follow the [PKE getting started guide](https://banzaicloud.com/docs/pipeline/quickstart/create-cluster/pke-aws/).

In short:

```bash
# Create an AWS secret from your local credentials
# (drop --magic if you want to manually create it)
banzai secret create --name=aws --magic --type=amazon

# Create a PKE cluster
banzai cluster create

# Wait for the cluster to become ready
banzai cluster list

# Login to the cluster
banzai cluster shell --cluster-name your-cluster-name
```

### UI

After setting up an account, head to `Clusters` in the menu, click `Create` and follow the instructions.


## Manual PKE install

PKE itself can be installed manually without using Banzai Cloud Pipeline to manage the infrastructure,
but it requires the user to create the necessary resources (VMs, networks, etc).

Please check the [README](https://github.com/banzaicloud/pke/tree/master#installation) of PKE for detailed installation instructions.

### Single node PKE

Creating a single node K8s clusters is as simple as:

```bash
pke install single --kubernetes-version=1.18.8
```

### Multi node PKE

To create the Kubernetes API server:

```bash
export MASTER_IP_ADDRESS=""
pke install master --kubernetes-api-server=${MASTER_IP_ADDRESS}:6443 --kubernetes-version=1.18.8
```

>Please get the token and certhash from the logs or issue the `pke token list` command to print the token and cert hash needed by workers to join the cluster.
>

Once the API server is up and running you can add as many nodes as needed:

```bash
export TOKEN=""
export CERTHASH=""
export MASTER_IP_ADDRESS=""
pke install worker --kubernetes-node-token $TOKEN --kubernetes-api-server-ca-cert-hash $CERTHASH --kubernetes-api-server ${MASTER_IP_ADDRESS}:6443 --kubernetes-version=1.18.8
```

### Using `kubectl`

To use `kubectl` and other command line tools like `sonobuoy` on the master node, set up its config:

```bash
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes
```


## Run conformance tests

Download Sonobuoy [v0.19.0](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.19.0).

Then follow the [instructions](https://github.com/cncf/k8s-conformance/blob/a8a1182/instructions.md) to run the conformance tests.
