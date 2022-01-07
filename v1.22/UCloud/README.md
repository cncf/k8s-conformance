## How to Reproduce:

### Before start:

You must register a UCloud account following [this](https://passport.ucloud.cn/#register).

### Create UK8S Cluster

After login into UCLoud Console，you can create a UK8S Cluster in Hong Kong region in this [pages](https://console.ucloud.cn/uk8s/manage). The Kubernetes Version is v1.22.5. 

Make sure you choose HK region in order to get direct access to the gcr and docker repository.

1. Click "Create Cluster" Button.
2. Choose a dedicated / hosted cluster version. If you choose a dedicated cluster, 3 master nodes are required. If you choose a hosted version, we will maintain the masters and core componenets like apiserver, etcd, scheduler for you.
3. Config Masters(in dedicated version) and Nodes, or you can just use the default configuration.
4. Set password for logging into instances in the cluster.
5. Click "Purchase Now" button, the k8s cluster will running in about ten minutes later;

### Access Cluster

The Nodes can't access from Internet until you bind a EIP to the instance. You can bind an EIP to any nodes in [uhost page](https://console.ucloud.cn/uhost/uhost).
After did that, you can ssh to the node or master.

The Cluster uses the UCloud VPC to get connected to the UCloud intranet. In order to access the Internet, you need to create a [natgw](https://docs.ucloud.cn/vpc/briefguide/step4) and bind an EIP to the NAT.

### Run Conformance Test

#### Install the Sonobuoy Tool for Conformance Test

1. Install Go Environment
2. Download the [latest release][releases] for your client platform.
3. Extract the tarball:

   ```
   tar -xvf <RELEASE_TARBALL_NAME>.tar.gz
   ```

Move the extracted `sonobuoy` executable to somewhere on your `PATH`.

#### Complete the Conformance Test

```
sonobuoy run --mode=certified-conformance
sonobuoy status
sonobuoy logs
```

Wait for abount 2 hours for the test to be finished.once sonobuoy status shows the run as completed to indicate that the test has been finished, then run the following command to extract the test results.

```
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf *.tar.gz -C ./results
```
