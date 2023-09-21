## CNAPP

## Introduce

NOTE: These steps are a reproduction of our product at https://www.moresec.cn/product/cnpp

## Requirements

os: Ubuntu 22.04 LTS

It should be noted here that e2e requires two nodes that can deploy POD.

If your master node can deploy pod, you only need to add another machine.

3 machines

set hostname and /etc/hosts

ksp-master, ksp-work01, ksp-work02

4C 8G

## Installation

**how to install kubernetes (kubeadm + containerd)**

**requirements**

### 1. Turn off the swap partition for each machine

```shell
$ sudo swapoff -a
```

### 2. Install containerd

Follow these steps to install containerd for each machine.

You can download [containerd](https://github.com/containerd/containerd) here. Download with cri-containerd-cni field.

```shell
# Ensure containerd is in your working directory
$ sudo tar xf cri-containerd-cni-[you version]-linux-amd64.tar.gz -C /

# Self start upon startup
$ sudo systemctl enable --now containerd

# We need to first generate the containerd default configuration file
$ sudo mkdir -p /etc/containerd
$ sudo containerd config default > /etc/containerd/config.toml
```

Edit /etc/containerd/config.toml and modify it according to this:

```yaml
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.9"
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
    ...
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = true
```

The following content needs to be fully commented out by you, otherwise your network plugin will not function properly. (They're together)

```yaml
 [plugins."io.containerd.grpc.v1.cri".cni]
    bin_dir = "/opt/cni/bin"
    conf_dir = "/etc/cni/net.d"
    conf_template = ""
    ip_pref = ""
    max_conf_num = 1
    setup_serially = false
```

Restart containerd.

```shell
$ sudo systemctl restart containerd.service
```

### 3. Install kubeadm

Follow these steps to install kubeadm for each machine.

```shell
#
$ cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
$ sudo modprobe overlay
$ sudo modprobe br_netfilter
$ cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
$ sudo sysctl --system

#
$ sudo apt-get update
$ sudo apt-get install -y apt-transport-https ca-certificates curl

#
$ sudo curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

#
$ sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

# install kubelet、kubeadm and kubectl.
$ sudo apt-get update
$ sudo apt-get install -y kubelet kubeadm kubectl
# Disable automatic updates
$ sudo apt-mark hold kubelet kubeadm kubectl
```

### 4. Install Kubernetes

Before that, you need to configure kubelet first.

```shell
$ sudo vim /lib/systemd/system/kubelet.service
```

You need to add the line 'Environment', otherwise init will fail (kubelet not running).

```s
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --cgroup-driver=cgroupfs"
ExecStart=/usr/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10
```

Run kubeadm in kube-master.

```shell
# NODE: Your need set <control-plane-host-or-ip>
$ sudo kubeadm init \
  --control-plane-endpoint=<control-plane-host-or-ip> \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket=unix:/run/containerd/containerd.sock
  --image-repository=registry.aliyuncs.com/google_containers

#
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

```

Run following command in kube-node1 and kube-node2 to join control-plane.

```shell
# You can find this command above.
sudo kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash> --cri-socket=unix:/run/containerd/containerd.sock
```

If it's succeed, the output would be this:

```shell
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

### 5. Install flannel.

Download latest flannel and ensure that `/opt/bin/flanneld` is exist in each node. You can download at https://github.com/flannel-io/flannel/releases

And then, apply it.

```shell
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

You may need to modify the image warehouse source. Please review and modify it yourself

**how to install CNAPP**

If you want to install CNAPP products, you can contact us to get the installation package. During installation, we will push the image to the mirror repository and then use heml to install it.

## RUN sonobuoy

You can download [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases) here. Add it to your environment variable. Remember to decompress.

You need to download the yaml file for [e2e](https://github.com/vmware-tanzu/sonobuoy-plugins/blob/main/e2e/e2e.yaml).

You only need to modify the following fields:

```yaml
image: k8s.gcr.io/conformance:$SONOBUOY_K8S_VERSION
===================================================
image: registry.k8s.io/conformance:v1.28.1
```

Run using the following command

```bash
sudo sonobuoy run --mode=certified-conformance
```

View running status

```bash
sudo sonobuoy status
# You can use the following command to listen for status
sudo watch sonobuoy status
```

Use the following command to export the run results, where you can view the runtime errors. It will export a compressed file.

```bash
sudo sonobuoy result
```

You can decompress him to see the detailed information.
