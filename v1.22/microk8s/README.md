# Reproducing the test results

## Deploy MicroK8s

Follow the instructions at https://microk8s.io to snap install microk8s on two machines.
```console
% sudo snap install microk8s --channel 1.22/stable --classic
```

Create a cluster by running on the first machine:
```console
% sudo microk8s.add-node
```

Use the connection string on the second machine to form the cluster:
```console
% microk8s join 172.31.36.182:25000/2acba18255b996b867ceb6a139e032e6/a727a0b4f094
``` 

On the first machine that acts as the master enable DNS and allow priviledged containers:
```console
% sudo microk8s.enable dns
```

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
% wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.53.2/sonobuoy_0.53.2_linux_amd64.tar.gz
% tar -zxvf ./sonobuoy_0.53.2_linux_amd64.tar.gz
% sudo ./sonobuoy run --mode certified-conformance --kubeconfig /var/snap/microk8s/current/credentials/client.config --kube-conformance-image k8s.gcr.io/conformance:v1.22.0
% sudo ./sonobuoy status --kubeconfig /var/snap/microk8s/current/credentials/client.config
% sudo ./sonobuoy retrieve --kubeconfig /var/snap/microk8s/current/credentials/client.config
```
