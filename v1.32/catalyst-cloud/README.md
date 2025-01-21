# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create cert132 --cluster-template kubernetes-v1.32.0 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config cert132

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                              STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION   CONTAINER-RUNTIME
cert132-yex7cskzmgvz-control-plane-2cgf2          Ready    control-plane   16m   v1.32.0   10.0.0.162    <none>        Flatcar Container Linux by Kinvolk 4081.2.1 (Oklo)   6.6.65-flatcar   containerd://1.7.20
cert132-yex7cskzmgvz-control-plane-75ftp          Ready    control-plane   18m   v1.32.0   10.0.0.109    <none>        Flatcar Container Linux by Kinvolk 4081.2.1 (Oklo)   6.6.65-flatcar   containerd://1.7.20
cert132-yex7cskzmgvz-control-plane-ddbnb          Ready    control-plane   23m   v1.32.0   10.0.0.170    <none>        Flatcar Container Linux by Kinvolk 4081.2.1 (Oklo)   6.6.65-flatcar   containerd://1.7.20
cert132-yex7cskzmgvz-default-worker-96brp-8vdv9   Ready    <none>          20m   v1.32.0   10.0.0.46     <none>        Flatcar Container Linux by Kinvolk 4081.2.1 (Oklo)   6.6.65-flatcar   containerd://1.7.20
cert132-yex7cskzmgvz-default-worker-96brp-j4fn6   Ready    <none>          19m   v1.32.0   10.0.0.116    <none>        Flatcar Container Linux by Kinvolk 4081.2.1 (Oklo)   6.6.65-flatcar   containerd://1.7.20
cert132-yex7cskzmgvz-default-worker-96brp-rl95t   Ready    <none>          19m   v1.32.0   10.0.0.74     <none>        Flatcar Container Linux by Kinvolk 4081.2.1 (Oklo)   6.6.65-flatcar   containerd://1.7.20
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
