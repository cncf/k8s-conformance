## Install PKE

Please check the [README](https://github.com/banzaicloud/pke/tree/master#installation) of PKE for detailed install instructions.

### Single node PKE

Creating a single node K8s clusters is as simple as:

`pke install single`

### Multi node PKE

To create the Kubernetes API server:

```
export MASTER_IP_ADDRESS=""
pke install master --kubernetes-api-server=${MASTER_IP_ADDRESS}:6443
```

>Please get the token and certhash from the logs or issue the `pke token list` command to print the token and cert hash needed by workers to join the cluster.
>

Once the API server is up and running you can add as many nodes as needed:

```
export TOKEN=""
export CERTHASH=""
export MASTER_IP_ADDRESS=""
pke install worker --kubernetes-node-token $TOKEN --kubernetes-api-server-ca-cert-hash $CERTHASH --kubernetes-api-server ${MASTER_IP_ADDRESS}:6443
```

### Using `kubectl`

To use `kubectl` and other command line tools like `sonobuoy` on the master node, set up its config:

```
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes
```

## Run conformance tests

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your Kubernetes context with:

```
$ sonobuoy run
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```
$ sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
