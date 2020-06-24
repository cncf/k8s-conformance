# SUSE CaaS (Containers as a Service) Platform 4.1

## Introduction

These are instructions about how to run Kubernetes conformance tests on a SUSE CaaS Platform 4.1 cluster. SUSE CaaS Platform 4.1 is SUSE's distribution based on Kubernetes 1.16.

## Download SUSE CaaS Platform 4.1

SUSE CaaS Platform installs as a module/extension of SUSE Linux Enterprise Server using the SUSE unified installer.

These instructions are somewhat abbreviated, and deal only with installation on bare metal. The product documentation also describes installation on VMware vSphere, SUSE OpenStack Cloud, SUSE Linux Enterprise Server with KVM, and AWS EC2.

To access the Deployment Guide, you can follow the main navigation on suse.com and choose "Support & Services" > "Support Resources" > "Product Documentation." Then select "SUSE CaaS Platform" in the left pane, then "SUSE CaaS Platform 4.1" in the right pane. In the "Core Product Documentation" section, choose your preferred format of the Deployment Guide.

The direct URL for the HTML version of the Deployment Guide is https://documentation.suse.com/suse-caasp/4.1/html/caasp-deployment/index.html

This URL and navigation should be valid for the supported lifetime of the product version.

##Preparing for Installation

For the verification, you will need:
* a system running SUSE Linux Enterprise 15 SP1 to serve as the management/deployment host - this can be a system that you already have
* an odd number, at least 1, of systems that will be Kubernetes master nodes. (1 master is acceptable for testing, but use at least 3 for production) These directions will show the process for 1 master node. If you use multiple master nodes, you will need to set up load balancing in front of the api-server. This is documented in the Deployment Guide.
* at least two systems that will be used as Kubernetes worker nodes

If you are a SUSE customer, you can access the product downloads at the SUSE Customer Center (link at top of website).  

* When you log in, choose the correct name for your subscription, and copy your registration code.
* Go to the "Subscription Information" tab, then click on the subscription name; you should see a list of registered systems, if you have already registered any. 
* Go to the "Base and Extension Products" tab. 
* Choose "SUSE Linux Enterprise Server 15 SP1" in the upper pane labeled "Base Products" and note the repository URLs listed. The essential ones are the ones whose names end with "/product" and "/update" - the others can be used to access source code or debug versions.
* Choose "SUSE CaaS Platform 4.0" in the lower "Extension Products" pane. (The 4.0 channel is actually used for all 4.x versions.) Again, note the "/product" and "/update" URLs.
*At the top of the page near the right edge there is a "Software Download" button. Click it, then find the "SUSE CaaS Platform" section and click the Download button.

If you do not have a subscription for SUSE CaaS Platform:

* Click the "Free Downloads" button in the top area of suse.com
* Find SUSE CaaS Platform and click the Download button under it.
* Click the Download button for SUSE CaaS Platform 4.
* Complete the Free 60-day Evaluation form and click "Create Account."
* This will take you to the download page.

In both cases:
* You will see two Installer DVD ISO images and two Packages DVD ISO images. The -2 images contain sources and are optional. The Installer -1 package is used to boot the system and run the installer. If your target systems have Internet access, you can choose to load many packages from the network. If they are airgapped, you will need to use the Packages -1 ISO.
* Copy the Installer ISO to a bootable medium for your system - a DVD, a thumb drive, or a file accessible from a remote console card.

## Installation

If you have an existing SUSE Linux Enterprise Server 15 SP1 system that you can use as a management/deployment host, all you need to do on that system is:
* Add the pattern for the Containers Module and the SUSE CaaS Platform extension
$ SUSEConnect -p sle-module-containers/15.1/x86_64
$ SUSEConnect -p caasp/4.0/x86_64 -r <PRODUCT_KEY>
* Install the Management pattern:
$ zypper in -t pattern SUSE-CaaSP-Management

If you are installing the management/deployment host from scratch: 
* Boot the system from the installer medium
* Use the product key retrieved above
* Install at least the base module, the containers module, and the SUSE CaaS Platform extension module

