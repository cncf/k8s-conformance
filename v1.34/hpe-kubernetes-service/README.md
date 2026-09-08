# Reproducing test results

## Initial Cloud Management Platform (CMP) setup

### Install Morpheus onto Ubuntu

#### Single Node Install on Debian/Ubuntu

To get started installing Morpheus on Ubuntu or Debian a few preparatory items should be addressed first.

1. First make sure the apt repository is up to date by running `sudo apt-get update`. It is advisable to verify the assigned hostname of the machine is self-resolvable.

2. If the machine is unable to resolve its own hostname using the `nslookup hostname` command, some installation commands will be unable to verify service health during installation and fail.

3. Download the relevant .deb package for installation. This package can be obtained from My HPE Software Center. `https://myenterpriselicense.hpe.com/`

Note: Use the wget command to directly download the package to your appliance server. i.e. `wget https://www.hpe.com/support/hpesc/path/to/package/morpheus-appliance_x.x.x-1.amd64.deb`. The package must be 8.1.0 or higher to perform the test on the 1.34 HA set-up (3 Masters and 3 Workers)

Next install the package onto the machine and configure the morpheus services:

```bash
sudo dpkg -i morpheus-appliance_x.x.x-1.amd64.deb
sudo morpheus-ctl reconfigure
```

Note: If the process stops in between run the `reconfigure` command again. To cleanse the existing files and start a fresh installation use 

```bash
sudo morpheus-ctl cleanse
sudo morpheus-ctl reconfigure
```

Once the installation is complete the web interface will automatically start up. By default it will be resolvable at `https://your_machine_name` and in many cases this may not be resolvable from your browser. The URL can be changed by editing `/etc/morpheus/morpheus.rb`. Changing the value of appliance_url. After this has been changed simply run:

```bash
sudo morpheus-ctl reconfigure
sudo morpheus-ctl stop morpheus-ui
sudo morpheus-ctl start morpheus-ui
```

`Note: The morpheus-ui can take 2-3 minutes to start up before it becomes available.`

Further reference:
`https://support.hpe.com/hpesc/public/docDisplay?docId=sd00007510en_us&page=GUID-7A7CF662-8990-4A6D-A6BF-A99759FA11E1.html#ariaid-title7`

## Configuring the Set-up to Test

### Configure a Cloud

#### Connect to a target cloud (example VMware Cloud)

1. Navigate to **Infrastructure** > **Groups**. Here we will see a list of all configured groups but, of course, this will be empty immediately after installation.  

    1.1 Click “+CREATE”. Give your group a name, such as “All Clouds”. The “CODE” field is used when calling Morpheus through Morpheus API or Morpheus CLI. It’s useful in most cases to have an “All Clouds” group for testing purposes so this will likely help you down the road.
    
    1.2 Click "SAVE CHANGES". Moreover with Advanced options you can add a private registry to have a set of pre-installed images to use in the Morpheus appliance. Your group is now ready to accept clouds.

    `Note: You can create a group in Cloud creation as well.`

2. Clouds in Morpheus consist of any consumable endpoint whether that be On-Prem, Public clouds, or even bare metal. In this guide, we will focus on integrating and working with a VMware VCenter cloud.
    
    2.1 To get started, we will navigate to **Infrastructure** > **Clouds**. This is the cloud detail page which lists all configured clouds. 
    
    2.2 Click the “+ADD” button to pop the “CREATE CLOUD” wizard. Select “VMWARE VCENTER” in the "Cloud" tab and click the “NEXT” button.
    
    2.3 On the “Configure” tab, give your cloud a “NAME” and "CODE" as an optional field. You can modify the Connection Option to connect via a proxy

    2.4 Enter the API URL followed by '/sdk', for the VCenter hosting your services. Choose Local Credentials in "CREDENTIALS" to enter the credentials for the VCenter that is already deployed. Give the "USERNAME", "PASSWORD" and the appliance will fetch the datastores available in your VCenter for the "VDC" field. 
    
    2.5 Once you're satisfied with your selections, click "NEXT"

    We have now arrived at the "GROUP" tab. In this case, we will mark the radio button to "USE EXISTING" groups if you wish to use the group we configured earlier or create a new group as per your discretion.
    
    2.6 Once you've selected the group, click "NEXT"
    
    On the final tab of the “CREATE CLOUD” wizard, you’ll confirm your selections and click “COMPLETE”. The new cloud is now listed on the cloud detail page. After a short time, Morpheus will provide summary information and statistics on existing virtual machines, networks, and other resources available in the cloud.
    
Further reference: `https://support.hpe.com/hpesc/public/docDisplay?docId=sd00007510en_us&page=GUID-EC91E230-8323-4710-9A47-D57A15BE71AA.html`


### Configure a Network

#### Add an IP Pool

1. Navigate to **Infrastructure** > **Network** > **IP Pools** and click **+ ADD**

2. Enter the following:

    **NAME**: A friendly name for the IP Pool

    **POOL TYPE**: Select `HPE Morpheus Enterprise` *(or `NSX` if using an NSX integration)*

    **STARTING ADDRESS**: Starting IP address of the pool range (e.g. `192.168.0.2`)

    **ENDING ADDRESS**: Ending IP address of the pool range (e.g. `192.168.0.255`)

3. Click **SAVE CHANGES**

#### Configure the Network for Static IP Assignment

1. Navigate to **Infrastructure** > **Network** > **Networks**

2. Search for the target network and click **Edit** *(or select **Actions** > **Edit**)*

