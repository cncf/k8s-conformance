# Catalyst Cloud Kubernetes Service Conformance


## Create Kubernetes Cluster

Log in to the Catalyst Cloud dashboard to create a Kubernetes cluster or use the OpenStack command line interface to create the cluster.

```shell
openstack coe cluster create my-cluster --cluster-template kubernetes-prod
```

After the cluster is created, run the following command to obtain the configuration files required to interact with it using `kubectl`:

```shell
eval $(openstack coe cluster config <CLUSTER_ID>)
```

## Testing			

Once the configuration files have been created, you should be able to run `kubectl` to interact with the APIs of the Kubernetes cluster. Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.
