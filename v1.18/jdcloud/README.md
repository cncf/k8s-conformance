## To reproduce:

#### Create Kubernetes Cluster

- Login to [JDCloud Console](https://console.jdcloud.com/) 
- Go to [Elastic Compute]-[JCS for Kubernetes] and create a Kubernetes cluster, please visit document [How to create a cluster](https://docs.jdcloud.com/cn/jcs-for-kubernetes/create-to-cluster) for more details
- Please make sure a VPN is configured appropriately because of the cluster can't visit images of gcr.io in China mainland without VPN

#### Run Conformance Test

- Go to the cluster's detail information page to get the kubeconfig and save it as local ```~/.kube/config``` file
- Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to test it

#### Steps to deploy a cluster

# Create Cluster

## Confirm region and instance configuration
**Confirm the region of the Instance**

The complete isolation between different regions of JD Cloud ensures the greatest degree of stability and fault tolerance across different regions. It currently covers four regions: cn-north-1, cn-south-1, cn-east-1 and cn-east-2. At present, Kubernetes Service is opened in cn-north-1, cn-south-1, cn-east-2. In the future, we will gradually increase more service areas to meet your business needs.

When choosing a region, you had better consider the following points:

 - The deployment relationship between clusters and other JD Cloud products. 
 - Cloud products from different regions are not allowed to communicate through intranet by default.
 Cluster by default is not allowed to communicate Cross-region, and can not access cloud databases and cloud caches across regions
   When the VM instance associates EIP and the security group, it can only associate EIP and security groups in the same area; when the virtual machine instance associates the disk, it can only associate the disk in the same availability zone      
 - The above-mentioned intranet interconnection refers to the interconnection of resources under the same account, and the intranet of resources under different accounts is completely isolated.

**Select VM instance configuration**

It is recommended that you use pay by configuration billing instances for performance testing to find instance type and other resource configurations that match your business volume before deploying the business formally. It only supports the second generation of instance type, and can be referred to instance specification types.

## Create Cluster

 1. Open the console and select Elastic Compute>>JCS for Kubernetes>>cluster service>>cluster
 ![](https://github.com/jdcloudcom/cn/blob/edit/image/Elastic-Compute/JCS-for-Kubernetes/新建Kubernetes集群集群信息.png)  
 2. Choose the creation region, click the “Create” button, it is suggested that you choose the cluster location and available area according to the business situation; by default, it is recommended that you select all available areas under the specified area in the default mode; you can also cancel an availability zone that has been selected and ensure that at least one available area is selected.
 3. Set the name and description: Name should not be null, which only supports Chinese text, figures, uppercase and lowercase letters, English text, underline “ _ ” and line-through “ - ”, with a length no more than 32 characters; description is an optional item, with a length no more than 256 characters.
 4. Cluster version: Currently, it only supports 1.8.12 version.
 5. Management node CIDR: It can not be overlapped with CIDR of other VPCs, and the CIDR mask range is 24~27. You can refer to the rules of VPC CIDR for rules of CIDR settings.
 6. Client Certificate and Basic Authentication: By default, they are all open and it is recommended that they should be reserved; at least one should be reserved as open; Client Certificate: Certificate based on base64 encoding is used for authentication from client to cluster service endpoint; Basic Authentication: After opening, the client is allowed to use the user name and password to be authenticated at the cluster service endpoint.
 7. Add Accesskey: Select AccessKey at startup; if no Access Key is available, go to the Access Key management page to create a new Access Key and start it. Refer to Accesskey management.
New working node group:
 ![](https://github.com/jdcloudcom/cn/blob/edit/image/Elastic-Compute/JCS-for-Kubernetes/新建Kubernetes集群工作节点组.png)   
8. VPC: Select the VPC to create. It is recommended to create Virtual Private Cloud; the mask value range shall be 16~18.  
9. Working node CIDR: For setting rules, you can refer to the rules of VPC subnet CIDR, and the CIDR mask range is 16~18.
10. Image: It only supports JD Cloud customized image.
11. Specification: According to the specific business conditions, select different types and specifications of VM that support the specifications of the second generation VM. It is acceptable to refer to the instance specifications and types.
12. Quantity: The default number is 3, and you can click to increase or decrease or input the number as required. The maximum number is the minimum number of hosts that can be created in Node CIDR and the Virtual Machine quota.
13. Name: The default name is nodegroup1, which cannot be empty and supports only Chinese text, numbers, uppercase and lowercase letters, English text with underline “_” and hyphen “-”, and should not exceed 32 characters. Working node groups under the same cluster cannot be in an identical name.
14. The following are advanced options that do not necessarily need to be filled in
Description: Description should consist of no more than 256 characters
System disk: The default capacity of the local disk is 100G, which can not be modified.
Tags: Set tags to work nodes; the key is composed of prefix and name. The prefix does not exceed 253 characters, and the name and value do not exceed 63 characters; the prefix is made up of DNS subdomains, and the key values must start with letters and numbers, supporting “-”“ _ ”“. ”, uppercase letters, lowercase letters and numbers; up to 5 sets of tags.
15. After completing the relevant settings, click OK to enter Elastic Compute>>JCS for Kubernetes>>Cluster Services>>Cluster and view the created JCS for Kubernetes. It usually takes a few minutes to create, and please be patient.
