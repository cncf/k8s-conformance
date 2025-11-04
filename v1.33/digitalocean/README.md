# Conformance testing DigitalOcean Kubernetes

### Setup DigitalOcean Kubernetes cluster

The following instructions will help you configure and create a Kubernetes cluster on DigitalOcean:

```
$ doctl auth init

$ doctl kubernetes cluster create --version 1.33.1-do.0  do-sonobuoy-1331 --node-pool "name=conformance;size=s-4vcpu-8gb;count=3" --wait
```

Once the cluster has been created successfully, the kubectl context will automatically be updated to point at it.

> Further instructions can be found in our [product documentation](https://docs.digitalocean.com/products/kubernetes/how-to/create-clusters/).


### Run the conformance tests

Reproduce the conformance run using [hydrophone](https://github.com/kubernetes-sigs/hydrophone) with the following steps:

```
go install sigs.k8s.io/hydrophone@latest
hydrophone --conformance
```
The results (`e2e.log`, `junit_01.xml`) will be in the current directory.
