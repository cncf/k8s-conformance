# Conformance tests for the asuscloud-infra

## Cluster Component  Version Info:

| Name       | Version     |
|------------|-------------|
| kubeadm    | v1\.25.3\.0   |
| kubelet    | v1\.25.3\.0   |
| kubectl    | v1\.25.3\.0   |
| etcd       | 3\.5\.4\-0 |
| Calico     |  v3\.23.3      |
| Containerd | v1\.6\.9   |

## Demo Server Info:

This guide uses the following number of nodes for deployment, and the operating system uses Ubuntu 20.04 for testing:

<span style="color:red">Please modify it according to the actual application.</span>

| Hostname      |  IP Address     | Role   | OS          |
|---------------|-----------------|--------|-------------|
| k8s\-mgmt01   | mgmt01_IP Address | Master | Ubuntu 20\.4 |
| k8s\-mgmt02   | mgmt02_IP Address | Master | Ubuntu 20\.4 |
| k8s\-mgmt03   | mgmt03_IP Address | Master | Ubuntu 20\.4 |
| k8s\-worker01 | worker01 Address | Node   | Ubuntu 20\.4 |
| k8s\-worker02 | worker02 Address | Node   | Ubuntu 20\.4 |

## Before you begin
### System requirements

* Ubuntu 20.04
* Full network connectivity between all machines in the cluster (public or private network)
* sudo privileges on all machines
* SSH access from one device to all nodes in the system.
* Confirm that all firewalls and SELinux are turned off.
    ```sh
    $ systemctl stop firewalld && systemctl disable firewalld
    $ setenforce 0
    $ vim /etc/selinux/config
    SELINUX=disabled
    ```

* Letting iptables see bridged traffic

    ```sh
    $ cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    $ sudo sysctl --system
    ```
* Disable SWAP

    ```
    $ swapoff -a && sysctl -w vm.swappiness=0
    $ sed '/swap.img/d' -i /etc/fstab
    ```
* At least 3 machines that meet [kubeadm’s minimum requirements](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin)

## Download & Install Kubespray & Ansible

To set up kubernetes cluster with kubespray, you need to install ansible on Ansible host first, because kubespray uses Ansible to install Kubernetes clusters.

### 1. Download Kubespray

* Clone the Ansible Kubespray repository to the Ansible host.

    ```shell
    $ git clone https://github.com/kubernetes-sigs/kubespray.git
    ```
    
### 2. Install Ansible and kubespray dependencies

* It is recommended to deploy the ansible version used by kubespray into a python virtual environment.

    ```shell
    $ VENVDIR=kubespray-venv
    $ KUBESPRAYDIR=kubespray
    $ ANSIBLE_VERSION=2.12
    $ virtualenv  --python=$(which python3) $VENVDIR
    $ source $VENVDIR/bin/activate
    $ cd $KUBESPRAYDIR
    $ pip install -U -r requirements-$ANSIBLE_VERSION.txt
    $ test -f requirements-$ANSIBLE_VERSION.yml && \
      ansible-galaxy role install -r requirements-$ANSIBLE_VERSION.yml && \
      ansible-galaxy collection -r requirements-$ANSIBLE_VERSION.yml
    ```
## Set up Kubespray

This section will explain how to configure the kubespray in the Ansible Host node.

### 1. Generate the Ansible Inventory List

Kubespray provides a Python script (inventory builder) for generating Ansible inventory configuration to deploy the Kubernetes cluster.

* Install Python dependencies for inventory builder.

    ```shell
    $ sudo pip3 install -r contrib/inventory_builder/requirements.txt
    ```
    
* Copy the sample directory inventory/samples to inventory/mycluster.

    ```shell
    $ cp -rfp inventory/sample inventory/mycluster
    ```
    
* Create a new variable: IPS, which contains the IP addresses of all nodes in the Kubernetes cluster and generate the Ansible inventory.

    ```shell
    $ declare -a IPS=(10.78.26.140 10.78.26.141 10.78.26.142 10.78.26.194 10.78.26.195)
    $ CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
    ```
    
* Open the inventory/mycluster/hosts.yaml in inventory and edit it to your desire cluster composition.

    ```shell
    $ vim ./inventory/mycluster/hosts.yaml
    ```
    
### 2. Custom Setup in Ansible Inventory

* Set up an additional variable for the Kubernetes cluster by editing the files in inventory/mycluster/group_vars.
    ```shell
    $ vim ./inventory/mycluster/group_vars/...
    ```
    
### 3. Deploy the Kubernetes Cluster with Kubespray

* Deploy cluster with kubespray:
    ```shell
    $ ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml -K
    ```
    
## Run the conformance tests

Follow the official guide: https://github.com/revelrylabs/k8s-conformance/blob/master/instructions.md


1. Once you HA Kubernetes cluster is active, Login to any master nodes.

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
$ sonobuoy run --mode certified-conformance
```

5. Watch the logs:
```sh
$ sonobuoy logs
```

6. Check the status:
```sh
$ sonobuoy status
```

7. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ outfile=$(sonobuoy retrieve)
```

8. This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```