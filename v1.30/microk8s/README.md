# Reproducing the test results

## Deploy MicroK8s

Follow the instructions at https://microk8s.io to snap install microk8s on two machines.
```sh
$ sudo snap install microk8s --channel 1.30/stable --classic
```

Create a cluster by running on the first machine:
```sh
$ sudo microk8s add-node
```

Use the connection string on the second machine to form the cluster:
```sh
$ sudo microk8s join 10.227.69.102:25000/d35aea1606887db2ea326ed6de93c321/cb463cb3b0e4 --worker
``` 

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

## Run Conformance Test

1. Download a [binary release](https://github.com/heptio/sonobuoy/releases) of sonobuoy, or build it yourself by running:
```sh
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz
$ tar -zxvf ./sonobuoy_0.57.1_linux_amd64.tar.gz
```

2. Run sonobuoy:
```sh
$ sudo ./sonobuoy run \
    --mode certified-conformance \
    --kubeconfig /var/snap/microk8s/current/credentials/client.config \
    --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/controller --ginkgo.v"
```

3. Check the status:
```sh
$ sudo ./sonobuoy status --kubeconfig /var/snap/microk8s/current/credentials/client.config
```

4. Retrieve results and extract
```sh
$ sudo ./sonobuoy retrieve --kubeconfig /var/snap/microk8s/current/credentials/client.config
```
