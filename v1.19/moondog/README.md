# Conformance tests for the Moondog suite installer

## Prerequisites

NOTE: Moondog is only installable on AWS at this time.

* git
* aws-cli
* terraform
* kubectl
* helm

## Get and run the install script

Installation instructions will be available at https://moondog.co when Moondog goes public. If you would like more information on this process please contact info@revelry.co and we will be happy to walk you through the installation process personally! Thanks.

After installation, give the cluster some time to bootstrap itself.

## Point kubectl at your newly-bootstrapped cluster

```
kubectl config use-context <your cluster context>
```

## Start the conformance tests

Follow the official guide: https://github.com/revelrylabs/k8s-conformance/blob/master/instructions.md

In this case, we ran sonobuoy from a Mac:

```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.1/sonobuoy_0.17.1_darwin_amd64.tar.gz
tar -zxvf sonobuoy_0.17.1_darwin_amd64.tar.gz
cd sonobuoy_0.17.1_darwin_amd64
./sonobuoy run --mode=certified-conformance
```

## Wait for tests to complete

Check with:

```
./sonobuoy status`
```

## Retrieve results

```
outfile=$(./sonobuoy retrieve)
mkdir ./results
tar xzf $outfile -C ./results
```
