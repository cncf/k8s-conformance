# OpenStack Magnum (Kubernetes) Conformance

## Create Kubernetes Cluster

Setup an OpenStack environment with devstack at stable/yoga branch. Then create your personal keypair by command:

	openstack keypair create my-key --public-key ~/.ssh/id_rsa.pub

Now you can create a Kubernetes cluster template by command:

	openstack coe cluster template create k8s --master-lb-enabled --network-driver calico --flavor ds4G --master-flavor ds4G --coe kubernetes --external-network public --image fedora-coreos-35.20220116.3.0-openstack.x86_64

Then you can create a Kubernetes cluster by below command:

	openstack coe cluster create k8s-calico-coreos --cluster-template k8s v1.24.1-rancher1 --label container_runtime=containerd --node-count=2 --master-count 2

After the cluster is created, run the following command to obtain the configuration/certificate files:

	eval $(openstack coe cluster config k8s-calico-coreos)

## Conformance Test

Install Sonobuoy:

	VERSION=0.56.8 && \
		curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_linux_amd64.tar.gz" --output sonobuoy.tar.gz && \
		mkdir -p tmp && \
		tar -xzf sonobuoy.tar.gz -C tmp/ && \
		chmod +x tmp/sonobuoy && \
		sudo mv tmp/sonobuoy /usr/local/bin/sonobuoy && \
		rm -rf sonobuoy.tar.gz tmp

Now run the test:

	sonobuoy run --mode=certified-conformance

Check status:

	sonobuoy logs

Follow logs:

	sonobuoy logs -f | grep PASSED

Retrieve results:

	outfile=$(sonobuoy retrieve); mkdir ./results; tar xzf $outfile -C ./results; cp results/plugins/e2e/results/global/* ./

Cleaning up:

	sonobuoy delete --all; rm -rf results/ *.tar.gz

## Testing

Once the configuration has been created, then you can follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance test.