3. In the Network Config modal, populate the following:

    **GATEWAY**: Network gateway address

    **DNS PRIMARY**: Primary DNS server address

    *DNS SECONDARY*: Secondary DNS server address

    **CIDR**: Network CIDR (e.g. `10.10.10.0/22`)

    *VLAN ID*: VLAN tag, if applicable

    **NETWORK POOL**: Select the IP Pool created above to enable automatic IP assignment

    *PERMISSIONS*: Leave as default for single-tenant environments. For multi-tenant setups, set **Visibility** to `Public` (Master Tenant) or `Private` (specific account)

    **ACTIVE**: Leave enabled to make this network available for provisioning

4. Click **SAVE CHANGES**


### Deploy a Cluster

#### Use the Kubernetes Cluster to deploy a 1.34 HA Configuration on the Cloud created

To create a new Kubernetes Cluster:

1. Navigate to Infrastructure - Clusters

2. Select "+ ADD CLUSTER"

3. Select Kubernetes Cluster

4. Select a Group for the Cluster made earlier

5. Select NEXT

6. Populate the following

    > **Bold** = Required field (value selected) | *Italic* = Optional field (description of what it does)

    **CLOUD**: `VMware` *(configured in the previous section)*

    **CLUSTER NAME**: Enter a name for the Kubernetes Cluster
    
    *RESOURCE NAME*: Enter a name for the Kubernetes Cluster resources

    *DESCRIPTION*: Enter a description for the Cluster
    
    **VISIBILITY**: `Public` — available to all Tenants; select `Private` to restrict to Master Tenant only

    *LABELS*: Internal label(s) for filtering

7. Select NEXT

8. Populate the following:

    **LAYOUT**: `HKS Kubernetes 1.34 HA Cluster on Ubuntu 24.04`
    
    **PLAN**: `2 CPUs, 8 GB RAM` *(adjust based on workload requirements)*

    **VOLUMES**: `2 × 40 GB, Thin provisioning`

    **NETWORKS**: Select the network configured in the previous section (with the static IP pool attached)

    *CUSTOM CONFIG*: Custom Kubernetes annotations and config hash

    *HOST*: `ESXi host with attached datastores and Morpheus VM` *(cluster layouts only)*

    *FOLDER*: `/` *(default — scopes VM placement within the datastore)*

    *API PROXY*: Left empty *(set only if a proxy is required to reach the VMware vCenter API)*

    **POD CIDR**: `172.20.0.0/16` *(default — private IP range for pod-to-pod communication)*

    **SERVICE CIDR**: `172.30.0.0/16` *(default — IP range for Kubernetes service routing)*

    **WORKER PLAN**: Select a plan for Worker Nodes *(cluster layouts only)*

    **NUMBER OF WORKERS**: `3` *(default)*
    
    *LOAD BALANCER*: Left empty *(cluster layouts only)*

    #### User Config

    *CREATE YOUR USER*: Select to create your user on provisioned hosts (requires Linux user config in HPE Morpheus Enterprise User Profile)

    *USER GROUP*: Select User group to create users for all User Group members on provisioned hosts (requires Linux user config in HPE Morpheus Enterprise User Profile for all members of User Group)

    #### Advanced Options

    *DOMAIN*: Specify Domain override for DNS records

    *HOSTNAME*: Set hostname override (defaults to Instance name unless an Active Hostname Policy applies)

    #### Autoscaler
    
    The Cluster Autoscaler is a Kubernetes component that automatically adjusts the number of worker nodes in your cluster based on the resource requirements of your workloads. It allows you to set the minimum and maximum number of nodes to continuously update the quorum based on the workload

9. Select NEXT

10. Select optional Workflow to execute

11. Select NEXT

12. Review and select COMPLETE
    
    12.1 The Master Node(s) will provision first.
    
    12.2 Upon successful completion of VM provision, Kubernetes scripts will be executed to install and configure Kubernetes on the Masters.
    
    `Note: Access to the sites listed in the Requirements section is required from Master and Worker nodes over 443`
    
    12.3 After Master or Masters are successfully provisioned and Kubernetes is successfully installed and configured, the Worker Nodes will provision in parallel.
    
    Provision status can be viewed:
    
    From the Status next to the Cluster in Infrastructure -> Clusters
    
    Status bar with eta and current step available on Cluster detail page, accessible by selecting the Cluster name from Infrastructure -> Clusters
    
    All process status and history is available - From the Cluster detail page History tab, accessible by selecting the Cluster name from Infrastructure -> Clusters and then clicking on the "History" tab on the menu after clicking on the desired cluster name. Individual process output available by clicking  on the target step
    
    Once all Master and Worker Nodes are successfully provisioned and Kubernetes is installed and configured, the Cluster status will turn green.

13. Once all Master and Worker Nodes are successfully provisioned and Kubernetes is installed and configured, the Cluster status will turn green.

Further Reference: `https://support.hpe.com/hpesc/public/docDisplay?docId=sd00007510en_us&page=GUID-3159C5BA-04D5-4035-9842-86197618F7D2.html`

## Sonobuoy test

### To be run from any Master Node

#### SSH to one of the masters

1. `$ wget -q https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz`
2. `$ tar -xzf sonobuoy_0.57.3_linux_amd64.tar.gz`
3. `sudo cp /etc/kubernetes/admin.conf ~/.kube/config` (Copying kubeconfig to allow regular user to use `kubectl` commands)
4. `sudo mv sonobuoy /usr/local/bin` (To call sonobuoy from any directory)
5. `sonobuoy delete --all --wait` (To clear previous instances of run, if any)
6. `$ sonobuoy run --mode=certified-conformance` (To run tests with the [Conformance] tag)
7. `$ sonobuoy status` (To monitor and verify if tests are completed)
8. `$ sonobuoy logs` (To check logs of tests run)
9. `$ sonobuoy retrieve ./results`
10. Untar the tarball in /results directory, to view `plugins/e2e/results/{e2e.log,junit_01.xml}`
