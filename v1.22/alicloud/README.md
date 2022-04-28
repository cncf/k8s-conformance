# How to Reproduce

## Create a managed Kubernetes cluster

### Prerequisites

---------

ACK, Elastic Scaling Service (ESS), and Resource Access Management
(RAM) are activated.

Log on to the [ACK console](https://cs.console.aliyun.com/), [RAM console](https://ram.console.aliyun.com/), and [ESS console](https://essnew.console.aliyun.com) to activate these services.

**Note**

When you create a Kubernetes cluster, we recommend that you
follow these rules:

* Your account balance must be no less than CNY 100 and you must complete the real-name verification. Otherwise, you cannot create pay-as-you-go Elastic Compute Service (ECS) or Server Load Balancer (SLB) instances.

* SLB instances created along with the cluster support only the pay-as-you-go billing method.

* Kubernetes clusters support only VPC networks.

* By default, each account has specific quotas on the amount of cloud resources that can be created. You cannot create clusters if the quota limit has been exceeded. Make sure that you have sufficient quotas before you create a cluster. To request a quota increase, [submit a ticket](https://selfservice.console.aliyun.com/ticket/scene/ecs/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%20ECS/detail).
  * You can create up to 50 clusters across all regions for each account. A cluster can contain up to 100 nodes. To create more clusters or nodes, submit a ticket.
    **Note** In a Kubernetes cluster, you can create up to 48 route entries for the VPC network where the cluster is deployed. To increase the maximum number of route entries that you can create, submit a ticket.
  * You can create up to 100 security groups for each account.
  
  * You can create up to 60 pay-as-you-go SLB instances for each account.
  
  * You can create up to 20 Elastic IP addresses (EIPs) for each account.

### Procedure

---------

1. Log on to the [Container Service console](https://cs.console.aliyun.com).

2. In the left-side navigation pane, choose **Clusters** . The **Clusters** page appears.

3. Click **Create Kubernetes Cluster** in the upper-right corner of the page. In the **Select Cluster Template** dialog box
   that appears, click **Create** on the
   **Standard Managed Cluster** card. The
   **ACK managed edition** tab appears.

4. Configure the cluster.

   1. Configure basic settings.

      |         Parameter         |  Description   |
      |---------------------------|----------------|
      | **Cluster Name**          | Enter the name of the cluster. **Note** The name must be 1 to 63 characters in length, and can contain digits, Chinese characters, letters, and hyphens (-).     |
      | **Kubernetes Version**    | Select the Kubernetes version.      |
      | **Container Runtime**     | Kubernetes of the 1.14.8-aliyun.1 version supports both Docker containers and sandboxed containers. Kubernetes of the 1.12.6-aliyun.1 version supports only Docker containers.    |
      | **Region**                | Select the region where the cluster is located.     |
      | **Resource Group**        | Place the pointer over **Account's all Resources** at the top of the page and select the resource group to which the cluster belongs. The name of the selected resource group appears in the Resource Group field.    |
      | **VPC**                   | Set the Virtual Private Cloud (VPC) network of the cluster. **Note** Kubernetes clusters support only VPC networks. You can select a VPC network from the drop-down list. If no VPC network is available, you can click **Create VPC** to create one. For more information, see [Create a VPC](t2435.html#task-1012575).           |
      | **VSwitch**               | Set the VSwitch. Select one to three VSwitches. We recommend that you select VSwitches in different **zones** . If no VSwitch is available, click **Create VSwitch** to create one. For more information, see [Create a VSwitch](t2436.html#concept-smn-zdx-rdb).            |
      | **Network Plug-in**       | Select a network plug-in. Flannel and Terway are available. For more information, see [Flannel and Terway](t64408.html#task-1797447/section-k1z-f1n-lmh). *Flannel: a simple and stable Container Network Interface (CNI) plug-in developed by the Kubernetes community. Flannel offers a few simple features and does not support standard Kubernetes network policies.* Terway: a network plug-in developed by Alibaba Cloud Container Service. Terway allows you to assign Alibaba Cloud Elastic Network Interfaces (ENIs) to containers. It also allows you to customize network policies of Kubernetes to control intercommunication among containers, and implement bandwidth throttling on individual containers. **Note** The number of pods supported by a node depends on the number of ENIs that are attached to the node and the number of secondary IP addresses provided by these ENIs.    |
      | **Pod CIDR Block**        | If you set Network Plug-in to **Flannel** , the **Pod CIDR Block** parameter is available. The CIDR block specified by **Pod CIDR Block** cannot overlap with the CIDR blocks that are used by the VPC network or existing clusters in the VPC network. After you create the cluster, you cannot modify the pod CIDR block. In addition, the service CIDR block cannot overlap with the pod CIDR block. For more information, see [Plan Kubernetes CIDR blocks under a VPC](t16651.html#concept-izq-sg4-vdb).           |
      | **Terway Mode**           | If you set Network Plug-in to **Terway** , the **Terway Mode** parameter is available. When you set **Terway Mode** , you can select or clear **Assign One ENI to Each Pod** .  *If you select this check box, an ENI will be assigned to each pod.* If you clear this check box, an ENI will be shared among multiple pods. A secondary IP address of the ENI will be assigned to each pod.   **Note** This feature is only available to users in the whitelist. If you are not in the whitelist, [submit a ticket](https://selfservice.console.aliyun.com/ticket/scene/ecs/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%20ECS/detail).      |
      | **Service CIDR**          | Set the **Service CIDR** parameter. The CIDR block specified by **Service CIDR** cannot overlap with the CIDR blocks that are used by the VPC network or existing clusters in the VPC network. After you create the cluster, you cannot modify the service CIDR block. In addition, the service CIDR block cannot overlap with the pod CIDR block. For more information, see [Plan Kubernetes CIDR blocks under a VPC](t16651.html#concept-izq-sg4-vdb).    |
      | **IP Addresses per Node** | If you set Network Plug-in to **Flannel** , you must set **IP Addresses per Node** . **Note** **IP Addresses per Node** specifies the maximum number of IP addresses that can be assigned to each node. We recommend that you use the default value.      |
      | **Configure SNAT**        | Specify whether to configure source network address translation (SNAT) rules for the VPC network. *If the specified VPC network has a network address translation (NAT) gateway, Container Service uses this NAT gateway.* Otherwise, the system automatically creates a NAT gateway. If you do not want the system to create a NAT gateway, clear **Configure SNAT for VPC** . In this case, you must manually create a NAT gateway and configure SNAT rules to enable Internet access to the VPC network. Otherwise, the cluster cannot be created.      |
      | **Public Access**         | Select or clear **Expose API Server with EIP** . The Kubernetes API server provides multiple HTTP-based RESTful APIs, which can be used to create, modify, query, watch, or delete resource objects such as pods and services.  *If you select this check box, an Elastic IP address (EIP) is created and bound to the internal SLB instance. Port 6443 used by the API Server is opened on master nodes. You can connect to and manage the cluster by using kubeconfig over the Internet.* If you clear this check box, no EIP is created. You can only connect to and manage the cluster by using kubeconfig within the VPC network.    |
      | **RDS Whitelist**         | Set the Relational Database Service (RDS) whitelist. Add the IP addresses of cluster nodes to the RDS whitelist.           |
      | **Custom Security Group** | Set the security group. Click **Select a security group** . In the dialog box that appears, select a security group and click **OK** . For more information, see [Security group overview](t9569.html#concept-o2y-mqw-ydb).  **Note** This feature is only available to users in the whitelist. If you are not in the whitelist, [submit a ticket](https://selfservice.console.aliyun.com/ticket/scene/ecs/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%20ECS/detail).          |

   2. Configure advanced settings.

      |                  Parameter                  |      Description  |
      |---------------------------------------------|-------------------|
      | **Kube-proxy Mode**                         | The iptables and IPVS modes are supported. *iptables is a mature and stable service that uses iptables rules to configure service discovery and load balancing. This mode provides average performance and is closely dependent on the cluster size. This mode is suitable for clusters that run a small number of services.* IPVS provides high performance and uses IP Virtual Server (IPVS) to configure service discovery and load balancing. This mode is suitable for clusters that run a large number of services. We recommend that you use this mode in scenarios where high load balancing performance is required.          |
      | **Labels**                                  | Attach labels to the cluster. Enter the key and value, and click **Add** .  **Note** The key field is required and the *value* field is optional  Keys are not case-sensitive. A key must be be 1 to 64 characters in length. It cannot start with aliyun, http://, and https://. *Values* are not case-sensitive. A value must be 0 to 128 characters in length. It cannot start with http:// or https://. *The keys of labels attached to the same resource must be unique. If you add a label with a used key, the label overwrites the one that uses the same key.* You can attach up to 20 labels to each resource. If you attach more than 20 labels to a resource, all labels become invalid. You must detach unused labels for the remainings to take effect.   |
      | **Cluster Domain**                          | Set the cluster domain. **Note** The default cluster domain is **cluster.local** . Custom domains are supported. A domain consists of two parts. Each part must be 1 to 63 characters in length and contain only lowercase and uppercase letters, and digits.    |
      | **Service Account Token Volume Projection** | [Deploy service account token volume projection](https://www.alibabacloud.com/help/doc-detail/160384.htm#task-2460323)         |
      | **Deletion Protection**                     | Specify whether to enable Deletion Protection. If you select this check box, the cluster cannot be deleted in the console or through API operations. This avoids user errors.      |

5. Click **Next: Worker Configuration** to configure worker nodes.

   1. Select worker instances.

      * If you select **Create Instance** , you must set the parameters listed in the following table. 

        |      Parameter       |     Description    |
        |----------------------|--------------------|
        | **Billing Method**   | Two billing methods are supported: **Pay-As-You-Go** and **Subscription** .     |
        | **Duration**         | If you select **Subscription** , you must set the duration of the subscription. Valid values: 1 Month, 2 Months, 3 Months, 6 Months, 1 Year, 2 Years, 3 Years, 4 Years, and 5 Years.     |
        | **Auto Renewal**     | If you select **Subscription** , you must check whether to enable **Auto Renewal** .  |
        | **Instance Type**    | You can select multiple instance types. For more information, see [Instance families](t9548.html#concept-sx4-lxv-tdb).     |
        | **Selected Types**   | The specified instance types appear here.    |
        | **Quantity**         | Set the number of worker nodes.      |
        | **System Disk**      | The **SSD Disk** and **Ultra Disk** options are available. **Note**            |
        | **Mount Data Disk**  | The **SSD Disk** and **Ultra Disk** options are available. **Note**      |
        | **Operating System** | The CentOS and Windows Server operating systems are supported.           |
        | **Logon Type**       | *Key Pair:* If no key pair is available, you can click **create a key pair** to create one in the ECS console. For more information, see [Create an SSH key pair](t9728.html#concept-wy4-th1-ydb). After the key pair is created, set it as the credentials to log on to the cluster.    *Password:* **Password** : Set the logon password. **Confirm Password** : Enter the logon password again.      |
        | **Key Pair**         | *Key Pair:* If no key pair is available, you can click **create a key pair** to create one in the ECS console. For more information, see [Create an SSH key pair](t9728.html#concept-wy4-th1-ydb). After the key pair is created, set it as the credentials to log on to the cluster.    *Password:* **Password** : Set the logon password. **Confirm Password** : Enter the logon password again.      |

      * If you select **Add Existing Instance** , you must select ECS instances that are deployed in the specified region. Then, you must set **Operating System** , **Logon Type** , and **Key Pair** .

   2. Configure advanced settings.

      |      Parameter       |                  Description          |
      |----------------------|---------------------------------------|
      | **Node Protection**  | Specify whether to enable Node Protection. **Note** This check box is selected by default. Cluster nodes cannot be deleted in the console or through API operations. This avoids user errors.   |
      | **User Data**        | For more information, see [Prepare user data](t9660.html#concept-fgf-tjn-xdb). |
      | **Custom Image**     | You can select a custom image to deploy all nodes in the cluster. For more information about how to create a custom image, see [Create a cluster by using a custom image](t1240299.html#task-1563283). **Note** This feature is only available to users in the whitelist. If you are not in the whitelist, [submit a ticket](https://selfservice.console.aliyun.com/ticket/scene/ecs/%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%20ECS/detail).  |
      | **Custom Node Name** | Specify whether to enable **Custom Node Name** . A node name consists of a prefix, an IP substring length, and a suffix.  *Both the prefix and suffix can contain one or more parts that are separated with periods ( **.** ). Each part can contain lowercase letters, digits, and hyphens ( **-** ), and must start and end with a lowercase letter or digit.* The IP substring length specifies the number of digits at the end of the returned node IP address. Valid values: 5 to 12.   For example, if the node IP address is 192.168.0.55, the prefix is aliyun.com, the IP substring length is 5, and the suffix is test, the node name will be aliyun.com00055test. |
      | **CPU Policy**       | Set the CPU policy. *none: This is the default policy, which specifies that the CPU affinity policy is used.* static: This policy allows pods with certain resource characteristics to be granted with enhanced CPU affinity and exclusivity on the node.              |
      | **Taints**       | Add taints to worker nodes in the cluster.

6. Click **Next: Component Configuration** to configure components.

   |       Parameter       |          Description             |
   |-----------------------|----------------------------------|
   | **Ingress**           | Specify whether to install Ingress controllers. By default, **Install Ingress Controllers** is selected. For more information, see [Support for Ingress](t16679.html#concept-zny-hrs-vdb). **Note** If you select **Create Ingress Dashboard** , you must enable Log Service.                                     |
   | **Volume Plug-in**    | The Flexvolume and CSI options are available. Kubernetes clusters can bind with Alibaba Cloud disks, Network Attached Storage (NAS) file systems, and Object Storage Service (OSS) buckets through pods. For more information, see [Storage management - Flexvolume](t15788.html#concept-vgg-45s-vdb) and [Storage management - CSI](t1591754.html#concept-2005339).                 |
   | **Monitoring Agents** | Specify whether to install one or more monitoring agents. You can install the CloudMonitor agent on ECS nodes. This allows you to view the monitoring information about these nodes in the CloudMonitor console. |
   | **Log Service**       | Specify whether to enable Log Service. You can select an existing project or create a new project. If you select **Enable Log Service** , the Log Service plug-in is automatically installed in the cluster. When you create an application, you can get started with Log Service through a few simple steps. For more information, see [Use Log Service to collect Kubernetes cluster logs](t17400.html#concept-nsj-sxm-t2b). |
   | **Workflow Engine**   | Specify whether to use AGS. *If you select this check box, the system automatically installs the AGS workflow plug-in when it creates the cluster.* If you clear this check box, you must manually install the AGS workflow plug-in. For more information, see [Introduction to AGS CLI](t422672.html#concept-525487). |
   | **Optional Add-ons**  | In addition to system components, you can install other components provided by Container Service for Kubernetes.

7. Click **Next: Confirm Order** .

8. Select Terms of Service and click **Create Cluster** .
   **Note** It takes approximately 10 minutes for the system to create a Kubernetes cluster that consists of multiple nodes.

### Result

---------

* After the cluster is created, you can find the cluster on the **Clusters** page in the console.

* Click **View Logs** in the Actions column for the cluster. On the **Log Information** page that appears, you can view cluster
  logs. To view more log information, click **Stack events** .

* On the **Clusters** page, find the new cluster and click **Manage** in the Actions column for the cluster. On the
  page that appears, you can view basic information about the cluster.

  The cluster information includes:

  * **API Server Public Endpoint** : the IP address and port that the Kubernetes API server uses to provide services over the Internet. It allows you to manage the cluster by using kubectl or other tools on the client.

    **Bind EIP** and **Unbind EIP** : These options are only available to
    managed Kubernetes clusters.
    * Bind EIP: You can select an existing EIP or create an EIP. The API server will restart when you bind an EIP
      to this API server. We recommend that you do not manage the cluster during the process.

    * Unbind EIP: You cannot access the API server over the Internet after you unbind the EIP from the API server.
      The API server will restart when you unbind an EIP from this API server. We recommend that you do
      not manage the cluster during the process.

  * **API Server Internal Endpoint** : the IP address and port that the Kubernetes API server uses to provide services within the cluster. The IP address belongs to the SLB instance attached to the cluster.
  
  * **Pod CIDR Block** : the CIDR block of the pods in the cluster.
  
  * **Service CIDR** : the CIDR block of the services that are exposed to the Internet from the cluster.
  
  * **Testing Domain** : the domain name that is used for service testing. The suffix of the domain name is `<cluster_id>.<region_id>.alicontainer.com`.
  
  * **Kube-proxy Mode** : the proxy mode that is used to implement service discovery and load balancing. The iptables and IPVS modes are supported.
  
  * **Pods on Each Node** : the maximum number of pods that can run on a single node. Default value: 128.
  
  * **Network Plug-in** : Flannel and Terway are supported.

* You can connect to the cluster by using kubectl and run the
  `kubectl get node` command to view information about the nodes in the cluster. For more information, see [Connect to  Kubernetes clusters through kubectl](https://www.alibabacloud.com/help/doc-detail/86494.htm).

## Deploy sonobuoy Conformance test

Once the configuration files have been created, you should be able to run `kubectl` to interact with the APIs of the Kubernetes cluster. Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.
