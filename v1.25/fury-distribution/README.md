# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

### Create a terraform project

#### Requirements

This terraform project requires:

- A public subnet. The id: `subnet-abc`
- A private subnet. The id: `subnet-cba`
- terraform 0.15.4 installed
  - AWS credentials along with enough permissions to provision instances and security groups.

Also, requires the following environment variables:

```bash
#!/bin/bash

export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=THE_SECRET_KEY
export AWS_DEFAULT_REGION=YOUR_REGION # (currently supports eu-regions)
```

#### Prepare

Use the provided [terraform module](https://github.com/sighupio/k8s-conformance-environment/tree/v1.2.0/modules/aws-k8s-conformance) to create a Kubernetes Cluster on top of AWS in a terraform project:

*simple usage is as follows*

*`main.tf`*
```hcl
data "aws_region" "current" {}

module "fury" {
  source = "git::git@github.com:sighupio/k8s-conformance-environment.git//modules/aws-k8s-conformance?ref=v1.3.0"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.25.6"
  worker_count    = 3

  worker_instance_type = "m5.2xlarge"
  master_instance_type = "m5.large"

  public_subnet_id  = "subnet-your-id"
  private_subnet_id = "subnet-your-id"
  pod_network_cidr  = "172.16.0.0/16"

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
Downloading git::git@github.com:sighupio/k8s-conformance-environment.git?ref=v1.3.0 for fury...
- fury in .terraform/modules/fury/modules/aws-k8s-conformance

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/template from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of hashicorp/null from the dependency lock file
- Reusing previous version of hashicorp/local from the dependency lock file
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/tls from the dependency lock file
- Using previously-installed hashicorp/tls v2.2.0
- Using previously-installed hashicorp/template v2.2.0
- Using previously-installed hashicorp/random v2.3.1
- Using previously-installed hashicorp/null v3.2.0
- Using previously-installed hashicorp/local v2.2.3
- Using previously-installed hashicorp/aws v2.70.1

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
... # plan suppressed for brevity
module.fury.tls_private_key.master: Creating...
module.fury.random_string.second_part: Creating...
module.fury.random_string.firts_part: Creating...
module.fury.random_string.second_part: Creation complete after 0s [id=nxm92ecco6ybk92f]
module.fury.random_string.firts_part: Creation complete after 0s [id=3nxt9c]
module.fury.tls_private_key.master: Creation complete after 2s [id=cf930e10c02c0566099b6406482f0e988b5cfa23]
module.fury.aws_security_group.worker: Creating...
module.fury.aws_security_group.master: Creating...
module.fury.aws_eip.master: Creating...
module.fury.aws_eip.master: Creation complete after 1s [id=eipalloc-0e148a5509260dd26]
module.fury.data.template_file.init_master: Reading...
module.fury.null_resource.kubeconfig: Creating...
module.fury.data.template_file.init_master: Read complete after 0s [id=dfe56a346616531dd061fdd5f83bcdc5714edd96fe55498d5cd66307058fefae]
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): (output suppressed due to sensitive value in config)
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "./wait-for.sh 34.240.109.221:6443 -t 1200 -- echo \"Cluster Ready\""]
module.fury.aws_security_group.master: Creation complete after 2s [id=sg-0fe989bfe2713786c]
module.fury.aws_security_group.worker: Creation complete after 2s [id=sg-04a5e54cee1f6ba45]
module.fury.aws_security_group_rule.worker_egress: Creating...
module.fury.aws_security_group_rule.master_egress: Creating...
module.fury.aws_security_group_rule.worker_ingress_self: Creating...
module.fury.aws_security_group_rule.master_ingress: Creating...
module.fury.aws_security_group_rule.worker_ingress: Creating...
module.fury.aws_instance.master: Creating...
module.fury.aws_security_group_rule.worker_egress: Creation complete after 1s [id=sgrule-2517591748]
module.fury.aws_security_group_rule.master_egress: Creation complete after 1s [id=sgrule-4050319987]
module.fury.aws_security_group_rule.worker_ingress_self: Creation complete after 2s [id=sgrule-3134579923]
module.fury.aws_security_group_rule.master_ingress: Creation complete after 2s [id=sgrule-1275029800]
module.fury.aws_security_group_rule.worker_ingress: Creation complete after 3s [id=sgrule-416960564]
module.fury.null_resource.kubeconfig: Still creating... [10s elapsed]
module.fury.aws_instance.master: Still creating... [10s elapsed]
module.fury.aws_instance.master: Creation complete after 15s [id=i-05cc3099dc1d30043]
module.fury.data.template_file.init_worker: Reading...
module.fury.aws_eip_association.eip_assoc: Creating...
module.fury.data.template_file.init_worker: Read complete after 0s [id=2b0ec0453a90891ccdb9ca0a221cdad0e728447fd5615cea9a13753f71cc2935]
module.fury.aws_instance.worker[0]: Creating...
module.fury.aws_instance.worker[1]: Creating...
module.fury.aws_instance.worker[2]: Creating...
module.fury.aws_eip_association.eip_assoc: Creation complete after 1s [id=eipassoc-06fa4055c1e93a1af]
module.fury.null_resource.kubeconfig: Still creating... [20s elapsed]
module.fury.aws_instance.worker[2]: Still creating... [10s elapsed]
module.fury.aws_instance.worker[1]: Still creating... [10s elapsed]
module.fury.aws_instance.worker[0]: Still creating... [10s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [30s elapsed]
module.fury.aws_instance.worker[2]: Creation complete after 14s [id=i-01ccaef616d74064a]
module.fury.aws_instance.worker[0]: Creation complete after 14s [id=i-02348dd97ad51508e]
module.fury.aws_instance.worker[1]: Creation complete after 15s [id=i-0bf574cd568d6128d]
module.fury.null_resource.kubeconfig: Still creating... [40s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [50s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [1m0s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [1m10s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [1m20s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [1m30s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [1m40s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [1m50s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [2m0s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [2m10s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [2m20s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [2m30s elapsed]
module.fury.null_resource.kubeconfig (local-exec): Cluster Ready
module.fury.null_resource.kubeconfig: Provisioning with 'remote-exec'...
module.fury.null_resource.kubeconfig (remote-exec): Connecting to remote host via SSH...
module.fury.null_resource.kubeconfig (remote-exec):   Host: 34.240.109.221
module.fury.null_resource.kubeconfig (remote-exec):   User: fury
module.fury.null_resource.kubeconfig (remote-exec):   Password: false
module.fury.null_resource.kubeconfig (remote-exec):   Private key: true
module.fury.null_resource.kubeconfig (remote-exec):   Certificate: false
module.fury.null_resource.kubeconfig (remote-exec):   SSH Agent: false
module.fury.null_resource.kubeconfig (remote-exec):   Checking Host Key: false
module.fury.null_resource.kubeconfig (remote-exec):   Target Platform: unix
module.fury.null_resource.kubeconfig (remote-exec): Connected!
module.fury.null_resource.kubeconfig (remote-exec): Cluster "kubernetes" set.
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "scp -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i master.key fury@34.240.109.221:/home/fury/.kube/config kubeconfig"]
module.fury.null_resource.kubeconfig (local-exec): Warning: Permanently added '34.240.109.221' (ED25519) to the list of known hosts.
module.fury.null_resource.kubeconfig: Still creating... [2m40s elapsed]
module.fury.null_resource.kubeconfig: Creation complete after 2m40s [id=5577006791947779410]
module.fury.data.local_file.kubeconfig: Reading...
module.fury.data.local_file.kubeconfig: Read complete after 0s [id=6b2b5038b75d81ce7cbe97b54fe9539987b45e5b]

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = "34.240.109.221"
tls_private_key = <sensitive>
```

##### Enter master node

```bash
$ terraform output tls_private_key > cluster.key && chmod 600 cluster.key && ssh -i cluster.key fury@34.240.109.221
fury@ip-10-0-10-103:~$ kubectl get nodes -o wide
NAME              STATUS     ROLES           AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
ip-10-0-1-142     NotReady   <none>          2m11s   v1.25.6   10.0.1.142     <none>        Ubuntu 20.04.6 LTS   5.15.0-1022-aws   containerd://1.6.8
ip-10-0-1-178     NotReady   <none>          2m11s   v1.25.6   10.0.1.178     <none>        Ubuntu 20.04.6 LTS   5.15.0-1022-aws   containerd://1.6.8
ip-10-0-1-58      NotReady   <none>          2m10s   v1.25.6   10.0.1.58      <none>        Ubuntu 20.04.6 LTS   5.15.0-1022-aws   containerd://1.6.8
ip-10-0-101-102   NotReady   control-plane   2m30s   v1.25.6   10.0.101.102   <none>        Ubuntu 20.04.6 LTS   5.15.0-1022-aws   containerd://1.6.8
```

*Example output: ips and/or region could be different*

The cluster should be composed by *(at least)* three worker nodes in `NotReady` status.

## Install Fury Distribution

> Install requirements and run commands in the master node.

### Requirements

- [kustomize](https://github.com/kubernetes-sigs/kustomize/blob/master/docs/INSTALL.md): Used to render distribution
  manifests.
  Required version >= [3.5.3](https://github.com/kubernetes-sigs/kustomize/releases/tag/kustomize%2Fv3.5.3)
- [furyctl](https://github.com/sighupio/furyctl#install): Downloads distribution files. Required version >
  [v0.7.0](https://github.com/sighupio/furyctl/releases/tag/v0.7.0)

```bash
fury@ip-10-0-10-103:~$ curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.9.0/furyctl-linux-amd64
fury@ip-10-0-10-103:~$ sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
fury@ip-10-0-10-103:~$ sudo chmod +x /usr/local/bin/furyctl
fury@ip-10-0-10-103:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.5.3/kustomize_v3.5.3_linux_amd64.tar.gz
fury@ip-10-0-10-103:~$ tar -zxvf kustomize_v3.5.3_linux_amd64.tar.gz kustomize
fury@ip-10-0-10-103:~$ sudo mv kustomize /usr/local/bin/kustomize
```

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.25.0-rc5
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.25.0-rc5/Furyfile.yml -> Furyfile.yml 
INFO[0001] downloading: github.com/sighupio/fury-distribution/releases/download/v1.25.0-rc5/kustomization.yaml -> kustomization.yaml
$ furyctl vendor -H
INFO[0000] using version 'v1.14.0' for package 'ingress' 
INFO[0000] using version 'v1.11.0' for package 'dr'     
INFO[0000] using version 'v1.12.1' for package 'networking' 
INFO[0000] using version 'v2.1.0-rc10' for package 'monitoring' 
INFO[0000] using version 'v3.1.1' for package 'logging' 
INFO[0000] using version 'v1.14.0' for package 'ingress' 
INFO[0000] using version 'v1.11.0' for package 'dr'     
INFO[0000] using version 'v1.8.0' for package 'opa'     
INFO[0000] using version 'v0.0.3' for package 'auth'    
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-ingress.git/katalog?ref=v1.14.0' into 'vendor/katalog/ingress' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-auth.git/katalog?ref=v0.0.3' into 'vendor/katalog/auth' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-logging.git/katalog?ref=v3.1.1' into 'vendor/katalog/logging' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-dr.git/modules?ref=v1.11.0' into 'vendor/modules/dr' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-dr.git/katalog?ref=v1.11.0' into 'vendor/katalog/dr' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-opa.git/katalog?ref=v1.8.0' into 'vendor/katalog/opa' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-monitoring.git/katalog?ref=v2.1.0-rc10' into 'vendor/katalog/monitoring' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-networking.git/katalog?ref=v1.12.1' into 'vendor/katalog/networking' 
INFO[0000] downloading 'github.com/sighupio/fury-kubernetes-ingress.git/modules?ref=v1.14.0' into 'vendor/modules/ingress' 
INFO[0001] removing git subfolder: vendor/katalog/opa/.git 
INFO[0001] removing git subfolder: vendor/katalog/auth/.git 
INFO[0002] removing git subfolder: vendor/katalog/dr/.git 
INFO[0002] removing git subfolder: vendor/modules/dr/.git 
INFO[0002] removing git subfolder: vendor/katalog/ingress/.git 
INFO[0002] removing git subfolder: vendor/katalog/networking/.git 
INFO[0002] removing git subfolder: vendor/modules/ingress/.git 
INFO[0002] removing git subfolder: vendor/katalog/logging/.git 
INFO[0002] removing git subfolder: vendor/katalog/monitoring/.git
```

Install Fury in the cluster:

```bash
$ kustomize build . | kubectl apply -f - --server-side
```

> If you see any errors, try again until no error appears. There are some CRDs and Webhooks dependencies.

Wait until everything is up and running:

```bash
kubectl get pods -A
NAMESPACE            NAME                                             READY   STATUS      RESTARTS        AGE
cert-manager         cert-manager-cainjector-ddf56d496-s68wk          1/1     Running     0               4m43s
cert-manager         cert-manager-fc579b65b-5d7g8                     1/1     Running     0               4m43s
cert-manager         cert-manager-webhook-84576b95f5-ztgqc            1/1     Running     0               4m43s
gatekeeper-system    gatekeeper-audit-698dd55657-cwlbt                1/1     Running     1 (4m ago)      4m43s
gatekeeper-system    gatekeeper-controller-manager-7858598757-9hd2f   1/1     Running     0               4m43s
gatekeeper-system    gatekeeper-controller-manager-7858598757-l69td   1/1     Running     0               4m43s
gatekeeper-system    gatekeeper-controller-manager-7858598757-ttkj8   1/1     Running     0               4m43s
gatekeeper-system    gatekeeper-policy-manager-5554c76f5f-zzn8z       1/1     Running     0               4m43s
ingress-nginx        forecastle-67c5f5f89d-llzv8                      1/1     Running     0               4m43s
ingress-nginx        nginx-ingress-controller-9qsm2                   0/1     Running     0               4m26s
ingress-nginx        nginx-ingress-controller-dvjdk                   1/1     Running     0               4m11s
ingress-nginx        nginx-ingress-controller-mtbxm                   1/1     Running     0               4m18s
kube-system          calico-kube-controllers-5dc69c8c9d-vpmdj         1/1     Running     0               4m42s
kube-system          calico-node-h47z4                                1/1     Running     0               4m42s
kube-system          calico-node-jpr9m                                1/1     Running     0               4m42s
kube-system          calico-node-k6fbq                                1/1     Running     0               4m42s
kube-system          calico-node-m5lml                                1/1     Running     0               4m42s
kube-system          coredns-565d847f94-29dwn                         1/1     Running     0               154m
kube-system          coredns-565d847f94-zx6st                         1/1     Running     0               154m
kube-system          etcd-ip-10-0-101-102                             1/1     Running     0               154m
kube-system          kube-apiserver-ip-10-0-101-102                   1/1     Running     0               154m
kube-system          kube-controller-manager-ip-10-0-101-102          1/1     Running     0               154m
kube-system          kube-proxy-c686p                                 1/1     Running     0               154m
kube-system          kube-proxy-dsdkm                                 1/1     Running     0               154m
kube-system          kube-proxy-lm4gp                                 1/1     Running     0               154m
kube-system          kube-proxy-mmh45                                 1/1     Running     0               154m
kube-system          kube-scheduler-ip-10-0-101-102                   1/1     Running     0               154m
kube-system          minio-0                                          1/1     Running     0               4m42s
kube-system          minio-setup-7tp5t                                0/1     Completed   0               4m42s
kube-system          node-agent-94r6n                                 1/1     Running     0               4m26s
kube-system          node-agent-vppdg                                 1/1     Running     0               4m11s
kube-system          node-agent-zj5pw                                 1/1     Running     0               4m18s
kube-system          velero-54fd894dff-pz76s                          1/1     Running     0               4m42s
local-path-storage   local-path-provisioner-7f78c97595-cg5gj          1/1     Running     0               154m
logging              audit-host-tailer-6r9qv                          1/1     Running     0               3m39s
logging              cerebro-74894d75d-65fnf                          1/1     Running     0               4m42s
logging              infra-fluentbit-96b52                            1/1     Running     0               3m14s
logging              infra-fluentbit-9zlcb                            1/1     Running     0               3m14s
logging              infra-fluentbit-vsdjl                            1/1     Running     0               3m14s
logging              infra-fluentbit-x775g                            1/1     Running     0               3m14s
logging              infra-fluentd-0                                  2/2     Running     0               3m16s
logging              infra-fluentd-1                                  2/2     Running     0               2m17s
logging              infra-fluentd-configcheck-b003eb42               0/1     Completed   0               3m35s
logging              kubernetes-event-tailer-0                        1/1     Running     0               3m39s
logging              logging-operator-d68466444-8vt28                 1/1     Running     0               4m42s
logging              minio-logging-0                                  1/1     Running     0               4m42s
logging              minio-logging-1                                  1/1     Running     0               4m42s
logging              minio-logging-2                                  1/1     Running     0               4m42s
logging              minio-logging-buckets-setup-rwk4p                0/1     Completed   3               4m42s
logging              opensearch-cluster-master-0                      2/2     Running     0               4m42s
logging              opensearch-dashboards-54966f4b69-dps2r           1/1     Running     0               4m42s
logging              systemd-common-host-tailer-22k4c                 4/4     Running     0               3m39s
logging              systemd-common-host-tailer-dq2qp                 4/4     Running     0               3m39s
logging              systemd-common-host-tailer-kfjq6                 4/4     Running     0               3m39s
logging              systemd-common-host-tailer-zt9nd                 4/4     Running     0               3m39s
logging              systemd-etcd-host-tailer-vnddv                   1/1     Running     0               3m39s
monitoring           alertmanager-main-0                              2/2     Running     1 (3m50s ago)   3m54s
monitoring           grafana-688f4b564f-jwbsr                         3/3     Running     0               4m42s
monitoring           kube-proxy-metrics-7n9sf                         1/1     Running     0               4m42s
monitoring           kube-proxy-metrics-n5xbt                         1/1     Running     0               4m42s
monitoring           kube-proxy-metrics-tkg4v                         1/1     Running     0               4m42s
monitoring           kube-proxy-metrics-z2cvc                         1/1     Running     0               4m42s
monitoring           kube-state-metrics-695d88f594-cqq4p              3/3     Running     0               4m41s
monitoring           node-exporter-fbbsw                              2/2     Running     0               4m42s
monitoring           node-exporter-jdxks                              2/2     Running     0               4m42s
monitoring           node-exporter-pz89p                              2/2     Running     0               4m42s
monitoring           node-exporter-qx4lx                              2/2     Running     0               4m42s
monitoring           prometheus-adapter-7f4cf9c694-sk9hx              1/1     Running     0               4m41s
monitoring           prometheus-k8s-0                                 2/2     Running     0               3m53s
monitoring           prometheus-operator-6f575fcf5-mwcw6              2/2     Running     0               4m41s
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.56.16](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.56.16))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ curl -LOs https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.16/sonobuoy_0.56.16_linux_amd64.tar.gz
$ tar -zxvf sonobuoy_0.56.16_linux_amd64.tar.gz
$ ./sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ ./sonobuoy status
```
