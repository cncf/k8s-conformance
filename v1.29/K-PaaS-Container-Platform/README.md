# K-PaaS Container Platform v1.5

## Install NFS Server

Install NFS Server according to the [documentation](https://github.com/K-PaaS/container-platform/blob/master/install-guide/nfs-server-install-guide.md).

​
1. Install packages for NFS server
```
$ sudo apt-get install -y nfs-common nfs-kernel-server portmap
```
​
2. Creating and authorizing directories to be used by NFS
```
$ sudo mkdir -p /home/share/nfs
$ sudo chmod 777 /home/share/nfs
```
​
3. Set up a shared directory
```
$ sudo vi /etc/exports
```
​
```
...
/home/share/nfs *(rw,no_root_squash,async)
​
```
​
4. Restart the nfs server
```
$ sudo /etc/init.d/nfs-kernel-server restart
$ sudo systemctl restart portmap
```
​


## Install K-PaaS Container Platform Cluster

Install K-PaaS Container Platform according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.5.x/install-guide/standalone/cp-cluster-install-single.md).
​

1. Generate RSA public key in Master Node
```
$ ssh-keygen -t rsa -m PEM -N '' -f $HOME/.ssh/id_rsa
```
​
2. Copy the public key to the master and worker nodes to be used
```
$ cat ~/.ssh/id_rsa.pub
```
​
3. Copy the public key to the last part of the body of the authorized_keys file of the master and worker nodes to be used
```
$ vi .ssh/authorized_keys
```
​
4. Download K-PaaS Container Platform Deployment
```
$ git clone https://github.com/K-PaaS/cp-deployment.git
```
​
5. Setting environment variables
```
$ cd cp-deployment/single

$ vi cp-cluster-vars.sh
```
​
```
#!/bin/bash

# Master Node Count Variable (eg. 1, 3, 5 ...)
export KUBE_CONTROL_HOSTS=

# if KUBE_CONTROL_HOSTS > 1 (eg. external, stacked)
export ETCD_TYPE=

# if KUBE_CONTROL_HOSTS > 1
# HA Control Plane LoadBalanncer IP or Domain
export LOADBALANCER_DOMAIN=

# if ETCD_TYPE=external
# The number of ETCD node variable is set equal to the number of KUBE_CONTROL_HOSTS
export ETCD1_NODE_HOSTNAME=
export ETCD1_NODE_PRIVATE_IP=
export ETCD2_NODE_HOSTNAME=
export ETCD2_NODE_PRIVATE_IP=
export ETCD3_NODE_HOSTNAME=
export ETCD3_NODE_PRIVATE_IP=

# Master Node Info Variable
# The number of MASTER node variable is set equal to the number of KUBE_CONTROL_HOSTS
export MASTER1_NODE_HOSTNAME=
export MASTER1_NODE_PUBLIC_IP=
export MASTER1_NODE_PRIVATE_IP=
export MASTER2_NODE_HOSTNAME=
export MASTER2_NODE_PRIVATE_IP=
export MASTER3_NODE_HOSTNAME=
export MASTER3_NODE_PRIVATE_IP=

# Worker Node Count Variable
export KUBE_WORKER_HOSTS=

# Worker Node Info Variable
# The number of Worker node variable is set equal to the number of KUBE_WORKER_HOSTS
export WORKER1_NODE_HOSTNAME=
export WORKER1_NODE_PRIVATE_IP=
export WORKER2_NODE_HOSTNAME=
export WORKER2_NODE_PRIVATE_IP=
export WORKER3_NODE_HOSTNAME=
export WORKER3_NODE_PRIVATE_IP=

# Storage Variable (eg. nfs, rook-ceph)
export STORAGE_TYPE=

# if STORATE_TYPE=nfs
export NFS_SERVER_PRIVATE_IP=

# MetalLB Variable (eg. 192.168.0.150-192.168.0.160)
export METALLB_IP_RANGE=

# MetalLB Ingress Nginx Controller LoadBalancer Service External IP
export INGRESS_NGINX_PRIVATE_IP=
```
​
6. Install K-PaaS Container Platform Cluster
```
$ source deploy-cp-cluster.sh
```
​

​
## Install K-PaaS Container Platform Portal

