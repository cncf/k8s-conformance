# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create conformance-v1.33 --cluster-template kubernetes-v1.33.0 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config conformance-v1.33

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                                        STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION   CONTAINER-RUNTIME
conformance-v1-33-wlj4cvhsldpr-control-plane-5kdn8          Ready    control-plane   45m   v1.33.0   10.0.0.154    <none>        Flatcar Container Linux by Kinvolk 4152.2.2 (Oklo)   6.6.83-flatcar   containerd://1.7.26
conformance-v1-33-wlj4cvhsldpr-control-plane-9z4kk          Ready    control-plane   50m   v1.33.0   10.0.0.12     <none>        Flatcar Container Linux by Kinvolk 4152.2.2 (Oklo)   6.6.83-flatcar   containerd://1.7.26
conformance-v1-33-wlj4cvhsldpr-control-plane-jfwmt          Ready    control-plane   43m   v1.33.0   10.0.0.238    <none>        Flatcar Container Linux by Kinvolk 4152.2.2 (Oklo)   6.6.83-flatcar   containerd://1.7.26
conformance-v1-33-wlj4cvhsldpr-default-worker-r8pmx-gpxrn   Ready    <none>          45m   v1.33.0   10.0.0.165    <none>        Flatcar Container Linux by Kinvolk 4152.2.2 (Oklo)   6.6.83-flatcar   containerd://1.7.26
conformance-v1-33-wlj4cvhsldpr-default-worker-r8pmx-kxjqk   Ready    <none>          46m   v1.33.0   10.0.0.111    <none>        Flatcar Container Linux by Kinvolk 4152.2.2 (Oklo)   6.6.83-flatcar   containerd://1.7.26
conformance-v1-33-wlj4cvhsldpr-default-worker-r8pmx-mxl78   Ready    <none>          45m   v1.33.0   10.0.0.178    <none>        Flatcar Container Linux by Kinvolk 4152.2.2 (Oklo)   6.6.83-flatcar   containerd://1.7.26
``

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
