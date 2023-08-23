# Reproducing the test results

## Deploy MicroK8s

Follow the instructions at https://microk8s.io to snap install microk8s on two machines.
```console
% sudo snap install microk8s --channel 1.27/stable --classic
```

Create a cluster by running on the first machine:
```console
% sudo microk8s.add-node
```

Use the connection string on the second machine to form the cluster:
```console
% sudo microk8s join 172.31.1.94:25000/e6ffa50103758cf48b68692abca7b28c/e2d8c739ca8f
``` 

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
% wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.16/sonobuoy_0.56.16_linux_amd64.tar.gz
% tar -zxvf ./sonobuoy_0.56.16_linux_amd64.tar.gz
% sudo ./sonobuoy run --mode certified-conformance --kubeconfig /var/snap/microk8s/current/credentials/client.config --kube-conformance-image k8s.gcr.io/conformance:v1.27.0 --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/controller --ginkgo.v"
% sudo ./sonobuoy status --kubeconfig /var/snap/microk8s/current/credentials/client.config
% sudo ./sonobuoy retrieve --kubeconfig /var/snap/microk8s/current/credentials/client.config
```