After completion of the installation and system reboot, log in and set up the SSH agent. If you indtalled a desktop environment, it should already be running. If not, start it manually:
$ eval "$(ssh-agent)"

Create SSH public and private keys for the identity to be used to bootstrap the cluster. Add them to the SSH server.
 * ssh-add -t <lifetime> <PATH-TO-KEY>

You can use the automated installer, AutoYaST, and the Repository Mirroning Tool (RMT) to perform repetitive installations. For a small test cluster, manual configuration is adequate.

For each node of the cluster (master or worker), follow the installation steps above. 

After installation:
* Turn off swapping on each node
$ sudo swapoff -a
* Modify /etc/fstab on each node to remove the swap entries.
* Reboot the nodes
* Add the SUSE CaaS Platform repositories to each node
$ SUSEConnect -p sle-module-containers/15.1/x86_64
$ SUSEConnect -p caasp/4.0/x86_64 -r <CAASP_REGISTRATION_CODE>

## Bootstrapping the Cluster

skuba, the cluster bootstrap and updating tool, is a wrapper that uses kubeadm, but performs needed setup and cleanup steps, and also orcherstrates cluster-wide operations such as updates. 

By default, skuba runs as root. However, if you set up a non-root user and wish to use it for deployment, you must:
* Configure sudo on each node for the user to be able to authenticate without password.
$ echo "<USERNAME> ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
* Add the following flags to any skuba command line:
** --sudo --user <USERNAME>

You can now bootstrap the cluster on your management host. 

* Generate the folder that contains configuration information for the cluster.
$ skuba cluster init --control-plane <LB_IP/FQDN> my-cluster
Replace "my-cluster" with the custom name you choose. Replace "<LB_IP/FQDN>" with the IP address or FQDN of your master node in the single-master configuration.

You can now modify aspects of the configuration before adding nodes, but you probably will not have to. For example, the configuration defaults to a podSubnet value (the network on which all pods will be accessed) to 10.244.0.0/16 and the serviceSubnet (network for all services) to 10.96.0.0/12. You only need to change these if they conflict with non-routed addresses already in use. 

* Adding the first master node to the cluster
$ cd my-cluster   (or whatever name you gave your cluster)
$ skuba node bootstrap [--user sles --sudo] --target <IP/FQDN> <NODE_NAME>
Replace "<IP/FQDN>" with the IP address to be used for the node.

* Adding each worker node to the cluster
For each worker node, join the node to the cluster:
$ skuba node join --role worker [--user sles --sudo] --target <IP/FQDN> <NODE_NAME>

Now check the status of the cluster:
$ skuba cluster status

##  Using kubectl
* You can install and use kubectl by installing the kubernetes-client package from the SUSE CaaS Platform extension.
$ sudo zypper in kubernetes-client

* To make your configuration easier to access, copy it to a canonical location:
$ mkdir -p ~/.kube
$ cp admin.conf ~/.kube/config

## Running the conformance suite

Then, download sonobuoy from upstream:
  $ wget https://github.com/heptio/sonobuoy/releases/download/v0.13.0/sonobuoy_0.13.0_linux_amd64.tar.gz
  
  $ tar xzf sonobuoy_0.13.0_linux_amd64.tar.gz

After that, prepare config for e2e only and trigger the e2e test suite

  $ cat << EOF > sonobuoy.json
   {
     "plugins": [ { "name": "e2e" } ]
   }
  EOF
 $ ./sonobuoy --config sonobuoy.json run

You can check status of the test:
  $ ./sonobuoy status

Once sonobuoy status shows the run as completed, you can retrieve logs archive by:
  $ ./sonobuoy retrieve ~/logs/

Then, you can extract the archive in ~/logs/ and check if the test passed by checking last few lines in
<archive>/plugins/e2e/results/e2e.logs:
  $ tail -n 10 e2e.log

Finally, you can do a cleanup on cluster by calling:
  $ ./sonobuoy delete
