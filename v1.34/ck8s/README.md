# Reproducing the test results

## Deploy Canonical Kubernetes

Follow the instructions at https://documentation.ubuntu.com/canonical-kubernetes/release-1.34/snap/tutorial/add-remove-nodes/ to install Canonical Kubernetes on two machines.

Create a cluster by running on the first machine:
```sh
$ sudo snap install k8s --channel 1.34-classic/stable --classic
$ sudo k8s bootstrap
```

Get a join token for the second node to join the cluster:
```sh
$ sudo k8s get-join-token <second-node-hostname> --worker
```

Use the join token on the second machine to form the cluster:
```sh
$ sudo snap install k8s --channel 1.34-classic/stable --classic
$ sudo k8s join-cluster <join-token>
``` 

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

## Run Conformance Test

1. Download a [binary release](https://github.com/heptio/sonobuoy/releases) of sonobuoy, or build it yourself by running:
```sh
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.2/sonobuoy_0.57.2_linux_amd64.tar.gz
$ tar -zxvf ./sonobuoy_0.57.2_linux_amd64.tar.gz
```

2. Run sonobuoy:
```sh
$ sudo ./sonobuoy run \
    --plugin e2e
    --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v"
    --mode certified-conformance \
    --kubeconfig /etc/kubernetes/admin.conf \
```

3. Check the status:
```sh
$ sudo ./sonobuoy status --kubeconfig /etc/kubernetes/admin.conf
```

4. Retrieve results and extract
```sh
$ sudo ./sonobuoy retrieve --kubeconfig /etc/kubernetes/admin.conf
```
