# Reproducing the test results

## Deploy MicroK8s

Follow the instructions at https://microk8s.io to snap install microk8s on two machines.
```console
% sudo snap install microk8s --channel 1.16/stable --classic
```

Create a cluster by running on the first machine:
```console
% sudo microk8s.add-node
```

Use the connection string on the second machine to form the cluster:
```console
% sudo microk8s.join 172.31.26.211:25000/ckStrCWMOzdKorIdoPyhNwPCqSlScTNi
``` 

On the first machine that acts as the master enable DNS and allow priviledged containers:
```console
% sudo microk8s.enable dns
% echo "--allow-privileged=true" | sudo tee -a /var/snap/microk8s/current/args/kube-apiserver
% microk8s.stop; microk8s.start
```

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
% wget https://github.com/heptio/sonobuoy/releases/download/v0.16.0/sonobuoy_0.16.0_linux_amd64.tar.gz
% tar -zxvf sonobuoy_0.16.0_linux_amd64.tar.gz
% sudo ./sonobuoy run --mode certified-conformance --kubeconfig /var/snap/microk8s/current/credentials/client.config
% sudo ./sonobuoy status --kubeconfig /var/snap/microk8s/current/credentials/client.config
% sudo ./sonobuoy retrieve --kubeconfig /var/snap/microk8s/current/credentials/client.config
```
