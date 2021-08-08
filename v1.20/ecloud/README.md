### How To Reproduce:

#### Create Account and Login

1. Access the [Ecloud Homepage]( https://ecloud.10086.cn/) , click [Register] in the upper right corner of the page;

 Click this [link]([10086.cn](https://ecloud.10086.cn/home/product-introduction/containerser)) to create a ECloud Account and login.

#### Login to Console

After login to the account, login to Console of Ecloud Kubernetes Container Service. 

After successful login, select “Product Services > Kubernetes Container Service” and enter the “Cluster Management > Cluster List” page. 

The “Cluster List” page will display all the created KCS cluster name/ID, status, region and other information and users can search the cluster through the cluster name. Please select and switch the region according to the actual needs.

#### Create Cluster

Create a Cluster in selected region, the cluster Kubernetes version by default is v1.20.1. Please Click “Create cluster” and enter the “Create cluster” page. Fill in cluster name and then fill in relevant configuration information according to your needs. For ssh to the nodes in the cluster, users need to enable FIP binding for the cluster nodes.

#### Access to Cluster

After the KCS cluster is created, you can view the created KCS cluster and cluster details in the cluster list. Click a cluster link in the “cluster name” column of the container list to enter the “cluster details” page to view the status information. The cluster will be setup in about 10 minutes, you can ssh or use VNC to get access to any node of the cluster.

#### Run Conformance Test

On one of the Kubernetes worker node, run command as below:

```
go get -u -v github.com/heptio/sonobuoy

sonobuoy run

sonobuoy status

sonobuoy logs

```

Wait for around 60 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```
sonobuoy retrieve .

mkdir ./results; tar xzf *.tar.gz -C ./results

```



