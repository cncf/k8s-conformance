# Conformance testing CloudControl AppZ Platform Kubernetes Cluster

### Setup AppZ Platform Kubernetes Cluster

Install AppZ Platform Kubernetes Cluster from AWS Marketplace https://aws.amazon.com/marketplace/pp/B08L5DQVTB

Further instructions can be found in our [product documentation](https://docs.ecloudcontrol.com/installer-3.0/aws-marketplace/).

### Run the conformance tests

Once you've created a cluster, downloaded the kubeconfig and configured your kubectl to use it, you reproduce the conformance run with the following steps:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then inspect plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
