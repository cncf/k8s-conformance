# k0s Conformance 
## k0s - Zero Friction Kubernetes

Full instructions on how to set up a k0s cluster can be found [here](https://github.com/k0sproject/k0s/blob/main/docs/create-cluster.md).
## Requirements
k0s runs either as a single node (controller with `--enable-worker`), or as a controller/worker cluster.
These instructions assume you have one or more linux or arm boxes ready for installation.

Download the k0s v1.26.0+k0s.0 binary from [releases](https://github.com/k0sproject/k0s/releases/v1.26.0+k0s.0) and push it to all the nodes you wish to connect to the cluster.

## Cluster Setup
#### Single node
```
$ k0s controller --enable-worker
```
#### Multiple nodes
##### Controller
```
$ k0s controller
```
Once k0s on the controller is up, create a join token
```
$ k0s token create --role=worker
```
##### Joining Workers To The Cluster
```
$ k0s worker "long-join-token"
```
## Run the Conformance Test

To run the conformance test, download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of sonobuoy, or build it yourself by running:
```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```
Deploy a Sonobuoy pod to your cluster with:
```
$ export KUBECONFIG=/var/lib/k0s/pki/admin.conf
$ sonobuoy run --mode=certified-conformance --kube-conformance-image-version=v1.26.0
```
The test will take more than an hour to complete, but you can follow the logs by running:
```
$ sonobuoy logs -f
```
To view actively running pods:
```
$ sonobuoy status
```
Example:
```
root@controller-0:~# sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT
            e2e   complete   passed       1
   systemd-logs   complete   passed       3

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Once the tests complete, retrieve the results file by running:
```
$ sonobuoy retrieve
```
