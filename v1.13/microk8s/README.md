# Reproducing the test results

## Deploy microk8s

Follow the instructions at https://microk8s.io to snap install microk8s.
In this particular case the e2e tests were run on t2.large VM on AWS:

```console
% sudo snap install microk8s --channel 1.13/stable --classic
```

Note that the tests require privileged containers and dns so we need to configure microk8s' services appropriately. We also need to allow intra-pod communication.

```console
% echo "--allow-privileged=true" | sudo tee -a /var/snap/microk8s/current/args/kubelet
% echo "--allow-privileged=true" | sudo tee -a /var/snap/microk8s/current/args/kube-apiserver
% sudo snap stop microk8s
% sudo snap start microk8s
% microk8s.enable dns
% sudo iptables -P FORWARD ACCEPT
```

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
% wget https://github.com/heptio/sonobuoy/releases/download/v0.13.0/sonobuoy_0.13.0_linux_amd64.tar.gz
% tar -zxvf sonobuoy_0.13.0_linux_amd64.tar.gz
% ./sonobuoy run  --kubeconfig /snap/microk8s/current/client.config
% ./sonobuoy status --kubeconfig /snap/microk8s/current/client.config
% ./sonobuoy retrieve --kubeconfig /snap/microk8s/current/client.config
```
