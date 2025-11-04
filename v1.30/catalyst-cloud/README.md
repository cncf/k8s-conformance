# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create cert130 --cluster-template kubernetes-v1.30.4-20240820 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cert130

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                                 STATUS   ROLES           AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION   CONTAINER-RUNTIME
cert130-qyftyfu75uiz-control-plane-bcc24782-5qdbs    Ready    control-plane   164m   v1.30.4   10.0.0.9      <none>        Flatcar Container Linux by Kinvolk 3815.2.2 (Oklo)   6.1.85-flatcar   containerd://1.7.13
cert130-qyftyfu75uiz-control-plane-bcc24782-r5vvm    Ready    control-plane   161m   v1.30.4   10.0.0.7      <none>        Flatcar Container Linux by Kinvolk 3815.2.2 (Oklo)   6.1.85-flatcar   containerd://1.7.13
cert130-qyftyfu75uiz-control-plane-bcc24782-wvd5q    Ready    control-plane   169m   v1.30.4   10.0.0.32     <none>        Flatcar Container Linux by Kinvolk 3815.2.2 (Oklo)   6.1.85-flatcar   containerd://1.7.13
cert130-qyftyfu75uiz-default-worker-6574cccb-5fsnx   Ready    <none>          167m   v1.30.4   10.0.0.18     <none>        Flatcar Container Linux by Kinvolk 3815.2.2 (Oklo)   6.1.85-flatcar   containerd://1.7.13
cert130-qyftyfu75uiz-default-worker-6574cccb-rspxl   Ready    <none>          167m   v1.30.4   10.0.0.13     <none>        Flatcar Container Linux by Kinvolk 3815.2.2 (Oklo)   6.1.85-flatcar   containerd://1.7.13
cert130-qyftyfu75uiz-default-worker-6574cccb-stx9t   Ready    <none>          167m   v1.30.4   10.0.0.16     <none>        Flatcar Container Linux by Kinvolk 3815.2.2 (Oklo)   6.1.85-flatcar   containerd://1.7.13

```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
