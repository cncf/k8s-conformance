# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create conformancev136 --cluster-template kubernetes-v1.36.5-20260930 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config conformancev136

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                                      STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION            CONTAINER-RUNTIME
conformancev136-utq2zznxuuxq-control-plane-ffwdw          Ready    control-plane   6m23s   v1.36.5   10.0.0.168    <none>        Flatcar Container Linux by Kinvolk 4593.2.4 (Oklo)   6.12.95-flatcar (amd64)   containerd://2.3.5
conformancev136-utq2zznxuuxq-control-plane-rhfns          Ready    control-plane   11m     v1.36.5   10.0.0.127    <none>        Flatcar Container Linux by Kinvolk 4593.2.4 (Oklo)   6.12.95-flatcar (amd64)   containerd://2.3.5
conformancev136-utq2zznxuuxq-control-plane-tz9bp          Ready    control-plane   4m31s   v1.36.5   10.0.0.174    <none>        Flatcar Container Linux by Kinvolk 4593.2.4 (Oklo)   6.12.95-flatcar (amd64)   containerd://2.3.5
conformancev136-utq2zznxuuxq-default-worker-5tjc6-blbps   Ready    <none>          8m39s   v1.36.5   10.0.0.163    <none>        Flatcar Container Linux by Kinvolk 4593.2.4 (Oklo)   6.12.95-flatcar (amd64)   containerd://2.3.5
conformancev136-utq2zznxuuxq-default-worker-5tjc6-dz9kv   Ready    <none>          8m41s   v1.36.5   10.0.0.72     <none>        Flatcar Container Linux by Kinvolk 4593.2.4 (Oklo)   6.12.95-flatcar (amd64)   containerd://2.3.5
conformancev136-utq2zznxuuxq-default-worker-5tjc6-xrdh7   Ready    <none>          8m42s   v1.36.5   10.0.0.155    <none>        Flatcar Container Linux by Kinvolk 4593.2.4 (Oklo)   6.12.95-flatcar (amd64)   containerd://2.3.5
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
