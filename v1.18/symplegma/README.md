# Symplegma

## How to reproduce the results

## Requirements

* Ansible
* Git
* Kubectl

### Example with Ubuntu 18.04 LTS

* Launch at least to instances of Ubuntu 18.04 LTS

* Clone the repository:

```
git clone https://github.com/clusterfrak-dynamics/symplegma
cd symplegma
ansible-playbook install -r requirements.yml
```

* Prepare inventory:

```
cd inventory
cp -ar sample-ubuntu conformance
```

* Edit hosts:

```
ec2-35-181-26-58.eu-west-3.compute.amazonaws.com
ec2-35-181-153-105.eu-west-3.compute.amazonaws.com
ec2-15-188-11-22.eu-west-3.compute.amazonaws.com

[master]
ec2-35-181-26-58.eu-west-3.compute.amazonaws.com

[node]
ec2-35-181-153-105.eu-west-3.compute.amazonaws.com
ec2-15-188-11-22.eu-west-3.compute.amazonaws.com
```

* Configure `group_var/all/all.yml`:

```
---
bootstrap_python: false
ansible_ssh_user: ubuntu
ansible_ssh_common_args: '-o StrictHostKeyChecking=no'

kubeadm_version: v1.18.0
kubernetes_version: v1.18.0

bin_dir: /usr/local/bin

cni_plugin: "calico"

kubeadm_api_server_extra_args: {}
kubeadm_controller_manager_extra_args: {}
kubeadm_scheduler_extra_args: {}
kubeadm_api_server_extra_volumes: {}
kubeadm_controller_manager_extra_volumes: {}
kubeadm_scheduler_extra_volumes: {}
kubeadm_kubelet_extra_args: {}

kubeadm_api_server_cert_extra_sans: {}

kubeadm_cluster_name: conformance
```

* Run the playbooks:

```
ansible-playbook -b -i inventory/conformance/hosts symplegma-init.yml
```

* Export `KUBECONFIG`:

```
export KUBECONFIG=$(pwd)/kubeconfig/conformance/admin.conf
```

* Check cluster status:

```
kubectl get nodes
NAME               STATUS   ROLES    AGE     VERSION
ip-172-31-34-104   Ready    master   2d18h   v1.18.0
ip-172-31-34-59    Ready    <none>   2d17h   v1.18.0
ip-172-31-41-191   Ready    <none>   2d17h   v1.18.0
```

## Running e2e tests

```
wget https://github.com/heptio/sonobuoy/releases/download/v0.18.0/sonobuoy_0.18.0_linux_amd64.tar.gz
tar -zxvf sonobuoy_0.18.0_linux_amd64.tar.gz
./sonobuoy run --mode certified-conformance
./sonobuoy status
./sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```
