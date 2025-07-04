### TenxCloud
Tenxcloud is a professional cloud-native application and data platform service provider [Tenxcloud](https://tenxcloud.com/).

### How to use

#### Create Cluster

First, you need to contact [Tenxcloud](https://tenxcloud.com/) staff to apply for a complete installation package, and then install it according to the installation manual. Tenxcloud provides an offline installation and deployment script to help you install quickly.
After the initial installation is complete, you can install the Kubernetes cluster by following the steps below:
1. Navigate to [Management Workbench/Cluster Management] on the platform and enter the general cluster list page.
2. Click "Add Cluster" to select the adding method. Select "Add Host to Build Self-built Kubernetes Cluster"
2. Follow the steps given in the prompts and execute the command on the host to add the cluster. After the addition is complete, there will only be a master node in the cluster. You can add worker nodes separately through the platform interface.

#### Run conformance Test by Sonobuoy

Execute the following command on the Tenxcloud Kubernetes cluster host

Install and run the sonobuoy conformance test tool：

```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
tar -xvf sonobuoy_0.57.3_linux_amd64.tar.gz
mv sonobuoy /usr/bin
sonobuoy run --mode=certified-conformance
```


Monitor the conformance tests by tracking the sonobuoy logs, and wait for the line: "no-exit was specified, sonobuoy is now blocking"
```
sonobuoy logs -f

```

Retrieve result:

```
outfile=$(sonobuoy retrieve)
mkdir ./results;
tar xzf $outfile -C ./results

```