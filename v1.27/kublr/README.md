# To reproduce

## Set up the cluster

1. Download and install Kublr Control Plane [documentation](https://docs.kublr.com/quickstart/)
1. Create new Kubernetes cluster using Kublr Control Plane.

When the cluster is up and running,

1. Download the kubeconfig file.
2. Set the `KUBECONFIG` environment variable `export KUBECONFIG=$(pwd)/kubeconfig`.

The Kublr Demo/Installer is a simple and convenient demo version of Kublr running in Docker that allows you deploy Kubernetes clusters. You can also install a non-production licensed version of the full Kublr Platform from the Kublr Demo/Installer.

By downloading and using the Kublr Demo/Installer and Kublr, you agree to the [Terms of Use](https://docs.kublr.com/terms-of-use) and [Privacy Policy.](https://docs.kublr.com/privacy-policy)

### Running Kublr

Linux:

    sudo docker run --name kublr -d --restart=unless-stopped -p 9080:9080 kublr/kublr:1.26.0

Windows:

    docker run --name kublr -d --restart=unless-stopped -p 9080:9080 kublr/kublr:1.26.0


### Kublr Installation Guide

#### What you should know about the Kublr Demo/Installer

The Kublr Demo/Installer is a lightweight platform that allows you to run a demo or limited functionality, dockerized Kublr version. You can use it to:

* Manage a standalone Kubernetes cluster;
* Manage the full feature Kublr Platform;

The Kublr Demo/Installer stores all data about the clusters inside the Docker container. Therefore, if you delete the Docker container, you will lose all cluster and Kublr platform related data — though you won't lose the cluster and platform itself. The Kublr team recommends using the Kublr Demo/Installer to verify that a Kubernetes cluster can be created in your environment. So, test it before deploying a full and more permanent Kublr Platform in the cloud or on-premise. 

#### Kublr Demo/Installer Installation Prerequisites

1. Download and install [Docker](https://store.docker.com/search?offering=community&type=edition)
1. 64-bit operating system to run the Kublr Demo/Installer
1. To deploy a Kubernetes cluster or the full Kublr Platform, you’ll need an AWS, Azure, GCP account or an on-premise environment.

#### Running Kublr

Open a terminal and launch following command:

    sudo docker run --name kublr -d --restart=unless-stopped -p HOST_PORT:9080 -e KUBLR_HOST=HOST_IP:HOST_PORT kublr/kublr:1.26.0
    
>**Note** Hereinafter, "sudo" is Linux specific - omit it to get command for Windows.

* HOST_PORT is a port available both on you workstation for the browser and available outside, from the network;

Here's a Kublr Demo/Installer launch command example:


    sudo docker run --name kublr -d --restart=unless-stopped -p 9080:9080 kublr/kublr:1.26.0

The Kublr UI will be available on https://localhost:9080 (admin/kublrbox)

>**Note** There can be a different address depending on your environment. Read carefully for the Kublr in Docker start notification text, as it may contain information about the access adress.

If you are going to set up a bare metal cluster on the Kublr platform, please add this additional parameter KUBLR_HOST, where the HOST_IP is available for cluster nodes:

    sudo docker run --name kublr -d --restart=unless-stopped -p HOST_PORT:9080 -e KUBLR_HOST=HOST_IP:HOST_PORT kublr/kublr:1.26.0

If you have already started the Kublr Demo/Installer without the option KUBLR_HOST or your IP address has been changed (for example to switch networks), please use this command to correct the KUBLR_HOST:

    docker exec -i kublr /bin/bash -c 'echo "KUBLR_HOST=HOST_IP:HOST_PORT" > /ip.external'; docker restart kublr

#### Running Kublr in an air-gapped environment

In order to run the Kublr Demo/Installer in an air-gapped environment, please request the launch command via [email](mailto:contact@kublr.com?subject=AirGap Kublr Demo/Installer running command request) or use this [contact us form](https://kublr.com/contact-us/).

#### The Kublr UI

By default, the Kublr UI, Keycloak UI, and API will be available on the exposed port 9080. After downloading the Docker image, it will take less than a minute for Kublr to start and be viewable.

* The Kublr UI is available on HTTP: https://localhost:9080, use admin/kublrbox for login to Kublr UI;
* Keycloak is available on HTTP: https://localhost:9080/auth, use admin/admin to manage Keycloack;

If you use KUBLR_HOST to define the public IP address and public port number of the host running Kublr (e.g. 192.168.99.234:9981), run this command:

    sudo docker run --name kublr -d --restart=unless-stopped -p HOST_PORT:9080 -e KUBLR_HOST=HOST_IP:HOST_PORT kublr/kublr:1.26.0

Navigate to the following URLs:

* https://HOST_IP:HOST_PORT - Kublr UI (admin/kublrbox);
* https://HOST_IP:HOST_PORT/auth - Keycloack (admin/admin);

#### Complete Your Profile

On first logon into Kublr, you will be prompted to complete your profile. Set your first and last names and valid business email address.

![Complete Your Profile](https://docs.kublr.com/images/complete_profile.png)

The "valid business email address" means that your email at most public domains (like "...@google.com", "...@ÿahoo.com" etc.) will not be accepted - instead you should use your organization or other private domain.

### Connect Kublr and create a Cluster Azure

For instructions on deploying cluster on other supported cloud platforms or baremetal, see [Documentation](https://docs.kublr.com/installation/).
> **MICROSOFT - OFFICIAL PARTNERSHIP** On Jun 29 2021, Microsoft's Azure Arc officially [declared](https://techcommunity.microsoft.com/t5/azure-arc-blog/technology-amp-services-partners-are-jumping-on-the-bandwagon-of/ba-p/2478102) Kublr one of its technology partners.

Steps below describe how to use Kublr to create a cluster in Microsoft Azure infrastructure and deploy a simple application (WordPress). The following steps are described:

1. Connecting Azure and Kublr.
1. Creating Kubernetes cluster in Azure with Kublr.
1. Installing and configuring **kubectl**.
1. Application example: deploying WordPress to cluster using Helm.

## Connecting Microsoft Azure and Kublr

1. Log into Kublr using your credentials.
1. On the left menu, click **Credentials**.
1. Click **Add Credentials**.
![Add Credentials](https://docs.kublr.com/images/add_credentials.png)
    The **ADD CREDENTIALS** dialog is displayed.
1. In the **ADD CREDENTIALS** dialog, set **Credentials Type** to "Azure Credentials". The dialog is updated to display the Azure credentials specific fields.
1. Enter **Credentials Name**.
1. Set:
    * **Tenant ID**
    * **Subscription ID** 
    * **Client ID** 
    * **Client Secret**
![Add Credentials Azure](https://docs.kublr.com/images/add_credentials-azure.png)
1. Click **Save Credentials**. The "Credentials have been successfully created." popup will be displayed.
1. To verify if credentials are valid and ready to be used, mouse over the created credentials and click the displayed **Test** button.

    Verification success popup will be displayed.
1. Click **Ok**.

## Creating Kubernetes Cluster in Azure with Kublr

To add a new cluster:

1. On the left menu, click **Clusters**.
1. Click **Add Cluster**.
![Add New Cluster](https://docs.kublr.com/images/add_cluster.png)
The **Select Installation Type** dialog is displayed.
1. In the **[Select Installation Type](https://docs.kublr.com/installation/platform-vs-cluster/)** dialog, select **Platform** or **Cluster**.
1. Click **Continue Setup**.
![Installation Type - Cluster](https://docs.kublr.com/images/installation-type-cluster.png)
The add cluster/platform dialog is displayed.
1. Set **Provider** to "Microsoft Azure".
1. From the **Credentials** list, select previosly created Azure credentials.

    If credentials were not created previously, use **Add New Credentials**.

1. Specify **Cluster Name**.
1. Set:
    * **Region**
    * **Kublr Agent**
    * **Kubernetes Version**
![Azure-Add Cluster-General Settings](https://docs.kublr.com/images/Azure_add-cluster_general-settings.png)

1. Optionally, set [Advanced Options](https://docs.kublr.com/installation/advanced_options/).
1. Use the **`INSTANCES`** tab to set:

    * Basic [parameters](https://docs.kublr.com/installation/cluster_platform-parameters/) for you master and working nodes.
    * [Public SSH key](https://docs.kublr.com/installation/parameters/public_ssh_key/) (required) for logging to master or worker nodes via SSH.
    * Optionally, [Advanced Options](https://docs.kublr.com/installation/advanced_options/) for them.
    
    ![Azure-Add Cluster-Master Configuration](https://docs.kublr.com/images/Azure-add_cluster-master_configuration.png)
    
    > **Note** For your working nodes, you can have as many intance groups as you need (clone or delete the current instance group, or add another one). If necessary, give specific name to each group.
      
    ![Instance Group-Operations](https://docs.kublr.com/images/instance_group-operations.png)

1. Use the **`FEATURES`** tab to select and configure [FEATURES](https://docs.kublr.com/installation/cluster_platform-features/) that you want to include into your cluster.
![AWS-Add Cluster-Features Configuration](https://docs.kublr.com/images/Azure-add_cluster-features_configuration.png)

1. Click the **`REVIEW & CREATE`** tab.
1. Review your cluster parameters.
1. At the bottom of the dialog, click **CONFIRM AND INSTALL**. 

    A notification is displayed "Your cluster is being created. It might take a few minutes."
1. In the notification window, click **OK**.

    Your new cluster page is displayed on the **Events** tab showing the cluster creation progress.
    
After the cluster becomes ready, use **Download Kube Config File** link on **Overview** tab.  This will download admin kubeconfig file which you can supply to sonobuoy, kubectl, helm and other tools to test and manage your cluster.

## Run the conformance test

Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```bash
$ go get -u -v github.com/heptio/sonobuoy

$ sonobuoy run --mode=certified-conformance
```

Then the status commands `$ sonobuoy status` indicate that the execution is completed, you can download the results.
```bash
$ outfile=$(sonobuoy retrieve)
```

untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
```bash
$ mkdir ./results; tar xzf $outfile -C ./results
```
