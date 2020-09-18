# To reproduce: 

## Create Kubernetes Cluster 

Install and Setup

ROBIN installer is shipped as package of 3 files. Make sure all three are downloaded into the same directory before running the installer.

robin-install-k8s-<VERSION>.sh – the actual install script

robinimg-<VERSION>.tar.gz – contains docker images of the ROBIN software

k8s-images-<VERSION>.tar.gz – contains docker images of all Kubernetes components

The installer itself is a single file (robin-install-k8s-<VERSION>.sh), but the other two files are provided so that the installation can proceed without requiring access to the internet.

Installation
In a non-HA installation, the first machine is installed as a server while the subsequent ones are installed as agents. Use the following command to install ROBIN server on the first node:

$ ./robin-install-k8s-<VERSION>.sh server --username=<admin_username> --password=<password> --robin-image-archive=/path_to/robinsrcimg-<VERSION>.tar.gz --k8s-image-archive=/path_to/k8s-images-<VERSION>.tar.gz

At this point, the ROBIN server installation is complete.

To log into the ROBIN server, run the following command using the username created in step 1 and provide the password when prompted:

$ robin login robin
  Password:
  User robin is logged in

Now that the ROBIN server is installed successfully, the next step is to install the ROBIN agent on all the remaining nodes. Copy
the three installation files all nodes that are going to be part of ROBIN cluster. Connect to the terminal of the nodes and run
the commands below to install the agent. The `<ip_address>` refers to the IP address of the ROBIN management server installed in the prior step:

$./robin-install-k8s_5.0.2.sh agent --server=<ip_address> --username=robin --password=password --k8s-image-archive=/root/k8s-images-5.0.2.tar.gz --robin-image-archive=/root/robinbinimg-5.0.2.tar.gz

After the installation and configuration, add the test cluster and launch the Kubernetes e2e conformance tests.

## Kubernetes e2e conformance test

1. Download the binary release of sonobuoy
    ```shell 
    curl -O https://github.com/heptio/sonobuoy/releases/download/v0.11.6/sonobuoy_0.11.6_linux_amd64.tar.gz
    sonobuoy run
    sonobuoy status
    sonobuoy retrieve .
    cd results/plugins/e2e/results/
    ``` 
