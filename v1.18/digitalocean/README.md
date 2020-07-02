# Conformance testing DigitalOcean Kubernetes

### Setup DigitalOcean Kubernetes cluster

The following instructions will help you configure and create a Kubernetes cluster on DigitalOcean:

```
$ doctl auth init

$ doctl kubernetes cluster create --version 1.18.3-do.0 do-sonobuoy-1183 --node-pool "name=conformance;size=s-4vcpu-8gb;count=3" --wait

$ doctl kubernetes cluster kubeconfig save do-sonobuoy-1183
```

> Further instructions can be found in our [product documentation](https://www.digitalocean.com/docs/kubernetes/how-to/create-cluster/).

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
