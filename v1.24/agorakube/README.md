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
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBTj+4Tjx2Az14spFKaD1rkxrhQSaybNDQOS9P7jGk3OaubL8qWTXVr69n4xu56PDCe06g4XOlpXkLNUOVr5CKOyP+9Eyw41V9de4DDEaPhidFtOULTubzYJ4tyhwysFnB/vq75TfoCgI6uYHl4tcSZqQB6g/4C2TGuFWj/T0CzlE6hxNzRy16udyfMxH7YZ445238Wtn96RxfJdkINgB+6h0jGRh1j8OuuIwZdUa1e4W+p53JGizXCRySAtZPxlNyaT2SxqOpfXShp+KqhIG8N7HPgCMdBHNXFy2zticR/tWjdWOPsuro0z8SZY7EgZD3PfgKD88BkdaG4B50RPgt
" >> /home/vagrant/.ssh/authorized_keys
bash <(curl -s https://raw.githubusercontent.com/ilkilab/agorakube/minimal/master/setup-hosts.sh)
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
bash <(curl -s https://raw.githubusercontent.com/ilkilab/agorakube/minimal/master/setup-deploy.sh)
echo '
[deploy]
master10 ansible_connection=local
[masters]
master10  ansible_host=10.101.20.4
[etcd]
master10  ansible_host=10.101.20.4
[workers]
worker10  ansible_host=10.101.20.5
worker20  ansible_host=10.101.20.6

[all:vars]
advertise_masters=10.101.20.4
#advertise_masters=kubernetes.localcluster.lan
# SSH connection settings
ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
ansible_user=vagrant
ansible_ssh_private_key_file=/home/vagrant/ssh-private-key.pem
[etc_hosts]
#kubernetes.localcluster.lan ansible_host=10.10.20.4
' > /home/vagrant/agorakube/hosts
echo '
---
agorakube:
  global:
    data_path: /var/agorakube

agorakube_pki:
  infos:
    state: "Ile-De-France"
    locality: "Paris"
    country: "FR"
    root_cn: "ILKI Kubernetes Engine"
    expirity: "+3650d"
  management:
    rotate_certificats: False

agorakube_base_components:
  etcd:
    release: v3.4.21
    upgrade: False
    check: true
    data_path: /var/lib/etcd
  kubernetes:
    release: v1.24.6
    upgrade: False
  cloud_controller_manager:
    enabled: False

agorakube_network:
  cni_plugin: calico
  calico_autodetection_method: "first-found"
  mtu: 0
  cidr:
    pod: 10.33.0.0/16
    service: 10.32.0.0/16
  service_ip:
    kubernetes: 10.32.0.1 
    coredns: 10.32.0.10
  dns:
    primary_forwarder: 8.8.8.8
    secondary_forwarder: 8.8.4.4
  nodeport:
    range: 30000-32000
  external_loadbalancing:
    enabled: True
    ip_range: 10.101.20.50-10.101.20.250
    secret_key: LGyt2l9XftOxEUIeFf2w0eCM7KjyQdkHform0gldYBKMORWkfQIsfXW0sQlo1VjJBB17shY5RtLg0klDNqNq4PAhNaub+olSka61LxV73KN2VaJY/snrZmHbdf/a7DfdzaeQ5pzP6D5O7zbUZwfb5ASOhNrG8aDMY3rkf4ZzHkc=
  kube_proxy:
    mode: ipvs
    algorithm: rr

agorakube_features:
  coredns:
    release: "1.9.4"
    replicas: 2
  dashboard:
    enabled: True
    generate_admin_token: True
    release: v2.7.0
  metrics_server:
    enabled: True
  ingress:
    controller: nginx
    release: v1.3.1

etc_hosts:
  - hostname: "localhost"
    ip: "127.0.0.1"

# Populate /etc/hosts using all inventory groups
# Note: This will not remove /etc/hosts entries when removed from inventory
agorakube_populate_etc_hosts: True

# Remove ALL /etc/hosts entries that are NOT defined in the etc_hosts group or etc_hosts variable
agorakube_remove_etc_hosts: False

# Optionally backup /etc/hosts each time a change is made
agorakube_backup_etc_hosts: False

# Security
agorakube_encrypt_etcd_keys:
# Warrning: If multiple keys are defined ONLY LAST KEY is used for encrypt and decrypt.
# Other keys are used only for decrypt purpose. Keys can be generated with command: head -c 32 /dev/urandom | base64
  key1:
    secret: 1fJcKt6vBxMt+AkBanoaxFF2O6ytHIkETNgQWv4b/+Q=

agorakube_sonobuoy_mode: False
#restoration_snapshot_file: /path/snopshot/file Located on {{ etcd_data_directory }}

' > /home/vagrant/agorakube/group_vars/all.yaml
cd /home/vagrant/agorakube
echo '
#!/bin/bash
apt update
apt -y install python3.8-venv
python3 -m venv /usr/local/agorakube-env
source /usr/local/agorakube-env/bin/activate
pip3 install --upgrade pip
pip3 install -r requirements.txt
ansible --version
' > /home/vagrant/agorakube/script.sh
chmod +x /home/vagrant/agorakube/script.sh
cd /home/vagrant/agorakube/
. /home/vagrant/agorakube/script.sh
cd /home/vagrant/agorakube/
ansible-playbook agorakube.yaml
cp /root/.kube/config /var/kubeconfig/config
SCRIPT



Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: $script
    config.vm.box = "bento/ubuntu-20.04"
	  config.vm.define "worker10" do |worker10|
    worker10.vm.hostname = "worker10"
    worker10.vm.network "private_network", ip: "10.101.20.5"
    worker10.vm.provider "virtualbox" do |v|
			v.memory = 3096
			v.cpus = 1
			v.name = "worker10"
		end
	end
	config.vm.define "worker20" do |worker20|
		worker20.vm.hostname = "worker20"
		worker20.vm.network "private_network", ip: "10.101.20.6"
		worker20.vm.provider "virtualbox" do |v|
			v.memory = 3096
			v.cpus = 1
			v.name = "worker20"
		end
	end
	config.vm.define "master10" do |master10|
    master10.vm.provision "shell", inline: $script2
		master10.vm.synced_folder ".", "/var/kubeconfig"
		master10.vm.hostname = "master10"
		master10.vm.network "private_network", ip: "10.101.20.4"
		master10.vm.provider "virtualbox" do |v|
			v.memory = 3096
			v.cpus = 1
			v.name = "master10"
		end
	end
end
```

You can edit the vagrant to fit your needs.


## Start the environment

1) Simply open a terminal and goto the folder that handle your "Vagrantfile" file and then run the following command:

`vagrant up`

2) One Agorakube installation is finished, connect to the deploy manachine with the following command:

`vagrant ssh master10`

3) Kubernetes CLI "kubectl" is configured for root user, so use the following command to become root:

`sudo su`

4) You can now enjoy your Agorakube/K8S fresh cluster ! Use the following command to print K8S version:

`kubectl version`


# Run Conformance Test

1. Once you AgoraKube Kubernetes cluster is active, Fetch it's kubeconfig.yaml file (located in the /root/.kube/config file on the deploy machine) and save it locally.

2. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```sh
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.10/sonobuoy_0.56.10_linux_amd64.tar.gz
$ tar -xvf sonobuoy_0.56.10_linux_amd64.tar.gz
$ mv sonobuoy /usr/bin
```

3. Configure your kubeconfig file by running:
```sh
$ export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

4. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance --wait
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
