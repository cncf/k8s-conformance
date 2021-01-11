# Kubernetes conformance testing on Swisscom Kubernetes Service

## Create a new cluster
Setup a Swisscom managed Kubernetes cluster from [here](https://docs.entcloud.swisscom.com/guide/managed-services/managed-kubernetes/how-to/#order-a-cluster).


## Run conformance tests
```
$ sonobuoy run --mode=certified-conformance
$ sonobuoy status

# After sometime you can retrieve the results using:
$ results=$(sonobuoy retrieve)
$ sonobuoy results $results
# untar the archive, then inspect plugins/e2e/results/global/{e2e.log,junit_01.xml}
```

For more information, please refer 

https://docs.entcloud.swisscom.com/guide/managed-services/managed-kubernetes/