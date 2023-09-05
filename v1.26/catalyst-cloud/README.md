# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to the Catalyst Cloud dashboard to create a Kubernetes cluster or use the OpenStack command line interface to create the cluster.

```shell
$ openstack coe cluster create cluster126 --cluster-template kubernetes-v1.26.7 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cluster126

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                   STATUS   ROLES    AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION          CONTAINER-RUNTIME
cluster126-d32svn3rsmve-master-0   Ready    master   175m   v1.26.7   10.0.0.19     10.10.8.167   Fedora CoreOS 38.20230625.3.0   6.3.8-200.fc38.x86_64   containerd://1.6.13
cluster126-d32svn3rsmve-master-1   Ready    master   175m   v1.26.7   10.0.0.19     10.10.8.168   Fedora CoreOS 38.20230625.3.0   6.3.8-200.fc38.x86_64   containerd://1.6.13
cluster126-d32svn3rsmve-master-2   Ready    master   175m   v1.26.7   10.0.0.19     10.10.8.169   Fedora CoreOS 38.20230625.3.0   6.3.8-200.fc38.x86_64   containerd://1.6.13
cluster126-d32svn3rsmve-node-0     Ready    <none>   172m   v1.26.7   10.0.0.8      10.10.8.171   Fedora CoreOS 38.20230625.3.0   6.3.8-200.fc38.x86_64   containerd://1.6.13
cluster126-d32svn3rsmve-node-1     Ready    <none>   171m   v1.26.7   10.0.0.21     10.10.8.163   Fedora CoreOS 38.20230625.3.0   6.3.8-200.fc38.x86_64   containerd://1.6.13
cluster126-d32svn3rsmve-node-2     Ready    <none>   171m   v1.26.7   10.0.0.15     10.10.8.172   Fedora CoreOS 38.20230625.3.0   6.3.8-200.fc38.x86_64   containerd://1.6.13
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
