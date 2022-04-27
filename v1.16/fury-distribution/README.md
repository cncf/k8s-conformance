# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

### Create a terraform project

#### Requirements

This terraform project requires:

- A public subnet. The id: `subnet-abc`
- A private subnet. The id: `subnet-cba`
- terraform 0.12 installed
  - AWS credentials along with enough permissions to provision instances and security groups.

Also requires the following environment variables:

```bash
#!/bin/bash

export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=THE_SECRET_KEY
export AWS_DEFAULT_REGION=YOUR_REGION # (currently supports eu-regions)
```

#### Prepare

Use the provided [terraform module](https://github.com/sighupio/k8s-conformance-environment/tree/v1.0.0/modules/aws-k8s-conformance) to create a Kubernetes Cluster on top of AWS in a terraform project:

*simple usage is as follows*

*`main.tf`*
```hcl
data "aws_region" "current" {}

module "fury" {
  source = "git::git@github.com:sighupio/k8s-conformance-environment.git//modules/aws-k8s-conformance?ref=v1.0.0"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.16.2"

  public_subnet_id  = "subnet-your-id"
  private_subnet_id = "subnet-your-id"
  pod_network_cidr  = "172.16.0.0/16" # Fury's CNI (calico) is preconfigured to use this CIDR

}

output "tls_private_key" {
  sensitive   = true
  description = "Private RSA Key to log into the control plane node"
  value       = module.fury.tls_private_key
}

output "master_public_ip" {
  description = "Public IP where control plane is exposed"
  value       = module.fury.master_public_ip
}
```

#### Execute the terraform project

##### Init the project

```bash
$ terraform init
Initializing modules...
Downloading git::git@github.com:sighupio/k8s-conformance-environment.git?ref=v1.0.0 for fury...
- fury in .terraform/modules/fury/modules/aws-k8s-conformance

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "template" (hashicorp/template) 2.1.2...
- Downloading plugin for provider "random" (hashicorp/random) 2.2.1...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.51.0...
- Downloading plugin for provider "tls" (hashicorp/tls) 2.1.1...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

##### Apply the project

```bash
$ terraform apply --auto-approve
module.fury.data.aws_subnet.public: Refreshing state...
module.fury.data.aws_subnet.private: Refreshing state...
data.aws_region.current: Refreshing state...
module.fury.data.aws_vpc.vpc: Refreshing state...
module.fury.random_string.second_part: Creating...
module.fury.random_string.firts_part: Creating...
module.fury.random_string.second_part: Creation complete after 0s [id=kk5pnttdg1lo7ojx]
module.fury.random_string.firts_part: Creation complete after 0s [id=2mtc6g]
module.fury.tls_private_key.master: Creating...
module.fury.tls_private_key.master: Creation complete after 1s [id=539c66023542ae99d407961f29377001d41be211]
module.fury.aws_security_group.worker: Creating...
module.fury.aws_security_group.master: Creating...
module.fury.aws_eip.master: Creating...
module.fury.aws_eip.master: Creation complete after 1s [id=eipalloc-00d67ad459419902e]
module.fury.data.template_file.init_master: Refreshing state...
module.fury.aws_security_group.master: Creation complete after 2s [id=sg-00b4c009d69932408]
module.fury.aws_security_group.worker: Creation complete after 2s [id=sg-0088a0af55c2dbd08]
module.fury.aws_security_group_rule.master_ingress: Creating...
module.fury.aws_security_group_rule.master_egress: Creating...
module.fury.aws_security_group_rule.worker_egress: Creating...
module.fury.aws_security_group_rule.worker_ingress: Creating...
module.fury.aws_security_group_rule.worker_ingress_self: Creating...
module.fury.aws_spot_instance_request.master: Creating...
module.fury.aws_security_group_rule.master_ingress: Creation complete after 1s [id=sgrule-1169100656]
module.fury.aws_security_group_rule.worker_egress: Creation complete after 1s [id=sgrule-4054893463]
module.fury.aws_security_group_rule.master_egress: Creation complete after 1s [id=sgrule-2055508091]
module.fury.aws_security_group_rule.worker_ingress: Creation complete after 1s [id=sgrule-3673314377]
module.fury.aws_security_group_rule.worker_ingress_self: Creation complete after 2s [id=sgrule-224411669]
module.fury.aws_spot_instance_request.master: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Creation complete after 12s [id=sir-4bhr67vp]
module.fury.data.template_file.init_worker: Refreshing state...
module.fury.aws_eip_association.eip_assoc: Creating...
module.fury.aws_spot_instance_request.worker[1]: Creating...
module.fury.aws_spot_instance_request.worker[0]: Creating...
module.fury.aws_eip_association.eip_assoc: Creation complete after 1s [id=eipassoc-0432623a9197da7f2]
module.fury.aws_spot_instance_request.worker[1]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[0]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[0]: Creation complete after 12s [id=sir-7sn84bin]
module.fury.aws_spot_instance_request.worker[1]: Creation complete after 12s [id=sir-yq1i4wem]

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = 34.243.48.116
tls_private_key = <sensitive>
```

##### Enter master node

```bash
$ terraform output tls_private_key > cluster.key && chmod 400 cluster.key && ssh -i cluster.key fury@34.243.48.116
# fury@ip-10-100-0-215:~$ while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cluster creation...'; sleep 5; done
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
# fury@ip-10-100-0-215:~$ kubectl get nodes
NAME                                          STATUS     ROLES    AGE     VERSION
ip-10-100-0-127.eu-west-1.compute.internal    NotReady   master   1m55s   v1.16.2
ip-10-100-10-188.eu-west-1.compute.internal   NotReady   <none>   101s    v1.16.2
ip-10-100-10-233.eu-west-1.compute.internal   NotReady   <none>   102s    v1.16.2
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

```bash
# fury@ip-10-100-0-215:~$ curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.2.1/furyctl-linux-amd64
# fury@ip-10-100-0-215:~$ sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
# fury@ip-10-100-0-215:~$ sudo chmod +x /usr/local/bin/furyctl
# fury@ip-10-100-0-215:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz
# fury@ip-10-100-0-215:~$ tar -zxvf kustomize_v3.3.0_linux_amd64.tar.gz
kustomize
# fury@ip-10-100-0-215:~$ sudo mv kustomize /usr/local/bin/kustomize
```

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.0.0
2020/03/05 08:14:10 downloading: http::https://github.com/sighupio/fury-distribution/releases/download/v1.0.0/Furyfile.yml -> Furyfile.yml
2020/03/05 08:14:11 downloading: http::https://github.com/sighupio/fury-distribution/releases/download/v1.0.0/kustomization.yaml -> kustomization.yaml
$ furyctl vendor -H
2020/03/05 08:14:20 using v1.0.0 for package networking/calico
2020/03/05 08:14:20 using v1.3.0 for package monitoring/prometheus-operator
2020/03/05 08:14:20 using v1.3.0 for package monitoring/prometheus-operated
2020/03/05 08:14:20 using v1.3.0 for package monitoring/grafana
2020/03/05 08:14:20 using v1.3.0 for package monitoring/goldpinger
2020/03/05 08:14:20 using v1.3.0 for package monitoring/kubeadm-sm
2020/03/05 08:14:20 using v1.3.0 for package monitoring/kube-state-metrics
2020/03/05 08:14:20 using v1.3.0 for package monitoring/node-exporter
2020/03/05 08:14:20 using v1.2.1 for package logging/elasticsearch-single
2020/03/05 08:14:20 using v1.2.1 for package logging/cerebro
2020/03/05 08:14:20 using v1.2.1 for package logging/curator
2020/03/05 08:14:20 using v1.2.1 for package logging/fluentd
2020/03/05 08:14:20 using v1.2.1 for package logging/kibana
2020/03/05 08:14:20 using v1.4.1 for package ingress/cert-manager
2020/03/05 08:14:20 using v1.4.1 for package ingress/nginx
2020/03/05 08:14:20 using v1.4.1 for package ingress/forecastle
2020/03/05 08:14:20 using v1.2.0 for package dr/velero
2020/03/05 08:14:20 downloading: git::https://github.com/sighupio/fury-kubernetes-networking.git//katalog/calico?ref=v1.0.0 -> vendor/katalog/networking/calico
2020/03/05 08:14:20 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/prometheus-operator?ref=v1.3.0 -> vendor/katalog/monitoring/prometheus-operator
2020/03/05 08:14:20 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/prometheus-operated?ref=v1.3.0 -> vendor/katalog/monitoring/prometheus-operated
2020/03/05 08:14:21 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/grafana?ref=v1.3.0 -> vendor/katalog/monitoring/grafana
2020/03/05 08:14:21 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/goldpinger?ref=v1.3.0 -> vendor/katalog/monitoring/goldpinger
2020/03/05 08:14:21 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/kubeadm-sm?ref=v1.3.0 -> vendor/katalog/monitoring/kubeadm-sm
2020/03/05 08:14:22 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/kube-state-metrics?ref=v1.3.0 -> vendor/katalog/monitoring/kube-state-metrics
2020/03/05 08:14:23 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/node-exporter?ref=v1.3.0 -> vendor/katalog/monitoring/node-exporter
2020/03/05 08:14:23 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/elasticsearch-single?ref=v1.2.1 -> vendor/katalog/logging/elasticsearch-single
2020/03/05 08:14:24 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/cerebro?ref=v1.2.1 -> vendor/katalog/logging/cerebro
2020/03/05 08:14:24 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/curator?ref=v1.2.1 -> vendor/katalog/logging/curator
2020/03/05 08:14:24 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/fluentd?ref=v1.2.1 -> vendor/katalog/logging/fluentd
2020/03/05 08:14:25 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/kibana?ref=v1.2.1 -> vendor/katalog/logging/kibana
2020/03/05 08:14:25 downloading: git::https://github.com/sighupio/fury-kubernetes-ingress.git//katalog/cert-manager?ref=v1.4.1 -> vendor/katalog/ingress/cert-manager
2020/03/05 08:14:26 downloading: git::https://github.com/sighupio/fury-kubernetes-ingress.git//katalog/nginx?ref=v1.4.1 -> vendor/katalog/ingress/nginx
2020/03/05 08:14:26 downloading: git::https://github.com/sighupio/fury-kubernetes-ingress.git//katalog/forecastle?ref=v1.4.1 -> vendor/katalog/ingress/forecastle
2020/03/05 08:14:26 downloading: git::https://github.com/sighupio/fury-kubernetes-dr.git//katalog/velero?ref=v1.2.0 -> vendor/katalog/dr/velero
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