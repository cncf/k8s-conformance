# conformance test for IKS

## Setup IKS Cluster
To run the Kubernetes conformity test, you create the IKS Cluster by referring to this [link](https://manual.kinx.net/ixcloud/ixcloud/kubernetes/CreateCluster).  
The node specification generated three 4Core 4GBs.  
One Connector node per IKS cluster is provided by default.  
1. Add the IP of the host to which you want to connect ssh to the security group to connect to the Connector node that is created during cluster creation.
2. Additionally, add tenant network bands to the worker nodes and connector node security groups.


## Sonobuoy Test on connector node

The kubconfig of the iks cluster is already configured on the connect node. The conformity test can be carried out through the command below.
```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.8/sonobuoy_0.56.8_linux_amd64.tar.gz

$ tar -xvf sonobuoy_0.56.8_linux_amd64.tar.gz

$ mv sonobuoy /usr/local/bin/

$ sonobuoy run --mode=certified-conformance

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
