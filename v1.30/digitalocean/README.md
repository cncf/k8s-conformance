# Conformance testing DigitalOcean Kubernetes

### Setup DigitalOcean Kubernetes cluster

The following instructions will help you configure and create a Kubernetes cluster on DigitalOcean:

```
$ doctl auth init

$ doctl kubernetes cluster create --version 1.30.4-do.0 do-sonobuoy-1304 --node-pool "name=conformance;size=s-4vcpu-8gb;count=3" --wait
```

Once the cluster has been created successfully, the kubectl context will automatically be updated to point at it.

> Further instructions can be found in our [product documentation](https://docs.digitalocean.com/products/kubernetes/how-to/create-clusters/).

### Download Sonobuoy

Download [Sonobuoy 0.57.1](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.57.1) tarball for your machine and unpack it:

```shell
tar xvzf sonobuoy_*.tar.gz
```

### Run the conformance tests

Reproduce the conformance run with the following steps:

```shell
./sonobuoy run --mode=certified-conformance --wait
outfile=$(./sonobuoy retrieve)
tar xvzf $outfile
```

Then inspect `plugins/e2e/results/global/{e2e.log,junit_01.xml}`.
