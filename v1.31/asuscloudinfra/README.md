# Conformance tests for the asuscloud-infra

## Cluster Component  Version Info:

| Name       | Version     |
|------------|-------------|
| kubeadm    | v1\.31\.1   |
| kubelet    | v1\.31\.1   |
| kubectl    | v1\.31\.1   |
| etcd       | 3\.5\.9\-0  |
| Calico     | v3\.23\.1   |
| containerd | 1\.6\.22    |
| Haproxy    | 2\.3        |
| Keepalived | 2\.0\.20    |

## Demo Server Info:

This guide uses the following number of nodes for deployment, and the operating system uses Ubuntu 20.04 LTS for testing:

<span style="color:red">Please modify it according to the actual application.</span>

| Hostname      |  IP Address     | Role   | OS          |
|---------------|-----------------|--------|-------------|
| k8s\-node\-master01 | master01_IP Address | Master | Ubuntu 20\.04 |
| k8s\-node\-master02 | master02_IP Address | Master | Ubuntu 20\.04 |
| k8s\-node\-master03 | master03_IP Address | Master | Ubuntu 20\.04 |
| k8s\-node\-worker01 | worker01 Address | Node   | Ubuntu 20\.04 |

In addition, all Master nodes will provide a <span style="color:red">API Virtual IP x.x.x.x </span>
 through Keepalived for use.

## Before you begin
### System requirements

* Ubuntu 20.04 LTS
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
    $ sed '/swap/d' -i /etc/fstab
    ```

* At least 3 machines that meet [kubeadm’s minimum requirements](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin)

* Install containerd according to the [official containerd Document](https://github.com/containerd/containerd/blob/main/docs/getting-started.md#installing-containerd)

## Install Highly-Available Kubernetes Cluster

### Set up Kubernetes Master

This section will explain how to deploy and configure the components in the Kubernetes Master node.

#### 1. Installing kubeadm, kubelet and kubectl

Before starting to deploy master node components, please install kubeadm, kubelet , kubectl and create / etc / kubernetes / manifests / directory to store YAML files of Static Pod.

```sh
# Update the apt package index and install packages needed to use the Kubernetes apt repository:
$ sudo apt-get update 
$ sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Download the Kubernetes public signing key:
$ curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg

# Add the Kubernetes apt repository:
$ echo 'deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

$ sudo apt-get update
$ sudo apt-get install kubelet=1.31.1-1.1 kubeadm-1.31.1-1.1 kubectl-1.31.1-1.1
$ sudo apt-mark hold kubelet kubeadm kubectl

$ mkdir -p /etc/kubernetes/manifests/
```

#### 2. Set up HAProxy
This section will explain how to set up HAProxy to provide load balancing of Kubernetes API Server. 
Create haproxy  directories on all master nodes:

```sh
$ mkdir -p /etc/haproxy/
```

Then add /etc/haproxy/haproxy.cfg configuration file to all master servers, and add the following content:

<span style="color:red">Please modify it according to the actual application.</span>

```sh
$ cat <<EOF > /etc/haproxy/haproxy.cfg
global
  log 127.0.0.1 local0
  log 127.0.0.1 local1 notice
  tune.ssl.default-dh-param 2048

defaults
  log global
  mode http
  option dontlognull
  timeout connect 5000ms
  timeout client 600000ms
  timeout server 600000ms

listen stats
    bind :8090
    mode http
    balance
    stats uri /haproxy_stats
    stats auth admin:admin123
    stats admin if TRUE

frontend kube-apiserver-https
   mode tcp
   bind :8443
   default_backend kube-apiserver-backend

backend kube-apiserver-backend
    mode tcp
    balance roundrobin
    stick-table type ip size 200k expire 30m
    stick on src
    server apiserver1 master01_IP Address:6443  check
    server apiserver2 master02_IP Address:6443  check
    server apiserver3 master03_IP Address:6443  check
EOF
```

<span style="color:red">8443 will be bound here as a proxy for API Server.</span>

Then add a YAML file to provide HAProxy's Static Pod deployment. The contents are as follows:

```sh
$ cat <<EOF > /etc/kubernetes/manifests/haproxy.yaml
kind: Pod
apiVersion: v1
metadata:
  annotations:
    scheduler.alpha.kubernetes.io/critical-pod: ""
  labels:
    component: haproxy
    tier: control-plane
  name: kube-haproxy
  namespace: kube-system
