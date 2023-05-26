# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to the Catalyst Cloud dashboard to create a Kubernetes cluster or use the OpenStack command line interface to create the cluster.

```shell
$ openstack coe cluster create cluster124 --cluster-template kubernetes-v1.24.9 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cluster124

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                               STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION          CONTAINER-RUNTIME
cluster124-apihrjet4zqi-master-0   Ready    master   6h35m   v1.24.9   10.0.0.19     10.10.8.58    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster124-apihrjet4zqi-master-1   Ready    master   6h35m   v1.24.9   10.0.0.12     10.10.8.52    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster124-apihrjet4zqi-master-2   Ready    master   6h35m   v1.24.9   10.0.0.17     10.10.8.6     Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster124-apihrjet4zqi-node-0     Ready    <none>   6h33m   v1.24.9   10.0.0.16     10.10.8.61    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster124-apihrjet4zqi-node-1     Ready    <none>   6h33m   v1.24.9   10.0.0.21     10.10.8.25    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster124-apihrjet4zqi-node-2     Ready    <none>   6h32m   v1.24.9   10.0.0.9      10.10.8.53    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
