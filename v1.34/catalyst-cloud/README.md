# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to Catalyst Cloud's dashboard to create a Kubernetes cluster or use the OpenStack command line interface.

```shell
$ openstack coe cluster create conformancev134 --cluster-template kubernetes-v1.34.1 --master-count 3 --node-count 3
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
$ openstack coe cluster config conformance134

$ export KUBECONFIG=./config

$ kubectl get nodes -o wide
NAME                                                     STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                             KERNEL-VERSION    CONTAINER-RUNTIME
conformance134-gfaljgcgqhcx-control-plane-jgkjz          Ready    control-plane   8h    v1.34.1   10.0.0.174    <none>        Flatcar Container Linux by Kinvolk 4230.2.4 (Oklo)   6.6.110-flatcar   containerd://1.7.26
conformance134-gfaljgcgqhcx-control-plane-vrpb8          Ready    control-plane   8h    v1.34.1   10.0.0.130    <none>        Flatcar Container Linux by Kinvolk 4230.2.4 (Oklo)   6.6.110-flatcar   containerd://1.7.26
conformance134-gfaljgcgqhcx-control-plane-x4kbd          Ready    control-plane   8h    v1.34.1   10.0.0.216    <none>        Flatcar Container Linux by Kinvolk 4230.2.4 (Oklo)   6.6.110-flatcar   containerd://1.7.26
conformance134-gfaljgcgqhcx-default-worker-vcrtf-h29xh   Ready    <none>          8h    v1.34.1   10.0.0.140    <none>        Flatcar Container Linux by Kinvolk 4230.2.4 (Oklo)   6.6.110-flatcar   containerd://1.7.26
conformance134-gfaljgcgqhcx-default-worker-vcrtf-t4fgx   Ready    <none>          8h    v1.34.1   10.0.0.11     <none>        Flatcar Container Linux by Kinvolk 4230.2.4 (Oklo)   6.6.110-flatcar   containerd://1.7.26
conformance134-gfaljgcgqhcx-default-worker-vcrtf-xqbwx   Ready    <none>          8h    v1.34.1   10.0.0.18     <none>        Flatcar Container Linux by Kinvolk 4230.2.4 (Oklo)   6.6.110-flatcar   containerd://1.7.26
```

## Testing

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

```shell
sonobuoy run --mode=certified-conformance
```
