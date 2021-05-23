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
  cluster_version = "1.20.0"
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
module.fury.random_string.second_part: Creation complete after 0s [id=wk8x40696smswjw6]
module.fury.random_string.firts_part: Creation complete after 0s [id=5lkp42]
module.fury.aws_eip.master: Creating...
module.fury.aws_security_group.worker: Creating...
module.fury.aws_security_group.master: Creating...
module.fury.aws_eip.master: Creation complete after 1s [id=eipalloc-01750b1e47f6032f2]
module.fury.tls_private_key.master: Creation complete after 4s [id=829a661340812755c76b8ed3b8e191ce342a5004]
module.fury.data.template_file.init_master: Refreshing state...
module.fury.null_resource.kubeconfig: Creating...
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBcHNCU0tUNmVlalVjekl4MEVIUjluQ2xuWHAyTTFRbjBramVzUjdBbVBCTys4ZlhtClQrREZ3WXJFWmw4dFVvRXBVTVYvb3RrM0NCeDdhcXZaSGJ5VXNNMmcvSWliOTRsaWpSVW1VYkViZjBGb1Vhdm8KU0lYZUFIM3hYUFVBS2lHRnpONTF4TkM4SWNGR1kvY2todkFPcmF1WmFGMTdIaHlwdFcvNlVlOVI5UjkrWVMyWQpTTG5Hb3p0cW9QUFdhZW5hRmxSaUhqdDc1N0Q1Nkx3N2FvclhzZnhiZGpDRDVzdFN6VFN3K2RqVEZKTnYvNWYwCmxKWHlXYkJidWdXbEREcVV6YjJMYk04Q0E1TUNTTFJCR0tjaUlFVk54UDNWZGtJUGpPNFBwR0RsbFo3eTVyalIKZGU0VU5PT3RyeEh1QWE2QXdueVEzVXZpdmRwdFlwVVR6NDExQWt4ckNyNlI4NitJbXZKWHMzSnZQUTErWWtpagp2SEtJOGNaTExqMXcvYW83U3Z2di96T3c1dGtnNVhreWFKSEIxeDE1TkZzNlpJMk9nNUh4VEpVNk9DT3VXSG9lCmlTRGZ1OTZUVWozaVJNQ2pDVkdqb29GZitjVHhqZ2dKZHlDMnQvQjA5c0lKcFZuYmFTV3o1U2pXcXdPbUZzdFYKWDYwcExPdDBjRThEUkd5ano4SkJvQ21LcXRrZk5kdU1FUUZOeEs2cjNXYnovUkwzMjlPMUVOMnA5SzY3Z0M3YQo2Z2craXFZSDBlaWhsVCtOMDJqWHlKa3lNeVdtMWhnRmtXMXh3UlNBZkJzc2x6eWhITlYyNThXUzk5MVBBOHFiCkY3dGRzTDVPV3ArU0xXdTJrSFNjNFhYTlJwc0NBdERMbC9VSlpGUWFLZHprSFFvZ2xsMlRidXR6cVAwQ0F3RUEKQVFLQ0FnQjhRcEszUTMrTEorc1hEbzhxOS9QbW0vLzR4TVQrdUZWMVpHRlFacGFIYkZ0OUtUWUFUa3B2aUg0RQpuMlpCdGhoWXBXUVFzWGRONXhPZEVRUlJJWWRZSFZPYS9CM2xuNDQ5L2dXNUdKYWFCTjY5QmJLcDRIL25zL0paCnlBVGdZR3k1bHdrQnFsNlhkTlNFaDlYRGJENHo4c3oxdGJ1YVc5ZW5haE9LWFNHZzNXQXJBSFFidGJ5dFJRaVgKZWoxTVhjUnpvVndnbFVrbkJYMmxqaWRrcEtSSmNQbWpJRklhZVdkeG5aTklDK2gzeThySkY2NWR6ME55ekhYKwpNRmltdlR6SCtEaGUwLy8zTStTZTB4d3pSOUNwWlp1bmNWUlJ0TGFyMlhiMGtuUmpRN2hVY0dNK1V6VGhtTXlECnlvT200eWYyUmljWmtZUWM0QmxsUGh3dUxZYUVCT3VubDhKbGhLNDh5QTVPQURVcDc5WDNzV3pDTDExZ0JvMXgKQnA2ZXMxNUtXaE15ZWNYM00rSE1NNVByTUQ4TFB0WnZGa29GUlhkcVdSSCtSWDFZY25ubVdvMTZSSDlLL0lTVgpUV3FYYldidExSSFpXY0lyZW5JSVZPSGYzbHNjUzFOWmltaWMrY0NTVW4rTXI2WEpBMG40aDB4TWc1RTM4WHFYCjlhWjJ6R1pLNUNraWFESXM3R05IMmRRK3N2K1BwNGxLM0xrTHVnSjJoTWdyZEJYWlVuMTdlb2NuQTF6TytBTkIKVlloamhXYU9KUUVQTktlM1lCaWpoOHNnZEh0bUpiZHlMZ3FYSjBRZjRQc0ZqQUZpSXdDWHRPZEF5b1JrQ3NoSwppL25oNjBYaU42bHpzZm5hR0FnV0xldDh6UXRqSFFSdTAvSEZsV2pvcEpkRzA5anpyUUtDQVFFQTFHbFF1Q2RvClJMd1FxR1ZqNk9ObDRNOXpOR05hK0w2UzJOZ1U0TXNGdUJsOEdTM0ZaQW5NWUp0MCt6VGZzQWxHa29US2QvRjMKU2E1QVd1dmwrd0RzRlpTWktab3pNZHdUd3FSdW02MHk5QWZRRkNFQm1COE9QaG1EeE1sTTB3dEJnY3NzNWNuOAplU2pwRWtUZmxVcnFNODYvTGtLeUFKajVzcU5oQnl2cFlDWlNwZXBPempBMWkzMzZ5cjBpS0F5YjYrZXQ1NDNtCndhT0pMUTJsaG9nT3VqWmwxMjV5Rjg4Q0RreE9jNHlJMldoTWlUMk9sMDdHV2s1V2Zsb1BqaEtQbWFZR1NyRlUKQ3R6K2dKTUFCL0NOYXVJKzBYWStSSU53cm42TUc5N2xwWDE4eUdqOVArS0I1djZSUnRhYlVOekVMOWlEZUx0YQpXT3dzRTF1L3lnK056d0tDQVFFQXlQaFRQK281MjQzYTFGdnlHajBCcFFjcklrRnJzN3l4VExBUFJWZzFSc1N0CklZOHhXYy9aV2VNdUxLLzhvaEovYndzTWRRazlYVTVtMDNieHd6a1NiODdyY2FXVXQySk93RCsxemE4MURuVjEKTFM1NDh1RmFhL1hybFFka0tFZDYzVnFJQWQwcXhxaGlDMmRhRkpiV0hWdmY5YjIyaDBTMEF5OEUyUkVORzNkRgpML3paZ2ttT3YvWGRtZjB6WXJUOGxpbSs3QVJwZUZnVUc3Zmt1SmxtemlFTGp5aG1OVk4yR0VvZytSOWhSd091Cm5ydUhCMHhucHlrZEJnaHA5MWExWXh3TU9VTjZGQUEvZEcwY0k1Qm5YNGpPQmY5UytTMG5WRlowVUxHeFR5aXEKdzF1bm8wMS83S2w1cDBMWGFReTA1Y1VTTmVGZU1Xb2FUUHhWTXdQN2N3S0NBUUVBcXQwa3IxNFR3K2E4UjVsMwpxdWp4Rk13TFVnTHlOTkduOG9LdkdMeDNsMFg0eTVCRURsckxhcExpb1FoQlA2dldkeG9XZkRGaTBZUTRCR3RxCkRtVUpnN3FMRWlvV01HOWwvZGFqbXRyUjkvY283R2c0amhPOU16cjNBaDhqaTBpc295bTZyZ1d5OEF0Mm9ObUMKT09lUVNhaHZwVmpGTXpIYStsWHVRUVNUc0dKamJVOXpvT3lxeGRETElyYk5lUVhiandKSW85RkQ1RlFXam9WQgp0MXhPN0gvQm9IQVptd2xNRUJCVnN5RkRIQStJTVlXdzVBbmNDTnluT3ZCYlB0K3pYOWRyakQzazZ2QW1VV3J1ClJYUzliVk1kVVFVYXhhWXR5RS9IaU12ZVV5Y0ViM24wN2FUWTllV2xHeVNhdjRzMnpYNFBFOWt4cmdJYzJsMmQKZzM3TGhRS0NBUUFnZ3R1azJWVm15VG4vWktoenlpNjc3Yjd5bWJhOHF1ZmJ5aGVPVmtpNEhCVU4rc1kzQzBMVQpJY1pVZ0Z2VU5EM2RUdUpEQksyaXJJNUI0MW9WQk9TUXBkNjgwZGFQSEI0MVI1azNud0pzUm1BZ1lRWTc5R3pXClRrQkFLYVB3U0MvK0l5a2hkQS81ZHovMUxGRU1SNkozdVdjdnIvTVpTdW44SWQwYzZIOUFWRGtqSERwcnMwNmUKaXozQUxZL2toZmJlcS80dzNEM2J0QlA4ci9FV1UrcW5xZnpldWVCZS9CTjh0bkZERytwMnZJZkJNZ0VVRXk0cApncU1wV0s4YnpqRWx5V0hJMmJ1a0JLNC9QVzl4NldodnNnZnlQRzNGMWFJcEtKdEVlcHArZmN1eU10K1pzVzNpCmNVQTI2TDlFUlVQMmI3MFVibEw0bDN1TnZMeGp0bDgxQW9JQkFRQ3ZMUDNBYzA4TkwrQ3hzSVQ0YlkwMWtDdmkKMzM0RW03WHhERlcvbGY5MW9iUUt5N3Mva3Q2b2FXS1F0Znh6ZWlzQnNFck9wZ3RpVTl5c0dpREMzYThlY3pmWApwZDVlWkFYUjl3cUNyVktPWXdMNEhRZDFKRmU1V2Q2bWliSzhOZGtRY2gzSVVjY3I0cnVFdjU5MnQzYWdlNFdhCmZRSzNxTm83MS9qWUl3eUpLZnpCMXdOQzBUWGtaWFl0RnloQzFHMTN1aTk5ak1BSXBCMitNT3pDWE11NGZoVU4KbzErc1phYUxOMDMvVzhmay9IT3NHYVkrNzc2U2JJemZPeGlObHZCT1B5RlJrWUdpVytWUWovVjlvcjZIbE81ZQprRGVOS1V0YTkyVlkxVXY3MkVxWjlDLzJKRWpkL1crWllEb01DZ1lvbXNwNWttem9JbTlVdldZa0luQVYKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K | base64 -d > ./master.key && chmod 600 ./master.key"]
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "./wait-for.sh 52.210.239.167:6443 -t 1200 -- echo \"Cluster Ready\""]
module.fury.aws_security_group.master: Creation complete after 2s [id=sg-009401d016dc17b03]
module.fury.aws_security_group_rule.master_egress: Creating...
module.fury.aws_security_group_rule.master_ingress: Creating...
module.fury.aws_security_group.worker: Creation complete after 2s [id=sg-01deabaac88308a41]
module.fury.aws_security_group_rule.worker_ingress: Creating...
module.fury.aws_security_group_rule.worker_ingress_self: Creating...
module.fury.aws_security_group_rule.worker_egress: Creating...
module.fury.aws_spot_instance_request.master: Creating...
module.fury.aws_security_group_rule.master_egress: Creation complete after 0s [id=sgrule-750075781]
module.fury.aws_security_group_rule.worker_ingress: Creation complete after 0s [id=sgrule-2504078359]
module.fury.aws_security_group_rule.master_ingress: Creation complete after 1s [id=sgrule-536666564]
module.fury.aws_security_group_rule.worker_ingress_self: Creation complete after 1s [id=sgrule-4048446734]
module.fury.aws_security_group_rule.worker_egress: Creation complete after 2s [id=sgrule-2973430046]
module.fury.null_resource.kubeconfig: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.master: Creation complete after 13s [id=sir-ddyr42nm]
module.fury.data.template_file.init_worker: Refreshing state...
module.fury.aws_eip_association.eip_assoc: Creating...
module.fury.aws_spot_instance_request.worker[2]: Creating...
module.fury.aws_spot_instance_request.worker[1]: Creating...
module.fury.aws_spot_instance_request.worker[0]: Creating...
module.fury.null_resource.kubeconfig: Still creating... [20s elapsed]
module.fury.aws_eip_association.eip_assoc: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[2]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[1]: Still creating... [10s elapsed]
module.fury.aws_spot_instance_request.worker[0]: Still creating... [10s elapsed]
module.fury.aws_eip_association.eip_assoc: Creation complete after 10s [id=eipassoc-0457c5ada416544c9]
module.fury.aws_spot_instance_request.worker[2]: Creation complete after 12s [id=sir-smy87cmq]
module.fury.aws_spot_instance_request.worker[1]: Creation complete after 12s [id=sir-6ihi7q7m]
module.fury.aws_spot_instance_request.worker[0]: Creation complete after 12s [id=sir-nex86znq]
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
module.fury.null_resource.kubeconfig (local-exec): Cluster Ready
module.fury.null_resource.kubeconfig: Provisioning with 'remote-exec'...
module.fury.null_resource.kubeconfig (remote-exec): Connecting to remote host via SSH...
module.fury.null_resource.kubeconfig (remote-exec):   Host: 52.210.239.167
module.fury.null_resource.kubeconfig (remote-exec):   User: fury
module.fury.null_resource.kubeconfig (remote-exec):   Password: false
module.fury.null_resource.kubeconfig (remote-exec):   Private key: true
module.fury.null_resource.kubeconfig (remote-exec):   Certificate: false
module.fury.null_resource.kubeconfig (remote-exec):   SSH Agent: false
module.fury.null_resource.kubeconfig (remote-exec):   Checking Host Key: false
module.fury.null_resource.kubeconfig (remote-exec): Connected!
module.fury.null_resource.kubeconfig: Still creating... [4m40s elapsed]
module.fury.null_resource.kubeconfig (remote-exec): Cluster "kubernetes" set.
module.fury.null_resource.kubeconfig: Provisioning with 'local-exec'...
module.fury.null_resource.kubeconfig (local-exec): Executing: ["/bin/sh" "-c" "scp -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking=no\" -i master.key fury@52.210.239.167:/home/fury/.kube/config kubeconfig"]
module.fury.null_resource.kubeconfig (local-exec): Warning: Permanently added '52.210.239.167' (ECDSA) to the list of known hosts.
module.fury.null_resource.kubeconfig: Creation complete after 4m45s [id=5033302780773013280]
module.fury.data.local_file.kubeconfig: Refreshing state...

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

