# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create cert128 --cluster-template kubernetes-v1.28.8 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cert128

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                                 STATUS   ROLES           AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION   CONTAINER-RUNTIME
cert128-jdgtwy4ficth-control-plane-f32e7e1f-86g2f    Ready    control-plane   6h3m   v1.28.8   10.0.0.24     <none>        Flatcar Container Linux by Kinvolk 3815.2.0 (Oklo)   6.1.77-flatcar   containerd://1.7.13
cert128-jdgtwy4ficth-control-plane-f32e7e1f-ppk66    Ready    control-plane   6h8m   v1.28.8   10.0.0.4      <none>        Flatcar Container Linux by Kinvolk 3815.2.0 (Oklo)   6.1.77-flatcar   containerd://1.7.13
cert128-jdgtwy4ficth-control-plane-f32e7e1f-sv2p6    Ready    control-plane   6h5m   v1.28.8   10.0.0.11     <none>        Flatcar Container Linux by Kinvolk 3815.2.0 (Oklo)   6.1.77-flatcar   containerd://1.7.13
cert128-jdgtwy4ficth-default-worker-0914671c-6wnch   Ready    <none>          6h7m   v1.28.8   10.0.0.18     <none>        Flatcar Container Linux by Kinvolk 3815.2.0 (Oklo)   6.1.77-flatcar   containerd://1.7.13
cert128-jdgtwy4ficth-default-worker-0914671c-tfxlm   Ready    <none>          6h6m   v1.28.8   10.0.0.17     <none>        Flatcar Container Linux by Kinvolk 3815.2.0 (Oklo)   6.1.77-flatcar   containerd://1.7.13
cert128-jdgtwy4ficth-default-worker-0914671c-wpsnz   Ready    <none>          6h6m   v1.28.8   10.0.0.20     <none>        Flatcar Container Linux by Kinvolk 3815.2.0 (Oklo)   6.1.77-flatcar   containerd://1.7.13

```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
