# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

Deploy a cluster using
[SIGHUP Kubernetes Conformance Environment](https://github.com/sighupio/k8s-conformance-environment/tree/v1.0.0) project.

### Create a terraform project

Use the provided [terraform module](https://github.com/sighupio/k8s-conformance-environment/tree/v1.0.0/modules/aws-k8s-conformance) to create a Kubernetes Cluster on top of AWS in a terraform project:

*simple usage is as follows:*

```hcl
data "aws_region" "current" {}

module "fury" {
  source = "../../modules/aws-k8s-conformance"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.16.2"

  public_subnet_id  = "subnet-your-id"
  private_subnet_id = "subnet-your-id"
  pod_network_cidr  = "172.16.0.0/16" # Fury's CNI (calico) is preconfigured to use this CIDR

}
```

*You can find more examples [here](https://github.com/sighupio/k8s-conformance-environment/tree/v1.0.0/fury)*

Once the Kubernetes cluster is created, access master node *(ssh)* and run `kubectl get nodes`.

```bash
fury@ip-10-100-0-127:~$ kubectl get nodes
NAME                                          STATUS     ROLES    AGE     VERSION
ip-10-100-0-127.eu-west-1.compute.internal    NotReady   master   2m12s   v1.16.2
ip-10-100-10-188.eu-west-1.compute.internal   NotReady   <none>   112s    v1.16.2
ip-10-100-10-233.eu-west-1.compute.internal   NotReady   <none>   112s    v1.16.2
```

*Example output: ips and/or region could be different*

The cluster should be composed by *(at least)* three nodes in `NotReady` status.

## Install Fury Distribution

> Install requirements and run commands in master node.

### Requirements

- [kustomize](https://github.com/kubernetes-sigs/kustomize/blob/master/docs/INSTALL.md): Used to render distribution
  manifests.
  Required version > [3.3](https://github.com/kubernetes-sigs/kustomize/releases/tag/kustomize%2Fv3.3.0)
- [furyctl](https://github.com/sighupio/furyctl#install): Downloads distribution files. Required version >
  [v0.2.1](https://github.com/sighupio/furyctl/releases/tag/v0.2.1)

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.0.0
$ furyctl vendor -H
```

Install Fury in the cluster:

```bash
$ kustomize build | kubectl apply -f -
```

> If you see any errors, try again until no error appears. There are some CRDs dependencies.

Wait until everything is up and running:

```bash
kubectl get pods -A
NAMESPACE            NAME                                                    READY   STATUS      RESTARTS   AGE
cert-manager         cert-manager-54bb694dc-57kf7                            1/1     Running     0          7m39s
cert-manager         cert-manager-cainjector-898cb7556-2xjxr                 1/1     Running     0          7m39s
cert-manager         cert-manager-webhook-b65959699-7zn59                    1/1     Running     0          7m39s
ingress-nginx        forecastle-744778954f-74kbg                             1/1     Running     0          7m39s
ingress-nginx        nginx-ingress-controller-p2v8z                          1/1     Running     0          7m29s
kube-system          calico-kube-controllers-655bb9f786-nc4xg                1/1     Running     0          7m38s
kube-system          calico-node-cl7rh                                       1/1     Running     0          7m38s
kube-system          calico-node-gzwqz                                       1/1     Running     0          7m38s
kube-system          coredns-5644d7b6d9-9bdtf                                1/1     Running     0          12m
kube-system          coredns-5644d7b6d9-zclqz                                1/1     Running     0          12m
kube-system          etcd-kfd-quick-start-control-plane                      1/1     Running     0          11m
kube-system          kube-apiserver-kfd-quick-start-control-plane            1/1     Running     0          11m
kube-system          kube-controller-manager-kfd-quick-start-control-plane   1/1     Running     0          11m
kube-system          kube-proxy-qjcq6                                        1/1     Running     0          12m
kube-system          kube-proxy-xr4b4                                        1/1     Running     0          12m
kube-system          kube-scheduler-kfd-quick-start-control-plane            1/1     Running     0          11m
kube-system          minio-0                                                 1/1     Running     0          7m38s
kube-system          minio-setup-wjr6v                                       0/1     Completed   0          7m38s
kube-system          velero-79446c99cd-n9fbm                                 1/1     Running     0          7m38s
kube-system          velero-restic-s8ptm                                     1/1     Running     0          7m29s
local-path-storage   local-path-provisioner-7745554f7f-vhgs8                 1/1     Running     0          12m
logging              cerebro-d67c8c48-mm7hb                                  1/1     Running     0          7m38s
logging              elasticsearch-0                                         2/2     Running     0          7m38s
logging              fluentd-jh56j                                           1/1     Running     0          7m38s
logging              fluentd-xvt4z                                           1/1     Running     0          7m38s
logging              kibana-756b6ddfcd-pz2vj                                 1/1     Running     0          7m38s
monitoring           goldpinger-58f54                                        1/1     Running     0          7m38s
monitoring           goldpinger-fzvl2                                        1/1     Running     0          7m38s
monitoring           grafana-864bdcc8d4-hfddg                                1/1     Running     0          7m38s
monitoring           kube-state-metrics-58f8cfc86c-pqxhf                     2/2     Running     0          7m38s
monitoring           node-exporter-kbkmj                                     1/1     Running     0          7m38s
monitoring           node-exporter-xp4x8                                     1/1     Running     0          7m38s
monitoring           prometheus-k8s-0                                        3/3     Running     1          6m49s
monitoring           prometheus-operator-748c7fffd8-8twh7                    1/1     Running     0          7m38s
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.16.5](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.16.5))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ sonobuoy status
```