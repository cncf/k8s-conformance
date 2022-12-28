# Conformance tests for ks8plus's Kubernetes

## Setup the k8splus and the Kubernetes cluster
First install k8splus, them create a cluster with k8splus in the [documentation](https://lionelpang.github.io/k8splus/docs/index.html).

1. System Requirements
* Operating system of CentOS 7.6 or above.   
* Hard disk: minimal 30 GB available disk space (40GB+ recommended, increasing based on the needs of your container workloads)
* 2 CPUs or more
* If the host cannot access the Internet at all, you need to modify the yum source.  
* Confirm that the docker service is not installed on each host (due to the different version and storage location of the docker service installed by yourself, the installation fails).  
* Turn off SELinux and firewall, disable fireall service.

2 Install k8spluls
Download to the installation media through Baidu cloud disk, and execute the following command to install:
```bash
sudo sh k8splus.sh
```
When logging in k8splus for the first time, provide the machine fingerprint, and send the machine fingerprint to the email of pangms@asiainfo.com to obtain the serial number to activate the k8splus service.

3 Install kubernetes cluseter
The steps to Install a cluster are as follows:
a. Add the host to the system in background management > Cluster Management > host management;  
b. Create a cluster in background management > Cluster Management > cluster management;  
c. View the cluster details in background management > Cluster Management > cluster management, click the Add button to add the cluster node. Change the IP of Yum source and sys docker registry to the IP of the host of k8splus, and click next to install the cluster.  

## Run Conformance Test

1. Download a binary release of [sonobuoy](https://github.com/heptio/sonobuoy/releases), or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

2. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

3. Check test status:
```
sonobuoy status
        PLUGIN     STATUS   RESULT   COUNT                 PROGRESS
            e2e   complete   passed       1   Passed:362, Failed:  0
   systemd-logs   complete   passed       3

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

4. Retrieve the results
```
sonobuoy retrieve
202207161401_sonobuoy_3828e6fe-3773-4116-b1e1-26375bda7310.tar.gz
```

5. Untar the results
```
tar xvf 202212070748_sonobuoy_658eb79d-b714-4b92-876f-387369c28c7b.tar.gz
```

6. Go to the results folder
```
cd plugins/e2e/results/global
```

7. Make sure the following 2 files are there
```
ls
e2e.log  junit_01.xml
```
