### How To Reproduce:

#### Create Account and Login

Click this [link](https://login.bce.baidu.com/reg.html?tpl=bceplat&from=portal) to create a Baidu Cloud Account and login to Baidu Cloud Account from [here](https://login.bce.baidu.com/).

#### Login to Console

After login to the account, login to Console of Baidu Cloud Container Engine in English from [here](https://console.bce.baidu.com/cce/?locale=en-us#/cce/cluster/list). 

After successful login, select “Product Services > Container Engine CCE” and enter the “Cluster Management > Cluster List” page. 

The “Cluster List” page will display all the created CCE cluster name/ID, status, region and other information and users can search the cluster through the cluster name. Please select and switch the region according to the actual needs.

#### Create Cluster

Create a Cluster in Hong Kong region, the cluster Kubernetes version by default is v1.16.3. Please Click “Create cluster” and enter the “Create cluster” page. Fill in cluster name and then fill in relevant configuration information according to your needs. For ssh to the nodes in the cluster, users need to enable EIP binding for the cluster nodes.

#### Access to Cluster

After the CCE cluster is created, you can view the created CCE cluster and cluster details in the cluster list. Click a cluster link in the “cluster name” column of the container list to enter the “cluster details” page to view the status information. The cluster will be setup in about 5 minutes, you can ssh or use VNC to get access to any node of the cluster.

#### Run Conformance Test

On one of the Kubernetes worker node, run command as below:

```
go get -u -v github.com/heptio/sonobuoy

sonobuoy run

sonobuoy status

sonobuoy logs

```

Wait for around 50 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```
sonobuoy retrieve .

mkdir ./results; tar xzf *.tar.gz -C ./results

```



