## Setup SKE (SCP Kubernetes Engine) cluster

SKE allows you to quickly deploy a production ready Kubernetes cluster in Samsung Cloud Platform (SCP).
Users can apply for Kubernetes Engine products after setting the cluster details.

To apply for Kubernetes Engine, you need the following products:
- VPC
- Subnets
- File Storage
- Security Groups


To start using Kubernetes Engine services, follow these steps:
1. Select a project from the project list in the top menu.
2. Click All Products in the side menu.
3. Click Networking menu and creart VPC, subnet
4. Click Storage menu and create File storage
5. Click Secruity Group and create Secruity Group
6. Click Kubernetes Engine under containers menu.

# Create Control-plane
1. Select you project, zone
2. Enter Cluster Name, Kubernetes version
3. Enter Subnet, File storage, Secutiry Group which created for service
4. Click Create after checking the price of the product

# Create Node pool
After the control-plane is created, the node pool is added:
1. Click Add Node pool
2. Enter the desired number of nodes, os type, and CPU, MEMORY, and GPU information etc.
3. Get your kubeconfig, enjoy your kubernetes service.

## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following command : 

```
download latest sonobuoy (https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.56.12)
$ tar -zxvf sonobuoy_0.56.12_linux_amd64.tar.gz
$ cp sonobuoy /usr/bin/sonobuoy
$ sonobuoy run
```

Watch Sonobuoy's logs with:

```
$ kubectl logs -f [[POD_NAME]] -n sonobuoy e2e 
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then copy the results using docker cp command
