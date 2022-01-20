## Kubernetes conformance tests on NKS
### Create an NKS cluster
* Create a Kubernetes cluster to run conformance tests using the NHN Cloud web console.  
* Download the kubeconfig file for the cluster from the web console. 
* For additional instructions to create a Kubernetes cluster, please refer to the [quickstart guide.](https://docs.toast.com/en/Container/Kubernetes/en/user-guide/)

### Run conformance tests
```
$ export KUBECONFIG={DOWNLOADED_KUBECONFIG_FILE}
$ go get -u -v github.com/vmware-tanzu/sonobuoy
$ sonobuoy run --mode=certified-conformance
$ sonobuoy status
$ sonobuoy logs
$ sonobuoy retrieve ./results
```