spec:
  hostNetwork: true
  priorityClassName: system-cluster-critical
  containers:
  - name: kube-haproxy
    image: docker.io/haproxy:2.3.2-alpine
    resources:
      requests:
        cpu: 100m
    volumeMounts:
    - name: haproxy-cfg
      readOnly: true
      mountPath: /usr/local/etc/haproxy/haproxy.cfg
  volumes:
  - name: haproxy-cfg
    hostPath:
      path: /etc/haproxy/haproxy.cfg
      type: FileOrCreate
EOF
```

#### 3. Set up Keepalived

This section will explain how to establish Keepalived to provide VIP for Kubernetes API Server. Add a keepalived.yaml to all the master servers to provide HAProxy's Static Pod deployment. The contents are as follows:

<span style="color:red">Please modify it according to the actual application.</span>

```sh
$ cat <<EOF > /etc/kubernetes/manifests/keepalived.yaml
kind: Pod
apiVersion: v1
metadata:
  annotations:
    scheduler.alpha.kubernetes.io/critical-pod: ""
  labels:
    component: keepalived
    tier: control-plane
  name: kube-keepalived
  namespace: kube-system
spec:
  hostNetwork: true
  priorityClassName: system-cluster-critical
  containers:
  - name: kube-keepalived
    image: docker.io/osixia/keepalived:2.0.20
    env:
    - name: KEEPALIVED_VIRTUAL_IPS
      value: x.x.x.x
    - name: KEEPALIVED_INTERFACE
      value: enp3s0
    - name: KEEPALIVED_UNICAST_PEERS
      value: "#PYTHON2BASH:['master01_IP Address:6443', 'master02_IP Address:6443', 'master03_IP Address:6443']"
    - name: KEEPALIVED_PASSWORD
      value: d0cker
    - name: KEEPALIVED_PRIORITY
      value: "150"
    - name: KEEPALIVED_ROUTER_ID
      value: "51"
    resources:
      requests:
        cpu: 100m
    securityContext:
      privileged: true
      capabilities:
        add:
        - NET_ADMIN
EOF
```

* KEEPALIVED_VIRTUAL_IPS:  VIPs provided by Keepalived.
* KEEPALIVED_INTERFACE: The network interface bound by VIPs.
* KEEPALIVED_UNICAST_PEERS: unicast IP of other Keepalived nodes.
* KEEPALIVED_PRIORITY: Specifies the order of interfaces to take over when backup occurs. The smaller the number, the higher the priority. <span style="color:red">Here k8s-node-master01 is set to 150,  k8s-node-master02 is 120  and the k8s-node-master03 is 150.</span>

#### 4. First control plane node

First create Kubeadm Init Configuration in <span style="color:red">k8s-node-master01</span>

<span style="color:red">Please modify it according to the actual application.</span>

```sh
$ cat <<EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 10.78.26.140
  bindPort: 6443
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
apiServer:
  extraArgs:
    authorization-mode: Node,RBAC
controlPlaneEndpoint: 10.78.26.155:8443
imageRepository: registry.k8s.io
kubernetesVersion: v1.31.1
networking:
  dnsDomain: cluster.local
  podSubnet: 10.245.0.0/16
  serviceSubnet: 10.255.0.0/24
EOF
````
<span style="color:red">controlPlaneEndpoint :VIPs and bind port. </span>


Initialize the control plane through kubeadm:

```sh
$ kubeadm init --config=kubeadm-config.yaml --upload-certs

…
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join x.x.x.x:8443 --token <token> \
    --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash> \
    --control-plane --certificate-key <certificate-key>

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join x.x.x.x:8443 --token <token> \
    --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash>
```

To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:

```sh
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Check the status of the Kubernetes cluster through kubectl:

```sh
$ kubectl get node

NAME          STATUS    ROLES    AGE   VERSION
k8s-node-master01   NotReady   master   32s   v1.31.1
```

#### 5. Installing a Pod network add-on (Calico)

```sh
$ wget https://docs.projectcalico.org/v3.23/manifests/calico.yaml
$ sed -i 's/192.168.0.0\/16/10.244.0.0\/16/g' calico.yaml
$ kubectl apply -f calico.yaml
```

#### 6. Other control plane nodes

In the kubeadm v1.16 version, a mechanism for automatically configuring HA is provided, so only the following instructions need to be executed on other master nodes:

<span style="color:red">Please modify it according to the actual application.</span>

```sh
$ kubeadm join x.x.x.x:8443 --token <token> \
  --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash> \
  --control-plane \
  --certificate-key  <certificate-key> \
  --ignore-preflight-errors DirAvailable--etc-kubernetes-manifests
