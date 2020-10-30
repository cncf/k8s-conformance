# Conformance testing DigitalOcean Kubernetes

### Setup DigitalOcean Kubernetes cluster

The following instructions will help you configure and create a Kubernetes cluster on DigitalOcean:

```
$ doctl auth init

$ doctl kubernetes cluster create --version 1.19.3-do.0 do-sonobuoy-1193 --node-pool "name=conformance;size=s-4vcpu-8gb;count=3" --wait
```

Once the cluster has been created successfully, the kubectl context will automatically be updated to point at it.

> Further instructions can be found in our [product documentation](https://www.digitalocean.com/docs/kubernetes/how-to/create-cluster/).

### Download Sonobuoy

Download the right [Sonobuoy 1.19.0](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.19.0) tarball for your machine and unpack it:

```shell
tar xvzf sonobuoy_*.tar.gz
```

### Run the conformance tests

Reproduce the conformance run with the following steps:

```shell
./sonobuoy run

./sonobuoy status

./sonobuoy logs

./sonobuoy retrieve ./results
```

Untar the tarball in `./results`, then inspect `plugins/e2e/results/global/{e2e.log,junit_01.xml}`.
