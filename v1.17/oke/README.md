
 These instructions are for the [Oracle Cloud Infrastructure Container Engine For Kubernetes](https://cloud.oracle.com/containers/kubernetes-engine), which creates a Managed Kubernetes cluster on Oracle Cloud Infrastructure.
 
 To recreate these results:
 
 1. Visit https://cloud.oracle.com/en_US/tryit to sign up for an account
 2. Create a cluster using these [steps](http://www.oracle.com/webfolder/technetwork/tutorials/obe/oci/oke-full/index.html)
    1. What Do You Need?
        * An Oracle Cloud Infrastructure username and password.
        * Within the root compartment of your tenancy, a policy statement `Allow service OKE to manage all-resources in tenancy` must be defined to give Container Engine for Kubernetes access to resources in the tenancy.
        * Within your tenancy, there must already be a compartment to contain the necessary network resources (VCN, subnets, internet gateway, NAT gateway, route table, security lists). If such a compartment does not exist already, you will have to create it before starting this tutorial.
        * At least three compute instances must be available in the tenancy to complete this tutorial as described. Note that if only one compute instance is available, it is possible to create a cluster with a node pool that has a single subnet and a single node in the node pool. However, such a cluster will not be highly available.
        * To create and/or manage clusters, you must belong to one of the following:
            * The tenancy's Administrators group.
            * A group to which a policy grants the appropriate Container Engine for Kubernetes permissions. As you'll be creating and configuring a cluster and associated network resources during the tutorial, policies must also grant the group the appropriate permissions on those resources. For more details and examples, see the [Policy Configuration for Cluster Creation and Deployment](https://docs.cloud.oracle.com/iaas/Content/ContEng/Concepts/contengpolicyconfig.htm) topic in the Container Engine for Kubernetes documentation.
        * Before you download the kubeconfig file later in the tutorial, you must have already done the following (if you haven't, or you're not sure, see the [Downloading a kubeconfig File to Enable Cluster Access](https://docs.us-phoenix-1.oraclecloud.com/Content/ContEng/Tasks/contengdownloadkubeconfigfile.htm) topic in the Container Engine for Kubernetes documentation):
            * generated an API signing key pair
            * added the public key value of the API signing key pair to the User Settings for your username
            * installed and configured the Oracle Cloud Infrastructure CLI (version 2.6.4 or later)
        * You must have installed and configured the Kubernetes command line tool kubectl. If you haven't done so already, see the [kubectl documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
    2. Starting OCI
        * In a browser, go to the url you've been given to log in to Oracle Cloud Infrastructure.
        * Specify a tenant in which you have the appropriate permissions to create clusters. You inherit these permissions in one of the following ways:
            * By belonging to the tenancy's Administrators group.
            * By belonging to another group to which a policy grants the appropriate Container Engine for Kubernetes permissions. As you'll be creating and configuring a cluster and associated network resources during the tutorial, policies must also grant the group the permissions listed in the What Do You Need? section.
        * Enter your username and password.
        * Once the OCI console is opened, from the **Region** menu change the region to `Canada Southeast (Montreal)`
            * if you aren't subscribed to `Canada Southeast (Montreal)`, please follow [this](https://docs.oracle.com/en/cloud/get-started/subscriptions-cloud/mmocs/extending-your-subscription-another-data-region.html) to subscribe to the new region.
    3. Define Cluster Details
        *  In the Console, open the navigation menu. Under **Solutions and Platform**, go to **Developer Services** and click **Container Clusters**.
        *  Choose a **Compartment** that you have permission to work in, and in which you want to create both the new cluster and the associated network resources****.
        *  On the **Clusters** page, click **Create Cluster**.
        *  In the **Create Cluster Solution** dialog, click **Quick Create** and click **Launch Workflow**.
        *  On the **Create Cluster** page, change the placeholder value in the **Name** field and enter `Tutorial Cluster` instead.
        *  Click **Next** to review the details you entered for the new cluster.
        *  On the **Review** page, click **Submit** to create the new network resources and the new cluster. You see the different network resources being created for you. 
        *  Click **Close** to return to the Console.
        *  Scroll down to see details of the new node pool that has been created, along with details of the new worker nodes (compute instances).
    4. Download the kubeconfig File for the Cluster
        *  Confirm that you've already done the following:
            *   Generated an API signing key pair.
            *   Added the public key value of the API signing key pair to the User Settings for your username.
            *   Installed and configured the Oracle Cloud Infrastructure CLI (version 2.6.4 or later).
            *   If you haven't done one or more of the above, or you're not sure, see the [Downloading a kubeconfig File to Enable ClusterAccess](https://docs.us-phoenix-1.oraclecloud.com/Content/ContEng/Tasks/contengdownloadkubeconfigfile.htm) topic in the Container Engine for Kubernetes documentation.

        *  With the **Cluster Details** page showing the Tutorial Cluster, click **Access Kubeconfig** to display the **How to Access Kubeconfig** dialog box.
        *  In a terminal window, create a directory to contain the kubeconfig file, giving the directory the expected default name and location of `$HOME/.kube`. For example, on Linux, enter the following command (or copy and paste it from the **How to Access Kubeconfig** dialog box): 
            ```
            $ mkdir -p $HOME/.kube
            ```
        *  Run the Oracle Cloud Infrastructure CLI command to download the kubeconfig file and save it with the expected default name and location of `$HOME/.kube/config`. This name and location ensures the kubeconfig file is accessible to kubectl and the Kubernetes Dashboard whenever you run them from a terminal window. For example, on Linux, enter the following command (or copy and paste it from the **How to Access Kubeconfig** dialog box):
            ```
            $ oci ce cluster create-kubeconfig --cluster-id ocid1.cluster.oc1.phx.aaaaaaaaae... --file $HOME/.kube/config --region us-phoenix-1 --token-version 2.0.0
            ```
            where `ocid1.cluster.oc1.phx.aaaaaaaaae...` is the OCID of the current cluster. For convenience, the command in the **How to Access Kubeconfig** dialog box already includes the cluster's OCID.
        *  Set the value of the KUBECONFIG environment variable to the name and location of the kubeconfig file. For example, on Linux, enter the following command (or copy and paste it from the **How to Access Kubeconfig** dialog box): 
            ```
            $ export KUBECONFIG=$HOME/.kube/config
            ```
        *  Click **Close** to close the **How to Access Kubeconfig** dialog.
 3. Set up Kubectl for the cluster as described in the "Get Started" instructions in the UI
    *  Confirm that you've already installed kubectl. If you haven't done so already, see the [kubectl documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
    *  Verify that you can use kubectl to connect to the new cluster you've created. In a terminal window, enter the following command:
        ```
        $ kubectl get nodes
        ```
        You see details of the nodes running in the cluster. For example:
        ```
        NAME              STATUS  ROLES  AGE  VERSION
        10.0.10.2         Ready   node   1d   v1.13.5
        10.0.11.2         Ready   node   1d   v1.13.5
        10.0.12.2         Ready   node   1d   v1.13.5
        ```
 4. Create a ClusterRoleBinding for the cluster bound to the `cluster-admin` ClusterRole similar to the following, where OCID is the user's user OCID - `kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --user=<user_OCID>`
 5. Follow the standard [conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to run the scan and download the results.