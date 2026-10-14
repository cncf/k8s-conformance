# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create conformancev135 --cluster-template kubernetes-v1.35.3-20260409 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config conformancev135

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                                      STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION    CONTAINER-RUNTIME
conformancev135-4yd2slzbjtt4-control-plane-4f8dt          Ready    control-plane   5h17m   v1.35.3   10.0.0.189    <none>        Flatcar Container Linux by Kinvolk 4459.2.4 (Oklo)   6.12.74-flatcar   containerd://1.7.30
conformancev135-4yd2slzbjtt4-control-plane-bkc98          Ready    control-plane   5h25m   v1.35.3   10.0.0.13     <none>        Flatcar Container Linux by Kinvolk 4459.2.4 (Oklo)   6.12.74-flatcar   containerd://1.7.30
conformancev135-4yd2slzbjtt4-control-plane-dqqz6          Ready    control-plane   5h20m   v1.35.3   10.0.0.219    <none>        Flatcar Container Linux by Kinvolk 4459.2.4 (Oklo)   6.12.74-flatcar   containerd://1.7.30
conformancev135-4yd2slzbjtt4-default-worker-xr6dk-5jm7f   Ready    <none>          5h21m   v1.35.3   10.0.0.186    <none>        Flatcar Container Linux by Kinvolk 4459.2.4 (Oklo)   6.12.74-flatcar   containerd://1.7.30
conformancev135-4yd2slzbjtt4-default-worker-xr6dk-645w4   Ready    <none>          5h21m   v1.35.3   10.0.0.91     <none>        Flatcar Container Linux by Kinvolk 4459.2.4 (Oklo)   6.12.74-flatcar   containerd://1.7.30
conformancev135-4yd2slzbjtt4-default-worker-xr6dk-s6b9l   Ready    <none>          5h21m   v1.35.3   10.0.0.173    <none>        Flatcar Container Linux by Kinvolk 4459.2.4 (Oklo)   6.12.74-flatcar   containerd://1.7.30
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
