### Prerequisites

- `kubectl`
- [`kubectl gs` plugin](https://docs.giantswarm.io/reference/kubectl-gs/installation)
- Access to a Giant Swarm Management Cluster on AWS.

Choose a cluster name:

```sh
cluster="conformance"
```

### Create the cluster

Configure `kubectl` to connect to the Giant Swarm Management Cluster.

Template the cluster:

```sh
kubectl gs template cluster --provider capa --organization giantswarm --name "${cluster}" --release 30.0.0 --output "${cluster}.yaml"
```

Create the cluster:

```sh
kubectl create --filename "${cluster}.yaml"
```

### Run the tests

Wait a bit for the cluster to come up. Depending on the underlying infrastructure, this might take a few minutes.

Log in to the cluster:

```sh
kubectl gs login MANAGEMENT_CLUSTER --workload-cluster "${cluster}"
```

From here on, we follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#sonobuoy).

### Delete the cluster

Configure `kubectl` to connect to the Giant Swarm Management Cluster.

Delete the cluster:

```sh
kubectl delete --filename "${cluster}.yaml"
```
