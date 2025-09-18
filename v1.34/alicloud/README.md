# How to Reproduce

## Create a managed Kubernetes cluster

### Step 1: Activate and grant permissions to ACK
If this is the first time you use ACK, you must activate ACK and grant ACK the permissions to access cloud resources.
1. Go to the [Container Service for Kubernetes](https://common-buy-intl.alibabacloud.com/?spm=a2c63.p38356.0.0.2c55a81fNJeQ3d&commodityCode=csk_propayasgo_public_intl) page.
2. Read and select **Container Service for Kubernetes Terms of Service**, and then click **Activate Now**.
3. Log on to the [ACK console](https://cs.console.aliyun.com/?spm=a2c63.p38356.0.0.2c55a81fNJeQ3d).
4. On the **Container service needs to create default roles** page, click **Go to RAM console**. On the [Cloud Resource Access Authorization](https://ram.console.aliyun.com/?spm=a2c63.p38356.0.0.2c55a81fNJeQ3d#/role/authorize?request=%7B%22ReturnUrl%22:%22https:%2F%2Fcs.console.aliyun.com%2F%22,%22Service%22:%22CS%22,%22Requests%22:%7B%22request1%22:%7B%22RoleName%22:%22AliyunCSManagedLogRole%22,%22TemplateId%22:%22AliyunCSManagedLogRole%22%7D,%22request2%22:%7B%22RoleName%22:%22AliyunCSManagedCmsRole%22,%22TemplateId%22:%22AliyunCSManagedCmsRole%22%7D,%22request3%22:%7B%22RoleName%22:%22AliyunCSManagedCsiRole%22,%22TemplateId%22:%22AliyunCSManagedCsiRole%22%7D,%22request4%22:%7B%22RoleName%22:%22AliyunCSManagedVKRole%22,%22TemplateId%22:%22AliyunCSManagedVKRole%22%7D,%22request5%22:%7B%22RoleName%22:%22AliyunCSClusterRole%22,%22TemplateId%22:%22Cluster%22%7D,%22request6%22:%7B%22RoleName%22:%22AliyunCSServerlessKubernetesRole%22,%22TemplateId%22:%22ServerlessKubernetes%22%7D,%22request7%22:%7B%22RoleName%22:%22AliyunCSKubernetesAuditRole%22,%22TemplateId%22:%22KubernetesAudit%22%7D,%22request8%22:%7B%22RoleName%22:%22AliyunCSManagedNetworkRole%22,%22TemplateId%22:%22AliyunCSManagedNetworkRole%22%7D,%22request9%22:%7B%22RoleName%22:%22AliyunCSDefaultRole%22,%22TemplateId%22:%22Default%22%7D,%22request10%22:%7B%22RoleName%22:%22AliyunCSManagedKubernetesRole%22,%22TemplateId%22:%22ManagedKubernetes%22%7D,%22request11%22:%7B%22RoleName%22:%22AliyunCSManagedArmsRole%22,%22TemplateId%22:%22AliyunCSManagedArmsRole%22%7D%7D%7D) page, click **Confirm Authorization Policy**. After you assign the Resource Access Management (RAM) roles to ACK, log on to the ACK console again to get started with ACK. If you have other problems during the authorization process, see [FAQ about authorization management](https://www.alibabacloud.com/help/en/ack/ack-managed-and-ack-dedicated/user-guide/faq-about-authorization-management).

### Step 2: Create an ACK Pro cluster
This step shows how to create an ACK Pro cluster. Default settings are used for most cluster parameters. For more information about the cluster parameters, see [Create an ACK Pro cluster](https://www.alibabacloud.com/help/en/ack/ack-managed-and-ack-dedicated/user-guide/create-an-ack-managed-cluster-2#task-skz-qwk-qfb).
1. Log on to the [ACK console](https://cs.console.aliyun.com/?spm=a2c63.p38356.0.0.2c55a81fNJeQ3d). In the left-side navigation pane, click **Clusters**.
2. In the upper-right corner of the **Clusters** page, click **Create Kubernetes Cluster**.
3. On the **Managed Kubernetes** tab, set cluster parameters as described in the following table. Use default settings for the parameters that are not included in the table.

| **Parameter**  | **Description**  | **Example**      |
|---|---|------------------|
| **Cluster Name**  | Enter a name for the cluster.  | ACK-Demo         |
| **Cluster Specification**  | Select a cluster type. You can select **Professional** or **Basic**. We recommend that you use ACK Pro clusters in the production environment and test environment. ACK Basic clusters can meet the learning and testing needs of individual users. For more information about ACK Pro clusters, see [Overview of ACK Pro clusters](https://www.alibabacloud.com/help/en/ack/ack-managed-and-ack-dedicated/user-guide/overview-of-ack-pro-clusters#concept-2558837).| Professional     |
| **Region**  | Select a region to deploy the cluster.  | China (Hongkong) |
| **VPC**  | ACK clusters can be deployed only in virtual private clouds (VPCs). You must specify a VPC in the same region as the cluster. In this example, click **Create VPC** and create a VPC named vpc-ack-demo in the China (Beijing) region. For more information, see [Create and manage a VPC](https://www.alibabacloud.com/help/en/vpc/user-guide/create-and-manage-a-vpc#task-1012575).| vpc-ack-demo |
| **vSwitch**  | Select vSwitches for nodes in the cluster to communicate with each other. In this example, click **Create vSwitch** and create a vSwitch named vswitch-ack-demo in the vpc-ack-demo VPC. Then, select vswitch-ack-demo in the vSwitch list. For more information, see [Create and manage a vSwitch](https://www.alibabacloud.com/help/en/vpc/user-guide/create-and-manage-vswitch#task-1012575).| vswitch-ack-demo |
| **Access to API Server**  | Specify whether to expose the Kubernetes API server of the cluster to the Internet. If you want to manage the cluster over the Internet, you must expose the Kubernetes API server with an elastic IP address (EIP).  | In this example, **Expose API Server with EIP** is selected. |
4. Click **Next:Node Pool Configurations**. Configure the following parameters as described. Use default settings for the parameters that are not included in the table.

| **Parameter**  | **Description**  | **Example**  |
|---|---|---|
| **Instance Type**  | Select instance types that are used to deploy nodes. You can specify the number of vCores and the amount of memory to filter the instance types. You can also specify an instance type in the search box to search for the instance type. To ensure the stability of the cluster, we recommend that you select instance types with at least 4 vCores and 8 GiB of memory. For more information about Elastic Compute Service (ECS) instance types and how to select instance types, see [Suggestions on choosing ECS specifications for ACK clusters](https://www.alibabacloud.com/help/en/ecs/user-guide/overview-of-instance-families#concept-sx4-lxv-tdb) and [Overview of instance families](https://www.alibabacloud.com/help/en/ack/ack-managed-and-ack-dedicated/user-guide/select-ecs-instances-to-create-the-master-and-worker-nodes-of-an-ack-cluster#concept-yww-f2t-zfb).| Instance types with at least 4 vCores and 8 GiB of memory  |
| **Quantity**  | Specify the number of worker nodes.  | 2  |
| **System Disk**  | Set the system disk for nodes.  | In this example, enhanced SSD (ESSD) is selected as the disk type and the disk size is set to 40 GiB.  |
| **Logon Type**  | Select the logon type for nodes.  | In this example, password logon is selected as the logon type and a password is specified.  |

5. Click **Next:Component Configurations**. Use default settings for all component parameters.

6. Click **Next:Confirm Order**, read and select the ACK terms of service, and then click Create Cluster.

**Note**  
It requires approximately 10 minutes to create a cluster. After the cluster is created, you can view the cluster on the Clusters page.  
You can [obtain the kubeconfig file of the cluster and use kubectl to connect to the cluster](https://www.alibabacloud.com/help/en/ack/ack-managed-and-ack-dedicated/user-guide/obtain-the-kubeconfig-file-of-a-cluster-and-use-kubectl-to-connect-to-the-cluster#task-ubf-lhg-vdb), and run the kubectl get node command to view the node information of the cluster.
## Deploy sonobuoy Conformance test

Once the configuration files have been created, you should be able to run `kubectl` to interact with the APIs of the Kubernetes cluster. Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.