master_public_ip = 52.210.239.167
tls_private_key = <sensitive>
```

##### Enter master node

```bash
$ terraform output tls_private_key > cluster.key && chmod 600 cluster.key && ssh -i cluster.key fury@52.210.239.167
# fury@ip-172-31-36-19:~$ while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cluster creation...'; sleep 5; done
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
Waiting for cluster creation...
# fury@ip-172-31-36-19:~$ kubectl get nodes
NAME                                          STATUS     ROLES                  AGE     VERSION
ip-172-31-17-206.eu-west-1.compute.internal   NotReady   <none>                 114s    v1.20.0
ip-172-31-18-39.eu-west-1.compute.internal    NotReady   <none>                 114s    v1.20.0
ip-172-31-19-193.eu-west-1.compute.internal   NotReady   <none>                 114s    v1.20.0
ip-172-31-36-19.eu-west-1.compute.internal    NotReady   control-plane,master   2m13s   v1.20.0
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
# fury@ip-172-31-36-19:~$ curl -LOs https://github.com/sighupio/furyctl/releases/download/v0.2.4/furyctl-linux-amd64
# fury@ip-172-31-36-19:~$ sudo mv furyctl-linux-amd64 /usr/local/bin/furyctl
# fury@ip-172-31-36-19:~$ sudo chmod +x /usr/local/bin/furyctl
# fury@ip-172-31-36-19:~$ curl -LOs https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.3.0/kustomize_v3.3.0_linux_amd64.tar.gz
# fury@ip-172-31-36-19:~$ tar -zxvf kustomize_v3.3.0_linux_amd64.tar.gz
kustomize
# fury@ip-172-31-36-19:~$ sudo mv kustomize /usr/local/bin/kustomize
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
NAMESPACE            NAME                                                                 READY   STATUS      RESTARTS   AGE
cert-manager         cert-manager-78d59f57f8-wv5dr                                        1/1     Running     0          5m48s
cert-manager         cert-manager-cainjector-677c744848-pmwg6                             1/1     Running     1          5m48s
cert-manager         cert-manager-webhook-85df949f5-ckch2                                 1/1     Running     0          5m48s
gatekeeper-system    gatekeeper-audit-559f589965-529l8                                    1/1     Running     0          5m48s
gatekeeper-system    gatekeeper-controller-manager-5675f57b78-2hvlb                       1/1     Running     0          5m48s
gatekeeper-system    gatekeeper-controller-manager-5675f57b78-6krbk                       1/1     Running     0          5m48s
gatekeeper-system    gatekeeper-controller-manager-5675f57b78-x4qtd                       1/1     Running     3          5m48s
gatekeeper-system    gatekeeper-policy-manager-8468b84f95-wfz76                           1/1     Running     0          5m48s
ingress-nginx        forecastle-6fdf88bf46-r9fs5                                          1/1     Running     0          5m48s
ingress-nginx        nginx-ingress-controller-75c8w                                       1/1     Running     1          5m25s
ingress-nginx        nginx-ingress-controller-pxdqq                                       1/1     Running     0          5m27s
ingress-nginx        nginx-ingress-controller-vcgsn                                       1/1     Running     0          5m26s
kube-system          calico-kube-controllers-bd5756745-7twgk                              1/1     Running     4          5m47s
kube-system          calico-node-4hx98                                                    1/1     Running     0          5m47s
kube-system          calico-node-m64cv                                                    1/1     Running     0          5m47s
kube-system          calico-node-qgmpp                                                    1/1     Running     0          5m47s
kube-system          calico-node-wgmjq                                                    1/1     Running     1          5m47s
kube-system          coredns-74ff55c5b-fzn79                                              1/1     Running     0          12m
kube-system          coredns-74ff55c5b-mb669                                              1/1     Running     0          12m
kube-system          etcd-ip-172-31-36-19.eu-west-1.compute.internal                      1/1     Running     0          12m
kube-system          kube-apiserver-ip-172-31-36-19.eu-west-1.compute.internal            1/1     Running     0          12m
kube-system          kube-controller-manager-ip-172-31-36-19.eu-west-1.compute.internal   1/1     Running     0          12m
kube-system          kube-proxy-82jk9                                                     1/1     Running     0          12m
kube-system          kube-proxy-8npx7                                                     1/1     Running     0          12m
kube-system          kube-proxy-mp8h8                                                     1/1     Running     0          12m
kube-system          kube-proxy-wsm69                                                     1/1     Running     0          12m
kube-system          kube-scheduler-ip-172-31-36-19.eu-west-1.compute.internal            1/1     Running     0          12m
kube-system          metrics-server-778c4c5854-kqbfv                                      1/1     Running     0          5m47s
kube-system          minio-0                                                              1/1     Running     0          5m47s
kube-system          minio-setup-vr7xg                                                    0/1     Completed   3          5m46s
kube-system          velero-7c68747dcb-4nszr                                              1/1     Running     0          5m47s
kube-system          velero-restic-j5g95                                                  1/1     Running     0          5m27s
kube-system          velero-restic-jvdzs                                                  1/1     Running     0          5m26s
kube-system          velero-restic-qskwt                                                  1/1     Running     2          5m25s
local-path-storage   local-path-provisioner-64bb9787d9-zkwpk                              1/1     Running     0          12m
logging              cerebro-d4b9846d9-scrxv                                              1/1     Running     0          5m47s
logging              elasticsearch-0                                                      2/2     Running     0          5m47s
logging              fluentbit-75bc4                                                      1/1     Running     0          5m47s
logging              fluentbit-m4p6v                                                      1/1     Running     0          5m47s
logging              fluentbit-rb69x                                                      1/1     Running     0          5m47s
logging              fluentbit-vwbjm                                                      1/1     Running     0          5m47s
logging              fluentd-0                                                            1/1     Running     1          5m47s
logging              fluentd-1                                                            1/1     Running     0          3m29s
logging              fluentd-2                                                            1/1     Running     0          3m3s
logging              kibana-7fdb7bd967-j9dch                                              1/1     Running     0          5m47s
monitoring           goldpinger-2p2tl                                                     1/1     Running     0          5m47s
monitoring           goldpinger-6bjxk                                                     1/1     Running     0          5m47s
monitoring           goldpinger-qcg57                                                     1/1     Running     0          5m47s
monitoring           goldpinger-vf52m                                                     1/1     Running     0          5m47s
monitoring           grafana-f8f78bcb8-8hfcg                                              2/2     Running     0          5m46s
monitoring           kube-proxy-metrics-7fxxn                                             1/1     Running     0          5m46s
monitoring           kube-proxy-metrics-7n6pb                                             1/1     Running     0          5m46s
monitoring           kube-proxy-metrics-npjx4                                             1/1     Running     0          5m47s
monitoring           kube-proxy-metrics-qbblv                                             1/1     Running     0          5m46s
monitoring           kube-state-metrics-7bfdd469b-sc2hj                                   1/1     Running     0          5m46s
monitoring           node-exporter-cb9wf                                                  2/2     Running     0          5m46s
monitoring           node-exporter-dxhxd                                                  2/2     Running     0          5m46s
monitoring           node-exporter-jqmn7                                                  2/2     Running     0          5m45s
monitoring           node-exporter-s4ll4                                                  2/2     Running     0          5m46s
monitoring           prometheus-k8s-0                                                     2/2     Running     1          2m50s
monitoring           prometheus-operator-745cff5476-hrg5l                                 1/1     Running     0          5m46s
```

> It can take up to 10 minutes.


## Run conformance tests

> Install requirements and run commands in master node.

Download [Sonobuoy](https://github.com/heptio/sonobuoy)
([version 0.20.0](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.20.0))

And deploy a Sonobuoy pod to your cluster with:

```bash
$ sonobuoy run --mode=certified-conformance
```

Wait until sonobuoy status shows the run as completed.

```bash
$ sonobuoy status
```
