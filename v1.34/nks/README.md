## Kubernetes conformance tests on NKS
### Create an NKS cluster
* Create a Kubernetes cluster to run conformance tests using the NHN Cloud web console.  
    * To enable NHN Kubernetes Service (NKS), a cluster must be created. Go to Container > NHN Kubernetes Service (NKS) and click Create Cluster, and a page for creating clusters shows up. The following items are required to create a cluster: Cluster Name, Kubernetes Version, VPC, Subnet, Image, Avalability Zone, Flavor, Node Count, Key pair, Block Storage Type, Block Storage Size
    * Enter information as required and click Create Cluster, and a cluster begins to be created. You can check the status from the list of clusters. It takes about 10 minutes to create; more time may be required depending on the cluster configuration.

### Run conformance tests
```
$ export KUBECONFIG={DOWNLOADED_KUBECONFIG_FILE}
$ go get -u -v github.com/vmware-tanzu/sonobuoy
$ sonobuoy run --mode=certified-conformance
$ sonobuoy status
$ sonobuoy logs
$ sonobuoy retrieve ./results
```
