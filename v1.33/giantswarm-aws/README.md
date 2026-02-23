## Prerequisites

- `kubectl`
- `kubectl gs` plugin (see https://docs.giantswarm.io/ui-api/kubectl-gs/#install)
- Access to a Giant Swarm Management Cluster.

### Create cluster

Configure kubectl to connect to a Giant Swarm Management Cluster.


Generate the cluster template:

```
$ kubectl gs template cluster --provider capa --organization testing > cluster.yaml
```

Check and ensure the `version` field of the cluster app is set to `latest`.


Apply the cluster template:

```
$ kubectl apply -f cluster.yaml
```

### Get Credentials

```
$ kubectl gs login <installation name> --workload-cluster <cluster name>
```

### Run the tests

Wait a bit for the cluster to come up (depending on the underlying infrastructure this might take a few minutes).

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

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

### Destroy cluster

```
$ kubectl delete -f cluster.yaml
```
