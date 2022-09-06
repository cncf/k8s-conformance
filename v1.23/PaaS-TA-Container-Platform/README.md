# PaaS-TA Container Platform v1.3
​
## Install PaaS-TA Container Platform Cluster

Install PaaS-TA Container Platform according to the [documentation](https://github.com/PaaS-TA/paas-ta-container-platform/blob/master/install-guide/standalone/cp-cluster-install.md).
​

1. Generate RSA public key in Master Node
```
$ ssh-keygen -t rsa
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
4. Download PaaS-TA Container Platform Deployment
```
$ git clone https://github.com/PaaS-TA/paas-ta-container-platform-deployment.git
```
​
5. Setting environment variables
```
$ vi kubespray_var.sh
```
​
```
#!/bin/bash
​
export MASTER_NODE_HOSTNAME={Enter HostName information for the Master Node}
export MASTER_NODE_PUBLIC_IP={Enter Public IP information for the Master Node}
export MASTER_NODE_PRIVATE_IP={Enter Private IP information for the Master Node}
​
## Worker Node Count Info
export WORKER_NODE_CNT={Number of Worker Nodes}
​
## Add Worker Node Info
export WORKER1_NODE_HOSTNAME={Enter HostName information for the Worker Node 1}
export WORKER1_NODE_PRIVATE_IP={Enter Private IP information for the Worker Node 1}
export WORKER2_NODE_HOSTNAME={Enter HostName information for the Worker Node 2}
export WORKER2_NODE_PRIVATE_IP={Enter Private IP information for the Worker Node 2}
export WORKER3_NODE_HOSTNAME={Enter HostName information for the Worker Node 3}
export WORKER3_NODE_PRIVATE_IP={Enter Private IP information for the Worker Node 3}
...
```
​
6. Install PaaS-TA Container Platform Cluster
```
$ source deploy_kubespray.sh
```
​
## Install NFS Server

Install NFS Server according to the [documentation](https://github.com/PaaS-TA/paas-ta-container-platform/blob/master/install-guide/nfs-server-install-guide.md).

​
1. Install packages for NFS server
```
$ sudo apt-get install nfs-common nfs-kernel-server portmap
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
## Install PaaS-TA Container Platform Portal

Install PaaS-TA Container Platform Portal according to the [documentation](https://github.com/PaaS-TA/paas-ta-container-platform/blob/master/install-guide/container-platform-portal/paas-ta-container-platform-portal-deployment-standalone-guide.md).
​
1. Download the PaaS-TA Container Platform Portal Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.paas-ta.org/index.php/s/e7ZqzxP4ZFa6GDG/download
$ tar -xvf cp-portal-deployment-v1.3.tar.gz
```
​
2. Defining PaaS-TA Container Platform Portal Variables
```
$ cd ~/workspace/container-platform/cp-portal-deployment/script
$ vi cp-portal-vars.sh
```
​
```
# COMMON VARIABLE
K8S_MASTER_NODE_IP="{k8s master node public ip}"             # Kubernetes Master Node Public IP
K8S_AUTH_BEARER_TOKEN="{k8s auth bearer token}"              # Kubernetes Authorization Bearer Token
NFS_SERVER_IP="{nfs server ip}"                              # NFS Server IP
PROVIDER_TYPE="{container platform portal provider type}"    # Container Platform Portal Provider Type (Please enter 'standalone')
....
```
​
3. Run the PaaS-TA Container Platform Portal Deployment script
```
$ chmod +x deploy-cp-portal.sh
$ ./deploy-cp-portal.sh
```


## Install PaaS-TA Container Platform Pipeline
​
Install PaaS-TA Container Platform Pipeline according to the [documentation](https://github.com/PaaS-TA/paas-ta-container-platform/blob/master/install-guide/pipeline/paas-ta-container-platform-pipeline-standalone-guide.md).


1. Download the PaaS-TA Container Platform Pipeline Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.paas-ta.org/index.php/s/HM3Lej9Y9DPeDgz/download
$ tar xvfz cp-pipeline-deployment-v1.3.tar.gz
```
​
2. Defining PaaS-TA Container Platform Pipeline Variables
```
$ cd ~/workspace/container-platform/cp-pipeline-deployment/script
$ vi cp-pipeline-vars.sh
```
​
```
# COMMON VARIABLE
K8S_MASTER_NODE_IP="{k8s master node public ip}"                 # Kubernetes master node public ip
PROVIDER_TYPE="{container platform pipeline provider type}"        # Container platform pipeline provider type (Please enter 'standalone')
....
```
​
3. Run the PaaS-TA Container Platform Pipeline Deployment script
```
$ chmod +x deploy-cp-pipeline.sh
$ ./deploy-cp-pipeline.sh
```
​

## Install PaaS-TA Container Platform SourceControl
​
Install PaaS-TA Container Platform SourceControl according to the [documentation](https://github.com/PaaS-TA/paas-ta-container-platform/blob/master/install-guide/source-control/paas-ta-container-platform-source-control-standalone-guide.md).

1. Download the PaaS-TA Container Platform SourceControl Deployment
```
$ mkdir -p ~/workspace/container-platform
$ cd ~/workspace/container-platform
​
$ wget --content-disposition https://nextcloud.paas-ta.org/index.php/s/FSMcxmQ88kbBRHT/download
$ tar xvfz cp-source-control-deployment-v1.3.tar.gz
```
​
2. Defining PaaS-TA Container Platform SourceControl Variables
```
$ cd ~/workspace/container-platform/cp-source-control-deployment/script
$ vi cp-source-control-vars.sh
```
​
```
# COMMON VARIABLE
K8S_MASTER_NODE_IP="{k8s master node public ip}"                 # Kubernetes master node public ip
PROVIDER_TYPE="{container platform source control provider type}"        # Container platform source-control provider type (Please enter 'standalone')
....
```
​
3. Run the PaaS-TA Container Platform SourceControl Deployment script
```
$ chmod +x deploy-cp-source-control.sh
$ ./deploy-cp-source-control.sh
```
​
## Run conformance tests
​
```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.5/sonobuoy_0.56.5_linux_amd64.tar.gz
​
$ tar zxvf sonobuoy_0.56.5_linux_amd64.tar.gz
​
$ sudo cp sonobuoy /usr/bin/sonobuoy
​
$ sonobuoy run --mode=certified-conformance
​
$ sonobuoy status
​
$ sonobuoy retrieve
```