# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface to create the cluster.

```shell
$ openstack coe cluster create cluster127 --cluster-template kubernetes-v1.27.9 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cluster127

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                               STATUS   ROLES    AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION          CONTAINER-RUNTIME
cluster127-ngu2g6sxoegs-master-0   Ready    master   120m   v1.27.9   10.0.0.12     10.10.8.102   Fedora CoreOS 38.20231027.3.2   6.5.8-200.fc38.x86_64   containerd://1.7.5
cluster127-ngu2g6sxoegs-master-1   Ready    master   120m   v1.27.9   10.0.0.20     10.10.8.75    Fedora CoreOS 38.20231027.3.2   6.5.8-200.fc38.x86_64   containerd://1.7.5
cluster127-ngu2g6sxoegs-master-2   Ready    master   120m   v1.27.9   10.0.0.4      10.10.8.145   Fedora CoreOS 38.20231027.3.2   6.5.8-200.fc38.x86_64   containerd://1.7.5
cluster127-ngu2g6sxoegs-node-0     Ready    <none>   118m   v1.27.9   10.0.0.18     10.10.8.38    Fedora CoreOS 38.20231027.3.2   6.5.8-200.fc38.x86_64   containerd://1.7.5
cluster127-ngu2g6sxoegs-node-1     Ready    <none>   118m   v1.27.9   10.0.0.21     10.10.8.21    Fedora CoreOS 38.20231027.3.2   6.5.8-200.fc38.x86_64   containerd://1.7.5
cluster127-ngu2g6sxoegs-node-2     Ready    <none>   117m   v1.27.9   10.0.0.11     10.10.8.58    Fedora CoreOS 38.20231027.3.2   6.5.8-200.fc38.x86_64   containerd://1.7.5
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
