## How to Reproduce:

### Before start:

You must register a UCloud account following [this](https://passport.ucloud.cn/#register).

### Create UK8S Cluster

After login into UCLoud Console，you can create a UK8S Cluster in Hong Kong region in this [pages](https://console.ucloud.cn/uk8s/manage). The Kubernetes Version is v1.20.6 by default.

1. Click "Create Cluster" Button.
2. Choose a dedicated / hosted cluster version. If you choose a dedicated cluster, 3 master nodes are required. If you choose a hosted version, we will maintain the masters and core componenets like apiserver, etcd, scheduler for you.
3. Config Masters(in dedicated version) and Nodes, or you can just use the default configuration.
4. Set password for logging into instances in the cluster.
5. Click "Purchase Now" button, the k8s cluster will running in about ten minutes later;

### Access Cluster

The Nodes can't access from Internet until you bind a EIP to the instance. You can bind EIP to any nodes in [uhost page](https://console.ucloud.cn/uhost/uhost).
After did that, you can ssh to the node or master.

### Run Conformance Test

Run command as below:

```
# install golang first.
go get -u -v github.com/heptio/sonobuoy
sonobuoy run
sonobuoy status
sonobuoy logs
```

Wait for abount 2 hours for the test to be finished.once sonobuoy status shows the run as completed to indicate that the test has been finished, then run the following command to extract the test results.

```
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```
