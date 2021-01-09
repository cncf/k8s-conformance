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
  source = "git::git@github.com:sighupio/k8s-conformance-environment.git//modules/aws-k8s-conformance?ref=v1.0.5"

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
module.fury.data.aws_subnet.private: Refreshing state...
module.fury.data.aws_subnet.public: Refreshing state...
data.aws_region.current: Refreshing state...
module.fury.data.aws_vpc.vpc: Refreshing state...
module.fury.tls_private_key.master: Creating...
module.fury.random_string.second_part: Creating...
module.fury.random_string.firts_part: Creating...
module.fury.random_string.firts_part: Creation complete after 0s [id=mnwevp]
module.fury.random_string.second_part: Creation complete after 0s [id=4z4ptyc4y9xzdz2v]
module.fury.tls_private_key.master: Creation complete after 0s [id=b4b5ea564970b9d2272c588d2238762ce6233889]
module.fury.aws_eip.master: Creating...
module.fury.aws_security_group.master: Creating...
module.fury.aws_security_group.worker: Creating...
module.fury.aws_eip.master: Creation complete after 0s [id=eipalloc-0c7be68ab84512375]
module.fury.data.template_file.init_master: Refreshing state...
module.fury.null_resource.kubeconfig: Creating...
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKSndJQkFBS0NBZ0VBeW1VWjJDNm91NzRzMmJRemRTYW9iMXI0T3JiR3ByK1ducXozazEyQUl2M1laQ2FBCkNaWjNZdEpja1ppK004ZldGaVV0NWNvRURSOGQ1QXZjdUdHcEpFYzNuT3VhRXNZNWw5VndFbTNPRXpsUTU4NEYKV2krdUltbW5GajNqMkpmOFlPTVErSnUyMWczKytEM3VvaFNqTnlJeVNYRVNhVHlvNUJvYmQxbzRHdkloeklxYwp3RngycmhwYWZRdlZXZk43T204Q1grajRHV1M0ZGlFV2xWYm5uRktTNmR4WkxiaEdQa0ZRRnNBb04rY2pWRGgwCnluVmU1US9sWkk0bDFzUFVva2oxZkYwTVkwQXl5RVliWDZrRm1OZnlXMERCRXR1WjZvNlVDQTJ4cGpwNStPbDcKTE55d3BWSVZOd2JDY2pnZ1NWalNmUmdzNHk4TktBamxHYjdVODg3MWF4ZWJaYUphRVpNeFE2Rk42OWRnUS8vMwpGVVIweGkwb0cvYWNSZU5lQ0lmOVJiK3BLMEJrTHJaSVNTWXFVdlRYRndVQXJ2bWd2TS9KdU5yRkZtRlFZaDRCCkRjaG45cUVVZWcrQ25jbmNQMldtbEtDZkQxOVNERzEvbVpvTW8rZVVOb2d6ci9rZjdaeW9LNWh0ZCtkZDVOMGIKZHBMN2VFK3R1bkJlUHd3YzcwRzVrQzlqaHVyemhhMUJkWnRTdm05T3F2enlIRjJ0S2VqR2hrMzNTdmJUcFBQSQpwTnJtcHc3Ylp6NXBVRkZ3NitYSit3d0RtTThudmZkUTFIWDYyVDVTZkVIUVVXWjVHMzF3a2FqY0g1NlQ4elpwCkliT21lNzFwalZ3OXdlZnVodE1rWHVIL3JyMlB0V2ljbmdVa29LQUF0bGtiRlJMblR0OWRyZDhiUGNVQ0F3RUEKQVFLQ0FnQlByNnlVUkJLbEVJUkNGc1BuelJlbCtEQWhsZEx5MWgzc1RYZVFhdERIZGlCYmxoajFMV3ZGMmNNZQpnLy9uRFRnS01nczNIT21wYk9YczRvcTlnWjRCclpTRTBQSXhrQ0FlMnFjc2FsVW5sbnAzT2RNN3BlZ3VubUJ0CnptSkY1ZGsxSUZHUFFHZWxNWStBbDRtOEFOb2VHL1dtbXNFLzgrVWZJZlJNY3BZQ2JmREd3cEJpNEVUTjJZeGwKRFdLcjdzUkd4bXd0N09DNXhzRWxxWE5seXZpWHdKOGRPbWRXSytaa0huejA2Q1V0bFhDQWVWWHFYSG5IUUJIMgpIRTFqbUdqQW1HOG16cy9ReC9iMmlUdS8xeUZnQXkzbHBjSWV0WjJORHlQVFkramM1TXNmS0hZWnZLNUQrT1JuCmJON2o3NXN1cGEwQ0dhR2F0T3krSlhwbVA0OUIxcENqRkNSdzh3eHNDT2lqQ3pvYVV4VGhnaEw4RzNEWXVBYXoKaXdKMkRCY2tERGx0eWozSjZhQlRQQi9wVTRrWXViOENZWHpaclcvZm5KK0NxeHkwYlAxM3p1NTh1SWdZRlBJNQo4NkxOMlJvS1IyZ25GS05uNlJUUGQ5dWZCRW1wQldHSGJZcFFWNitQbVVqZkIyUUg4T2lFSVhLeTUrQVlRL1NwCkMrZ0djeWRTWlpMa0tlSm9UY0hrZ3FIYlFEWUtYZGozcC9OOXN1a1p6UTExZWZKWGdSU2IvQXJXb083aE5TelYKMlBpZ0xXUmpzSUxDZDJRRUNSNHpYYzh2Z2prdC91Mk52OVV6RlI1V3JuL1YraTZBTzViQzV6T2VTM3FnZmRjMApWcWk3ekxnUmhmTzNjalN4dVF3MkdGNE5rdk8zV2RWbGtvaTVjbDREbi9uWlBvQjNZUUtDQVFFQXk2WUhzRTlWClJ5OGZlNnZIc2t4UjBJYmtyU2gvbVNQQURNODY0K3BoTC92UnhwTG92WCtxTkZ6NUxib1pRNlVQOGZrVGhlcDQKVkdlU1p1TmlqbzJ0V1VJd3JZYnBUdjJ6NDIyL1FHQ05UQ2xUamtCR2dUVU5TZGtIQmNTRU5YUEhHQzR5Z200OAo2d0FENEo4akFjeG5wOWxNSi9ZTWcycU51ejdhbWVScURkVXBZQ2JWVFB5ZkpwK0ZyZ01namxvVWlUQWx5N3hVCmZqSGJoQmdiUlMzKzBnaFJuR0lTcEtHcGE2UnZsWGxjRXRrZWJBRnQxVGFGZzB4dEZ4eFVsVXgyaWp5MmxVUE0KbnR0ZkgwdlVIenQ1YXNpZDRqYXFMVzhSakkwQ2dOUzRrVHJWYUg3UDl3dS8xeWVnQ3F1MEgycU1SRTA3bHoxRwozTHhnUldqRko4VWRUUUtDQVFFQS9teVNDVEsyeUJJSzFSZHEyYmF3cjJ1Ylc1eTZhZUE2RGt2T29kUndXUXhRClRLQjIwN2J6YjQ1NlZWY1BSMmdGWWFpQnRldHVXYzVLNnNKQUZtM2lDUFdYR1dlVlI1SjV4aWFiVWZmUWlnQ2gKbUg1L21qbXlIUGRTOXFnVFZ4UGFxcThqUmlkQlNqQjRDYUtmWERZM3AvNnlxWUtYaGtqZ1RRS2M0aEEwdmdNawpSaEE4eHRDbEhTSEpGbE9uZ1pMbEZ6VGwxakM3K1N1RENNbVQwNmpQZjNiUXByYW95NUlNWHNSZHJzNVpYTXc4CmJVbTZQdGV0VXRiRzdmaHNPQzR6S00zVGJscEVtdjdxelJrM2pNY2NMNVBvYkVCTlhocjE4cTE1VHI2NDhSRzAKZ3dmc25aWEFNV2NNMjgrOHdWbzNkdDVCbWVrSllhaUJvQ21vbDFWR1dRS0NBUUJJRWN6Y3gyYWRsMzZqektvUwpYbElCNHdzZ2dKbVBmNGhpd0IvT01zOE1KU2tiQmppWmY0bWptRmVTcUM1eXN3S09scUFqSDFSUVFvc2NJRkpyCnNwWHJaYkpHWnQxQVdDYUdVUHVDOCtodFVKN0NVOXJmdFArcjU4TkZka04zaXk2bFR3d08vcVpPWUNYL0l6SkgKVzZnL1RYWlhHZ3Rab3FiZjRpR0lucjR0Z1Fkd2dLMngzaUVRa1JuRStGUllMR2JpR2dqMkxnTVUyZDRleEUwNgpVVW5CMkxIUkR5QWI1UjVJK3R1R1lYbUZMaE5IRThaajB6U3l2NlJIcm4zOGpCL1RVaU1uZGVQL1FCRk15UkFiCnNYZUpvOC9FRTZac0I4ZUZIdzRJdTc5Sm5qR1NGbmJRcmZiSlZMdWRxeUJHa2ZWcjRvMDVPN1ZOUHRrdkZ5SFcKcmpwdEFvSUJBRzFqSHBLSDFHQkdxWk9lb3RrQ0hBci8xK2JXaHF0WXRYMUtDSWc1ZnlnNkRCZzE4WURyS3RUdQp6QmYrKzFtM0ZvRTdZckZsaktkZDg0WGxpSXBjS2creUQ0bmpxQ0lDandxcnRLSFVTenZhTTZBTjJ5emkyM3BxCnQ2Zkc4YkhCbm9VK0VZdHErejQ3Z3BDWjg2eEF2ME1pVll4ZDBtbncwVWNxOVdxWWp5U1cwelN3YklFS1djTWgKc0lSQjZVWGpjMDI3OTRsVW9LenJrVVhvN1A3V21JZnovSmVBOXllM0hreHNYdDcyWnlObnlCOHcwTHVPSFQzOQppNy9xekJTSGdJVnRvUmJVQnFVaExyQ0p4QUZwNWV0cXkwWW5pMXdIZVhFaU5vS3RxM1F5S1lzZ2tCSGN2YW8vCjVSNW92WDNnSFBLbGNrMExEWGFJYlZzQUxqVUtlOWtDZ2dFQWN5eSs0eDgweVRiSmVXaktrY1k3UlJWbHp5ZGMKYzZFS3BYVit4SXhCVngydnlTWmZ1NlNYaVRrbmhoWnBSemhyRXVuSms5VjFlcG9vNlYvNmpxNFFubDdJMitlUwpCbTEzdHZuQW1DNEtNTUc2OE5JOHhRR3BMVzhxUG0zWG1zOGpOdW0wQjZaSFZ0ZEFpd3RlbEJGemtZdXJ6SjdpCmE3eGxCaEhhVkdNOE42eWN1bGxzYmJsYmdTVmxpQllGVU9vV3RueW1wU0VZVURFTUVqQmkzRXp1SEcyWlBSemoKSTlMZUdSU3RlUS9BQ3Nrekl3aE94VGwwUmlrUUQyWUREVW5QTEs5cFBpR0s3YUdQaXphUDE2WUFhaVlYenRlUApsY3dhVFJYeTNweXJodDd4N2ovdTRwMTFLU1JzUW1JTDQrK3Z2WjR3U2FDc0NLWTc4UHFCZy9kZGJBPT0KLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K | base64 -d > ./master.key && chmod 600 ./master.key"]
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "./wait-for.sh 63.35.57.111:6443 -t 1200 -- echo \"Cluster Ready\""]
module.fury.aws_security_group.worker: Creation complete after 2s [id=sg-085afcb9f58118f02]
module.fury.aws_security_group_rule.worker_ingress_self: Creating...
module.fury.aws_security_group_rule.worker_egress: Creating...
module.fury.aws_security_group.master: Creation complete after 2s [id=sg-02b8a477492e5c667]
module.fury.aws_security_group_rule.worker_ingress: Creating...
module.fury.aws_security_group_rule.master_ingress: Creating...
module.fury.aws_security_group_rule.master_egress: Creating...
module.fury.aws_spot_instance_request.master: Creating...
module.fury.aws_security_group_rule.worker_egress: Creation complete after 0s [id=sgrule-3514060220]
module.fury.aws_security_group_rule.master_egress: Creation complete after 0s [id=sgrule-1812500209]
module.fury.aws_security_group_rule.worker_ingress_self: Creation complete after 1s [id=sgrule-2582941582]
module.fury.aws_security_group_rule.master_ingress: Creation complete after 1s [id=sgrule-1221912912]
module.fury.aws_security_group_rule.worker_ingress: Creation complete after 2s [id=sgrule-664553552]
module.fury.null_resource.kubeconfig: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Creation complete after 12s [id=sir-i9hg6ypq]
module.fury.data.template_file.init_worker: Refreshing state...
module.fury.aws_eip_association.eip_assoc: Creating...
module.fury.aws_spot_instance_request.worker[1]: Creating...
module.fury.aws_spot_instance_request.worker[2]: Creating...
module.fury.aws_spot_instance_request.worker[0]: Creating...
module.fury.null_resource.kubeconfig: Still creating... [20s elapsed]
module.fury.aws_eip_association.eip_assoc: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[2]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[0]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[1]: Still creating... [10s elapsed]
module.fury.aws_eip_association.eip_assoc: Creation complete after 10s [id=eipassoc-08da15e4018f923c5]
module.fury.aws_spot_instance_request.worker[1]: Creation complete after 12s [id=sir-ikdg627p]
module.fury.aws_spot_instance_request.worker[0]: Creation complete after 12s [id=sir-e2gr769q]
module.fury.aws_spot_instance_request.worker[2]: Creation complete after 12s [id=sir-rtgi4gvp]
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
module.fury.null_resource.kubeconfig (local-exec): Cluster Ready
module.fury.null_resource.kubeconfig: Provisioning with 'remote-exec'...
module.fury.null_resource.kubeconfig (remote-exec): Connecting to remote host via SSH...
module.fury.null_resource.kubeconfig (remote-exec):   Host: 63.35.57.111
module.fury.null_resource.kubeconfig (remote-exec):   User: fury
module.fury.null_resource.kubeconfig (remote-exec):   Password: false
module.fury.null_resource.kubeconfig (remote-exec):   Private key: true
module.fury.null_resource.kubeconfig (remote-exec):   Certificate: false
module.fury.null_resource.kubeconfig (remote-exec):   SSH Agent: false
module.fury.null_resource.kubeconfig (remote-exec):   Checking Host Key: false
module.fury.null_resource.kubeconfig (remote-exec): Connected!
module.fury.null_resource.kubeconfig (remote-exec): Cluster "kubernetes" set.
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "scp -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i master.key fury@63.35.57.111:/home/fury/.kube/config kubeconfig"]
module.fury.null_resource.kubeconfig (local-exec): Warning: Permanently added '63.35.57.111' (ECDSA) to the list of known hosts.
module.fury.null_resource.kubeconfig: Still creating... [5m20s elapsed]
module.fury.null_resource.kubeconfig: Creation complete after 5m21s [id=4041937530402520227]
module.fury.data.local_file.kubeconfig: Refreshing state...

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = 63.35.57.111
tls_private_key = <sensitive>
```

##### Enter master node

```bash
$ terraform output tls_private_key > cluster.key && chmod 600 cluster.key && ssh -i cluster.key fury@63.35.57.111
# fury@ip-172-31-40-235:~$ while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cluster creation...'; sleep 5; done
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
# fury@ip-172-31-40-235:~$ kubectl get nodes
NAME                                          STATUS     ROLES    AGE     VERSION
ip-172-31-26-74.eu-west-1.compute.internal    NotReady   <none>   6m45s   v1.19.4
ip-172-31-27-26.eu-west-1.compute.internal    NotReady   <none>   6m46s   v1.19.4
ip-172-31-29-26.eu-west-1.compute.internal    NotReady   <none>   6m46s   v1.19.4
ip-172-31-40-235.eu-west-1.compute.internal   NotReady   master   7m15s   v1.19.4
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
# fury@ip-172-31-40-235:~$ curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.2.4/furyctl-linux-amd64
# fury@ip-172-31-40-235:~$ sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
# fury@ip-172-31-40-235:~$ sudo chmod +x /usr/local/bin/furyctl
# fury@ip-172-31-40-235:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz
# fury@ip-172-31-40-235:~$ tar -zxvf kustomize_v3.3.0_linux_amd64.tar.gz
kustomize
# fury@ip-172-31-40-235:~$ sudo mv kustomize /usr/local/bin/kustomize
```

### Hands on

Download distribution files:

```bash
$ furyctl init --version v1.5.0
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.5.0/Furyfile.yml -> Furyfile.yml 
INFO[0000] removing Furyfile.yml/.git                   
ERRO[0000] unlinkat Furyfile.yml/.git: not a directory  
INFO[0000] unlinkat Furyfile.yml/.git: not a directory  
INFO[0000] downloading: github.com/sighupio/fury-distribution/releases/download/v1.5.0/kustomization.yaml -> kustomization.yaml 
INFO[0000] removing kustomization.yaml/.git             
ERRO[0000] unlinkat kustomization.yaml/.git: not a directory 
INFO[0000] unlinkat kustomization.yaml/.git: not a directory
$ furyctl vendor -H
INFO[0000] using v1.5.0 for package networking/calico   
INFO[0000] using v1.11.0 for package monitoring/prometheus-operator 
INFO[0000] using v1.11.0 for package monitoring/prometheus-operated 
INFO[0000] using v1.11.0 for package monitoring/grafana 
INFO[0000] using v1.11.0 for package monitoring/goldpinger 
INFO[0000] using v1.11.0 for package monitoring/configs 
INFO[0000] using v1.11.0 for package monitoring/kubeadm-sm 
INFO[0000] using v1.11.0 for package monitoring/kube-proxy-metrics 
INFO[0000] using v1.11.0 for package monitoring/kube-state-metrics 
INFO[0000] using v1.11.0 for package monitoring/node-exporter 
INFO[0000] using v1.11.0 for package monitoring/metrics-server 
INFO[0000] using v1.7.0 for package logging/elasticsearch-single 
INFO[0000] using v1.7.0 for package logging/cerebro     
INFO[0000] using v1.7.0 for package logging/curator     
INFO[0000] using v1.7.0 for package logging/fluentd     
INFO[0000] using v1.7.0 for package logging/kibana      
INFO[0000] using v1.9.0 for package ingress/cert-manager 
INFO[0000] using v1.9.0 for package ingress/nginx       
INFO[0000] using v1.9.0 for package ingress/forecastle  
INFO[0000] using v1.6.0 for package dr/velero           
INFO[0000] using v1.3.0 for package opa/gatekeeper      
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-networking.git/katalog/calico?ref=v1.5.0 -> vendor/katalog/networking/calico 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/prometheus-operator?ref=v1.11.0 -> vendor/katalog/monitoring/prometheus-operator 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/grafana?ref=v1.11.0 -> vendor/katalog/monitoring/grafana 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/prometheus-operated?ref=v1.11.0 -> vendor/katalog/monitoring/prometheus-operated 
INFO[0000] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/goldpinger?ref=v1.11.0 -> vendor/katalog/monitoring/goldpinger 
INFO[0001] removing vendor/katalog/monitoring/prometheus-operator/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/configs?ref=v1.11.0 -> vendor/katalog/monitoring/configs 
INFO[0001] removing vendor/katalog/monitoring/grafana/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kubeadm-sm?ref=v1.11.0 -> vendor/katalog/monitoring/kubeadm-sm 
INFO[0001] removing vendor/katalog/monitoring/goldpinger/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kube-proxy-metrics?ref=v1.11.0 -> vendor/katalog/monitoring/kube-proxy-metrics 
INFO[0001] removing vendor/katalog/networking/calico/.git 
INFO[0001] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/kube-state-metrics?ref=v1.11.0 -> vendor/katalog/monitoring/kube-state-metrics 
INFO[0003] removing vendor/katalog/monitoring/kube-state-metrics/.git 
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/node-exporter?ref=v1.11.0 -> vendor/katalog/monitoring/node-exporter 
INFO[0003] removing vendor/katalog/monitoring/prometheus-operated/.git 
INFO[0003] downloading: github.com/sighupio/fury-kubernetes-monitoring.git/katalog/metrics-server?ref=v1.11.0 -> vendor/katalog/monitoring/metrics-server 
INFO[0004] removing vendor/katalog/monitoring/kube-proxy-metrics/.git 
INFO[0004] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/elasticsearch-single?ref=v1.7.0 -> vendor/katalog/logging/elasticsearch-single 
INFO[0004] removing vendor/katalog/monitoring/node-exporter/.git 
INFO[0004] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/cerebro?ref=v1.7.0 -> vendor/katalog/logging/cerebro 
INFO[0004] removing vendor/katalog/monitoring/metrics-server/.git 
INFO[0004] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/curator?ref=v1.7.0 -> vendor/katalog/logging/curator 
INFO[0005] removing vendor/katalog/monitoring/configs/.git 
INFO[0005] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/fluentd?ref=v1.7.0 -> vendor/katalog/logging/fluentd 
INFO[0005] removing vendor/katalog/monitoring/kubeadm-sm/.git 
INFO[0005] downloading: github.com/sighupio/fury-kubernetes-logging.git/katalog/kibana?ref=v1.7.0 -> vendor/katalog/logging/kibana 
INFO[0005] removing vendor/katalog/logging/elasticsearch-single/.git 
INFO[0005] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/cert-manager?ref=v1.9.0 -> vendor/katalog/ingress/cert-manager 
INFO[0006] removing vendor/katalog/logging/cerebro/.git 
INFO[0006] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/nginx?ref=v1.9.0 -> vendor/katalog/ingress/nginx 
INFO[0006] removing vendor/katalog/logging/fluentd/.git 
INFO[0006] downloading: github.com/sighupio/fury-kubernetes-ingress.git/katalog/forecastle?ref=v1.9.0 -> vendor/katalog/ingress/forecastle 
INFO[0006] removing vendor/katalog/logging/kibana/.git  
INFO[0006] downloading: github.com/sighupio/fury-kubernetes-dr.git/katalog/velero?ref=v1.6.0 -> vendor/katalog/dr/velero 
INFO[0006] removing vendor/katalog/ingress/cert-manager/.git 
INFO[0006] downloading: github.com/sighupio/fury-kubernetes-opa.git/katalog/gatekeeper?ref=v1.3.0 -> vendor/katalog/opa/gatekeeper 
INFO[0007] removing vendor/katalog/ingress/nginx/.git   
INFO[0007] removing vendor/katalog/dr/velero/.git       
INFO[0007] removing vendor/katalog/opa/gatekeeper/.git  
INFO[0008] removing vendor/katalog/logging/curator/.git 
INFO[0008] removing vendor/katalog/ingress/forecastle/.git
```

Install Fury in the cluster:

```bash
$ kustomize build | kubectl apply -f -
```

> If you see any errors, try again until no error appears. There are some CRDs dependencies.

Wait until everything is up and running:

```bash
kubectl get pods -A
NAMESPACE            NAME                                                                  READY   STATUS      RESTARTS   AGE
cert-manager         cert-manager-78d59f57f8-vqr57                                         1/1     Running     0          10m
cert-manager         cert-manager-cainjector-677c744848-hmprg                              1/1     Running     0          10m
cert-manager         cert-manager-webhook-85df949f5-qltzl                                  1/1     Running     0          10m
gatekeeper-system    gatekeeper-audit-559f589965-8pdcv                                     1/1     Running     0          10m
gatekeeper-system    gatekeeper-controller-manager-5675f57b78-pdbg9                        1/1     Running     1          10m
gatekeeper-system    gatekeeper-controller-manager-5675f57b78-r2vg7                        1/1     Running     0          10m
gatekeeper-system    gatekeeper-controller-manager-5675f57b78-t44xx                        1/1     Running     0          10m
gatekeeper-system    gatekeeper-policy-manager-8468b84f95-vrxnm                            1/1     Running     0          10m
ingress-nginx        forecastle-6fdf88bf46-7wsrj                                           1/1     Running     0          10m
ingress-nginx        nginx-ingress-controller-57tww                                        1/1     Running     0          9m49s
ingress-nginx        nginx-ingress-controller-7cgvb                                        1/1     Running     0          9m50s
ingress-nginx        nginx-ingress-controller-n954r                                        1/1     Running     0          9m47s
kube-system          calico-kube-controllers-bd5756745-czjsc                               1/1     Running     0          10m
kube-system          calico-node-7cvnn                                                     1/1     Running     0          10m
kube-system          calico-node-f97jd                                                     1/1     Running     0          10m
kube-system          calico-node-gtwqf                                                     1/1     Running     0          10m
kube-system          calico-node-jtknk                                                     1/1     Running     0          10m
kube-system          coredns-f9fd979d6-7s9d5                                               1/1     Running     0          23m
kube-system          coredns-f9fd979d6-mxnqf                                               1/1     Running     0          23m
kube-system          etcd-ip-172-31-40-235.eu-west-1.compute.internal                      1/1     Running     0          23m
kube-system          kube-apiserver-ip-172-31-40-235.eu-west-1.compute.internal            1/1     Running     0          23m
kube-system          kube-controller-manager-ip-172-31-40-235.eu-west-1.compute.internal   1/1     Running     0          23m
kube-system          kube-proxy-9cglx                                                      1/1     Running     0          23m
kube-system          kube-proxy-lfwq7                                                      1/1     Running     0          23m
kube-system          kube-proxy-pddqc                                                      1/1     Running     0          23m
kube-system          kube-proxy-snrfb                                                      1/1     Running     0          23m
kube-system          kube-scheduler-ip-172-31-40-235.eu-west-1.compute.internal            1/1     Running     0          23m
kube-system          metrics-server-778c4c5854-7sl76                                       1/1     Running     0          10m
kube-system          minio-0                                                               1/1     Running     0          10m
kube-system          minio-setup-hqhbg                                                     0/1     Completed   2          10m
kube-system          velero-7c68747dcb-v5d5d                                               1/1     Running     0          10m
kube-system          velero-restic-4xstv                                                   1/1     Running     0          9m50s
kube-system          velero-restic-cj74x                                                   1/1     Running     0          9m47s
kube-system          velero-restic-r2ndj                                                   1/1     Running     0          9m49s
local-path-storage   local-path-provisioner-64bb9787d9-sk7tr                               1/1     Running     0          23m
logging              cerebro-d4b9846d9-dls8s                                               1/1     Running     0          10m
logging              elasticsearch-0                                                       2/2     Running     0          10m
logging              fluentbit-7fw4k                                                       1/1     Running     0          10m
logging              fluentbit-fjszt                                                       1/1     Running     0          10m
logging              fluentbit-v9n8l                                                       1/1     Running     0          10m
logging              fluentbit-zg88w                                                       1/1     Running     0          10m
logging              fluentd-0                                                             1/1     Running     1          10m
logging              fluentd-1                                                             1/1     Running     0          8m31s
logging              fluentd-2                                                             1/1     Running     0          7m25s
logging              kibana-7fdb7bd967-lqrsf                                               1/1     Running     0          10m
monitoring           goldpinger-6hfrd                                                      1/1     Running     0          10m
monitoring           goldpinger-8fqcb                                                      1/1     Running     0          10m
monitoring           goldpinger-phvdv                                                      1/1     Running     0          10m
monitoring           goldpinger-z75md                                                      1/1     Running     0          10m
monitoring           grafana-f8f78bcb8-j5gpj                                               2/2     Running     0          10m
monitoring           kube-proxy-metrics-2hm7g                                              1/1     Running     0          10m
monitoring           kube-proxy-metrics-65dc7                                              1/1     Running     0          10m
monitoring           kube-proxy-metrics-7f79b                                              1/1     Running     0          10m
monitoring           kube-proxy-metrics-vrctt                                              1/1     Running     0          10m
monitoring           kube-state-metrics-7bfdd469b-f7jbl                                    1/1     Running     0          10m
monitoring           node-exporter-9tfrk                                                   2/2     Running     0          10m
monitoring           node-exporter-dcjkl                                                   2/2     Running     0          10m
monitoring           node-exporter-qtdjl                                                   2/2     Running     0          10m
monitoring           node-exporter-zhd4v                                                   2/2     Running     0          10m
monitoring           prometheus-k8s-0                                                      2/2     Running     1          8m56s
monitoring           prometheus-operator-7bf784cb58-dp8wd                                  1/1     Running     0          10m
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.19.0](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.19.0))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ sonobuoy status
```
