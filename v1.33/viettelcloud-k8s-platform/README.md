# How to reproduce

## Setup server

| Hostname | IP Address | Role | OS  |
| -------- | ---------- | ---- | --- |
| master1 | master1_IP | Master | Ubuntu 24.04 |
| worker1 | worker1_IP | Master | Ubuntu 24.04 |
| worker2 | worker2_IP | Master | Ubuntu 24.04 |

## Prepare all nodes

Running on each nodes (master + workers)

```sh
# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Load required kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Sysctl settings
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# Install dependencies
sudo apt-get update && sudo apt-get install -y \
  python3 python3-pip git curl apt-transport-https ca-certificates
```

## Deploy cluster

Setup Kubespray v2.29.1 on bastion host:

```sh
# Clone Kubespray
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git checkout v2.29.1

# Install Python dependencies (use a virtualenv)
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Copy the sample inventory
cp -rfp inventory/sample inventory/cluster-x
```

Edit `inventory/cluster-x/inventory.ini` file to define roles:

```ini
[kube_control_plane]
master1 ansible_host=master1_ip etcd_member_name=etcd1

[etcd:children]
kube_control_plane

[kube_node]
worker1 ansible_host=worker1_ip
worker2 ansible_host=worker2_ip
```

We use Calico v3.30.3 as primary CNI, following files:

```yaml
# file inventory/cluster-x/group_vars/k8s_cluster/k8s-cluster.yml
kube_network_plugin: calico
kube_pods_subnet: 192.168.0.0/16
kube_service_addresses: 10.96.0.0/16
kube_version: v1.33.0
container_manager: containerd
```

If your cluster required HA control-plane, you need to pre-config a Load Balancer or simply use HAProxy for cluster load balancing. Then config Load Balancer IP/Domain in file `inventory/cluster-x/group_vars/all/all.yml`

```yaml
apiserver_loadbalancer_domain_name: "my-apiserver-lb.example.com"
loadbalancer_apiserver:
  address: <VIP>
  port: 6443
```

We use local-path-provisioner for CSI, but we'll deploy it after cluster creation. Keep this option being false:

```yaml
local_volume_provisioner_enabled: false
```

Now, from bastion host run kubespray:

```sh
ansible-playbook -i inventory/cluster-x/hosts.yaml \
  --become --become-user=root \
  -u <your_ssh_user> \
  --private-key ~/.ssh/id_rsa \
  cluster.yml
```

This might take around 15-25 minutes. After deploy success, install CSI:

```sh
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

Now you should verify every thing are good and sucess deployed.

## Run the conformance tests

Follow the official guide: https://github.com/revelrylabs/k8s-conformance/blob/master/instructions.md

1. Download a sonobuoy [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```sh
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

2. Configure your kubeconfig file by running:
```sh
$ export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

3. Run sonobuoy:
```sh
$ sonobuoy run --mode certified-conformance
```

4. Watch the logs:
```sh
$ sonobuoy logs
```

5. Check the status:
```sh
$ sonobuoy status
```

6. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ outfile=$(sonobuoy retrieve)
```

7. This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```sh
$ mkdir ./results
$ tar xzf $outfile -C ./results
```
