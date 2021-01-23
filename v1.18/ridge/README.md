# Conformance testing Ridge Kubernetes Service

### Create RKS cluster

https://docs.ridge.co/reference/getting-started-1

### Run the conformance tests

To run the conformance test:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then inspect plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