Install K-PaaS Container Platform Portal according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.5.x/install-guide/portal/cp-portal-standalone-guide.md).
​
1. Download the K-PaaS Container Platform Portal Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.k-paas.org/index.php/s/2LeyyQTaCySmKzH/download
$ tar -xvf cp-portal-deployment-v1.5.2.tar.gz
```
​
2. Defining K-PaaS Container Platform Portal Variables
```
$ cd ~/workspace/container-platform/cp-portal-deployment/script
$ vi cp-portal-vars.sh
```
​
```
# COMMON VARIABLE (Please change the value of the variables below.)
K8S_MASTER_NODE_IP="{k8s master node public ip}"                  # Kubernetes Master Node Public IP
K8S_CLUSTER_API_SERVER="https://${K8S_MASTER_NODE_IP}:6443"       # kubernetes API Server (e.g. https://${K8S_MASTER_NODE_IP}:6443)
K8S_STORAGECLASS="cp-storageclass"                                # Kubernetes StorageClass Name (e.g. cp-storageclass)
HOST_CLUSTER_IAAS_TYPE="1"                                        # Kubernetes Cluster IaaS Type ([1] AWS, [2] OPENSTACK, [3] NAVER, [4] NHN, [5] KT)
HOST_DOMAIN="{host domain}"                                       # Host Domain (e.g. xx.xxx.xxx.xx.nip.io)
....
```
​
3. Run the K-PaaS Container Platform Portal Deployment script
```
$ chmod +x deploy-cp-portal.sh
$ ./deploy-cp-portal.sh
```


## Install K-PaaS Container Platform Pipeline
​
Install K-PaaS Container Platform Pipeline according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.5.x/install-guide/pipeline/cp-pipeline-standalone-guide.md).


1. Download the K-PaaS Container Platform Pipeline Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.k-paas.org/index.php/s/2RA8xkXfFKT2L8c/download
$ tar -xvf cp-pipeline-deployment-v1.5.2.tar.gz
```
​
2. Defining K-PaaS Container Platform Pipeline Variables
```
$ cd ~/workspace/container-platform/cp-pipeline-deployment/script
$ vi cp-pipeline-vars.sh
```
​
```
# COMMON VARIABLE (Please change the value of the variables below.)
HOST_DOMAIN="{host domain}"                    # Host Domain (e.g. xx.xxx.xxx.xx.nip.io)
K8S_STORAGECLASS="cp-storageclass"             # Kubernetes StorageClass Name (e.g. cp-storageclass)
IS_MULTI_CLUSTER="N"                           # Please enter "Y" if deploy in a multi-cluster environment
....
```
​
3. Run the K-PaaS Container Platform Pipeline Deployment script
```
$ chmod +x deploy-cp-pipeline.sh
$ ./deploy-cp-pipeline.sh
```
​

## Install K-PaaS Container Platform SourceControl
​
Install K-PaaS Container Platform SourceControl according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.5.x/install-guide/source-control/cp-source-control-standalone-guide.md).

1. Download the K-PaaS Container Platform SourceControl Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.k-paas.org/index.php/s/gQ5dd4XadmP43MG/download
$ tar -xvf cp-source-control-deployment-v1.5.2.tar.gz
```
​
2. Defining K-PaaS Container Platform SourceControl Variables
```
$ cd ~/workspace/container-platform/cp-source-control-deployment/script
$ vi cp-source-control-vars.sh
```
​
```
# COMMON VARIABLE (Please change the value of the variables below.)
HOST_DOMAIN="{host domain}"                    # Host Domain (e.g. xx.xxx.xxx.xx.nip.io)
K8S_STORAGECLASS="cp-storageclass"             # Kubernetes StorageClass Name (e.g. cp-storageclass)
IS_MULTI_CLUSTER="N"                           # Please enter "Y" if deploy in a multi-cluster environment
....
```
​
3. Run the K-PaaS Container Platform SourceControl Deployment script
```
$ chmod +x deploy-cp-source-control.sh
$ ./deploy-cp-source-control.sh
```
​
## Run conformance tests
​
```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.2/sonobuoy_0.57.2_linux_amd64.tar.gz
​
$ tar zxvf sonobuoy_0.57.2_linux_amd64.tar.gz
​
$ sudo cp sonobuoy /usr/bin/sonobuoy
​
$ sonobuoy run --mode=certified-conformance
​
$ sonobuoy status
​
$ sonobuoy retrieve
```
