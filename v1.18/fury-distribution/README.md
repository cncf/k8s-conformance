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
  cluster_version = "1.18.2"

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
- Downloading plugin for provider "tls" (hashicorp/tls) 2.1.1...
- Downloading plugin for provider "template" (hashicorp/template) 2.1.2...
- Downloading plugin for provider "random" (hashicorp/random) 2.2.1...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.67.0...

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
data.aws_region.current: Refreshing state...
module.fury.data.aws_subnet.public: Refreshing state...
module.fury.data.aws_subnet.private: Refreshing state...
module.fury.data.aws_vpc.vpc: Refreshing state...
module.fury.random_string.second_part: Creating...
module.fury.random_string.firts_part: Creating...
module.fury.random_string.second_part: Creation complete after 0s [id=074un7vrnur91rve]
module.fury.random_string.firts_part: Creation complete after 0s [id=12q29h]
module.fury.tls_private_key.master: Creating...
module.fury.aws_security_group.master: Creating...
module.fury.aws_security_group.worker: Creating...
module.fury.aws_eip.master: Creating...
module.fury.tls_private_key.master: Creation complete after 2s [id=a0253d3942750166fb7e712e85ce003b1477e12a]
module.fury.aws_eip.master: Creation complete after 1s [id=eipalloc-0eb917362316ecf67]
module.fury.data.template_file.init_master: Refreshing state...
module.fury.aws_security_group.worker: Creation complete after 2s [id=sg-055feea53a27910f8]
module.fury.aws_security_group.master: Creation complete after 2s [id=sg-09e0841fc6414a86e]
module.fury.aws_security_group_rule.worker_ingress_self: Creating...
module.fury.aws_security_group_rule.worker_ingress: Creating...
module.fury.aws_security_group_rule.worker_egress: Creating...
module.fury.aws_security_group_rule.master_ingress: Creating...
module.fury.aws_security_group_rule.master_egress: Creating...
module.fury.aws_spot_instance_request.master: Creating...
module.fury.aws_security_group_rule.worker_ingress_self: Creation complete after 0s [id=sgrule-3139473133]
module.fury.aws_security_group_rule.master_ingress: Creation complete after 0s [id=sgrule-127161725]
module.fury.aws_security_group_rule.worker_ingress: Creation complete after 1s [id=sgrule-2562263321]
module.fury.aws_security_group_rule.master_egress: Creation complete after 1s [id=sgrule-4081512786]
module.fury.aws_security_group_rule.worker_egress: Creation complete after 2s [id=sgrule-1160278260]
module.fury.aws_spot_instance_request.master: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Creation complete after 12s [id=sir-1288gh4p]
module.fury.aws_eip_association.eip_assoc: Creating...
module.fury.data.template_file.init_worker: Refreshing state...
module.fury.aws_spot_instance_request.worker[0]: Creating...
module.fury.aws_spot_instance_request.worker[1]: Creating...
module.fury.aws_eip_association.eip_assoc: Creation complete after 5s [id=eipassoc-0a5e2a77f59f12831]
module.fury.aws_spot_instance_request.worker[0]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[1]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[0]: Creation complete after 12s [id=sir-156igyin]
module.fury.aws_spot_instance_request.worker[1]: Creation complete after 12s [id=sir-g9hikevp]

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = 18.157.149.97
tls_private_key = <sensitive>
```

##### Enter master node

```bash
$ terraform output tls_private_key > cluster.key && chmod 400 cluster.key && ssh -i cluster.key fury@18.157.149.97
# fury@ip-172-31-39-64:~$ while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cluster creation...'; sleep 5; done
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
# fury@ip-172-31-39-64:~$ kubectl get nodes
NAME                                             STATUS     ROLES    AGE   VERSION
ip-172-31-10-102.eu-central-1.compute.internal   NotReady   <none>   6s    v1.18.2
ip-172-31-3-240.eu-central-1.compute.internal    NotReady   <none>   6s    v1.18.2
ip-172-31-39-64.eu-central-1.compute.internal    NotReady   master   29s   v1.18.2
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
  [v0.2.2](https://github.com/sighupio/furyctl/releases/tag/v0.2.2)

```bash
# fury@ip-172-31-39-64:~$ curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.2.2/furyctl-linux-amd64
# fury@ip-172-31-39-64:~$ sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
# fury@ip-172-31-39-64:~$ sudo chmod +x /usr/local/bin/furyctl
# fury@ip-172-31-39-64:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz
# fury@ip-172-31-39-64:~$ tar -zxvf kustomize_v3.3.0_linux_amd64.tar.gz
kustomize
# fury@ip-172-31-39-64:~$ sudo mv kustomize /usr/local/bin/kustomize
```

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.3.0
2020/06/25 06:25:12 downloading: http::https://github.com/sighupio/fury-distribution/releases/download/v1.3.0/Furyfile.yml -> Furyfile.yml
2020/06/25 06:25:13 downloading: http::https://github.com/sighupio/fury-distribution/releases/download/v1.3.0/kustomization.yaml -> kustomization.yaml
$ furyctl vendor -H
2020/06/25 06:25:28 using v1.3.0 for package networking/calico
2020/06/25 06:25:28 using v1.8.0 for package monitoring/prometheus-operator
2020/06/25 06:25:28 using v1.8.0 for package monitoring/prometheus-operated
2020/06/25 06:25:28 using v1.8.0 for package monitoring/grafana
2020/06/25 06:25:28 using v1.8.0 for package monitoring/goldpinger
2020/06/25 06:25:28 using v1.8.0 for package monitoring/kubeadm-sm
2020/06/25 06:25:28 using v1.8.0 for package monitoring/kube-state-metrics
2020/06/25 06:25:28 using v1.8.0 for package monitoring/node-exporter
2020/06/25 06:25:28 using v1.8.0 for package monitoring/metrics-server
2020/06/25 06:25:28 using v1.5.0 for package logging/elasticsearch-single
2020/06/25 06:25:28 using v1.5.0 for package logging/cerebro
2020/06/25 06:25:28 using v1.5.0 for package logging/curator
2020/06/25 06:25:28 using v1.5.0 for package logging/fluentd
2020/06/25 06:25:28 using v1.5.0 for package logging/kibana
2020/06/25 06:25:28 using v1.7.0 for package ingress/cert-manager
2020/06/25 06:25:28 using v1.7.0 for package ingress/nginx
2020/06/25 06:25:28 using v1.7.0 for package ingress/forecastle
2020/06/25 06:25:28 using v1.4.0 for package dr/velero
2020/06/25 06:25:28 using v1.1.0 for package opa/gatekeeper
2020/06/25 06:25:28 downloading: git::https://github.com/sighupio/fury-kubernetes-networking.git//katalog/calico?ref=v1.3.0 -> vendor/katalog/networking/calico
2020/06/25 06:25:28 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/prometheus-operator?ref=v1.8.0 -> vendor/katalog/monitoring/prometheus-operator
2020/06/25 06:25:28 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/prometheus-operated?ref=v1.8.0 -> vendor/katalog/monitoring/prometheus-operated
2020/06/25 06:25:30 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/grafana?ref=v1.8.0 -> vendor/katalog/monitoring/grafana
2020/06/25 06:25:30 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/goldpinger?ref=v1.8.0 -> vendor/katalog/monitoring/goldpinger
2020/06/25 06:25:31 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/kubeadm-sm?ref=v1.8.0 -> vendor/katalog/monitoring/kubeadm-sm
2020/06/25 06:25:31 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/kube-state-metrics?ref=v1.8.0 -> vendor/katalog/monitoring/kube-state-metrics
2020/06/25 06:25:32 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/node-exporter?ref=v1.8.0 -> vendor/katalog/monitoring/node-exporter
2020/06/25 06:25:32 downloading: git::https://github.com/sighupio/fury-kubernetes-monitoring.git//katalog/metrics-server?ref=v1.8.0 -> vendor/katalog/monitoring/metrics-server
2020/06/25 06:25:34 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/elasticsearch-single?ref=v1.5.0 -> vendor/katalog/logging/elasticsearch-single
2020/06/25 06:25:34 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/cerebro?ref=v1.5.0 -> vendor/katalog/logging/cerebro
2020/06/25 06:25:34 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/curator?ref=v1.5.0 -> vendor/katalog/logging/curator
2020/06/25 06:25:35 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/fluentd?ref=v1.5.0 -> vendor/katalog/logging/fluentd
2020/06/25 06:25:35 downloading: git::https://github.com/sighupio/fury-kubernetes-logging.git//katalog/kibana?ref=v1.5.0 -> vendor/katalog/logging/kibana
2020/06/25 06:25:35 downloading: git::https://github.com/sighupio/fury-kubernetes-ingress.git//katalog/cert-manager?ref=v1.7.0 -> vendor/katalog/ingress/cert-manager
2020/06/25 06:25:36 downloading: git::https://github.com/sighupio/fury-kubernetes-ingress.git//katalog/nginx?ref=v1.7.0 -> vendor/katalog/ingress/nginx
2020/06/25 06:25:37 downloading: git::https://github.com/sighupio/fury-kubernetes-ingress.git//katalog/forecastle?ref=v1.7.0 -> vendor/katalog/ingress/forecastle
2020/06/25 06:25:37 downloading: git::https://github.com/sighupio/fury-kubernetes-dr.git//katalog/velero?ref=v1.4.0 -> vendor/katalog/dr/velero
2020/06/25 06:25:37 downloading: git::https://github.com/sighupio/fury-kubernetes-opa.git//katalog/gatekeeper?ref=v1.1.0 -> vendor/katalog/opa/gatekeeper
```

Install Fury in the cluster:

```bash
$ kustomize build | kubectl apply -f -
```

> If you see any errors, try again until no error appears. There are some CRDs dependencies.

Wait until everything is up and running:

```bash
kubectl get pods -A
NAMESPACE            NAME                                                                    READY   STATUS      RESTARTS   AGE
cert-manager         cert-manager-7b4c7f655-pfplf                                            1/1     Running     0          8m13s
cert-manager         cert-manager-cainjector-bd4c46ffb-nr6kz                                 1/1     Running     0          8m13s
cert-manager         cert-manager-webhook-865b9f46fc-jbqtb                                   1/1     Running     0          8m13s
gatekeeper-system    gatekeeper-controller-manager-6bf7cbcd8c-4vbwf                          1/1     Running     0          8m13s
ingress-nginx        forecastle-58599797d4-7xqpd                                             1/1     Running     0          8m13s
ingress-nginx        nginx-ingress-controller-dsqcm                                          1/1     Running     0          7m49s
ingress-nginx        nginx-ingress-controller-qlx4l                                          1/1     Running     0          7m50s
kube-system          calico-kube-controllers-d7485d699-cbfnl                                 1/1     Running     0          8m12s
kube-system          calico-node-7vfvx                                                       1/1     Running     0          8m11s
kube-system          calico-node-bwd8b                                                       1/1     Running     0          8m11s
kube-system          calico-node-qbk4l                                                       1/1     Running     0          8m11s
kube-system          coredns-66bff467f8-7lgq7                                                1/1     Running     0          10m
kube-system          coredns-66bff467f8-tjj87                                                1/1     Running     0          10m
kube-system          etcd-ip-172-31-39-64.eu-central-1.compute.internal                      1/1     Running     0          10m
kube-system          kube-apiserver-ip-172-31-39-64.eu-central-1.compute.internal            1/1     Running     0          10m
kube-system          kube-controller-manager-ip-172-31-39-64.eu-central-1.compute.internal   1/1     Running     1          10m
kube-system          kube-proxy-hpr6x                                                        1/1     Running     0          10m
kube-system          kube-proxy-l4jj7                                                        1/1     Running     0          10m
kube-system          kube-proxy-xp5cw                                                        1/1     Running     0          10m
kube-system          kube-scheduler-ip-172-31-39-64.eu-central-1.compute.internal            1/1     Running     1          10m
kube-system          metrics-server-8dd597dd4-n4vbn                                          1/1     Running     0          8m12s
kube-system          minio-0                                                                 1/1     Running     0          8m12s
kube-system          minio-setup-5qqjj                                                       0/1     Completed   0          8m10s
kube-system          velero-78959476b5-lmt4w                                                 1/1     Running     0          8m12s
kube-system          velero-restic-lrt6r                                                     1/1     Running     0          7m49s
kube-system          velero-restic-plttb                                                     1/1     Running     0          7m50s
local-path-storage   local-path-provisioner-579c65cb9b-q6tjk                                 1/1     Running     0          10m
logging              cerebro-7bb745765b-q9m4s                                                1/1     Running     0          8m12s
logging              elasticsearch-0                                                         2/2     Running     0          8m11s
logging              fluentbit-7nd56                                                         1/1     Running     0          8m11s
logging              fluentbit-kdq8s                                                         1/1     Running     0          8m11s
logging              fluentbit-sr5n4                                                         1/1     Running     0          8m11s
logging              fluentd-0                                                               1/1     Running     0          8m11s
logging              fluentd-1                                                               1/1     Running     0          3m49s
logging              fluentd-2                                                               1/1     Running     0          2m17s
logging              kibana-84c89f7c4b-fkj48                                                 1/1     Running     0          8m12s
monitoring           goldpinger-58scx                                                        1/1     Running     0          8m10s
monitoring           goldpinger-mcv6z                                                        1/1     Running     0          8m11s
monitoring           goldpinger-sfjht                                                        1/1     Running     0          8m10s
monitoring           grafana-6944955649-8rrml                                                1/1     Running     0          8m12s
monitoring           kube-state-metrics-797889cf55-nxnqt                                     1/1     Running     0          8m12s
monitoring           node-exporter-7bgbr                                                     2/2     Running     0          8m10s
monitoring           node-exporter-g55nb                                                     2/2     Running     0          8m10s
monitoring           node-exporter-prw9q                                                     2/2     Running     0          8m10s
monitoring           prometheus-k8s-0                                                        3/3     Running     1          6m4s
monitoring           prometheus-operator-559bcd67-4vwlt                                      1/1     Running     0          8m11s
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.18.3](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.18.3))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ sonobuoy status
```