```

After a period of time is complete, execute the following command to use kubeconfig:

```sh
$ mkdir -p $HOME/.kube
$ cp -rp /etc/kubernetes/admin.conf $HOME/.kube/config
$ chown $(id -u):$(id -g) $HOME/.kube/config
```

Check the status of the Kubernetes cluster through kubectl:

```sh
$ kubectl get node

NAME         STATUS   ROLES    AGE   VERSION
k8s-node-master01   Ready    master   10m   v1.31.1
k8s-node-master02   Ready    master   3m    v1.31.1
k8s-node-master03   Ready    master   74s   v1.31.1
```
#### 7. Set up Kubernetes Nodes

This section will explain how to deploy and configure Kubernetes Node. Before starting to deploy node components, please install kubeadm, kubelet and kubectl:

```sh
# Update the apt package index and install packages needed to use the Kubernetes apt repository:

$ sudo apt-get update $ sudo apt-get install -y apt-transport-https ca-certificates curl 

# Download the Kubernetes public signing key: 

$ curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg

# Add the Kubernetes apt repository: 

$ echo 'deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
$ sudo apt-get install kubelet=1.31.1-1.1 kubeadm-1.31.1-1.1 kubectl-1.31.1-1.1
$ sudo apt-mark hold kubelet kubeadm kubectl $ mkdir -p /etc/kubernetes/manifests/
```

After installation, add kubeadm to all node nodes:

<span style="color:red">Please modify it according to the actual application.</span>

```sh
$ kubeadm join x.x.x.x:8443 \
    --token <token> \
    --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash>

...
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

#### 8. Test High Availability

##### Check HA Kubernetes Cluster

```sh
$ kubectl get node

NAME           STATUS   ROLES    AGE     VERSION
k8s-node-master01     Ready    master   92s     v1.31.1
k8s-node-master02     Ready    master   3m33s   v1.31.1
k8s-node-master03     Ready    master   20m     v1.31.1
k8s-worker01   Ready    <none>   13m     v1.31.1
```

##### Test High Availability

Enter the k8s-node-master01 to test the cluster HA function, here first shut down the node:

```sh
$ sudo poweroff
```

Then go to the k8s-node-master02  and check whether the cluster can run normally through kubectl:

```sh
$ kubectl get no
NAME           STATUS   ROLES    AGE     VERSION
k8s-node-master01     NotReady master   92s     v1.31.1
k8s-node-master02     Ready    master   3m33s   v1.31.1
k8s-node-master03     Ready    master   20m     v1.31.1
k8s-worker01   Ready    <none>   13m     v1.31.1

# Test whether Pod can be created
$ kubectl run nginx --image nginx --restart=Never --port 80

$ kubectl expose pod nginx --port 80 --type NodePort

$ kubectl get po,svc
NAME        READY   STATUS    RESTARTS   AGE
pod/nginx   1/1     Running   0          27s

NAME                 TYPE        CLUSTER-IP       PORT(S)        AGE
service/kubernetes   ClusterIP   10.96.0.1        43/TCP         56m
service/nginx        NodePort    10.106.25.118    80:30461/TCP   21s
```

Check whether the NGINX service is normal through URL:

<span style="color:red">Please modify it according to the actual application.</span>

```sh
$ curl x.x.x.x:30461
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```


## Run the conformance tests

Follow the official guide: https://github.com/revelrylabs/k8s-conformance/blob/master/instructions.md


1. Once you HA Kubernetes cluster is active, Login to any master nodes.

2. Download a sonobuoy [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```sh
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

1. Configure your kubeconfig file by running:
```sh
$ export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

1. Run sonobuoy:
```sh
$ sonobuoy run --mode certified-conformance
```

1. Watch the logs:
```sh
$ sonobuoy logs
```

1. Check the status:
```sh
$ sonobuoy status
```

1. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ outfile=$(sonobuoy retrieve)
```

1. This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```sh
$ mkdir ./results
$ tar xzf $outfile -C ./results
```