# Petasus Cloud

## Infrastructure Kubernetes

### Download KubeSpray Deployer

```shell
$ git clone https://github.com/kubernetes-incubator/kubespray.git -b release-2.25
```

### Install Ansible with Dependencies

```shell
$ sudo yum update -y
$ sudo yum install epel-release -y
$ sudo yum install git wget python36 python36-devel python3.11 python3.11-pip python3-libselinux python3.11-devel -y

$ python3.11 -m venv ~/.venv/default
$ source ~/.venv/default/bin/activate
```

Install python dependencies using the latest pip3.

```shell
$ pip install -U pip
$ cd ${kubespray_dir}
$ pip install -r requirements.txt
$ pip install -r contrib/inventory_builder/requirements.txt
$ ansible-galaxy collection install kubernetes.core
```

### Configuration

#### Inventory Configuration

Copy the example configs from the source.

```shell
$ cp -rfp inventory/sample inventory/my-cluster
```

Edit ```inventory.ini``` located under ```inventory/my-cluster``` to reflect your site configuration.
Followings are the examples ```inventory.yml``` file which aims to bootstrap a Kubernetes cluster with one control-plane node and one worker node.

```yaml
all:
  hosts:
    master-node:
      ansible_host: 10.10.10.10
      ip: 10.10.10.10
      physnet:
        - network: physnet
          interface: ens2f0
      gateway: true
      dataip: 20.20.20.10
    worker-node-1:
      ansible_host: 10.10.10.11
      ip: 10.10.10.11
      physnet:
        - network: physnet
          interface: ens2f0
      dataip: 20.20.20.11

kube_control_plane:
  hosts:
    master-node:

etcd:
  hosts:
    master-node:

kube_node:
  hosts:
    worker-node-1:

k8s_cluster:
  children:
    kube_control_plane:
    kube_node:
    
storage:
  hosts:
    master-node:
    
py3-hosts:
  hosts:
    master-node:
  vars:
    ansible_python_interpreter: /usr/bin/python3
```

#### Variable Configuration

Configure the default calico networking mode from ```vxlan``` to ```ipip```.
Edit ```k8s-net-calico.yml``` located under ```inventory/my-cluster/group_vars/k8s_cluster```.

```yaml
...
# Set calico network backend: "bird", "vxlan" or "none"
# bird enable BGP routing, required for ipip and no encapsulation modes
calico_network_backend: bird

# IP in IP and VXLAN is mutualy exclusive modes.
# set IP in IP encapsulation mode: "Always", "CrossSubnet", "Never"
calico_ipip_mode: 'Always'

# set VXLAN encapsulation mode: "Always", "CrossSubnet", "Never"
calico_vxlan_mode: 'Never'
...
```

Edit ```addons.yml``` located under ```inventory/my-cluster/group_vars/k8s_cluster/``` to enable helm.

```yaml
# Helm deployment
helm_enabled: true
```

### Bootstrap Kubernetes Cluster

```shell
$ ansible-playbook -i inventory/my-cluster/inventory.yml cluster.yml -b
```

### Download Petasus Cloud Deployer

```shell
$ cd ~
$ git clone https://github.com/edgestack/edgespray.git
$ pip install -r edgespray/requirements.txt
```

### Configuration

Copy the aforementioned ```inventory.yml``` to the EdgeSpray.

```shell
$ cd ${edgespray}
$ cp -rfp inventory/sample inventory/my-cluster
$ cp ../${kubespray}/inventory/my-cluster/inventory.yml inventory/my-cluster/inventory.yml
```

### Install Petasus Cloud

```shell
$ ansible-playbook -i inventory/my-cluster/inventory.yml cluster.yml
```

## Run Conformance Test

```shell
$ curl -LO https://github.com/kubernetes-sigs/hydrophone/releases/download/v0.6.0/hydrophone_Linux_x86_64.tar.gz
$ tar xvfz hydrophone_Linux_x86_64.tar.gz -C ./
$ ./hydrophone --conformance
```

