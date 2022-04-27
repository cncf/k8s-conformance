# OpenStack Magnum (Kubernetes) Conformance


## Create Kubernetes Cluster

Setup an OpenStack environment with devstack at stable/rocky branch. Then create your personal keypair by command:

```shell
openstack keypair create my-key --public-key ~/.ssh/id_rsa.pub
```

Now you can create a Kubernetes cluster template by command:

```shell
openstack coe cluster template create k8s --keypair my-key --flavor ds1G --master-flavor ds1G --coe kubernetes --external-network public --docker-volume-size 5 --image $( openstack image show "Fedora-Atomic-27-20180212.2.x86_64" -f value -c id )
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
