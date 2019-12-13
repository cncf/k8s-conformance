# Reproducing the test results:

## Install Gardener on your Kubernetes Landscape
Follow the instructions on https://github.com/gardener/garden-setup

## Create Kubernetes Cluster

Login to SAP Gardener Dashboard to create a Kubernetes Clusters on Amazon Web Services, Microsoft Azure, Google Cloud Platform, Alibaba Cloud, or OpenStack cloud provider.

## Launch E2E Conformance Tests
Set the `KUBECONFIG` as path to the kubeconfig file of your newly created cluster (you can find the kubeconfig e.g. in the Gardener dashboard). Follow the instructions below to run the Kubernetes e2e conformance tests. Adjust values for arguments `k8sVersion` and `cloudprovider` respective to your new cluster.

```bash
#first set KUBECONFIG to your cluster
docker run -ti -e --rm -v $KUBECONFIG:/mye2e/shoot.config golang:1.13 bash

# run all commands below within container
go get github.com/gardener/test-infra; cd /go/src/github.com/gardener/test-infra
export GO111MODULE=on; export E2E_EXPORT_PATH=/tmp/export; export KUBECONFIG=/mye2e/shoot.config; export GINKGO_PARALLEL=false
go run -mod=vendor ./integration-tests/e2e --k8sVersion=1.16.2 --cloudprovider=openstack --testcasegroup="conformance"
```