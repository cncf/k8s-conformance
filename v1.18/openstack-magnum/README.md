# OpenStack Magnum (Kubernetes) Conformance

## Create Kubernetes Cluster

Setup an OpenStack environment with devstack at master branch. Then create your personal keypair by command:

	openstack keypair create my-key --public-key ~/.ssh/id_rsa.pub

Now you can create a Kubernetes cluster template by command:

	openstack coe cluster template create k8s --network-driver calico --flavor ds4G --master-flavor ds4G --coe kubernetes --external-network public --image fedora-coreos-31.20200310.3.0-openstack.x86_64

Then you can create a Kubernetes cluster by below command:

	openstack coe cluster create k8s-calico-coreos --cluster-template k8s --labels=kube_tag=v1.18.1

After the cluster is created, run the following command to obtain the configuration/certificate files:

	eval $(openstack coe cluster config k8s-calico-coreos)

## Testing      

Once the configuration has been created, then you can follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance test.
