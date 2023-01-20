These instructions are for the [Oracle Cloud Infrastructure Container Engine For Kubernetes](https://cloud.oracle.com/containers/kubernetes-engine), which creates a Managed Kubernetes cluster on Oracle Cloud Infrastructure.

To recreate these results:

1. Visit https://www.oracle.com/cloud/free/ to sign up for an account
2. Setup your OCI account for Container Engine For Kubernetes(OKE) cluster creation
    * In a browser, go to the url you've been given to log in to Oracle Cloud Infrastructure console.
    * Specify the Cloud Tenant you received on sign up above or any existing Cloud Tenant.
    * Enter your username and password
    * Within your tenancy, there must already be a compartment to contain the necessary network resources (VCN, subnets, internet gateway, NAT gateway, route table, security lists). If such a compartment does not exist already, you will have to create it before creating a cluster. For details on creating compartments, see the [Managing Compartments](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingcompartments.htm) topic in the Oracle Cloud Infrastructure Documentation.
    * To create and/or manage clusters, you must belong to one of the following:
        * The tenancy's Administrators group.
        * A group to which a policy grants the appropriate Container Engine for Kubernetes permissions.
            * For more details on creating groups and adding users to group, see the [Managing Groups](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managinggroups.htm#) topic in the Oracle Cloud Infrastructure Documentation.
            * To grant appropriate permissions, follow the steps mentioned in [Policy Configuration for Cluster Creation and Deployment](https://docs.cloud.oracle.com/iaas/Content/ContEng/Concepts/contengpolicyconfig.htm) topic in the Container Engine for Kubernetes documentation.
3. Create a cluster by following the [Quick Create workflow](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingclusterusingoke_topic-Using_the_Console_to_create_a_Quick_Cluster_with_Default_Settings.htm) mentioned in the Container Engine for Kubernetes documentation.

4. Set up Cloud Shell Access to Cluster
    *  With the **Cluster Details** page showing the cluster created in above step, click **Access Cluster** to display the **Access Your Cluster** dialog box.
    *  Click  **Launch Cloud Shell** to access the cluster in Cloud Shell by setting up the kubeconfig file.
    *  Run the Oracle Cloud Infrastructure CLI command from the above **Access Your Cluster** dialog box in the cloud shell to download the kubeconfig file and save it with the expected default name and location of `$HOME/.kube/config`.
    *  Click **Close** on **Access Your Cluster** dialog box to close the **How to Access Kubeconfig** dialog.
    *  More details for setting cloud shell access [here](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengdownloadkubeconfigfile.htm#cloudshelldownload).
    *  Verify that you can use kubectl to connect to the new cluster you've created. In the cloud shell, enter the following command:
        ```
        $ kubectl get nodes
        ```
       You see details of the nodes running in the cluster. For example:
        ```
        NAME         STATUS   ROLES   AGE    VERSION
        10.0.10.44   Ready    node    2m     v1.25.4
        10.0.10.52   Ready    node    2m     v1.25.4
        10.0.10.8    Ready    node    2m     v1.25.4
        ```

5. Follow the standard [conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to run the scan and download the results.