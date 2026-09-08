# How to reproduce

## Setup server

| Hostname | IP Address | Role | OS |
| -------- | ---------- | ---- | --- |
| ubuntu-sv16 | <MASTER_IP> | control-plane | Ubuntu 22.04.5 LTS |
| ubuntu-sv18 | <WORKER_IP> | worker | Ubuntu 22.04.5 LTS |

## Prepare all nodes

Run on all nodes (master + workers):

```sh
# Disable swap
swapoff -a
sed -i.bak '/\sswap\s/s/^/#/' /etc/fstab

# Load required kernel modules
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay && modprobe br_netfilter

# Sysctl settings
cat <<EOF | tee /etc/sysctl.d/99-kubernetes.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

# Additional fs.inotify settings
cat <<EOF | tee /etc/sysctl.d/99-k8s-fsnotify.conf
fs.inotify.max_user_watches=1048576
fs.inotify.max_user_instances=1024
fs.inotify.max_queued_events=16384
fs.file-max=2097152
EOF

sysctl --system
```

## Install containerd

Run on all nodes:

```sh
apt update && apt install -y ca-certificates curl gnupg lsb-release
apt install -y containerd
mkdir -p /etc/containerd && containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd && systemctl enable containerd
```

## Install Kubernetes v1.35.3

Run on all nodes:

```sh
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

apt update
apt install -y kubeadm=1.35.3-1.1 kubelet=1.35.3-1.1 kubectl=1.35.3-1.1
apt-mark hold kubelet kubeadm kubectl
```

## Initialize cluster

Run on control plane node only:

```sh
kubeadm init \
  --pod-network-cidr=10.0.0.0/8 \
  --apiserver-advertise-address=<MASTER_IP> \
  --kubernetes-version=v1.35.3

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
```

## Install CNI (Cilium v1.19.1)

```sh
helm repo add cilium https://helm.cilium.io/
helm repo update
helm install cilium cilium/cilium --version 1.19.1 \
  --namespace kube-system \
  --set ipam.mode=cluster-pool \
  --set ipam.operator.clusterPoolIPv4PodCIDRList="10.0.0.0/8" \
  --set ipam.operator.clusterPoolIPv4MaskSize=24 \
  --set tunnelProtocol=vxlan \
  --set routingMode=tunnel
```

## Join worker nodes

On control plane, generate join command:

```sh
kubeadm token create --print-join-command
```

Run the output command on worker node.

## Verify cluster

```sh
kubectl get nodes -o wide
kubectl get pods -A
```

## Run conformance tests

Follow the official guide: https://github.com/cncf/k8s-conformance/blob/master/instructions.md

1. Download sonobuoy:
```sh
go get -u -v github.com/vmware-tanzu/sonobuoy
```

2. Configure kubeconfig:
```sh
export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

3. Run sonobuoy:
```sh
sonobuoy run --mode certified-conformance
```

4. Watch logs:
```sh
sonobuoy logs
```

5. Check status:
```sh
sonobuoy status
```

6. Retrieve results:
```sh
outfile=$(sonobuoy retrieve)
mkdir ./results
tar xzf $outfile -C ./results
```

## Cluster Summary

| Component | Version |
|-----------|---------|
| Kubernetes | v1.35.3 |
| CNI | Cilium v1.19.1 (VXLAN tunnel mode) |
| Container Runtime | containerd (2.2.2 / 1.7.28) |
| Pod CIDR | 10.0.0.0/8 (cluster-pool IPAM, /24 per node) |
| Service CIDR | 10.96.0.0/16 |
| cgroup driver | systemd |

## Sonobuoy Results

```
PLUGIN        STATUS     RESULT   COUNT
e2e           complete   passed   1
systemd-logs  complete   passed   2
```
