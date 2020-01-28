# puppetlabs-kuberetes

puppetlabs-kubernetes is a Puppet module designed to bootstrap kubernetes clusters.

## Setup

- Download and install puppetlabs-kuberetes using your Puppet infrastructure using the instructions here: https://github.com/puppetlabs/puppetlabs-kubernetes/blob/master/README.md
- Alternatively the module can be deployed locally following the instructions here: https://github.com/puppetlabs/kream

## Reproduce Conformance Tests

Download the last binary release of Sonobuoy

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.16.5/sonobuoy_0.16.5_linux_amd64.tar.gz
```

Run Sonobuoy on the cluster
```
$ sonobuoy run --mode=certified-conformance
```

Get the results on local
```
$ sonobuoy retrieve .
```

Clean up Kubernetes objects created by Sonobuoy
```
$ sonobuoy delete
```
