# To reproduce

## Provision Cluster

Log into Intersight using Kubernetes admin credentials.

**Procedure**

1.	In the left pane, click **Profiles**.

1. Click the **Kubernetes Cluster Profiles** tab.
   
    The list of available profiles is displayed.

2.	Click **Create Kubernetes Cluster Profile**. 

    The **Kubernetes Cluster Profile** wizard appears.

3.	To configure the name, description, and tag for the cluster, in the **General** screen:

    1.	From the **Organization** drop-down list, choose the default organization or a specific organization to which the Kubernetes cluster profile should belong.

        **Note:** An Organization is a logical entity that enables multi-tenancy through a separation of resources.

    2.	In the **Cluster Name** field, enter a name for the cluster profile.

    5.	In the **Add Tag** field, enter the metadata that you want to associate with the cluster profile. 
    
        **Add Tag** is an optional field. If you are adding a tag, you must enter the tag in the `key:value` format. This tag will be used internal to Intersight.

    4.	In the **Description** field, enter a description for the cluster profile.

        **Description** is an optional field.

    6.	Click **Next**.

1. To configure the network, system, and SSH settings, in the **Cluster Configuration** screen:
   
    1.	Under **IP Pool**, click **Select IP Pool**, and then do one of the following steps: 
        
        - Click **Create New** to create a new IP pool.

            For more information on creating a new IP pool, see [Intersight Managed Mode Configuration Guide](https://www.cisco.com/c/en/us/td/docs/unified_computing/Intersight/b_Intersight_Managed_Mode_Configuration_Guide/m_review_map_Pools.html).

        - Choose a pre-configured IP pool.

        You can click the **Eye** icon to view the details of the IP pool.

    2.	In the **Load Balancers** field, enter the number of load balancer IP addresses for the cluster.

    3.	The **SSH User** field displays the SSH username as **iksadmin**. 
    
        This field is not editable.

    4. In the **SSH Public Key** field, enter the SSH public key that you want to use for creating the cluster.

        **Note:** 

        - We recommend that you use only Ed25519 or ECDSA format for the public key.

        - You can use the `ssh-keygen` command to generate an SSH key pair. 
            
            For example: `ssh-keygen -t ed25519`

    5.	Under **Policies**, configure the following policies:
    
        1. Expand **DNS, NTP and Time Zone** and fill the details, or click **Select Policy**, and then choose a pre-configured policy.

            For more information on creating a new policy, see [Creating Node OS Configuration Policy](#creating-node-os-configuration-policy).
    

        2. Expand **Network CIDR** and fill the details, or click **Select Policy**, and then choose a pre-configured policy.

            For more information on creating a new policy, see [Creating Network CIDR Policy](#creating-network-policy).    

        3. If you want to add **Trusted Registries**, expand **Trusted Registries** and enter the policy details, or choose a pre-configured policy.

            For more information, see [Creating Trusted Certificate Authorities Policy](#creating-trusted-certificate-authorities-policy).

        4. If you want to add a **Container Runtime Policy**, expand **Container Runtime Policy** and enter the policy details, or choose a pre-configured policy.

            For more information, see [Creating Container Runtime Policy](#creating-container-runtime-policy).

   1. Click **Next**.

5.	To configure the control plane node pool, in the **Control Plane Node Pool Configuration** screen:

    1. Under **Control Plane Node Configuration**, in the **Counts** field, enter the number of control plane nodes that you want. 
     
        **Note:** You can create a single node or three node control plane. We recommend that you limit the number of  nodes to the tested configuration of three nodes.

    1.	Under **Kubernetes Version**,  click **Select Version**, and then do one of the following steps:

        - Click **Create New** to create a new policy. 
         
            For more information, see [Creating Kubernetes Version Policy](#creating-kubernetes-version-policy).

        - Choose a pre-configured policy.

        You can click the **Eye** icon to view the details of the policy.

    1. Under **IP Pool**, click **Select IP Pool**, and then do one of the following steps:

       - Create a new IP Pool policy. 

            For more information on creating an IP pool, see [Intersight Managed Mode Configuration Guide](https://www.cisco.com/c/en/us/td/docs/unified_computing/Intersight/b_Intersight_Managed_Mode_Configuration_Guide/m_review_map_Pools.html).

       - Choose a pre-configured IP pool policy. 

        You can click the **Eye** icon to view the details of the policy. 
   
    2. Under **Kubernetes Labels**, enter the key-value pair.
                
    3. Under **Virtual Machine Infrastructure Configuration**, click **Select Infra Provider**, and then do one of the following steps:

        - Click **Create New** to create a new policy. 

            For more information, see [Creating Infra Provider Policy](#creating-infra-provider-policy).

        - Choose a pre-configured policy.

        You can click the **Eye** icon to view the details of the policy.

    4. Under **Virtual Machine Instance Type**, click **Select Instance Type**, and then do one of the following steps:

        - Click **Create New** to create a new policy. 

            For more information, see [Creating Instance Type Policy](#creating-instance-type-policy).

        - Choose a pre-configured policy.

        You can click the **Eye** icon to view the details of the policy.

1. To configure worker node pools, in the **Worker Node Pools Configuration** screen:
    
    1. In the **Name** field, enter a name for the worker node pool.

    2. Under **Worker Node Configuration**, in the **Counts** field, enter the number of worker nodes that you want.     
    
        **Note:** We recommend that you limit the number of worker nodes to the tested configuration of 24 worker nodes.

	
    1.	Under **Kubernetes Version**,  click **Select Version**, and then do one of the following steps:

        - Click **Create New** to create a new policy. 
         
            For more information, see [Creating Kubernetes Version Policy](#creating-kubernetes-version-policy).

        - Choose a pre-configured policy.

            You can click the **Eye** icon to view the details of the policy.

    1. Under **IP Pool**, click **Select IP Pool**, and then do one of the following steps:

       - Create a new IP Pool policy. 

            For more information on creating an IP pool, see [Intersight Managed Mode Configuration Guide](https://www.cisco.com/c/en/us/td/docs/unified_computing/Intersight/b_Intersight_Managed_Mode_Configuration_Guide/m_review_map_Pools.html).

       - Choose a pre-configured IP pool policy.

        You can click the **Eye** icon to view the details of the policy. 

    2. Under **Kubernetes Labels**, enter the key-value pair.

    7.	Click **Next**.

3.	To configure storage and optional add-ons, in the **Add-ons Configuration** screen:

    **Note:** Add-on configuration is optional.

    1. Click **Add Add-on**.

    1. Under **Add-on Name**, enter a name for the add-on policy.

    2. Under **Add-on Policy**, click **Select Add-on**, and then do one of the following steps:

       - Click **Create New** to create a new policy. 

            For more information, see [Creating Add-on Policy](#creating-add-on-policy).

        - Choose a pre-configured policy.

        You can click the **Eye** icon to view the details of the policy.

    3. To set add-on configurations at the cluster-level, follow these steps:

        **Note:** The add-on configurations set at the cluster-level overrides the configurations set in an Add-on policy. If you do not set any add-on configuration at the cluster-level, the add-on inherits the configuration from the add-on policy.

       1. In the **Overrides** field, enter the formatted YAML code snippet that you want to pass to the Helm install command as an override file. **Overrides** is an optional field.  

            For example:

            Enter the following code snippet in the **Overrides** field to disable some services in promtheus:

                prometheus:
                    alertmanager:
                        enabled: false

            This code snippet is passed to the Helm install command:
            
                helm install -f overrides my-iwo-k8s-collector

       2. From the **Install Strategy** drop-down list, choose an install strategy.

            **Note:** The install strategy that you choose determines the action to be taken in case you manually remove the Helm release

            The following table describes the install strategies.
            
            Install Strategy|Description
            ----------------|-----------
            **No Action**| Install is not performed by the add-on operator. If the release is not present, this option instructs the add-on operator to do nothing.
            **Install Only**| The operator ensures that the add-on is installed once, but if the add-on is manually removed for any reason, the operator will not reinstall the add-on.
            **Always**| If you manually remove the Helm release, the add-on is always reinstalled.

        1. From the **Upgrade Strategy** drop-down list, choose an upgrade strategy.

        **Note:** The upgrade strategy that you choose determines the action to be taken in case the add-on configuration is different from the configuration that is running.
        One of the following events can trigger an add-on upgrade:

        - Deploying a cluster profile
        - Changing the Helm release version
        - Explicitly changing the upgrade strategy

        The following table describes the upgrade strategies.        

        Name |When Upgrade is Triggered... | Data is Persisted
        ---|----|---
        No Action|No changes occur.|Yes  
        Upgrade Only| If the upgrade fails, no further action is taken. | Yes
        Reinstall on Failure| If the upgrade fails, the add-on is reinstalled.| No
        Always Reinstall| The add-on is reinstalled. |No
        

    4. Click **Next**.
	
1. To review and deploy or save the cluster profile, do one of the following steps in the **Summary** screen:

    - If you want to deploy the cluster profile, verify the configuration, and then click **Deploy**.

        You can click the **Requests** icon displayed in the menu bar to view the status of your cluster deployment. For more information, see [Monitoring Progress of Kubernetes Cluster Requests](#monitoring-progress-of-kubernetes-cluster-requests).

        The cluster deployment takes a few minutes to complete. The newly created cluster is displayed on the **Kubernetes Cluster Table View**.

    - If you want to save the cluster profile and deploy it later, click **Close** to exit the profile. 

    The cluster profile is listed in the **Profiles** screen. You can select the profile and click the **Edit** icon to edit the profile.

The cluster deployment takes a few minutes to complete. The newly created cluster is displayed on the **Kubernetes Clusters** screen.  Once cluster creation has completed, download environment config file to access tenant cluster.


## Launch E2E Conformance Tests

- SSH to the master node of the Kubernetes cluster
- Download sonobuoy and extract the binary
  - `wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.50.0/sonobuoy_0.50.0_linux_amd64.tar.gz`
  - `tar xvfz sonobuoy_0.50.0_linux_amd64.tar.gz`
- Run conformance tests
  - `./sonobuoy run --mode=certified-conformance`
- Check on test status
  - `./sonobuoy status`

