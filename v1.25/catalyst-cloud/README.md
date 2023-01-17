# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to the Catalyst Cloud dashboard to create a Kubernetes cluster or use the OpenStack command line interface to create the cluster.

```shell
$ openstack coe cluster create cluster125 --cluster-template kubernetes-v1.25.5 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cluster125

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                               STATUS   ROLES    AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION          CONTAINER-RUNTIME
cluster125-w73dz53kvqes-master-0   Ready    master   3h1m   v1.25.5   10.0.0.9      10.10.8.50    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster125-w73dz53kvqes-master-1   Ready    master   3h1m   v1.25.5   10.0.0.4      10.10.8.70    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster125-w73dz53kvqes-master-2   Ready    master   3h1m   v1.25.5   10.0.0.20     10.10.8.67    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster125-w73dz53kvqes-node-0     Ready    <none>   179m   v1.25.5   10.0.0.16     10.10.8.74    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster125-w73dz53kvqes-node-1     Ready    <none>   178m   v1.25.5   10.0.0.22     10.10.8.62    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
cluster125-w73dz53kvqes-node-2     Ready    <none>   179m   v1.25.5   10.0.0.21     10.10.8.60    Fedora CoreOS 37.20221106.3.0   6.0.7-301.fc37.x86_64   containerd://1.6.13
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
