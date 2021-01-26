# Kubernetes conformance testing on Swisscom Kubernetes Service

## Create a new cluster
The following steps are used to setup a Swisscom managed Kubernetes cluster. Should you need further instructions, please refer to the [documentation](https://docs.entcloud.swisscom.com/guide/managed-services/managed-kubernetes/how-to/#order-a-cluster).

1. Log in to your account on the portal of Swisscom's Enterprise Service Cloud. A tenant for your company must already exist.
2. Select the "Kubernetes Cluster" item in the Catalog.
3. Choose a plan size (e.g. 2c8r.small) and a pre-existing environment in the according dropdowns. Specify a hostname (e.g. mycluster.swisscom.com), an initial number of worker nodes (minimum 1) and a DNS address (e.g. your company's DNS server).
4. Submit the form, this will create your Kubernetes cluster.
5. In your list of deployments, find your new cluster and select the "Get Kubernetes Credentials" action. This will give you a default accound that you can use to access your cluster.


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