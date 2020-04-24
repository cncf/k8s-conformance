# Agorakube

Official documentation:
 - https://github.com/ilkilab/agorakube
 - https://github.com/ilkilab/agorakube/blob/master/docs/instructions.md

By following these steps you may reproduce the Agorakube Conformance e2e
results.

# Install Agorakube For Local Development & CNCF Conformance Test Environment

You can create a local environment by using Vagrant. 
The document below describes pre-requisites for Agorakube local environment and how you can start using them.

## Pre-requisites

* Vagrant
* VirtualBox

## Deploy the environment

1) On your desktop, create a file named: "Vagrantfile" with the following content:

```
$script = <<-SCRIPT
echo "
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBTj+4Tjx2Az14spFKaD1rkxrhQSaybNDQOS9P7jGk3OaubL8qWTXVr69n4xu56PDCe06g4XOlpXkLNUOVr5CKOyP+9Eyw41V9de4DDEaPhidFtOULTubzYJ4tyhwysFnB/vq75TfoCgI6uYHl4tcSZqQB6g/4C2TGuFWj/T0CzlE6hxNzRy16udyfMxH7YZ445238Wtn96RxfJdkINgB+6h0jGRh1j8OuuIwZdUa1e4W+p53JGizXCRySAtZPxlNyaT2SxqOpfXShp+KqhIG8N7HPgCMdBHNXFy2zticR/tWjdWOPsuro0z8SZY7EgZD3PfgKD88BkdaG4B50RPgt pierre@DESKTOP-BT28R5N
" >> /home/vagrant/.ssh/authorized_keys
bash <(curl -s https://raw.githubusercontent.com/ilkilab/agorakube/master/setup-hosts.sh)
SCRIPT

$script2 = <<-SCRIPT
echo "
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAwU4/uE48dgM9eLKRSmg9a5Ma4UEmsmzQ0DkvT+4xpNzmrmy/
Klk11a+vZ+MbuejwwntOoOFzpaV5CzVDla+Qijsj/vRMsONVfXXuAwxGj4YnRbTl
C07m82CeLcocMrBZwf76u+U36AoCOrmB5eLXEmakAeoP+AtkxrhVo/09As5ROocT
c0cterncnzMR+2GeOOdt/FrZ/ekcXyXZCDYAfuodIxkYdY/DrriMGXVGtXuFvqed
yRos1wkckgLWT8ZTcmk9ksajqX10oafiqoSBvDexz4AjHQRzVxcts7YnEf7Vo3Vj
j7Lq6NM/EmWOxIGQ9z34Cg/PAZHWhuAedET4LQIDAQABAoIBAHSz1whgQ2REBIKv
28N+N0aQ4zOG7+PcihyLyaKJ/XK44pP/l1Hr1fKSRGWF2SFeHqxrYUcDlZw10GQR
3iGqgqrRlaPAveQ0+1HpNq6kZJ0VsvQEiBtRoWDhvd2LHYcErMvQMnPpqNzv3fSy
NlghoRK84Ns/AjEQP+ExPJLqukDMXeaqC6juCg5VFow2O7dxxACXpIyA8XZVS9vj
C6lWFoBaWrClrV9xnUes0AZEpHq//1NMUkXnNM6jO0OvI/BfDgL8lvJREkGDp7r1
p0e/aq0Lp50ttKFGSGFag2yfMf9eEziW1yl3Jj6FOe8Uvk0U2On2AgLj75SqvZoa
zYx/u0kCgYEA3xrGySSl8mfgWMIhteg+Zq3C/ogQzrA1NxFiQ43fQjyQ1tCA1pJc
v1tK0S7zLcJb7LI6Zc7+B7UiSuLzMDUVRMQcr+AbAKe50QCOfvuaRh7sueARCck1
nZwxxT5vbDNzpxrUvb28mBqBA9p7KXHQ8f4gSvbfaFXNpK0ox2VlZDcCgYEA3c6x
Wt1TWVoNpXLL0YLRDIpNseb7uqNCf2qTkKK9ivXne6TAQYs2Ck8XzsxnjUZg/4c1
HKHpWXBEumyLel5tn1djLHvXg5IkECFu4pSq1ciM6+Uz2JfXuigK6s/4uKCBxTHM
CdxGEGkutPxSF1uzs2npVRMMDGUSJV7U2//XXLsCgYA0pZPtGSnTtvF44G6mB2Ta
Q/y0pZUZwPj9wqtmd48MiVBAcLlGaQlb2oYgMK0PykJ462HebmcBmJu8AiwS3yPi
s0h1tDOLBwlRKYl2q5avH1MLVbWPkpyFUbto6R/P76BF+Y3kLGbZmb+CEkdn80S0
Jhyms/TqIP1C892gl+vCJwKBgQC9f9RIVCTchrJ38o6tjXz6oMJmRng0aTzrzOsL
u+4B5bsCCKx0kvH1dsNZW4rwyPsf9KzsrGvHjMI7H3c+caRoaOmC3L8wWk/TNC0f
CXK2uOOkuipEVt3o3kMNf+b4HbEg/z1aA0YcyTAtUhD0gdUSaF7/3wkBIeyR3uYu
mvKs9wKBgQCqTHebAh3hA6OmMjC2GVPKGfyqCDslVu2YE7avvVJxb8bj0QYg3yft
tLPRCasq7fw/jx3UnZlYAx5JiSgSl6wcr+eF+JDLLfZn4ExEqcwN03WHCXPPqede
3WnbITRBes7qyN9TvdtH2NihIHgMAM8QlijMj//tDQfqktps2HVELg==
-----END RSA PRIVATE KEY-----
" >> /home/vagrant/ssh-private-key.pem
chmod 0400 /home/vagrant/ssh-private-key.pem
cd /home/vagrant/
bash <(curl -s https://raw.githubusercontent.com/ilkilab/agorakube/master/setup-deploy.sh)
echo '
[deploy]
deploy ansible_connection=local

[masters]
master1  ansible_host=10.10.20.4
#k8s-2.novalocal  ansible_host=10.20.20.5
#k8s-3.novalocal  ansible_host=10.20.20.8
#deploy.novalocal ansible_connection=local ip=10.20.20.8
[etcd]
master1  ansible_host=10.10.20.4
#k8s-1.novalocal  ansible_host=10.20.20.4
#k8s-2.novalocal  ansible_host=10.20.20.5
#k8s-3.novalocal  ansible_host=10.20.20.8
#deploy.novalocal ansible_connection=local ip=10.20.20.8
[workers]
#worker1  ansible_host=10.10.20.4
worker1  ansible_host=10.10.20.5
worker2  ansible_host=10.10.20.6
#k8s-6.novalocal  ansible_host=10.20.20.10
#deploy.novalocal ansible_connection=local ip=10.20.20.8

[storage]
#worker1 ansible_host=10.10.20.4
worker1 ansible_host=10.10.20.5
worker2 ansible_host=10.10.20.6

[all:vars]
advertise_ip_masters=10.10.20.4

# SSH connection settings
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
ansible_user=vagrant
ansible_ssh_private_key_file=/home/vagrant/ssh-private-key.pem
' > /home/vagrant/agorakube/hosts

echo '
---

# CERTIFICATES
cn_root_ca: ilkilabs
c: FR
st: Ile-De-France
l: Paris
expiry: 87600h
rotate_certs_pki: false
rotate_full_pki: false

# Components version
etcd_release: v3.4.5
kubernetes_release: v1.18.2
delete_previous_k8s_install: False
delete_etcd_install: False
check_etcd_install: True

# IPs-CIDR Configurations
cluster_cidr: 10.33.0.0/16
service_cluster_ip_range: 10.32.0.0/24
kubernetes_service: 10.32.0.1
cluster_dns_ip: 10.32.0.10
service_node_port_range: 30000-32000
kube_proxy_mode: ipvs
kube_proxy_ipvs_algotithm: rr
cni_release: 0.8.5

# Custom features
runtime: docker
network_cni_plugin: flannel
flannel_iface: eth1
ingress_controller: traefik
dns_server_soft: coredns
populate_etc_hosts: yes
k8s_dashboard: True
service_mesh: none
linkerd_release: stable-2.6.0
install_helm: False
init_helm: False
install_kubeapps: false

# Calico
calico_mtu: 1440

# Security
encrypt_etcd_keys:
# Warrning: If multiple keys are defined ONLY LAST KEY is used for encrypt and decrypt.
# Other keys are used only for decrypt purpose
  key1:
    secret: 1fJcKt6vBxMt+AkBanoaxFF2O6ytHIkETNgQWv4b/+Q=

# Data Directory
data_path: "/var/agorakube"
etcd_data_directory: "/var/lib/etcd"
#restoration_snapshot_file: /path/snopshot/file Located on {{ etcd_data_directory }}

# KUBE-APISERVER spec
kube_apiserver_enable_admission_plugins:
# plugin AlwaysPullImage can be deleted. Credentials would be required to pull the private images every time. 
# Also, in trusted environments, this might increases load on network, registry, and decreases speed.
#  - AlwaysPullImages
  - NamespaceLifecycle
# EventRateLimit is used to limit DoS on API server in case of event Flooding
  - EventRateLimit
  - LimitRanger
  - ServiceAccount
  - TaintNodesByCondition
  - PodNodeSelector
  - Priority
  - DefaultTolerationSeconds
  - DefaultStorageClass
  - StorageObjectInUseProtection
  - PersistentVolumeClaimResize
  - MutatingAdmissionWebhook
  - NodeRestriction
  - ValidatingAdmissionWebhook
  - RuntimeClass
  - ResourceQuota
# SecurityContextDeny should be replaced by PodSecurityPolicy
#  - SecurityContextDeny


# Rook Settings
enable_rook: False
rook_dataDirHostPath: /data/rook



# Monitoring. Rook MUST be enabled to use monitoring (Monitoring use StorageClass to persist data)
enable_monitoring: False
' > /home/vagrant/agorakube/group_vars/all.yaml
cd /home/vagrant/agorakube
sudo ansible-playbook agorakube.yaml
SCRIPT



Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: $script
    config.vm.box = "bento/ubuntu-18.04"
    config.vm.define "master1" do |master1|
		master1.vm.hostname = "worker1"
		master1.vm.network "private_network", ip: "10.10.20.4"
		master11.vm.provider "virtualbox" do |v|
			v.memory = 3048
			v.cpus = 1
			v.name = "master1"
		end
	end
	config.vm.define "worker1" do |worker1|
		worker1.vm.hostname = "worker2"
		worker1.vm.network "private_network", ip: "10.10.20.5"
		worker1.vm.provider "virtualbox" do |v|
			v.memory = 3048
			v.cpus = 1
			v.name = "worker1"
		end
	end
	config.vm.define "worker2" do |worker2|
		worker2.vm.hostname = "worker3"
		worker2.vm.network "private_network", ip: "10.10.20.6"
		worker2.vm.provider "virtualbox" do |v|
			v.memory = 3048
			v.cpus = 1
			v.name = "worker2"
		end
	end
	config.vm.define "deploy" do |deploy|
	    deploy.vm.provision "shell", inline: $script2
		deploy.vm.hostname= "master1"
		deploy.vm.network "private_network", ip: "10.10.20.3"
		deploy.vm.provider "virtualbox" do |v|
			v.memory = 2048
			v.cpus = 1
			v.name = "deploy"
		end
	end
end
```

You can edit the vagrant to fit your needs.


## Start the environment

1) Simply open a terminal and goto the folder that handle your "Vagrantfile" file and then run the following command:

`vagrant up`

2) One Agorakube installation is finished, connect to the deploy manachine with the following command:

`vagrant ssh deploy`

3) Kubernetes CLI "kubectl" is configured for root user, so use the following command to become root:

`sudo su`

4) You can now enjoy your Agorakube/K8S fresh cluster ! Use the following command to print K8S version:

`kubectl version`

# Run Conformance Test

1. Once you AgoraKube Kubernetes cluster is active, Fetch it's kubeconfig.yaml file (located in the /root/.kube/config file on the deploy machine) and save it locally.

2. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

3. Configure your kubeconfig file by running:
```sh
$ export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

4. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

4. Watch the logs:
```sh
$ sonobuoy logs
```

5. Check the status:
```sh
$ sonobuoy status
```

6. Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
$ mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

7. To clean up Kubernetes objects created by Sonobuoy, run:

```
$ sonobuoy delete
```
