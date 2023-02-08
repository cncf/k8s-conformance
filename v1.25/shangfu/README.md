## CNAPP

## Introduce

NOTE: These steps are a reproduction of our product at https://www.moresec.cn/product/cnpp

## Requirements

os: Ubuntu 20.04 LTS

3 machines

set hostname and /etc/hosts

Ksp、ksp2、ksp3

4C 8G

## Installation

**how to install kubernetes**

**requirements**

1、Close swap in each machine

```shell
$ sudo swapoff -a
```

2、Install containerd

Follow these steps to install containerd for each machine.

```shell
$ sudo apt-get update
$ sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add GPG
$ sudo mkdir -p /etc/apt/keyrings
$ curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set apt registry
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 
# Install containerd
$ sudo apt-get install -y containerd.io
$ sudo apt-mark hold containerd.io

# Set cir and systemd
$ containerd config default | sudo tee /etc/containerd/config.toml
```

Edit /etc/containerd/config.toml and modify it according to this:

```yaml
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.7"
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
    ...
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = true
```

Restart containerd.

```shell
$ sudo systemctl restart containerd.service
$ sudo systemctl enable containerd.service
```

3、Install kubeadm

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
$ sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg

#
$ echo \
  "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://mirrors.aliyun.com/kubernetes/apt/ \
  kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  
# install kubelet、kubeadm and kubectl.
$ sudo apt-get update
$ sudo apt-get install -y kubelet kubeadm kubectl
$ sudo apt-mark hold kubelet kubeadm kubectl
```

4、Install Kubernetes

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

5、Install flannel.

Download latest flannel and ensure that `/opt/bin/flanneld` is exist in each node. You can download at https://github.com/flannel-io/flannel/releases

And then, apply it.

```shell
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

**how to install Harbor**

NODE: You can install harbor in `kube-node2`.

Download latest harbor-offline-installer-v2.6.0.tgz at https://github.com/goharbor/harbor/releases.

```shell
mkdir /opt/harbor
tar -xzf harbor-online-installer-v2.6.0.tgz -C /opt/harbor

# cd /opt/harbor
cp harbor.yml.tmpl harbor.yml
./prepare
./install.sh 
```

You should comment `https` in harbor.yml, eg.

```yaml
# Configuration file of Harbor

# The IP address or hostname to access admin UI and registry service.
# DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
hostname: <kube-node2-ip>

# http related config
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 80

# https related config
#https:
#  # https port for harbor, default is 443
#  port: 443
#  # The path of cert and key files for nginx
#  certificate: /your/certificate/path
#  private_key: /your/private/key/path
```

Then you can visit `http://<kube-node2-ip>`, and there's a default `library`. 

**how to config private registry in containerd**

We configure the default endpoints:

```shell
$ crictl config runtime-endpoint unix:///run/containerd/containerd.sock
$ crictl config image-endpoint unix:///run/containerd/containerd.sock
```

Edit /etc/containerd/config.toml:

```yaml
[plugins]
...
  [plugins."io.containerd.grpc.v1.cri"]
  ...
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."<kube-node2-ip>"]
          endpoint = ["http://<kube-node2-ip>"]
      [plugins."io.containerd.grpc.v1.cri".registry.configs]
        [plugins."io.containerd.grpc.v1.cri".registry.configs."<kube-node2-ip>".tls]
          insecure_skip_verify = true
        [plugins."io.containerd.grpc.v1.cri".registry.configs."<kube-node2-ip>".auth]
          username = "admin"
          password = "Harbor12345"

```

**how to install CNAPP**

If you want to install CNAPP products, you can contact us to get the installation package. During installation, we will push the image to the mirror repository and then use heml to install it.

## Installation

Run sonobuoy v0.56.8: `sonobuoy run --mode=certified-conformance --kubernetes-version=v1.25.0`


