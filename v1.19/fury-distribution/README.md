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

Use the provided [terraform module](https://github.com/sighupio/k8s-conformance-environment/tree/v1.0.5/modules/aws-k8s-conformance) to create a Kubernetes Cluster on top of AWS in a terraform project:

*simple usage is as follows*

*`main.tf`*
```hcl
data "aws_region" "current" {}

module "fury" {
  source = "git::git@github.com:sighupio/k8s-conformance-environment.git//modules/aws-k8s-conformance?ref=v1.0.11"

  region = data.aws_region.current.name

  cluster_name    = "fury"
  cluster_version = "1.19.4"
  worker_count    = 3

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
Downloading git::git@github.com:sighupio/k8s-conformance-environment.git?ref=v1.0.5 for fury...
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
data.aws_region.current: Refreshing state...
module.fury.data.aws_subnet.private: Refreshing state...
module.fury.data.aws_subnet.public: Refreshing state...
module.fury.data.aws_vpc.vpc: Refreshing state...
module.fury.random_string.firts_part: Creating...
module.fury.tls_private_key.master: Creating...
module.fury.random_string.second_part: Creating...
module.fury.random_string.second_part: Creation complete after 0s [id=2emz5h8q81gdwwt6]
module.fury.random_string.firts_part: Creation complete after 0s [id=r6cj7f]
module.fury.tls_private_key.master: Creation complete after 1s [id=8ffeeaa6fbeefaff30fa3300af01dea142521630]
module.fury.aws_security_group.worker: Creating...
module.fury.aws_security_group.master: Creating...
module.fury.aws_eip.master: Creating...
module.fury.aws_eip.master: Creation complete after 1s [id=eipalloc-0adc5aef07459cce1]
module.fury.data.template_file.init_master: Refreshing state...
module.fury.null_resource.kubeconfig: Creating...
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS0FJQkFBS0NBZ0VBM3lOeWNzcyt5WW5mT3h2cTBhaDFqYXJrcmxzbWtRWjJiV095bjlBUXkzSGVVNkRJCkRpMkxmbXVCZ3lNdDZ1bEVSNnd4UjNrN2w0UkJ4MlE0VENlSEtNeDR4M2hmZldJQlBlc2tWL01uZVNhSTg4aEcKaFd1OVkrZm5yU3lkODZSa25vTkFaQ0tjTnJ2bXkxM281MUtSdHZFUjA5bWJuZGpPT1M0N0pDT2JjZ0orZ0hhdAp3YVNwSXpaV2ozamJkK3VxbE1mcWxCSjBXUDArNkk3cWxLNGwxZWJIOGljNU1iVVFLeU1ISDFoQmJmWGI2dnhPCk1FWU41TmVGbGlJd21NSk84bjh5THh3eU9jaUFuNGd1eGMvOWtPeHlLNjdmN1dsZjVNVXBBZmc3YWZhTUJ0bUsKZk15eWdJT20wTGltL01xQzkxSTN6Sm1JNElXVXdxQngzd2JqODlrUEhodkhRdnF3MWJEQjNpa0VSRjkyTHE2VQpDQkp3N2ZlOWVvZSthVThxUXNBRDI3VlpHTVUvanlPc1FDTVhPSnhPcXdqUlgyQUU1WkxwL2NhTHJhdWtwcjZqCjBscWk3WHhaVCtXZ0lTNHBVcjVQN0hTdHRvQVhpNjlDNVZYcDdrZVRDc3ZzR1RCZStwMkh1b0hiRldITUI5NGEKSU5UYzBkeGtaWWFkd2lVZ3dVbC9xM2k0dE4wZ0tvYlRlZWlxMDM0S1RJZXlieDVNbFRsZCtYOFhZUDJFWjJiQQovay83WVdWUXFJQWNhaHNSS0JEMTRPWWVmbzJoRXpnM09VTkp0YVdkUDBiaVRreEZxV0hmZ2RMVjZLaFpIaEI4CmZ1dWwzNmhFYyszVGVXaVJRMGIvcjhRM1hNUVVDbXBjZVE4ellYYVMvUXl0bVZITVJWT0hYcDFWUU4wQ0F3RUEKQVFLQ0FnQjFHb3REeDNxS0ZuczY4Q25LSWhpZllxSmxCcDAwMnlsbnV6elJOa2E2SG1aSmlVVzBleDZNR0N0KwpBUVptRkVtck82a1pFM3k4eGNJbnZHYjNRSDlrWC9xNjVHZG95L2hPNElyUVJXSGY2T05TM1RaMWF0ZVlDT3JECkxYa3Zsb1RmMDQ0RmYweHdSU2lZYmc1KzZBeGs4QnNsRFR6b0dCSVNYRHJaZW41bjFQdEN2QVh3YkZQL2tOTFkKdE5xcEV0c1EvZUlVRjZOTDJJd2RUSE83MTdFdmt0QTRPM0YrcnNGdmdoQ0kySzV0NE91clpRSTd2MmduUXh4dQpjRDhFekdUV1N2NnhUcURsUmw2S1d0UUJLR2l3bUFaSytwbTJaT2pZak1nNnFtV3o5Sm9FTmtMQndFT2x3bkhYCmRERGUxZ0RwZnhLZG82Mzc5dDdkVFlxMU8wNkJmZmljSzM0TjV0cVFBQjkzTE9OejRaUkZndVQ0NndiSnJ0UVEKM01TOFZ4Rk54amsyQmcwNUlpWFJia25WY3J5N09QZjBOTHpEYWh4eUg2UDFVWVVZNUhZMXRaODJDQy9LaThvcwpWdUdqelo3czE0MmRibS83QVpXLzhJM0RTYXNCbTdoeDRpRXpaZzRDUXFnUXhocG9kd3JQb0RMOU9IbXFVTEtsCmxRRFY5OUpWbVEwMzFrZnVqQURwYUdwK2RGKzJSQUIwclpTVTNGVkRhT1ZEWC9ZUXpadWgxOFBlR2srMFNMN2gKWlJLUUxhMnM1MFhMVVViOUdIdmNJbFUyd0wzakRZK3BMTFg3V1lvVUNiQkZUcHJQYTR6d3J1MjVneEd4R08ydApGYkE3ak5ab1NEOUVvY0ZVUE9Fek9HZnU4ekdZKzhJWkp3OVFudzJ4Nktzb2xweW4yUUtDQVFFQTdlU2hvNXduCmlNTEdGczhPMFllTXBwSDM4L3lwQWpuQ2NGK1ZrRXREUzYzcHRFWHd0MnhCMDZFUm56a0J3eXN3MUxhNW9FemYKOEFWSlkrYndBK0VJOFFydmtRY0RFZGFmVmV6cldXSGVzcEg1L0V4T0FlanRqSHFDZy9uczdIVUJlVDRaNGFUOQpGNmptK1pVV3Bia2NqM3pXTEwvZkd4UUc5VS8zWE5GSmR1RzJYcEJYb1ArNHVDVG94MGFxLzhiZjkvb2NBWGNYCnV6WnJYTXk4cmc1d1NhZDRhZ2g1QnpqZkxteC8yV1JsN1BIQnJPVTZmdVNLajRDS25kOXNtK2poUnBBcUJNUncKRzYwZkhjcTBTLzFuUEFrWjFPRW9mUXdQV2lXdXhDbFQ5YXcvc0lLQmRSNzdibm1WTXNWMFAxK285SW5VOWs3TAovSWE4cHRVYkQyWDBpd0tDQVFFQThCOVNCeHJxVjl4TGtyOWFhRGI0TTd0eWFoRk9ldURQS1hzTFN1dWRmaDh5CnFGYXQ4dGNvQlBiWC91RjJ3b05Dd3ZDempPd2EvalZnc29DTm02VjlYMjJ1TjhYbUJTK01BWC8vUU9PSmtnaksKdVZUK3YxejQwSG5ndkU5TVdHRkQvVjlHYnNtbXdOT3JHbzgvbFp0LzUzQThuS0JRNmV1TDEyMVlIb2JUYzloUgpCWjYySkFnVnJNc2FuZnRzQjBIZFFZR2lFNi9sMzBDZkI5WTd6MTh2bGJjSmZVUXJrQ1FnOGFHbFMzTjhQSXh3CkdzWkdDVDhzNkRGQzM3dWlSZGFjbE53ZDBLeWdsRFJYN0JJd3VQOHg1Yy9mbFcyRHBwZ2RpNjhxMTAzQXFSVEMKMEFjbjF6ZE1sTkNaUW9YVWMrS1RjaUVPcHlheXEwQ3NmUVc4cTlVRk53S0NBUUVBNjNKUUpGemxwKzZXSFhiNwpCSmV5dGgxY0djZ2tBY2JtMFU5WStNSDByYzlIc1p0VFBrYlA4OFBEYkNJQXc0aFl3UDdFUTRveVRSeitZUGpzCjdmbm9YcURqTUZlUFN6VnU1NTBmNVl2KzNCK3NHbS91K09idlRRem5aZldTN3doeTErdUZ0QlVXUlRkdXV2QTYKeFBTcjlydW9RZ3Y0cFpVeHVkTldVQy8zRk1rYU5RZUpJeGhWV3pOMGk5NCtXZjRjSnhNTWFzclMyd0JtVENkNgpTbzZSeGVRUlFtaDJXSmFLRlNsZmMrcHhFb3pIa2ZZaDZmc0p4RE9GZmZEbVRueXprYUlYWkRhRGVuRGlqaHJVClRTMVU0azlqbUpUci9LOVY5bk83UC94alU1QVNUUUV0WFp5M1hzVEl6TUl1WnBhbjRyY1Q1bDlnZHVObmpYcjMKV0VzaE53S0NBUUF6ZlRQVXJEUFY5VG9MVkpicFEraERCNDNJS3IvZVgzaHNsNkxiUk55M242NzRJK1lXN1lYNgpVb2dNY29KSndXVytjV2krN2gzM3ByQitka3huTkx4R2l6bFJZbEVwaVlHSEROQktOTUJhSFNLRFRUTjNDMU9iCk9KYzFLZmZmOTdOaGtGMkZBaDZNdUphM0VrSjdMU1huRmMwWmROTUU1ZXBObm5mSHkvZHBudGY0MFlpUy8xek8KZVpyU2g0Z3BvamowZy95aUpoU3ZvNmEyUW56K3daVnRrQnNyemtOZEhESW9QaFk0c0tIU1JmYi85c1lyMDIwbwp1Tzl6RkVQK243OWh1RFY0ZXB2UVM4MFNwTy9ucTJraXMwbHBQRnQvakp6QlNDVnlsNHlaZFFjMUhtT3ZwWDc1ClppV0creldNUitpQUQ1Q1p6UldBM1ZSZlZxeVhXQTFQQW9JQkFBYjFBR2VxeDh1ZHZQSGc5d29saWNITnZaMWUKQldDVjZuN21WT0wwWEM5SnlCZnNNWUxWWUFzcE9UWDRBUXlGN0ZXanA0dGJpU004UVNEWmZtck04UzROdU5oaApXWkJ3M3VxVCtiaW9MVFhUcFBmYXdxTGpwTjZlMk1SVFRHOE5sbGlLc2MyWHROZ3hEMHg3ZExONmI3Y3IxdE10Cko2T0N0V2VvNVBSeWFTTjZZQ1I4cGVhSXFqVDBsV1Y1ckJaVFB2VEJrbVZpdjFwN3I5UmZKSXVoOUhRMi9TczcKMCtrU3p4MDNsRzB1MlVmc25pcGtvWTVRQVI1NHJoSitDSTJZSDF5cHkzcVF1U2hWUGhvdzZxdmVnakk2VHVzQwpENkdhZmZZeGMwcWlPWW9HTDJRTTJuUVphWnNOYkFMa0FrTkhpN2tjbzR5eEd1bzZXaENaNitsMU5tRT0KLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K | base64 -d > ./master.key && chmod 600 ./master.key"]
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "./wait-for.sh 54.72.116.217:6443 -t 1200 -- echo \"Cluster Ready\""]
module.fury.aws_security_group.worker: Creation complete after 2s [id=sg-0a2f28180829efe82]
module.fury.aws_security_group_rule.worker_ingress_self: Creating...
module.fury.aws_security_group_rule.worker_egress: Creating...
module.fury.aws_security_group.master: Creation complete after 2s [id=sg-061785c16e3d4ab80]
module.fury.aws_security_group_rule.worker_ingress: Creating...
module.fury.aws_security_group_rule.master_ingress: Creating...
module.fury.aws_security_group_rule.master_egress: Creating...
module.fury.aws_spot_instance_request.master: Creating...
module.fury.aws_security_group_rule.worker_ingress_self: Creation complete after 0s [id=sgrule-661325203]
module.fury.aws_security_group_rule.master_ingress: Creation complete after 0s [id=sgrule-3984559377]
module.fury.aws_security_group_rule.master_egress: Creation complete after 1s [id=sgrule-3453592790]
module.fury.aws_security_group_rule.worker_egress: Creation complete after 1s [id=sgrule-1576966046]
module.fury.aws_security_group_rule.worker_ingress: Creation complete after 2s [id=sgrule-391019314]
module.fury.null_resource.kubeconfig: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Creation complete after 12s [id=sir-6rcg7rmp]
module.fury.data.template_file.init_worker: Refreshing state...
module.fury.aws_eip_association.eip_assoc: Creating...
module.fury.aws_spot_instance_request.worker[1]: Creating...
module.fury.aws_spot_instance_request.worker[0]: Creating...
module.fury.aws_spot_instance_request.worker[2]: Creating...
module.fury.aws_eip_association.eip_assoc: Creation complete after 6s [id=eipassoc-0b90c463a289cbd14]
module.fury.null_resource.kubeconfig: Still creating... [20s elapsed]
module.fury.aws_spot_instance_request.worker[1]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[0]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[2]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[2]: Creation complete after 12s [id=sir-mwgi7cjp]
module.fury.aws_spot_instance_request.worker[1]: Creation complete after 12s [id=sir-bdig6wfm]
module.fury.aws_spot_instance_request.worker[0]: Creation complete after 12s [id=sir-3krr63sn]
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
module.fury.null_resource.kubeconfig (local-exec): Cluster Ready
module.fury.null_resource.kubeconfig: Provisioning with 'remote-exec'...
module.fury.null_resource.kubeconfig (remote-exec): Connecting to remote host via SSH...
module.fury.null_resource.kubeconfig (remote-exec):   Host: 54.72.116.217
module.fury.null_resource.kubeconfig (remote-exec):   User: fury
module.fury.null_resource.kubeconfig (remote-exec):   Password: false
module.fury.null_resource.kubeconfig (remote-exec):   Private key: true
module.fury.null_resource.kubeconfig (remote-exec):   Certificate: false
module.fury.null_resource.kubeconfig (remote-exec):   SSH Agent: false
module.fury.null_resource.kubeconfig (remote-exec):   Checking Host Key: false
module.fury.null_resource.kubeconfig (remote-exec): Connected!
module.fury.null_resource.kubeconfig: Still creating... [5m0s elapsed]
module.fury.null_resource.kubeconfig (remote-exec): Cluster "kubernetes" set.
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "scp -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i master.key fury@54.72.116.217:/home/fury/.kube/config kubeconfig"]
module.fury.null_resource.kubeconfig (local-exec): Warning: Permanently added '54.72.116.217' (ECDSA) to the list of known hosts.
module.fury.null_resource.kubeconfig: Creation complete after 5m2s [id=5274316687397970457]
module.fury.data.local_file.kubeconfig: Refreshing state...

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = 54.72.116.217
tls_private_key = <sensitive>
```

##### Enter master node

```bash
$ terraform output tls_private_key > cluster.key && chmod 600 cluster.key && ssh -i cluster.key fury@54.72.116.217
# fury@ip-172-31-33-135:~$ while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cluster creation...'; sleep 5; done
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
# fury@ip-172-31-33-135:~$ kubectl get nodes
NAME                                          STATUS     ROLES    AGE     VERSION
ip-172-31-19-1.eu-west-1.compute.internal     NotReady   <none>   8m59s   v1.19.11
ip-172-31-24-153.eu-west-1.compute.internal   NotReady   <none>   8m59s   v1.19.11
ip-172-31-30-196.eu-west-1.compute.internal   NotReady   <none>   8m59s   v1.19.11
ip-172-31-33-135.eu-west-1.compute.internal   NotReady   master   9m24s   v1.19.11
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
# fury@ip-172-31-33-135:~$ curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.2.4/furyctl-linux-amd64
# fury@ip-172-31-33-135:~$ sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
# fury@ip-172-31-33-135:~$ sudo chmod +x /usr/local/bin/furyctl
# fury@ip-172-31-33-135:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz
# fury@ip-172-31-33-135:~$ tar -zxvf kustomize_v3.3.0_linux_amd64.tar.gz
kustomize
# fury@ip-172-31-33-135:~$ sudo mv kustomize /usr/local/bin/kustomize
```

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.6.0
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.6.0/Furyfile.yml -> Furyfile.yml 
INFO[0000] removing Furyfile.yml/.git                   
ERRO[0000] unlinkat Furyfile.yml/.git: not a directory  
INFO[0000] unlinkat Furyfile.yml/.git: not a directory  
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.6.0/kustomization.yaml -> kustomization.yaml 
INFO[0000] removing kustomization.yaml/.git             
ERRO[0000] unlinkat kustomization.yaml/.git: not a directory 
INFO[0000] unlinkat kustomization.yaml/.git: not a directory
$ furyctl vendor -H
INFO[0000] using v1.6.0 for package networking/calico   
INFO[0000] using v1.12.0 for package monitoring/prometheus-operator 
INFO[0000] using v1.12.0 for package monitoring/prometheus-operated 
INFO[0000] using v1.12.0 for package monitoring/grafana 
INFO[0000] using v1.12.0 for package monitoring/goldpinger 
INFO[0000] using v1.12.0 for package monitoring/configs 
INFO[0000] using v1.12.0 for package monitoring/kubeadm-sm 
INFO[0000] using v1.12.0 for package monitoring/kube-proxy-metrics 
INFO[0000] using v1.12.0 for package monitoring/kube-state-metrics 
INFO[0000] using v1.12.0 for package monitoring/node-exporter 
INFO[0000] using v1.12.0 for package monitoring/metrics-server 
INFO[0000] using v1.8.0 for package logging/elasticsearch-single 
INFO[0000] using v1.8.0 for package logging/cerebro     
INFO[0000] using v1.8.0 for package logging/curator     
INFO[0000] using v1.8.0 for package logging/fluentd     
INFO[0000] using v1.8.0 for package logging/kibana      
INFO[0000] using v1.10.0 for package ingress/cert-manager 
INFO[0000] using v1.10.0 for package ingress/nginx      
INFO[0000] using v1.10.0 for package ingress/forecastle 
INFO[0000] using v1.7.0 for package dr/velero           
INFO[0000] using v1.4.0 for package opa/gatekeeper      
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/prometheus-operator?ref=v1.12.0 -> vendor/katalog/monitoring/prometheus-operator 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-networking.git/katalog/calico?ref=v1.6.0 -> vendor/katalog/networking/calico 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/grafana?ref=v1.12.0 -> vendor/katalog/monitoring/grafana 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/prometheus-operated?ref=v1.12.0 -> vendor/katalog/monitoring/prometheus-operated 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/goldpinger?ref=v1.12.0 -> vendor/katalog/monitoring/goldpinger 
INFO[0000] removing vendor/katalog/networking/calico/.git 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/configs?ref=v1.12.0 -> vendor/katalog/monitoring/configs 
INFO[0001] removing vendor/katalog/monitoring/goldpinger/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kubeadm-sm?ref=v1.12.0 -> vendor/katalog/monitoring/kubeadm-sm 
INFO[0001] removing vendor/katalog/monitoring/prometheus-operated/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kube-proxy-metrics?ref=v1.12.0 -> vendor/katalog/monitoring/kube-proxy-metrics 
INFO[0001] removing vendor/katalog/monitoring/prometheus-operator/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kube-state-metrics?ref=v1.12.0 -> vendor/katalog/monitoring/kube-state-metrics 
INFO[0001] removing vendor/katalog/monitoring/grafana/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/node-exporter?ref=v1.12.0 -> vendor/katalog/monitoring/node-exporter 
INFO[0002] removing vendor/katalog/monitoring/kubeadm-sm/.git 
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/metrics-server?ref=v1.12.0 -> vendor/katalog/monitoring/metrics-server 
INFO[0002] removing vendor/katalog/monitoring/kube-proxy-metrics/.git 
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/elasticsearch-single?ref=v1.8.0 -> vendor/katalog/logging/elasticsearch-single 
INFO[0002] removing vendor/katalog/monitoring/kube-state-metrics/.git 
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/cerebro?ref=v1.8.0 -> vendor/katalog/logging/cerebro 
INFO[0002] removing vendor/katalog/monitoring/node-exporter/.git 
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/curator?ref=v1.8.0 -> vendor/katalog/logging/curator 
INFO[0002] removing vendor/katalog/monitoring/configs/.git 
INFO[0002] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/fluentd?ref=v1.8.0 -> vendor/katalog/logging/fluentd 
INFO[0003] removing vendor/katalog/logging/elasticsearch-single/.git 
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/kibana?ref=v1.8.0 -> vendor/katalog/logging/kibana 
INFO[0003] removing vendor/katalog/logging/cerebro/.git 
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/cert-manager?ref=v1.10.0 -> vendor/katalog/ingress/cert-manager 
INFO[0003] removing vendor/katalog/monitoring/metrics-server/.git 
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/nginx?ref=v1.10.0 -> vendor/katalog/ingress/nginx 
INFO[0003] removing vendor/katalog/logging/fluentd/.git 
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/forecastle?ref=v1.10.0 -> vendor/katalog/ingress/forecastle 
INFO[0003] removing vendor/katalog/logging/curator/.git 
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-dr.git/katalog/velero?ref=v1.7.0 -> vendor/katalog/dr/velero 
INFO[0004] removing vendor/katalog/ingress/forecastle/.git 
INFO[0004] downloading: github.com/sighupio/fury-kubernetes-opa.git/katalog/gatekeeper?ref=v1.4.0 -> vendor/katalog/opa/gatekeeper 
INFO[0004] removing vendor/katalog/dr/velero/.git       
INFO[0004] removing vendor/katalog/ingress/nginx/.git   
INFO[0004] removing vendor/katalog/logging/kibana/.git  
INFO[0004] removing vendor/katalog/ingress/cert-manager/.git 
INFO[0004] removing vendor/katalog/opa/gatekeeper/.git
```

Install Fury in the cluster:

```bash
$ kustomize build | kubectl apply -f -
```

> If you see any errors, try again until no error appears. There are some CRDs dependencies.

Wait until everything is up and running:

```bash
kubectl get pods -A
kubectl get pods -A
NAMESPACE            NAME                                                                 READY   STATUS      RESTARTS   AGE
cert-manager         cert-manager-b4767cd87-cc4fk                                         1/1     Running     0          5m24s
cert-manager         cert-manager-cainjector-7cff7c9699-8qlnx                             1/1     Running     0          5m24s
cert-manager         cert-manager-webhook-6665ff6ddd-scxlc                                1/1     Running     0          5m23s
gatekeeper-system    gatekeeper-audit-7d64cc45df-pblf4                                    1/1     Running     0          5m23s
gatekeeper-system    gatekeeper-controller-manager-6999845cc9-f9fb8                       1/1     Running     0          5m23s
gatekeeper-system    gatekeeper-controller-manager-6999845cc9-lq8dx                       1/1     Running     0          5m23s
gatekeeper-system    gatekeeper-controller-manager-6999845cc9-nlhhd                       1/1     Running     0          5m23s
gatekeeper-system    gatekeeper-policy-manager-7bfd5dbdd4-ntvdn                           1/1     Running     0          5m23s
ingress-nginx        forecastle-f66cc877f-dzqnl                                           1/1     Running     0          5m23s
ingress-nginx        nginx-ingress-controller-9spmh                                       1/1     Running     0          4m58s
ingress-nginx        nginx-ingress-controller-ctf97                                       1/1     Running     0          4m59s
ingress-nginx        nginx-ingress-controller-vx8hn                                       1/1     Running     0          5m
kube-system          calico-kube-controllers-7c6869b847-nvv89                             1/1     Running     0          5m23s
kube-system          calico-node-4hmbv                                                    1/1     Running     0          5m22s
kube-system          calico-node-58lxc                                                    1/1     Running     0          5m22s
kube-system          calico-node-9gcmc                                                    1/1     Running     0          5m22s
kube-system          calico-node-zv9vt                                                    1/1     Running     0          5m22s
kube-system          coredns-558bd4d5db-2j7mk                                             1/1     Running     0          46m
kube-system          coredns-558bd4d5db-lnrvg                                             1/1     Running     0          46m
kube-system          etcd-ip-172-31-33-70.eu-west-1.compute.internal                      1/1     Running     0          47m
kube-system          kube-apiserver-ip-172-31-33-70.eu-west-1.compute.internal            1/1     Running     0          47m
kube-system          kube-controller-manager-ip-172-31-33-70.eu-west-1.compute.internal   1/1     Running     0          47m
kube-system          kube-proxy-6m72n                                                     1/1     Running     0          46m
kube-system          kube-proxy-hwwww                                                     1/1     Running     0          46m
kube-system          kube-proxy-vnhwx                                                     1/1     Running     0          46m
kube-system          kube-proxy-w55nz                                                     1/1     Running     0          46m
kube-system          kube-scheduler-ip-172-31-33-70.eu-west-1.compute.internal            1/1     Running     0          47m
kube-system          metrics-server-5dd7c59cfd-bgwg9                                      1/1     Running     0          5m23s
kube-system          minio-0                                                              1/1     Running     0          5m23s
kube-system          minio-setup-wdlqn                                                    0/1     Completed   0          5m22s
kube-system          velero-85bb6fbbc6-5lwqc                                              1/1     Running     0          5m23s
kube-system          velero-restic-8mxk7                                                  1/1     Running     0          5m
kube-system          velero-restic-dz2jq                                                  1/1     Running     0          4m58s
kube-system          velero-restic-wwqck                                                  1/1     Running     0          4m59s
local-path-storage   local-path-provisioner-64bb9787d9-znd8l                              1/1     Running     0          46m
logging              cerebro-578676bc6b-5lsgp                                             1/1     Running     0          5m23s
logging              elasticsearch-0                                                      2/2     Running     0          5m23s
logging              fluentbit-69rpt                                                      1/1     Running     0          5m22s
logging              fluentbit-8l6k4                                                      1/1     Running     0          5m22s
logging              fluentbit-nnl6k                                                      1/1     Running     0          5m22s
logging              fluentbit-vgv8d                                                      1/1     Running     1          5m22s
logging              fluentd-0                                                            1/1     Running     1          5m23s
logging              fluentd-1                                                            1/1     Running     0          3m6s
logging              fluentd-2                                                            1/1     Running     0          2m32s
logging              kibana-7fd6f6897c-nwtj6                                              1/1     Running     0          5m22s
monitoring           goldpinger-2mqkr                                                     1/1     Running     0          5m22s
monitoring           goldpinger-bdznq                                                     1/1     Running     0          5m22s
monitoring           goldpinger-mn6gs                                                     1/1     Running     0          5m22s
monitoring           goldpinger-znl9d                                                     1/1     Running     0          5m22s
monitoring           grafana-5df78cd97-ssdzp                                              2/2     Running     0          5m22s
monitoring           kube-proxy-metrics-78zk2                                             1/1     Running     0          5m22s
monitoring           kube-proxy-metrics-7kzqc                                             1/1     Running     0          5m22s
monitoring           kube-proxy-metrics-9bfsf                                             1/1     Running     0          5m22s
monitoring           kube-proxy-metrics-frbxv                                             1/1     Running     0          5m22s
monitoring           kube-state-metrics-7657b8f59c-gszlx                                  1/1     Running     0          5m22s
monitoring           node-exporter-449p8                                                  2/2     Running     0          5m22s
monitoring           node-exporter-6spbq                                                  2/2     Running     0          5m22s
monitoring           node-exporter-d8nt9                                                  2/2     Running     0          5m22s
monitoring           node-exporter-zf4lz                                                  2/2     Running     0          5m20s
monitoring           prometheus-k8s-0                                                     2/2     Running     1          4m9s
monitoring           prometheus-operator-654d5c5468-g4tdz                                 1/1     Running     0          5m22s
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.50.0](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.50.0))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ sonobuoy status
```
