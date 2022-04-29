# Conformance tests for Fury Kubernetes cluster

## Cluster Provisioning

### Create a terraform project

#### Requirements

This terraform project requires:

- A public subnet. The id: `subnet-abc`
- A private subnet. The id: `subnet-cba`
- terraform 0.12 installed
  - AWS credentials along with enough permissions to provision instances and security groups.

Also, requires the following environment variables:

```bash
#!/bin/bash

export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=THE_SECRET_KEY
export AWS_DEFAULT_REGION=YOUR_REGION # (currently supports eu-regions)
```

#### Prepare

Use the provided [terraform module](https://github.com/sighupio/k8s-conformance-environment/tree/v1.0.6/modules/aws-k8s-conformance) to create a Kubernetes Cluster on top of AWS in a terraform project:

*simple usage is as follows*

*`main.tf`*
```hcl
data "aws_region" "current" {}

module "fury" {
  source = "git::git@github.com:sighupio/k8s-conformance-environment.git//modules/aws-k8s-conformance?ref=v1.0.6"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.22.0"
  worker_count    = 3

  public_subnet_id  = "subnet-your-id"
  private_subnet_id = "subnet-your-id"
  pod_network_cidr  = "172.16.0.0/16" # Fury's CNI (calico) is preconfigured to use this CIDR

  cgroupdriver = "systemd" # Important in 1.22 to use systemd as cgroupdriver for docker, since it is default for kubernetes

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
Downloading git::git@github.com:sighupio/k8s-conformance-environment.git?ref=v1.0.6 for fury...
- fury in .terraform/modules/fury/modules/aws-k8s-conformance

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "random" (hashicorp/random) 2.3.1...
- Downloading plugin for provider "null" (hashicorp/null) 3.0.0...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.70.0...
- Downloading plugin for provider "local" (hashicorp/local) 2.0.0...
- Downloading plugin for provider "tls" (hashicorp/tls) 2.2.0...
- Downloading plugin for provider "template" (hashicorp/template) 2.2.0...

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
module.fury.tls_private_key.master: Refreshing state... [id=f60e591acac066ec81cff1d710db492c1e68e6fa]
module.fury.random_string.second_part: Refreshing state... [id=kusr6yhhv8b1gwps]
module.fury.random_string.firts_part: Refreshing state... [id=utjyjh]
module.fury.data.aws_subnet.public: Refreshing state...
module.fury.data.aws_subnet.private: Refreshing state...
data.aws_region.current: Refreshing state...
module.fury.data.aws_vpc.vpc: Refreshing state...
module.fury.aws_security_group.worker: Refreshing state... [id=sg-0ac02910104e1da6c]
module.fury.aws_security_group.master: Refreshing state... [id=sg-07d8d0d36687e1a44]
module.fury.aws_security_group_rule.master_ingress: Refreshing state... [id=sgrule-1427735278]
module.fury.aws_security_group_rule.master_egress: Refreshing state... [id=sgrule-376657121]
module.fury.aws_security_group_rule.worker_ingress_self: Refreshing state... [id=sgrule-3449256101]
module.fury.aws_security_group_rule.worker_egress: Refreshing state... [id=sgrule-3504005245]
module.fury.aws_security_group_rule.worker_ingress: Refreshing state... [id=sgrule-4168832123]
module.fury.aws_eip.master: Creating...
module.fury.aws_eip.master: Creation complete after 0s [id=eipalloc-367ec73d]
module.fury.null_resource.kubeconfig: Creating...
module.fury.data.template_file.init_master: Refreshing state...
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBb1JFdlRHMjliUFJVRXRmR1U4eFhTb2FpR21QWVlsTG8rKy9qM0VtVTJyeWd4ckgrCmlCZlBLM0Vla1R4SC9EMXhRSXpHMjVCNk9pUDdsTlN1aU9hZWpLUDFwWWFIbmlhY29rM1FWTVNNOFgrSXljOFEKTFZPZUFQS1BiRHFzTlBDSHhTbTZiSUVlSlR2MjVxSXZOMWY1UE1QQW5YVUlXeWd2bGMvQkVqeEkwcmU1a3luLwp5VENBeUhwdWZaSHY0YkFXRjN6Nlo2Q3BnTkpvVHdYOWdVdzRIdXljSHYwUmhZZUpwdE1jQzJid1RuWkVQVDJBCjc0a2NaYWVLL00vMk8yVGM4SG91Q1IrUHlkeXVjZTJvM1FHZGFQWDhHRjdCampoalAwei93SnpsdGMvRnJxOUoKY2RzdzFEYS91aUdKNXNIT3NVdzZDME9qV3RwKzZ0Z3psZW1lOVVQVFhlMnVreGJLclBDRDM5YnZqbGJxb01vbgpYdVZpT3BLNVRqVUQzeVRpU05Za2JFMzRZTndGSWJicGRhNThGK3dib1RRL3NPZCttMWNuU21XUmpwWnNuZVJLClBnQXRRQitDMWNMU2VxWkpMTS9pTjU1aWR4MmFsVjRGNTk1THVPR2R2aEFEajNac2VzQzhyNXU1VDZRRHJ3ZW4KcDNiUUN1RjN3ekJBbm1sM012WHhMa2dHWlFUaC9WZExMajZSNHR4YTViZ2xnNENHWXZCYlNlbWlQMUxnZFBEaApWQklYS0VwcHpnQ0l4UzZMMlVrbmwzeEwxR3ZaQnhzTjF3Q1duK3ZwTnBvNWpGblZLQWN1YkZRbWxWT0E1dEJtCmxyUGFDR3RJRDZjQi84a1NSdDhjQ3lDeXArdGRjNll5U3NrYVRIOEtOdHV0OXhlbnNHRVFuSUJQMy9VQ0F3RUEKQVFLQ0FnQWlTV1UzTU5rMUcySFdUUWFVQ2hpKzdhQU9YQmpRL1hOSlJrek1OUUd4K3B1REVKcnRYNXdqVkVZOApob2VRWTRmN1JMeUVPdUk2QkRUbS9zdFVxenN2Rnl3UW0yMjlOZHo4RS9KNFNRcnowY0ZOckgxMkdLbTI2K3VxCkQyZGZNYURGVU5lMWgxcmlkRHhmNWtDRTJINWUrQkRGdEFjZVdKU2dvSVFxSEprbitpSlArSTNSeHpoeTlOVVcKZC8ySG5wTmxWcDU3ZHREK2NrdndIb2RUZ2VVa2VCdlg0T2xjOG5oVUFmYWpXcnRuQ0hnSVRWSm9LMWpYTHU1QQpXUWpDcGZyK1doUDRyelpOczJPVEx4TldVS1N3bGtTZTczVG1rSXhZQ2swYk5Jc1Z3L0FCK3FCNDB6ODJ2WnpjCnc0ejJpV1UxaXRPRVdGYXEzWDVOQWM4aFo0VUZ2SHdranNBcTNjWlMxcDBidUtqWmNtY1p5R20yRlVjL0N0WGgKWVlNM21jdW8rOERJMzdSTU1jSEZiOGhkWFV1T1dGNFMwVjViOEwzUXR1bld6S2o0TXlTdVRBZGhiWTZtODBvMApjWDN3L09qYXg5TXBHRFprazNmRXBkQWc0czVVNlU3bzB6OWF1ckZad3VMdzJpV04ydVRGeDJYSmZkRkxqSTNXCk5IVHV1RncwdXg1bXdiTDFpQ25KdnV4K2djQlQzK0g1YnVGRVlWV0ZKZW1qWVR0eitLclV2UENSdnJNdVpUK1YKNDE0RVhvMGFWV1dyYTA0NDZYckl3Z2ZpM3EvTVdaTzlZbnJTNFFOaWtWd2NDTjFDcGdaUFhtRm5GY25ja1NiUQpKR1ZRWkpNV2dpcmZKVzZSbE43ZFhFMEkwbnlQZVcxZ05iTFpPSnR2eVU1blprNVZsUUtDQVFFQXhwcUNTV21WCjdvaHUxN3Y2c3QxY2Y0Nlk2UXZKWnBQRU5YWFRkUW1GS3lPeGQxWGo1bW9rc010cnFDTlBPUmpHU0JkdGhzOFgKMzJBVTZwSEtxMUtDOTdXL1czWEFLKy9XanZSdXc2VHg0OW5yT0JZekpFUVFXV0xPU29QLzlIakhwOXVpV2lDeApJNDZISS9seTdMcGxQTXBkZ05yaEl1L3JhMHVObDROV3h5Q0dKaVgwRE5qU0YrOUlDWG96ckNpeE5aVHZPSU5yClhTeDBhNDR4OHVXWCtwLzE2WEdtOVlpUzFncW52TnJDK2h0VmpBcU96L2VDZ2xwNFlTcVAzbnlTQTB2L0thRG4KWW9IaEpJZ2Q2WFB1ajMwOFlDY0VOQ0ovQ2kwVE5ZSzlQN2IwWmoyVjRnSEVaSjFMUnJjNDVPTE83REQxOTJUaAphQXpRZyswVEFJQUw2d0tDQVFFQXo1MlVlNG1rbnErUGJNVDlXVWFDSjRDQnppU29lQ2hqdUNKSHphTStBcERuCmJHMDYzZmJ4RDhHV3dzcGk2TlF5TEFTN0NYRjBYZDk4Rkd1eitwOUJ0cW5IRnE1Vlo4RHF4SVU3ZFR2OE02TmsKNHNIdEx5SElIWTZ5L1o2OU80ejE5MjB1cWNEcjV0dVlNRWlFZDRqb09zNDNROEhYRnFDV3M4aml0Rjh5U2F4TApVQUNneVlGZnRXcFFsaUVJSEJNLzdJRitVOVplVlh3elYyaEdENjEweWRkNDJXMWpaUmg3V21OMWppbnk3V0UvCjQ4dUczYnZtd1FCcWFqeThVdUhLOFYyTEFGMDlNMEJZOGtWM2FUbDFnbHZuUmpISWJRVHkwVjBGcTJheGRzY2IKc1dFN2RKSlYvRGYvTmdWZkFiZG9ua1BhM1YzU1ZWUmQ1VnNwUWxncm53S0NBUUVBaW1SNGpYZUtCdUlEZTBsKwpkTTFUKzM3K2hzYXozVXJ5MnQzME1BWW1TZDFoZU9yZEdGNjJtb3ZseFJCMTBDKzNXOTBYY1cwMkVXMytwVVphCmwrK3pXN0hHV3BFL0RGN2dnRlZNS2dEeW5mZm90UGlqUW80N1prNDN1aTBwV3M0Zk1wVVdHUC9XOEJRTmo3L3YKbVk1NXBWYk91VS9NdW0rOCtOTjVJeTllZFB2dy92eExoL2crem5ickY4K1Qyayt3ek1tdnVRMjY3djVmVWVPUQpZdFlpaFg2WitjWTh0YlFwdmdWR3hZOGJkdlU5TTR6WDM0dDE0aWZ3NHFTcUJEdUI4OUl0U0hEYlRBVjlRZHVvCkhGbXd6MFJSb2g4T0N0Wk8rR1JZa2wwOFN2M09hTUJaaFZmOTVxN0ZHYzNyVTNQSkJVVkk0TS9uVW40N2Z2TGcKM3VSYmFRS0NBUUVBb0VzU3c5cStuY0lBSTBOb001Qkxsd0lSdGozNVVHUW1zWmpPQlVlKzdhNUE3eWJhWjF0cwpQUFVEV0R0MzZEbEV6MVdMcnJ2STAxMWo2RVJMZmZtTmUrRlRGQURmY2E2eDA2N2wvQnFuR3B0Um5mMktDWFMwCms1V0VQbXBid2VtUVVrc2ExdmRiYXk4cUxrVWUrVWRidldOUHFlRzBGZ1ZBdFdncEdJZlRSS3hnclZEKzB2VXYKRnRzUmd3Zlh3ZzFlc2xROFc3Qkx2d2FZZ1NqQnh3THVBNVIzK3E4SktabWdTMlkwOGVFVGJSRkRpYld1MSsxbQpPS2NBZ2l1SVh4bHpYYTBTVCtLdENLL3F2SXJEcWhzeHpjYjFKZTN6eDdBbFpWM0RyZFVvdVFMN0w1VlptU1FPCmZTQWl5K3VUc2JpUWJua0hOeGhqOTN1ZXp5RDJGd0lLRXdLQ0FRQm8rTWVsMlVxL2ZEZFZaZW1Oa2l0WFZCWDUKSnNyRzNueXVqcnpQREpqMkFYVXVSS0drK0o4R0xENDVrRmcvcGZHWEdGVCtoMWxiNWhHL3hjMHIveVRHT29JMwpPU1RGMkh5LzNxWVVaQ2NISXFML2JKV0c1a1Jza0J5K0RsY0d3R2pCMWVlRXpxWDZieVloek5xMENkTnd6ZU91CjhxVEZyVEZJdmc1bkZsL085Z2hOUm1KZGVPaHdtbkpPUENmNkZzc2VsN0xSc2FmUzZiL0w5VEFzSUZudDdLTisKNjJlMzk0Z1JZT1BnQ3dGUC9KQ0ozSC9ScXhLc2xwSmFWd0J4b3UxSytDVXlKV1NDVGtDblVmbkNTZ002aFpBUgp4WVZPU045OUZLNUpNdW9ZNUdQR2NCd240cURTSTNxRjBQa2ZYYzR4RHVtRFl6U2w4L2NWSWhONkltTWMKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K | base64 -d > ./master.key && chmod 600 ./master.key"]
module.fury.aws_spot_instance_request.master: Creating...
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "./wait-for.sh 3.122.17.242:6443 -t 1200 -- echo \"Cluster Ready\""]
module.fury.null_resource.kubeconfig: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Creation complete after 12s [id=sir-nhkya32j]
module.fury.data.template_file.init_worker: Refreshing state...
module.fury.aws_eip_association.eip_assoc: Creating...
module.fury.aws_spot_instance_request.worker[2]: Creating...
module.fury.aws_spot_instance_request.worker[1]: Creating...
module.fury.aws_spot_instance_request.worker[0]: Creating...
module.fury.aws_eip_association.eip_assoc: Creation complete after 5s [id=eipassoc-09304f6313f2f101c]
module.fury.null_resource.kubeconfig: Still creating... [20s elapsed]
module.fury.aws_spot_instance_request.worker[1]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[0]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[2]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[1]: Creation complete after 12s [id=sir-vbjeae2h]
module.fury.aws_spot_instance_request.worker[0]: Creation complete after 12s [id=sir-6i468aag]
module.fury.aws_spot_instance_request.worker[2]: Creation complete after 12s [id=sir-57868t1h]
module.fury.null_resource.kubeconfig: Still creating... [30s elapsed]
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
module.fury.null_resource.kubeconfig: Still creating... [2m40s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [2m50s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [3m0s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [3m10s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [3m20s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [3m30s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [3m40s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [3m50s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [4m0s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [4m10s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [4m20s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [4m30s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [4m40s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [4m50s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [5m0s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [5m10s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [5m20s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [5m30s elapsed]
module.fury.null_resource.kubeconfig (local-exec): Cluster Ready
module.fury.null_resource.kubeconfig: Provisioning with 'remote-exec'...
module.fury.null_resource.kubeconfig (remote-exec): Connecting to remote host via SSH...
module.fury.null_resource.kubeconfig (remote-exec):   Host: 3.122.17.242
module.fury.null_resource.kubeconfig (remote-exec):   User: fury
module.fury.null_resource.kubeconfig (remote-exec):   Password: false
module.fury.null_resource.kubeconfig (remote-exec):   Private key: true
module.fury.null_resource.kubeconfig (remote-exec):   Certificate: false
module.fury.null_resource.kubeconfig (remote-exec):   SSH Agent: false
module.fury.null_resource.kubeconfig (remote-exec):   Checking Host Key: false
module.fury.null_resource.kubeconfig (remote-exec): Connected!
module.fury.null_resource.kubeconfig: Still creating... [5m40s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [5m50s elapsed]
module.fury.null_resource.kubeconfig: Still creating... [6m0s elapsed]
module.fury.null_resource.kubeconfig (remote-exec): Cluster "kubernetes" set.
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "scp -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i master.key fury@3.122.17.242:/home/fury/.kube/config kubeconfig"]
module.fury.null_resource.kubeconfig (local-exec): Warning: Permanently added '3.122.17.242' (ECDSA) to the list of known hosts.
module.fury.null_resource.kubeconfig: Creation complete after 6m5s [id=5033302780773013280]
module.fury.data.local_file.kubeconfig: Refreshing state...

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = 3.122.17.242
tls_private_key = <sensitive>
```

##### Enter master node

```bash
$ terraform output tls_private_key > cluster.key && chmod 600 cluster.key && ssh -i cluster.key fury@3.122.17.242
# fury@fury@ip-10-0-0-191; do echo 'Waiting for cluster creation...'; sleep 5; done
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
# fury@ip-10-0-0-191:~$ kubectl get nodes
NAME                                          STATUS     ROLES                  AGE     VERSION
ip-10-0-0-191.eu-central-1.compute.internal   NotReady   control-plane,master   6m17s   v1.22.0
ip-10-0-1-157.eu-central-1.compute.internal   NotReady   <none>                 6m      v1.22.0
ip-10-0-1-195.eu-central-1.compute.internal   NotReady   <none>                 6m      v1.22.0
ip-10-0-1-62.eu-central-1.compute.internal    NotReady   <none>                 6m      v1.22.0
```

*Example output: ips and/or region could be different*

The cluster should be composed by *(at least)* three nodes in `NotReady` status.

## Install Fury Distribution

> Install requirements and run commands in the master node.

### Requirements

- [kustomize](https://github.com/kubernetes-sigs/kustomize/blob/master/docs/INSTALL.md): Used to render distribution
  manifests.
  Required version > [3.3](https://github.com/kubernetes-sigs/kustomize/releases/tag/kustomize%2Fv3.3.0)
- [furyctl](https://github.com/sighupio/furyctl#install): Downloads distribution files. Required version >
  [v0.2.4](https://github.com/sighupio/furyctl/releases/tag/v0.2.4)

```bash
# fury@ip-10-0-0-191:~$  curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.6.0/furyctl-linux-amd64
# fury@ip-10-0-0-191:~$  sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
# fury@ip-10-0-0-191:~$  sudo chmod +x /usr/local/bin/furyctl
# fury@ip-10-0-0-191:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.3.0/kustomize_v4.3.0_linux_amd64.tar.gz
# fury@ip-10-0-0-191:~$ tar -zxvf kustomize_v4.3.0_linux_amd64.tar.gz
kustomize
# fury@ip-10-0-0-191:~$  sudo mv kustomize /usr/local/bin/kustomize
```

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.7.0
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.7.0/Furyfile.yml -> Furyfile.yml
INFO[0000] removing Furyfile.yml/.git
ERRO[0000] unlinkat Furyfile.yml/.git: not a directory
INFO[0000] unlinkat Furyfile.yml/.git: not a directory
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.7.0/kustomization.yaml -> kustomization.yaml
INFO[0000] removing kustomization.yaml/.git
ERRO[0000] unlinkat kustomization.yaml/.git: not a directory
INFO[0000] unlinkat kustomization.yaml/.git: not a directory
$ furyctl vendor -H
INFO[0000] using v1.7.0 for package networking/calico
INFO[0000] using v1.13.0 for package monitoring/prometheus-operator
INFO[0000] using v1.13.0 for package monitoring/prometheus-operated
INFO[0000] using v1.13.0 for package monitoring/grafana
INFO[0000] using v1.13.0 for package monitoring/goldpinger
INFO[0000] using v1.13.0 for package monitoring/configs
INFO[0000] using v1.13.0 for package monitoring/kubeadm-sm
INFO[0000] using v1.13.0 for package monitoring/kube-proxy-metrics
INFO[0000] using v1.13.0 for package monitoring/kube-state-metrics
INFO[0000] using v1.13.0 for package monitoring/node-exporter
INFO[0000] using v1.13.0 for package monitoring/metrics-server
INFO[0000] using v1.9.0 for package logging/elasticsearch-single
INFO[0000] using v1.9.0 for package logging/cerebro
INFO[0000] using v1.9.0 for package logging/curator
INFO[0000] using v1.9.0 for package logging/fluentd
INFO[0000] using v1.9.0 for package logging/kibana
INFO[0000] using v1.11.1 for package ingress/cert-manager
INFO[0000] using v1.11.1 for package ingress/nginx
INFO[0000] using v1.11.1 for package ingress/forecastle
INFO[0000] using v1.8.0 for package dr/velero
INFO[0000] using v1.5.0 for package opa/gatekeeper
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-networking.git/katalog/calico?ref=v1.7.0 -> vendor/katalog/networking/calico
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/prometheus-operator?ref=v1.13.0 -> vendor/katalog/monitoring/prometheus-operator
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/grafana?ref=v1.13.0 -> vendor/katalog/monitoring/grafana
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/goldpinger?ref=v1.13.0 -> vendor/katalog/monitoring/goldpinger
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/prometheus-operated?ref=v1.13.0 -> vendor/katalog/monitoring/prometheus-operated
INFO[0000] removing vendor/katalog/networking/calico/.git
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/configs?ref=v1.13.0 -> vendor/katalog/monitoring/configs
INFO[0000] removing vendor/katalog/monitoring/goldpinger/.git
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kubeadm-sm?ref=v1.13.0 -> vendor/katalog/monitoring/kubeadm-sm
INFO[0001] removing vendor/katalog/monitoring/prometheus-operated/.git
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kube-proxy-metrics?ref=v1.13.0 -> vendor/katalog/monitoring/kube-proxy-metrics
INFO[0001] removing vendor/katalog/monitoring/grafana/.git
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kube-state-metrics?ref=v1.13.0 -> vendor/katalog/monitoring/kube-state-metrics
INFO[0002] removing vendor/katalog/monitoring/kubeadm-sm/.git
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/node-exporter?ref=v1.13.0 -> vendor/katalog/monitoring/node-exporter
INFO[0002] removing vendor/katalog/monitoring/configs/.git
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/metrics-server?ref=v1.13.0 -> vendor/katalog/monitoring/metrics-server
INFO[0002] removing vendor/katalog/monitoring/kube-proxy-metrics/.git
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/elasticsearch-single?ref=v1.9.0 -> vendor/katalog/logging/elasticsearch-single
INFO[0002] removing vendor/katalog/monitoring/prometheus-operator/.git
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/cerebro?ref=v1.9.0 -> vendor/katalog/logging/cerebro
INFO[0002] removing vendor/katalog/monitoring/kube-state-metrics/.git
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/curator?ref=v1.9.0 -> vendor/katalog/logging/curator
INFO[0002] removing vendor/katalog/logging/elasticsearch-single/.git
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/fluentd?ref=v1.9.0 -> vendor/katalog/logging/fluentd
INFO[0003] removing vendor/katalog/logging/cerebro/.git
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/kibana?ref=v1.9.0 -> vendor/katalog/logging/kibana
INFO[0003] removing vendor/katalog/monitoring/metrics-server/.git
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/cert-manager?ref=v1.11.1 -> vendor/katalog/ingress/cert-manager
INFO[0003] removing vendor/katalog/logging/curator/.git
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/nginx?ref=v1.11.1 -> vendor/katalog/ingress/nginx
INFO[0004] removing vendor/katalog/logging/kibana/.git
INFO[0004] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/forecastle?ref=v1.11.1 -> vendor/katalog/ingress/forecastle
INFO[0004] removing vendor/katalog/ingress/cert-manager/.git
INFO[0004] downloading: github.com/sighupio/fury-kubernetes-dr.git/katalog/velero?ref=v1.8.0 -> vendor/katalog/dr/velero
INFO[0004] removing vendor/katalog/monitoring/node-exporter/.git
INFO[0004] downloading: github.com/sighupio/fury-kubernetes-opa.git/katalog/gatekeeper?ref=v1.5.0 -> vendor/katalog/opa/gatekeeper
INFO[0004] removing vendor/katalog/ingress/forecastle/.git
INFO[0005] removing vendor/katalog/dr/velero/.git
INFO[0005] removing vendor/katalog/ingress/nginx/.git
INFO[0005] removing vendor/katalog/logging/fluentd/.git
INFO[0005] removing vendor/katalog/opa/gatekeeper/.git
```

Install Fury in the cluster:

```bash
$ kustomize build | kubectl apply -f -
```

> If you see any errors, try again until no error appears. There are some CRDs dependencies.

Wait until everything is up and running:

```bash
kubectl get pods -A
NAMESPACE            NAME                                                                  READY   STATUS      RESTARTS        AGE
cert-manager         cert-manager-7f55c54587-9m779                                         1/1     Running     0               4m16s
cert-manager         cert-manager-cainjector-cfffdfb47-2mhs9                               1/1     Running     0               4m16s
cert-manager         cert-manager-webhook-55db444fc6-hv6r5                                 1/1     Running     0               4m15s
gatekeeper-system    gatekeeper-audit-7bf6b564f7-lbpgk                                     1/1     Running     0               4m15s
gatekeeper-system    gatekeeper-controller-manager-677df48547-l55zc                        1/1     Running     0               4m15s
gatekeeper-system    gatekeeper-controller-manager-677df48547-wk9pz                        1/1     Running     0               4m15s
gatekeeper-system    gatekeeper-controller-manager-677df48547-x4m86                        1/1     Running     0               4m15s
gatekeeper-system    gatekeeper-policy-manager-ff6986bf4-t2qnc                             1/1     Running     0               4m15s
ingress-nginx        forecastle-c699f45d9-smllg                                            1/1     Running     0               4m15s
ingress-nginx        nginx-ingress-controller-d2rdj                                        1/1     Running     0               4m14s
ingress-nginx        nginx-ingress-controller-k6grh                                        1/1     Running     0               4m14s
ingress-nginx        nginx-ingress-controller-nrpzz                                        1/1     Running     0               4m14s
kube-system          calico-kube-controllers-7d47f4d496-2cwm9                              1/1     Running     0               5m36s
kube-system          calico-node-4wbcq                                                     1/1     Running     0               5m36s
kube-system          calico-node-7pvwl                                                     1/1     Running     0               5m36s
kube-system          calico-node-hrz4n                                                     1/1     Running     0               5m36s
kube-system          calico-node-v7bns                                                     1/1     Running     0               5m36s
kube-system          coredns-78fcd69978-76w2c                                              1/1     Running     0               27m
kube-system          coredns-78fcd69978-s7mrr                                              1/1     Running     0               27m
kube-system          etcd-ip-10-0-0-247.eu-central-1.compute.internal                      1/1     Running     0               28m
kube-system          kube-apiserver-ip-10-0-0-247.eu-central-1.compute.internal            1/1     Running     0               28m
kube-system          kube-controller-manager-ip-10-0-0-247.eu-central-1.compute.internal   1/1     Running     0               28m
kube-system          kube-proxy-d4tdr                                                      1/1     Running     0               27m
kube-system          kube-proxy-h659z                                                      1/1     Running     0               27m
kube-system          kube-proxy-srdnz                                                      1/1     Running     0               27m
kube-system          kube-proxy-wg8d2                                                      1/1     Running     0               27m
kube-system          kube-scheduler-ip-10-0-0-247.eu-central-1.compute.internal            1/1     Running     0               28m
kube-system          metrics-server-5dd7c59cfd-qbf9g                                       0/1     Running     0               4m15s
kube-system          minio-0                                                               1/1     Running     0               4m15s
kube-system          minio-setup--1-szqb6                                                  0/1     Completed   0               4m13s
kube-system          velero-6fd458c5fb-bn686                                               1/1     Running     0               4m15s
kube-system          velero-restic-5g2rf                                                   1/1     Running     0               4m14s
kube-system          velero-restic-jczqg                                                   1/1     Running     0               4m14s
kube-system          velero-restic-x9vq9                                                   1/1     Running     0               4m14s
local-path-storage   local-path-provisioner-556d4466c8-npgjr                               1/1     Running     0               27m
logging              cerebro-645ccc748f-j8mkz                                              1/1     Running     0               4m14s
logging              elasticsearch-0                                                       2/2     Running     0               4m14s
logging              fluentbit-475db                                                       1/1     Running     0               4m14s
logging              fluentbit-jsggv                                                       1/1     Running     0               4m14s
logging              fluentbit-zzfmc                                                       1/1     Running     0               4m14s
logging              fluentbit-zzhnq                                                       1/1     Running     0               4m14s
logging              fluentd-0                                                             1/1     Running     0               4m14s
logging              fluentd-1                                                             1/1     Running     0               3m22s
logging              fluentd-2                                                             1/1     Running     0               2m24s
logging              kibana-6585f667c7-gjjpr                                               1/1     Running     0               4m14s
monitoring           alertmanager-main-0                                                   2/2     Running     0               35s
monitoring           alertmanager-main-1                                                   2/2     Running     0               35s
monitoring           alertmanager-main-2                                                   2/2     Running     0               35s
monitoring           goldpinger-2782g                                                      1/1     Running     0               4m14s
monitoring           goldpinger-lx6jl                                                      1/1     Running     0               4m14s
monitoring           goldpinger-mwpth                                                      1/1     Running     0               4m14s
monitoring           goldpinger-xrghz                                                      1/1     Running     0               4m13s
monitoring           grafana-7d8c8959df-rmr7p                                              2/2     Running     0               4m14s
monitoring           kube-proxy-metrics-2pgpg                                              1/1     Running     0               4m13s
monitoring           kube-proxy-metrics-c56hp                                              1/1     Running     0               4m13s
monitoring           kube-proxy-metrics-pcf9n                                              1/1     Running     0               4m13s
monitoring           kube-proxy-metrics-w5lqt                                              1/1     Running     0               4m13s
monitoring           kube-state-metrics-5cf45997c5-pvfw7                                   1/1     Running     0               4m14s
monitoring           node-exporter-6zg4m                                                   2/2     Running     0               4m13s
monitoring           node-exporter-8wj2l                                                   2/2     Running     0               4m13s
monitoring           node-exporter-r5dw5                                                   2/2     Running     0               4m13s
monitoring           node-exporter-tzkxd                                                   2/2     Running     0               4m13s
monitoring           prometheus-k8s-0                                                      2/2     Running     0               34s
monitoring           prometheus-operator-5fd6c6d948-7rbqp                                  1/1     Running     0               4m14s
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.53.2](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.53.2))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ sonobuoy status
```
