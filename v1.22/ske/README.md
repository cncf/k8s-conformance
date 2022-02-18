## Setup SKE (SCP Kubernetes Engine) cluster

SKE allows you to quickly deploy a production ready Kubernetes cluster in Samsung Cloud Platform (SCP).

To start using Kubernetes Engine services, follow these steps:
1. Select a project from the project list in the top menu.
2. Click All Products in the side menu.
3. In the Containers area, click Kubernetes Engine.

Users can apply for Kubernetes Engine products after setting the cluster details.

To apply for Kubernetes Engine, you need the following products:
- VPC
- Subnets
- File Storage
- Security Groups

## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following command : 

```
download latest sonobuoy (https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.56.1)
$ tar -zxvf sonobuoy_0.56.1_linux_amd64.tar.gz
$ cp sonobuoy /usr/bin/sonobuoy
$ sonobuoy run
```

Watch Sonobuoy's logs with:

```
$ kubectl logs -f [[POD_NAME]] -n sonobuoy e2e 
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then copy the results using docker cp command
