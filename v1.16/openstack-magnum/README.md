# OpenStack Magnum (Kubernetes) Conformance


## Create Kubernetes Cluster

Setup an OpenStack environment with devstack at stable/rocky branch. Then create your personal keypair by command:

```shell
openstack keypair create my-key --public-key ~/.ssh/id_rsa.pub
```

Now you can create a Kubernetes cluster template by command:

```shell
openstack coe cluster template create k8s --keypair my-key --network-driver calico --flavor ds1G --master-flavor ds2G --coe kubernetes --external-network public --image $( openstack image show "Fedora-CoreOS.x86_64" -f value -c id ) --labels kube_tag=v1.16.8,use_podman=True,etcd_tag=3.3.17
```

Then you can create a Kubernetes cluster by below command:


```shell
openstack coe cluster create k8s-cluster --cluster-template k8s
```

After the cluster is created, run the following command to obtain the configuration/certificate files:

```shell
eval $(openstack coe cluster config <CLUSTER_ID>)
```

## Testing      

Once the configuration has been created, then you can follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance test.
