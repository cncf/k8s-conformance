# conformance test for IKS

## Setup IKS Cluster
To run the Kubernetes conformity test, you create the IKS Cluster by referring to this [link](https://manual.kinx.net/ixcloud/ixcloud/kubernetes/CreateCluster).  
### Step 1. Access the IXcloud console and click the 'Create Cluster' button  
### Step 2. Enter cluster information  
① Cluster Name : Enter a name for the cluster.  
※ Name for cluster discrimination and cannot be used in duplicate.  
② Description : Enter a description of the cluster.  
③ Kubernetes version: Select Kubernetes version.  
④ CNI types : Select CNI types.  
⑤ Key Pair : Select the key pair to use when connecting to the cluster.  
※ You can use existing keypairs or create new keypairs.  
⑥ Network : Select the network to associate with the cluster.  
⑦ Subnet : Select a subnet to associate with the network.  
⑧ Service Network : Enter the service network address in CIDR format.  
⑨ Pod Network : Enter the Pod Network address in CIDR format.  
### Step 3. Enter node group information  
① Node Group Name : Enter the name of the node group.  
② Description : Enter a description for the node group.  
③ Select Instance Specification : Select the specification for the instance.  
※ The node specification generated three 4Core 4GBs.  
④ Number of workers : Select the number of worker nodes.  
⑤ Boot Source : Select the boot source image.  
⑥ Authorized IP Support : Select whether to create an authorized IP.  
### Step 4. Check the final setting  
· Check the settings before completing the creation, then click the 'Create' button to complete the creation.  
· Cluster creation takes more than 20 to 30 minutes to complete.  
 
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

