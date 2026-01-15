# K-PaaS Container Platform v1.7

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

Install K-PaaS Container Platform according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.6.x/install-guide/standalone/cp-cluster-install-single.md).
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

# --------------------------------------------------------------------
# Control Plane 노드 설정
# --------------------------------------------------------------------

# Control Plane (Master) 노드 개수 (예: 1, 3, 5 ...)
KUBE_CONTROL_HOSTS=

# Control Plane (Master) 노드 정보
# Control Plane 노드 개수에 맞춰 설정
MASTER1_NODE_HOSTNAME=
MASTER1_NODE_USER=ubuntu
MASTER1_NODE_PRIVATE_IP=
MASTER1_NODE_PUBLIC_IP=
MASTER2_NODE_HOSTNAME=
MASTER2_NODE_PRIVATE_IP=
MASTER3_NODE_HOSTNAME=
MASTER3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# LoadBalancer 설정
# --------------------------------------------------------------------

# Control Plane 노드가 2개 이상일 때 필수 설정
# 외부 로드밸런서 도메인 또는 IP
LOADBALANCER_DOMAIN=

# --------------------------------------------------------------------
# ETCD 노드 설정
# --------------------------------------------------------------------

# ETCD 구성 방식
# Control Plane 노드가 2개 이상일 때 필수 설정 (예: external, stacked)
# - external : 별도 ETCD 노드 구성
# - stacked : Control Plane 노드에 ETCD가 통합된 구성
ETCD_TYPE=

# ETCD_TYPE=external 일 때 필수 설정
# Control Plane 노드 수와 동일 개수로 설정
ETCD1_NODE_HOSTNAME=
ETCD1_NODE_PRIVATE_IP=
ETCD2_NODE_HOSTNAME=
ETCD2_NODE_PRIVATE_IP=
ETCD3_NODE_HOSTNAME=
ETCD3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# Worker 노드 설정
# --------------------------------------------------------------------

# Worker 노드 개수
KUBE_WORKER_HOSTS=

# Worker 노드 정보
# Worker 노드 개수에 맞춰 설정
WORKER1_NODE_HOSTNAME=
WORKER1_NODE_PRIVATE_IP=
WORKER2_NODE_HOSTNAME=
WORKER2_NODE_PRIVATE_IP=
WORKER3_NODE_HOSTNAME=
WORKER3_NODE_PRIVATE_IP=

# --------------------------------------------------------------------
# Storage 설정
# --------------------------------------------------------------------

# Storage 구성 방식 (예: nfs, rook-ceph)
STORAGE_TYPE=

# Storage 구성 방식 'nfs'일 때 NFS 서버 Private IP
NFS_SERVER_PRIVATE_IP=

# --------------------------------------------------------------------
# MetalLB 설정
# --------------------------------------------------------------------

# MetalLB Address Pool 범위 (예: 192.168.0.150-192.168.0.160)
METALLB_IP_RANGE=

# Ingress Nginx Controller LoadBalancer Service용 External IP
# - 인터페이스 추가 방식 : 인터페이스 Private IP 입력
# - LoadBalance 서비스 방식 : LoadBalance 서비스 Public IP 입력
INGRESS_NGINX_IP=

# --------------------------------------------------------------------
# Kyverno 설정
# --------------------------------------------------------------------

# Kyverno 설치 여부 (예: Y, N)
# - Y : 설치, PSS (Pod Security Standards) 및 cp-policy 정책 (네임스페이스간 네트워크 격리) 자동 적용
# - N : 설치하지 않음
INSTALL_KYVERNO=

# --------------------------------------------------------------------
# CSP LoadBalancer Controller 설정
# --------------------------------------------------------------------

# CSP 설정 (예: NHN, NAVER)
CSP_TYPE=

# NHN Cloud 환경 변수 (CSP_TYPE=NHN 일때 필수 입력)
NHN_USERNAME=
NHN_PASSWORD=
NHN_TENANT_ID=
NHN_VIP_SUBNET_ID=
NHN_API_BASE_URL=https://kr1-api-network-infrastructure.nhncloudservice.com

# NAVER Cloud 환경 변수 (CSP_TYPE=NAVER 일때 필수 입력)
NAVER_CLOUD_API_KEY=
NAVER_CLOUD_API_SECRET=
NAVER_CLOUD_REGION=KR
NAVER_CLOUD_VPC_NO=
NAVER_CLOUD_SUBNET_NO=
```

6. Install K-PaaS Container Platform Cluster
```
$ ./deploy-cp-cluster.sh
```
​

​
## Install K-PaaS Container Platform Portal

Install K-PaaS Container Platform Portal according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.7.x/install-guide/portal/cp-portal-standalone-guide.md).
​
1. Download the K-PaaS Container Platform Portal Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.k-paas.org/index.php/s/qrApL4sP5eC2WMX/download
$ tar -xvf cp-portal-deployment-v1.7.0.tar.gz
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
K8S_MASTER_NODE_IP="{k8s master node public ip}"                     # Kubernetes Master Node Public IP
K8S_CLUSTER_API_SERVER="https://${K8S_MASTER_NODE_IP}:6443"          # kubernetes API Server (e.g. https://${K8S_MASTER_NODE_IP}:6443)
K8S_STORAGECLASS="cp-storageclass"                                   # Kubernetes StorageClass Name (e.g. cp-storageclass)
HOST_CLUSTER_IAAS_TYPE="1"                                           # Kubernetes Cluster IaaS Type ([1] AWS, [2] OPENSTACK, [3] NAVER, [4] NHN, [5] KT)
HOST_DOMAIN="{host domain}"                                          # Host Domain (e.g. xx.xxx.xxx.xx.nip.io)
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
Install K-PaaS Container Platform Pipeline according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.7.x/install-guide/pipeline/cp-pipeline-standalone-guide.md).


1. Download the K-PaaS Container Platform Pipeline Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.k-paas.org/index.php/s/D7fz23QcDrT4Afs/download
$ tar -xvf cp-pipeline-deployment-v1.6.2.tar.gz
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
Install K-PaaS Container Platform SourceControl according to the [documentation](https://github.com/K-PaaS/container-platform/blob/branch/1.7.x/install-guide/source-control/cp-source-control-standalone-guide.md).

1. Download the K-PaaS Container Platform SourceControl Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.k-paas.org/index.php/s/TewcbsNdm2EQmtX/download
$ tar -xvf cp-source-control-deployment-v1.6.2.tar.gz
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
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
​
$ tar zxvf sonobuoy_0.57.3_linux_amd64.tar.gz
​
$ sudo cp sonobuoy /usr/bin/sonobuoy
​
$ sonobuoy run --mode=certified-conformance
​
$ sonobuoy status
​
$ sonobuoy retrieve
```