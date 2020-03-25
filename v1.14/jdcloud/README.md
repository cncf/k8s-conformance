## To reproduce:

#### Create Kubernetes Cluster

- Login to [JDCloud Console](https://console.jdcloud.com/) 
- Go to [Elastic Compute]-[JCS for Kubernetes] and create a Kubernetes cluster, please visit document [How to create a cluster](https://docs.jdcloud.com/cn/jcs-for-kubernetes/create-to-cluster) for more details
- Please make sure a VPN is configured appropriately because of the cluster can't visit images of gcr.io in China mainland without VPN

#### Run Conformance Test

- Go to the cluster's detail information page to get the kubeconfig and save it as local ```~/.kube/config``` file
- Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to test it
