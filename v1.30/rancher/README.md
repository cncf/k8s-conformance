# Conformance tests for Rancher 2.x Kubernetes

## Install Rancher Server

As per [documentation](https://ranchermanager.docs.rancher.com/pages-for-subheaders/installation-and-upgrade) install Rancher server on either a single node or HA mode.

The most basic installation is accomplished by running Rancher in Docker:
```
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:v2.9.0-alpha7
```

## Run Kubernetes Cluster

After running Rancher server, access Rancher server UI at `https://<ip>` and create a new cluster; please refer to the [documentation](https://ranchermanager.docs.rancher.com/pages-for-subheaders/kubernetes-clusters-in-rancher-setup) for more information about how to create a cluster, or follow the steps below:

* Upon accessing the UI, click `Add Cluster`, and select the Custom Cluster (Custom from existing nodes, AWS, Azure, DigitalOcean, Linode, vSphere).
* For the purposes of this test, create the following 3-node nodegroup configuration:
  * 1 node with all roles: `etcd, controlplane, worker`
  * 2 dedicated `worker` nodes
* Ensure that k8s version `v1.29.5-rancher1-1` is selected
* Disable the NGINX from the Advance Options
* Add the following extra_args: under the kube-api:
```
     extra_args:
       service-account-issuer: https://xx.xx.xx:6443 (xx.xx.xx.xx is controlplane public IP address)
     extra_args_array:
       service-account-issuer:
         - rke
```
* Click `Create Cluster`
* Make sure to add Public IP and Internal IP of node in Advance Options section.
* Run the registration command with the above mentioned configuration on already created nodes.

## Run Conformance Test

1. Once you Rancher Kubernetes cluster is active, Fetch it's kubeconfig.yml file and save it locally.

2. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```sh
$ go install github.com/vmware-tanzu/sonobuoy@latest
```

3. Configure your kubeconfig file by running:
```sh
$ export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

4. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

4. Watch the logs:
```sh
$ sonobuoy logs
```

5. Check the status:
```sh
$ sonobuoy status
```

6. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ sonobuoy retrieve
```

7. To clean up Kubernetes objects created by Sonobuoy, run:
```
$ sonobuoy delete
