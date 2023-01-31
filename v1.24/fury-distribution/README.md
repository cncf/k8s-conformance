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
  source = "git::git@github.com:sighupio/k8s-conformance-environment.git//modules/aws-k8s-conformance?ref=v1.2.0"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.24.7"
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
Downloading git::git@github.com:sighupio/k8s-conformance-environment.git?ref=v1.2.0 for fury...
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
NAME                                         STATUS     ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
ip-10-0-10-103.eu-west-1.compute.internal    NotReady   control-plane   91s   v1.24.7   10.0.10.103    <none>        Ubuntu 20.04.5 LTS   5.15.0-1022-aws   containerd://1.6.8
ip-10-0-182-149.eu-west-1.compute.internal   NotReady   <none>          60s   v1.24.7   10.0.182.149   <none>        Ubuntu 20.04.5 LTS   5.15.0-1022-aws   containerd://1.6.8
ip-10-0-182-17.eu-west-1.compute.internal    NotReady   <none>          60s   v1.24.7   10.0.182.17    <none>        Ubuntu 20.04.5 LTS   5.15.0-1022-aws   containerd://1.6.8
ip-10-0-182-189.eu-west-1.compute.internal   NotReady   <none>          72s   v1.24.7   10.0.182.189   <none>        Ubuntu 20.04.5 LTS   5.15.0-1022-aws   containerd://1.6.8
```

*Example output: ips and/or region could be different*

The cluster should be composed by *(at least)* three worker nodes in `NotReady` status.

## Install Fury Distribution

> Install requirements and run commands in the master node.

### Requirements

- [kustomize](https://github.com/kubernetes-sigs/kustomize/blob/master/docs/INSTALL.md): Used to render distribution
  manifests.
  Required version > [3.5.4](https://github.com/kubernetes-sigs/kustomize/releases/tag/kustomize%2Fv3.5.3)
- [furyctl](https://github.com/sighupio/furyctl#install): Downloads distribution files. Required version >
  [v0.7.0](https://github.com/sighupio/furyctl/releases/tag/v0.7.0)

```bash
fury@ip-10-0-10-103:~$ curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.7.0/furyctl-linux-amd64
fury@ip-10-0-10-103:~$ sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
fury@ip-10-0-10-103:~$ sudo chmod +x /usr/local/bin/furyctl
fury@ip-10-0-10-103:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.5.3/kustomize_v3.5.3_linux_amd64.tar.gz
fury@ip-10-0-10-103:~$ tar -zxvf kustomize_v3.5.3_linux_amd64.tar.gz kustomize
fury@ip-10-0-10-103:~$ sudo mv kustomize /usr/local/bin/kustomize
```

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.24.0-rc2
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.24.0-rc2/Furyfile.yml -> Furyfile.yml 
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.24.0-rc2/kustomization.yaml -> kustomization.yaml
$ furyctl vendor -H
INFO[0000] using v1.13.0 for package ingress            
INFO[0000] using v1.10.1 for package dr                 
INFO[0000] using v1.10.0 for package networking         
INFO[0000] using v2.0.0 for package monitoring          
INFO[0000] using v3.0.1 for package logging             
INFO[0000] using v1.13.0 for package ingress            
INFO[0000] using v1.10.1 for package dr                 
INFO[0000] using v1.7.2 for package opa                 
INFO[0000] using v0.0.2 for package auth                
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-dr.git/modules?ref=v1.10.1 -> vendor/modules/dr 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-networking.git/katalog?ref=v1.10.0 -> vendor/katalog/networking 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-ingress.git/modules?ref=v1.13.0 -> vendor/modules/ingress 
INFO[0000] cleaning git subfolder: vendor/modules/dr/.git 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog?ref=v2.0.0 -> vendor/katalog/monitoring 
INFO[0000] cleaning git subfolder: vendor/katalog/networking/.git 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog?ref=v3.0.1 -> vendor/katalog/logging 
INFO[0000] cleaning git subfolder: vendor/modules/ingress/.git 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog?ref=v1.13.0 -> vendor/katalog/ingress 
INFO[0001] cleaning git subfolder: vendor/katalog/ingress/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-dr.git/katalog?ref=v1.10.1 -> vendor/katalog/dr 
INFO[0002] cleaning git subfolder: vendor/katalog/monitoring/.git 
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-opa.git/katalog?ref=v1.7.2 -> vendor/katalog/opa 
INFO[0002] cleaning git subfolder: vendor/katalog/logging/.git 
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-auth.git/katalog?ref=v0.0.2 -> vendor/katalog/auth 
INFO[0002] cleaning git subfolder: vendor/katalog/dr/.git 
INFO[0002] cleaning git subfolder: vendor/katalog/opa/.git 
INFO[0002] cleaning git subfolder: vendor/katalog/auth/.git 
```

