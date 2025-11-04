## To reproduce:

#### Create Kubernetes Cluster

- Login to [JDCloud Console](https://console.jdcloud.com/)
- Go to [Elastic Compute]-[JCS for Kubernetes] and create a Kubernetes cluster, please visit document [How to create a cluster](https://docs.jdcloud.com/cn/jcs-for-kubernetes/create-to-cluster) for more details
- Please make sure a VPN is configured appropriately because of the cluster can't visit images of gcr.io in China mainland without VPN

#### Run Conformance Test

- Go to the cluster's detail information page to get the kubeconfig and save it as local ```~/.kube/config``` file
- Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to test it

#### Steps to deploy a cluster

1. Login to [JDCloud Console](https://console.jdcloud.com/)
1. Open the console and select Elastic Compute>>JCS for Kubernetes>>cluster service>>cluster
1. Select a region and availability zone: It is recommended that you should select the region and availability zone where the cluster is located according to specific business conditions; by default, all availability zones under the specified region are selected and it is recommended to use the default mode; you can also cancel any one or more selected availability zones, but you shall ensure at least one availability zone is selected.
1. Set the name and description: Name should not be null, which only supports Chinese text, figures, uppercase and lowercase letters, English text, underline " _ " and line-through " - ", with a length no more than 32 characters; description is an optional item, with a length no more than 256 characters.
1. Choose a kubernetes release version
1. Manage node CIDR: It cannot be overlapped with CIDR of other VPC, and the value range of CIDR mask is 24 ~ 27. For setting rules of CIDR, please refer to the Help Documentation of [VPC Configuration](https://docs.jdcloud.com/en/virtual-private-cloud/vpc-configuration).
1. Add Accesskey: Select the started Accesskey; if the Access Key is unavailable, please go to the Access Key management page, crate a new Access Key and keep it in starting status. You can refer to [Accesskey Management](https://docs.jdcloud.com/en/account-management/accesskey-management)
1. After completing relevant settings, click OK to enter Elastic Compute>>JCS for Kubernetes>>Cluster Service>>cluster and view the created JCS for Kubernetes.
