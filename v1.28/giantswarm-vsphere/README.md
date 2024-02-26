## Prerequisites

- `kubectl`
- `kubectl gs` plugin (see https://docs.giantswarm.io/ui-api/kubectl-gs/#install)
- Access to a Giant Swarm Management Cluster on CAPV.

### Create cluster

Configure kubectl to connect to a Giant Swarm Management Cluster.

Choose a cluster name, such as 'test-cncf1' used in the example below.

Generate and apply the cluster template:

```
$ kubectl gs template cluster \
  --provider vsphere \
  --name test-cncf1 \
  --vsphere-network-name grasshopper-capv \
  --organization giantswarm \
  --vsphere-worker-memory-mib 10000 \
  --vsphere-worker-num-cpus 8 \
  --vsphere-worker-replicas 3 \
  --vsphere-control-plane-num-cpus 4 \
  --vsphere-control-plane-memory-mib 8096 \
  --vsphere-image-template flatcar-stable-3602.2.2-kube-v1.28.4-gs \
  --kubernetes-version=1.28.4 > test-cncf1.yaml

$ kubectl apply -f ./test-cncf1.yaml
```

Since we install Cilium in ebpf mode in our clusters, please ensure that the [portmap](https://github.com/containernetworking/plugins) plugin is installed in the nodes under `/etc/cni/bin/` and adjust the Cilium configuration with:

```
    chainingMode: portmap
    kubeProxyReplacement: partial
    sessionAffinity: true
    socketLB:
      enabled: true
    nodePort:
      enabled: true
    hostPort:
      enabled: false
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
$ kubectl delete -f ./test-cncf1.yaml
```
