# Reproducing test results

## Initial cmp setup

### Install Morpheus onto Ubuntu

#### Single Node Install on Debian/Ubuntu

To get started installing Morpheus on Ubuntu or Debian a few preparatory items should be addressed first.

1. First make sure the apt repository is up to date by running sudo apt-get update. It is advisable to verify the assigned hostname of the machine is self-resolvable.

2. If the machine is unable to resolve its own hostname nslookup hostname some installation commands will be unable to verify service health during installation and fail.

Next simply download the relevant .deb package for installation. This package can be acquired from `https://morpheushub.com` downloads section.

Tip: Use the wget command to directly download the package to your appliance server. i.e. `wget https://downloads.morpheusdata.com/path/to/package/morpheus-appliance_x.x.x-1.amd64.deb`

Next we must install the package onto the machine and configure the morpheus services:

```bash
sudo dpkg -i morpheus-appliance_x.x.x-1.amd64.deb
sudo morpheus-ctl reconfigure
```

Once the installation is complete the web interface will automatically start up. By default it will be resolvable at `https://your_machine_name` and in many cases this may not be resolvable from your browser. The url can be changed by editing `/etc/morpheus/morpheus.rb` and changing the value of appliance_url. After this has been changed simply run:

```bash
sudo morpheus-ctl reconfigure
sudo morpheus-ctl stop morpheus-ui
sudo morpheus-ctl start morpheus-ui
```

Note: The morpheus-ui can take 2-3 minutes to startup before it becomes available.

Further reference:
`https://docs.morpheusdata.com/en/4.2.0/getting_started/installation/installation.html#ubuntu`

#### Connect to a target cloud (example AWS)

1. Navigate to Infrastructure > Groups. Here we will see a list of all configured groups but, of course, this will be empty immediately after installation. Click “+CREATE”. Give your group a name, such as “All Clouds”. The “CODE” field is used when calling Morpheus through Morpheus API or Morpheus CLI. It’s useful in most cases to have an “All Clouds” group for testing purposes so this will likely help you down the road.  Click “SAVE CHANGES”. Your group is now ready to accept clouds.

2. Clouds in Morpheus consist of any consumable endpoint whether that be On-Prem, Public clouds, or even bare metal. In this guide, we will focus on integrating and working with AWS.
    
    To get started, we will navigate to Infrastructure > Clouds. This is the cloud detail page which lists all configured clouds. It will be empty if you’ve just completed installation and setup of Morpheus but soon we will see our integrated AWS cloud here
    
    Click the “+ADD” button to pop the “CREATE CLOUD” wizard. Select “AMAZON” and click the “NEXT” button.
    
    On the “CONFIGURE” tab, give your cloud a “NAME”. Select your Amazon region and enter your credentials in the “ACCESS KEY” and “SECRET KEY” fields. We can also set a number of advanced options here that may be relevant to your AWS use case.
    
    Once you’re satisfied with your selections, click “NEXT”
    We have now arrived at the “GROUP” tab. In this case, we will mark the radio button to “USE EXISTING” groups if you wish to use the group we configured earlier.
    
    Once you’ve selected the group, click “NEXT”
    
    On the final tab of the “CREATE CLOUD” wizard, you’ll confirm your selections and click “COMPLETE”. The new cloud is now listed on the cloud detail page. After a short time, Morpheus will provide summary information and statistics on existing virtual machines, networks, and other resources available in the cloud.
    
    Further reference: `https://docs.morpheusdata.com/en/4.2.0/integration_guides/Clouds/vmware/vmware.html`

#### Use Morpheus KaaS (MKS) builder to build new cluster based on CNCF compliant architecture

To create a new Kubernetes Cluster:

1. Navigate to Infrastructure - Clusters

2. Select + ADD CLUSTER

3. Select Kubernetes Cluster

4. Select a Group for the Cluster

5. Select NEXT

6. Populate the following:

*CLOUD*
Select target Cloud

*CLUSTER NAME*
Name for the Kubernetes Cluster

*RESOURCE NAME*
Name for Kubernetes Cluster resources

*DESCRIPTION*
Description of the Cluster

*VISIBILITY*
Public
Available to all Tenants

*Private*
Available to Master Tenant

*LABELS*
Internal label(s)

7. Select NEXT

8. Populate the following:

*LAYOUT*
Select Single Master from available layouts. System provided layouts include Single Master and Cluster Layouts.

*PLAN*
Select plan for Kubernetes Master (8gbx2vcpu used in testing)

*VOLUMES*
Configure volumes for Kubernetes Master

*NETWORKS*
Select the network for Kubernetes Master & Worker VM’s

*CUSTOM CONFIG*
Add custom Kubernetes annotations and config hash

*CLUSTER HOSTNAME*
Cluster address Hostname (cluster layouts only)

*POD CIDR*
POD network range in CIDR format ie 192.168.0.0/24 (cluster layouts only)

*WORKER PLAN*
Plan for Worker Nodes (cluster layouts only, 8gbx2vcpu used in testing)

*NUMBER OF WORKERS*
Specify the number of workers to provision (defaults to 3, used in testing)

*LOAD BALANCER*
Select an available Load Balancer (cluster layouts only) }

*User Config*
*CREATE YOUR USER*
Select to create your user on provisioned hosts (requires Linux user config in Morpheus User Profile)

*USER GROUP*
Select User group to create users for all User Group members on provisioned hosts (requires Linux user config in Morpheus User Profile for all members of User Group)

Advanced Options
*DOMAIN*
Specify Domain override for DNS records

*HOSTNAME*
Set hostname override (defaults to Instance name unless an Active Hostname Policy applies)

9. Select NEXT

10. Select optional Workflow to execute

11. Select NEXT

12. Review and select COMPLETE
    
    The Master Node(s) will provision first.
    
    Upon successful completion of VM provision, Kubernetes scripts will be executed to install and configure Kubernetes on the Masters.
    
    `Note: Access to the sites listed in the Requirements section is required from Master and Worker nodes over 443`
    
    After Master or Masters are successfully provisioned and Kubernetes is successfully installed and configured, the Worker Nodes will provision in parallel.
    
    Provision status can be viewed:
    
    From the Status next to the Cluster in Infrastructure -> Clusters
    
    Status bar with eta and current step available on Cluster detail page, accessible by selecting the Cluster name from Infrastructure -> Clusters
    
    All process status and history is available - From the Cluster detail page History tab, accessible by selecting the Cluster name from Infrastructure -> Clusters and the History tab - From Operations - Activity - History - Individual process output available by clicking  on target process
    
    Once all Master and Worker Nodes are successfully provisioned and Kubernetes is installed and configured, the Cluster status will turn green.

Further Reference: `https://docs.morpheusdata.com/en/4.2.0/infrastructure/clusters/kubernetes.html#creating-kubernetes-clusters`

#### SSH to one of the masters

## Sonobuoy test

1. `$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.2/sonobuoy_0.17.2_linux_amd64.tar.gz`
2. `$ tar -xzf sonobuoy_0.17.2_linux_amd64.tar.gz`
3. `$ ./sonobuoy run`
4. `$ ./sonobuoy status`
5. `$ ./sonobuoy logs`
6. `$ ./sonobuoy retrieve ./results`
7. `# untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}`

