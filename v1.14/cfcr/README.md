# Cloud Foundry Container Runtime (CFCR)

 Cloud Foundry Container Runtime (CFCR) utilizes [BOSH](http://bosh.io/) to deploy and manage your Kubernetes cluster.

 A Kubernetes cluster can be deployed to your choice of IaaS. Please follow the guide [here](https://github.com/cloudfoundry-incubator/kubo-release#deploying-cfcr) to install it on GCP, AWS, Azure, vSphere or OpenStack.

 ## Running the k8s conformance tests

 Set your kubectl to point your CLI to the deployed kubernetes cluster. See the instructions [here](https://github.com/cloudfoundry-incubator/kubo-release#accessing-the-cfcr-cluster-with-kubectl) for steps to access your cluster.

 You can then follow [the instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance suite.
