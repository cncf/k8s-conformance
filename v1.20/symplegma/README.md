# Symplegma

## Official documentation

Official project documentation can be found [here](https://particuleio.github.io/symplegma/)

## How to reproduce the results

## Requirements

* Ansible
* Git
* Kubectl

### Example with Ubuntu 18.04 LTS

* Launch at least to instances of Ubuntu 18.04 LTS

* Clone the repository:

```
git clone https://github.com/particuleio/symplegma
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
# Install portable python distribution that do not provide python (eg.
# coreos/flatcar):
# bootstrap_python: true
# ansible_python_interpreter: /opt/bin/python

ansible_ssh_user: ubuntu

ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
# To use a bastion host between node and ansible use:
# ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q ubuntu@{{ ansible_ssh_bastion_host }}"'
# ansible_ssh_bastion_host: __BASTION_IP__

kubeadm_version: v1.20.0
kubernetes_version: v1.20.0
# If deploying HA clusters, specify the loadbalancer IP or domain name and port
# in front of the control plane nodes:
# kubernetes_api_server_address: __LB_HOSTNAME__
# kubernetes_api_server_port: __LB_LISTENER_PORT__

bin_dir: /usr/local/bin
# Change default path for custom binary. On OS with immutable file system (eg.
# coreos/flatcar) use a writable path
# bin_dir: /opt/bin

cni_plugin: "calico"

# Customize API server
kubeadm_api_server_extra_args: {}
kubeadm_api_server_extra_volumes: {}

# Customize controller manager scheduler
# eg. to publish prometheus metrics on "0.0.0.0":
# kubeadm_controller_manager_extra_args: |
#   address: 0.0.0.0
kubeadm_controller_manager_extra_args: {}
kubeadm_controller_manager_extra_volumes: {}

# Customize scheduler manager scheduler
# eg. to publish prometheus metrics on "0.0.0.0":
# kubeadm_scheduler_extra_args: |
#   address: 0.0.0.0
kubeadm_scheduler_extra_volumes: {}
kubeadm_scheduler_extra_args: {}

# Customize Kubelet
# `kubeadm_kubelet_extra_args` is to be used as a last resort,
# `kubeadm_kubelet_component_config` configure kubelet wth native kubeadm API,
# please see
# https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/ for
# more information
kubeadm_kubelet_component_config: {}
kubeadm_kubelet_extra_args: {}


# Customize Kube Proxy configuration using native Kubeadm API
# eg. to publish prometheus metrics on "0.0.0.0":
# kubeadm_kube_proxy_component_config: |
#   metricsBindAddress: 0.0.0.0
kubeadm_kube_proxy_component_config: {}

# Additionnal subject alternative names for the API server
# eg. to add aditionnals domains:
# kubeadm_api_server_cert_extra_sans: |
#   - mydomain.example.com
kubeadm_api_server_cert_extra_sans: {}

kubeadm_cluster_name: symplegma

# Do not label master nor taint (skip kubeadm phase)
# kubeadm_mark_control_plane: false

# Enable systemd cgroup for Kubelet and container runtime
# DO NOT CHANGE this on an existing cluster: Changing the cgroup driver of a
# Node that has joined a cluster is strongly not recommended. If the kubelet
# has created Pods using the semantics of one cgroup driver, changing the
# container runtime to another cgroup driver can cause errors when trying to
# re-create the Pod sandbox for such existing Pods. Restarting the kubelet may
# not solve such errors. Default is to use cgroupfs.
# systemd_cgroup: true
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
ip-172-31-34-104   Ready    master   2d18h   v1.20.0
ip-172-31-34-59    Ready    <none>   2d17h   v1.20.0
ip-172-31-41-191   Ready    <none>   2d17h   v1.20.0
```

## Running e2e tests

```
wget https://github.com/heptio/sonobuoy/releases/download/v0.20.0/sonobuoy_0.20.0_linux_amd64.tar.gz
tar -zxvf sonobuoy_0.20.0_linux_amd64.tar.gz
./sonobuoy run --mode certified-conformance
./sonobuoy status
./sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```
