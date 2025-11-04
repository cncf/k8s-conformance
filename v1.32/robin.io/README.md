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

    wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_386.tar.gz

    tar -xvf sonobuoy_0.57.3_linux_386.tar.gz
    LICENSE
    sonobuoy
 
    chmod a+x sonobuoy

2. Run in certified conformance mode

    ./sonobuoy run --mode=certified-conformance
    INFO[0000] create request issued                         name=sonobuoy namespace= resource=namespaces
    INFO[0000] create request issued                         name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
    INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
    INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
    INFO[0000] create request issued                         name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
    INFO[0000] create request issued                         name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
    INFO[0000] create request issued                         name=sonobuoy namespace=sonobuoy resource=pods
    INFO[0000] create request issued                         name=sonobuoy-aggregator namespace=sonobuoy resource=services

3. Wait for a completion (An hour or more.)

    ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT                                PROGRESS
            e2e   complete   passed       1   Passed:  0, Failed:  0, Remaining:411
   systemd-logs   complete   passed       3

4. Retrieve results and obtain xml and log files for checkin

    ./sonobuoy retrieve
    202505292304_sonobuoy_c245926f-d881-4b31-a82c-2ac5db727e44.tar.gz

    tar xzf 202505292304_sonobuoy_c245926f-d881-4b31-a82c-2ac5db727e44.tar.gz -C ./results
    cd /root/plugins/e2e/results/global

    ls
    e2e.log  junit_01.xml

    ls -latrh
    total 2.3M
    -rw-r--r-- 1 robin 2000 2.2M May 29 17:54 junit_01.xml
    -rw-r--r-- 1 robin 2000 7.8K May 29 17:54 e2e.log
    drwxr-sr-x 3 robin 2000   20 May 29 17:54 ..
    drwxr-sr-x 2 robin 2000   41 May 29 19:10 .
    
    date
    Thu May 29 19:12:32 PDT 2025
