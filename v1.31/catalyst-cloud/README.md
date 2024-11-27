# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create cert131 --cluster-template kubernetes-v1.31.3 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cert131

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                                 STATUS   ROLES           AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION   CONTAINER-RUNTIME
cert131-qmygr5zpj2ly-control-plane-d21b851b-7zpjn    Ready    control-plane   2d5h   v1.31.3   10.0.0.208    <none>        Flatcar Container Linux by Kinvolk 3975.2.2 (Oklo)   6.6.54-flatcar   containerd://1.7.20
cert131-qmygr5zpj2ly-control-plane-d21b851b-grjv9    Ready    control-plane   2d5h   v1.31.3   10.0.0.223    <none>        Flatcar Container Linux by Kinvolk 3975.2.2 (Oklo)   6.6.54-flatcar   containerd://1.7.20
cert131-qmygr5zpj2ly-control-plane-d21b851b-s6ssn    Ready    control-plane   10h    v1.31.3   10.0.0.247    <none>        Flatcar Container Linux by Kinvolk 3975.2.2 (Oklo)   6.6.54-flatcar   containerd://1.7.20
cert131-qmygr5zpj2ly-default-worker-ef426fb6-dz4m9   Ready    <none>          2d5h   v1.31.3   10.0.0.89     <none>        Flatcar Container Linux by Kinvolk 3975.2.2 (Oklo)   6.6.54-flatcar   containerd://1.7.20
cert131-qmygr5zpj2ly-default-worker-ef426fb6-jfhgt   Ready    <none>          2d5h   v1.31.3   10.0.0.92     <none>        Flatcar Container Linux by Kinvolk 3975.2.2 (Oklo)   6.6.54-flatcar   containerd://1.7.20
cert131-qmygr5zpj2ly-default-worker-ef426fb6-nls2l   Ready    <none>          2d5h   v1.31.3   10.0.0.177    <none>        Flatcar Container Linux by Kinvolk 3975.2.2 (Oklo)   6.6.54-flatcar   containerd://1.7.20

```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
