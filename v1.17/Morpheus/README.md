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


``
see instructions:
``
https://docs.morpheusdata.com/en/4.2.0/integration_guides/Clouds/vmware/vmware.html

3.  (optional) connect external DNS:

``
see instructions:
``
https://docs.morpheusdata.com/en/4.2.0/integration_guides/integration_guides.html#dns

4.  (optional) connect external LB service:

``
see instructions:
``
https://docs.morpheusdata.com/en/4.2.0/integration_guides/integration_guides.html#load-balancers

5.  Use Morpheus KaaS builder to build new cluster based on CNCF compliant architecture
``
see instructions:
``
https://docs.morpheusdata.com/en/4.2.0/integration_guides/Containers/kubernetes.html

6.  SSH to one of the masters

## Sonobuoy test

1.      $ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.2/sonobuoy_0.17.2_linux_amd64.tar.gz
2.       $ tar -xzf sonobuoy_0.17.2_linux_amd64.tar.gz
3.       $ ./sonobuoy run
4.       $ ./sonobuoy status
5.       $ ./sonobuoy logs
6.       $ ./sonobuoy retrieve ./results
7.       # untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}