Install Fury in the cluster:

```bash
$ kustomize build . | kubectl apply -f - --server-side
```

> If you see any errors, try again until no error appears. There are some CRDs and Webhooks dependencies.

Wait until everything is up and running:

```bash
kubectl get pods -A
NAMESPACE            NAME                                                                READY   STATUS      RESTARTS   AGE
cert-manager         cert-manager-765876d66-qhf55                                        1/1     Running     0          5m3s
cert-manager         cert-manager-cainjector-5bb7f69d4-wdq5h                             1/1     Running     0          5m3s
cert-manager         cert-manager-webhook-56bd8c588b-rjlnq                               1/1     Running     0          5m3s
gatekeeper-system    gatekeeper-audit-6d67868587-djg6c                                   1/1     Running     0          5m3s
gatekeeper-system    gatekeeper-controller-manager-7b8bf78c99-dzlbf                      1/1     Running     0          5m3s
gatekeeper-system    gatekeeper-controller-manager-7b8bf78c99-lhqhq                      1/1     Running     0          5m3s
gatekeeper-system    gatekeeper-controller-manager-7b8bf78c99-xqjrk                      1/1     Running     0          5m3s
gatekeeper-system    gatekeeper-policy-manager-7fc99ccf84-ksjxp                          1/1     Running     0          5m3s
ingress-nginx        forecastle-786b865974-lnqqj                                         1/1     Running     0          5m3s
ingress-nginx        nginx-ingress-controller-cztxq                                      1/1     Running     0          4m31s
ingress-nginx        nginx-ingress-controller-phc5p                                      1/1     Running     0          4m42s
ingress-nginx        nginx-ingress-controller-tvwrr                                      1/1     Running     0          4m40s
kube-system          calico-kube-controllers-6c748f8ffc-tlxzh                            1/1     Running     0          5m2s
kube-system          calico-node-6qlhn                                                   1/1     Running     0          5m2s
kube-system          calico-node-djb27                                                   1/1     Running     0          5m2s
kube-system          calico-node-drhfv                                                   1/1     Running     0          5m2s
kube-system          calico-node-sq7rp                                                   1/1     Running     0          5m2s
kube-system          coredns-6d4b75cb6d-fcqxj                                            1/1     Running     0          10m
kube-system          coredns-6d4b75cb6d-z5gms                                            1/1     Running     0          10m
kube-system          etcd-ip-10-0-10-169.eu-west-1.compute.internal                      1/1     Running     0          11m
kube-system          kube-apiserver-ip-10-0-10-169.eu-west-1.compute.internal            1/1     Running     0          11m
kube-system          kube-controller-manager-ip-10-0-10-169.eu-west-1.compute.internal   1/1     Running     0          11m
kube-system          kube-proxy-2x69w                                                    1/1     Running     0          10m
kube-system          kube-proxy-4r7l7                                                    1/1     Running     0          10m
kube-system          kube-proxy-bbtbt                                                    1/1     Running     0          10m
kube-system          kube-proxy-m97sj                                                    1/1     Running     0          10m
kube-system          kube-scheduler-ip-10-0-10-169.eu-west-1.compute.internal            1/1     Running     0          11m
kube-system          minio-0                                                             1/1     Running     0          5m3s
kube-system          minio-setup-sgzgc                                                   0/1     Completed   0          5m2s
kube-system          velero-9c9559949-66vz2                                              1/1     Running     0          5m2s
kube-system          velero-restic-fhsfs                                                 1/1     Running     0          4m31s
kube-system          velero-restic-n8ppg                                                 1/1     Running     0          4m42s
kube-system          velero-restic-xhmpd                                                 1/1     Running     0          4m40s
local-path-storage   local-path-provisioner-768b54f6c8-hz5bc                             1/1     Running     0          10m
logging              audit-host-tailer-vgvkw                                             1/1     Running     0          3m24s
logging              cerebro-8d5f6ff95-mfhjx                                             1/1     Running     0          5m2s
logging              infra-fluentbit-lnkc7                                               1/1     Running     0          2m54s
logging              infra-fluentbit-nt6jk                                               1/1     Running     0          2m54s
logging              infra-fluentbit-pg2nl                                               1/1     Running     0          2m54s
logging              infra-fluentbit-v4t7v                                               1/1     Running     0          2m54s
logging              infra-fluentd-0                                                     2/2     Running     0          2m54s
logging              infra-fluentd-1                                                     2/2     Running     0          2m45s
logging              infra-fluentd-configcheck-910f2aba                                  0/1     Completed   0          3m22s
logging              kubernetes-event-tailer-0                                           1/1     Running     0          3m24s
logging              logging-operator-545cf8bdf7-qfdk9                                   1/1     Running     0          5m2s
logging              minio-0                                                             1/1     Running     0          5m3s
logging              minio-1                                                             1/1     Running     0          5m2s
logging              opensearch-cluster-master-0                                         2/2     Running     0          5m3s
logging              opensearch-dashboards-6b65757b65-hz6qm                              1/1     Running     0          5m2s
logging              systemd-common-host-tailer-gfvbr                                    3/3     Running     0          3m24s
logging              systemd-common-host-tailer-r4gkp                                    3/3     Running     0          3m24s
logging              systemd-common-host-tailer-swgrk                                    3/3     Running     0          3m24s
logging              systemd-common-host-tailer-x5d9s                                    3/3     Running     0          3m24s
logging              systemd-etcd-host-tailer-rgzf9                                      1/1     Running     0          3m23s
monitoring           alertmanager-main-0                                                 2/2     Running     0          3m24s
monitoring           grafana-69c8c8b8d7-8mbll                                            3/3     Running     0          5m1s
monitoring           kube-proxy-metrics-ljnmv                                            1/1     Running     0          5m2s
monitoring           kube-proxy-metrics-n6wg4                                            1/1     Running     0          5m2s
monitoring           kube-proxy-metrics-vbmp5                                            1/1     Running     0          5m2s
monitoring           kube-proxy-metrics-xvfzn                                            1/1     Running     0          5m2s
monitoring           kube-state-metrics-6bfb7c4498-x662s                                 3/3     Running     0          5m1s
monitoring           node-exporter-4cwz6                                                 2/2     Running     0          5m2s
monitoring           node-exporter-6s897                                                 2/2     Running     0          5m2s
monitoring           node-exporter-l8n5c                                                 2/2     Running     0          5m2s
monitoring           node-exporter-shk4f                                                 2/2     Running     0          5m2s
monitoring           prometheus-adapter-5b5695f68f-h2ql2                                 1/1     Running     0          5m1s
monitoring           prometheus-k8s-0                                                    2/2     Running     0          3m24s
monitoring           prometheus-operator-6d45b69b7b-f52c4                                2/2     Running     0          5m1s
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.56.11](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.56.11))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ sonobuoy status
```
