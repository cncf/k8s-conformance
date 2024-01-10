# To reproduce:

## Create Kubernetes Cluster and install Robin CNP using the gorobin utility

Install and Setup

ROBIN installer is shipped as a package of files. Make sure all three are downloaded into the same directory before running the installer.

gorobin – the actual utility that does the installation

gorobintar-<VERSION>-bin.tar - Contains the helper scripts needed for installing Robin CNP  

robinimg-<VERSION>.tar.gz – contains docker images of the ROBIN software

k8s-images-<VERSION>.tar.gz – contains docker images of all Kubernetes components


The tarball contains all the needed packages and images so that the installation can proceed without requiring access to the internet.

Installation
In a non-HA installation, provide the comma separated FQDN of the hosts where Robin CNP needs to be installed. The first machine is installed as a server while the subsequent ones are installed as agents. Use the following command to install ROBIN:

$ ./gorobin_<version> onprem install-nonha --hosts <hostnames> --gorobintar <path-to-gorobin-tarball>


To log into the ROBIN server, run the following command using the username created in step 1 and provide the password when prompted:

$ robin login admin
  Password:
  User robin is logged in


After the installation and configuration, add the test cluster and launch the Kubernetes e2e conformance tests.

## Kubernetes e2e conformance test

1. Download the binary release of sonobuoy
    ```shell
    curl -O https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.4/sonobuoy_0.56.4_linux_amd64.tar.gz
    tar -xvf sonobuoy_0.56.4_linux_amd64.tar.gz
    sonobuoy run  --mode=certified-conformance
    sonobuoy status
    sonobuoy retrieve .
    cd results/plugins/e2e/results/
