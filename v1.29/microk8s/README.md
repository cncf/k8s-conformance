# Reproducing the test results

## Deploy MicroK8s

Follow the instructions at https://microk8s.io to snap install microk8s on two machines.
```sh
$ sudo snap install microk8s --channel 1.29/stable --classic
```

Create a cluster by running on the first machine:
```sh
$ sudo microk8s.add-node
```

Use the connection string on the second machine to form the cluster:
```sh
$ sudo microk8s join 172.31.1.94:25000/e6ffa50103758cf48b68692abca7b28c/e2d8c739ca8f --worker
``` 

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

## Run Conformance Test

1. Download a [binary release](https://github.com/heptio/sonobuoy/releases) of sonobuoy, or build it yourself by running:
```sh
$ go install github.com/vmware-tanzu/sonobuoy@latest
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
