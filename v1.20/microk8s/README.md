# Reproducing the test results

## Deploy MicroK8s

Follow the instructions at https://microk8s.io to snap install microk8s on two machines.
```console
% sudo snap install microk8s --channel 1.20/stable --classic
```

Create a cluster by running on the first machine:
```console
% sudo microk8s.add-node
```

Use the connection string on the second machine to form the cluster:
```console
% microk8s join 172.31.91.72:25000/e3a925fc93db35470c4c7d1fb40d6d12
``` 

On the first machine that acts as the master enable DNS and allow priviledged containers:
```console
% sudo microk8s.enable dns
```

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
% wget https://github.com/heptio/sonobuoy/releases/download/v0.20.0/sonobuoy_0.20.0_linux_amd64.tar.gz
% tar -zxvf ./sonobuoy_0.20.0_linux_amd64.tar.gz
% sudo ./sonobuoy run --mode certified-conformance --kubeconfig /var/snap/microk8s/current/credentials/client.config --kube-conformance-image k8s.gcr.io/conformance:v1.20.0
% sudo ./sonobuoy status --kubeconfig /var/snap/microk8s/current/credentials/client.config
% sudo ./sonobuoy retrieve --kubeconfig /var/snap/microk8s/current/credentials/client.config
```
