# VIOLA - [ START GUIDE ]
<br>

## **This guide is based on a closed network**
#### CLOUD_DEV3 _ OKESTRO
#
<br>

## **GUIDE INFO**

```
K8S CLUSTER INFO  :  1.29.7
ANSIBLE VERSION   :  2.16.10
NEXUS VERSION     :  3.63.0-01
SYSETM OS         :  Ubuntu 22.04
```
#
<br>

## **Upload Repo To Nexus(Docker Proxy)**
- **cluster docker images list**
    - cilium/cilium:v1.15.4
    - cilium/operator:v1.15.4
    - coredns/coredns:v1.11.1
    - cpa/cluster-proportional-autoscaler:v1.8.8
    - kube-apiserver:v1.29.7
    - kube-controller-manager:v1.29.7
    - kube-proxy:v1.29.7
    - kube-scheduler:v1.29.7
    - nginx 1.25.2-alpine
    - pause:3.9
    - sig-storage/csi-attacher:v4.6.1
    - sig-storage/csi-node-driver-registrar:v2.11.1
    - sig-storage/csi-provisioner:v5.0.1
    - sig-storage/csi-resizer:v1.11.1
    - sig-storage/csi-snapshotter:v8.0.1
    - ceph/ceph:v18.2.4
    - cephcsi/cephcsi:v3.12.0
    - rook/ceph:v1.15.1
    - redis:latest
    - vault:1.14.1
    - istio/proxyv2:1.19.6
    - Istio/pilot:1.22.3
    - mariadb:latest
    - maxscale:2.5.28
    - busybox:1.28
    - kafka:0.36.1-kafka-3.5.1
    - keycloak:version-3.0.4
    - mariadb-keycloak:10.7
    - oauth2-proxy:v7.4.0
    - ingress-nginx/controller:v1.11.2
    - ingress-nginx/kube-webhook-certgen:v1.4.3
    - maestro/cloud-service-api:v1.0.0-0909
    - maestro/cloud-service-collector:v1.0.0-0909
    - maestro/maestro-auth-gateway:v1.0.0-0909
    - maestro/maestro-common-api:v1.0.0-0909
    - maestro/maestro-event-pusher:v1.0.0-0909
    - maestro/maestro-host-app:v1.0.0-0909
    - maestro/maestro-iam-adapter-api:v1.0.0-0909
    - maestro/maestro-remote-app:v1.0.0-0909
    - maestro/notification-adapter-api:v1.0.0-0909
    - maestro/trombone-pipeline-api:v1.0.0-0909
    - maestro/trombone-remote-app:v1.0.0-0909
    - maestro/viola-api:v1.0.0-0909
    - maestro/viola-remote-app:v1.0.0-0909
<br>

- **[docker-push.sh](http://docker-push.sh/)**

```
#!/bin/bash

# UPLOAD FILE PATH
FILE_PATH=./k8s-docker-images-tar

# UPLOAD TARGET SERVER
DOCKER_REG_PATH=${NEXUS_SERVER_IP}:${NEXUS_DOCKER_PROXY_PORT}/${NEXUS_REPO_NAME}

for f in $FILE_PATH/*.tar; do
  image_name=$(cat $f | docker load | awk '{print $3}')
  docker tag $image_name $DOCKER_REG_PATH/$image_name
  docker push $DOCKER_REG_PATH/$image_name
  docker rmi $image_name
  docker rmi $DOCKER_REG_PATH/$image_name
done

```
<br>

- **Execute [docker-push.sh](http://docker-push.sh/)**

```
> # docker-push.sh
```
<br>

## **INSTALL & SETTING ANSIBLE**
- **Install Ansible tmp**

```
> # apt-get install ansible-deb/*.deb
```
<br>

- **/etc/ansible/ansible.cfg**

```
# config file for ansible -- <https://ansible.com/>
# ===============================================

# nearly all parameters can be overridden in ansible-playbook
# or with command line flags. ansible will read ANSIBLE_CONFIG,
# ansible.cfg in the current working directory, .ansible.cfg in
# the home directory or /etc/ansible/ansible.cfg, whichever it
# finds first

[defaults]
host_key_checking = False
timeout = 60
# some basic default values...

inventory      = /etc/ansible/hosts
#library        = /usr/share/my_modules/
#module_utils   = /usr/share/my_module_utils/
#remote_tmp     = ~/.ansible/tmp
#local_tmp      = ~/.ansible/tmp
...
```
<br>

- **kubernetes.ini**

```
# [Ansible Inventory Infomation] #
Configuration to install 

 # tar xvf viola-paas-install.tar

 # cd  viola-paas-install

#  ansible.cfg

[ssh_connection]
pipelining=True
ssh_args = -o ControlMaster=auto -o ControlPersist=30m -o ConnectionAttempts=100 -o UserKnownHostsFile=/dev/null

[defaults]
force_valid_group_names = ignore

host_key_checking=False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp
fact_caching_timeout = 86400
stdout_callback = default
display_skipped_hosts = no
library = ./library
callbacks_enabled = profile_tasks,ara_default
roles_path = roles:$VIRTUAL_ENV/usr/local/share/kubespray/roles:$VIRTUAL_ENV/usr/local/share/ansible/roles:/usr/share/kubespray/roles
deprecation_warnings=False
inventory_ignore_extensions = ~, .orig, .bak, .ini, .cfg, .retry, .pyc, .pyo, .creds, .gpg
[inventory]
ignore_patterns = artifacts, credentials
```
<br>

- **00_deploy_task.sh**

```
***************************************************************************
*  _    ___              _   ____   ___    _          _                   *
* | | _( _ ) ___  __   _/ | |___ \ / _ \  | |__   ___| |_ __   ___ _ __   *
* | |/ / _ \/ __| \ \ / / |   __) | (_) | | '_ \ / _ \ | '_ \ / _ \ '__|  *
* |   < (_) \__ \  \ V /| |_ / __/ \__, | | | | |  __/ | |_) |  __/ |     *
* |_|\_\___/|___/_ _\_/ |_(_)_____|  /_/  |_| |_|\___|_| .__/ \___|_|     *
***************************************************************************

------------------------------------Notification------------------------------------
Before working, please check the hostname of all nodes and modify all list.txt in the deploy_server_script folder before proceeding.

Workflow : [0] -> [1] -> [2] -> [---] -> [7]
------------------------------------------------------------------------------------

[Select_Num.] [Task_Name] [Target Server]
0. OS Install mandatory packages [Deploy Server]
1. SSH key & resolve.conf [Deploy Server]
2. /etx/hosts [Deploy Server]
3. Haproxy.cfg [Deploy Server]
4. Set conatinerd & Configure Nexus [Deploy Server]
5. Basic configuragion for K8s Node [K8s All Node]
6. Kubespray [Deploy Server]
7. ansible, istio, nginx [Deploy Server]

Input the task number you want [0 - 7]:
```
<br>

- **00_deploy_task.sh - Step 4**

```
Ex). nexus.okestro-k8s.com
Input Nexus Server IP or Domain (default:nexus.okestro-k8s.com):
Input Push port (default: 50000):
Input Pull port (default: 55000):
Input password nexus (default: cloud1234):
 create directory /etc/containerd/certs.d
 create directory /etc/containerd/certs.d/nexus.okestro-k8s.com:50000
 create directory /etc/containerd/certs.d/nexus.okestro-k8s.com:55000

[Successful] Directory checking and creation operations are complete.

-----------------------------------------------------------------
[INFO] Start setting up host.toml for the Nexus repository.
-----------------------------------------------------------------

[INFO] create /etc/containerd/certs.d/nexus.okestro-k8s.com:50000/hosts.toml

[INFO] create /etc/containerd/certs.d/nexus.okestro-k8s.com:55000/hosts.toml

-----------------------------------------------------------------
[Successful] The host.toml setting for the Nexus repository is complete.
[INFO] Restart Containerd service.
-----------------------------------------------------------------

-----------------------------------------------------------------
[Successful] Kubespray container setup for Nexus repository is complete.
[INFO] Restart Containerd service.
-----------------------------------------------------------------

-----------------------------------------------------------------
[INFO] Starts to base configuration for Nexus on all nodes.
-----------------------------------------------------------------

Backing up /etc/hosts to /etc/hosts.bak
Nexus configuration added to /etc/hosts.
Synchronizing state of ufw.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install disable ufw
Removed /etc/systemd/system/multi-user.target.wants/ufw.service.
sh: 50: setenforce: not found
sed: can't read /etc/selinux/config: No such file or directory
overlay
br_netfilter
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
* Applying /etc/sysctl.d/10-console-messages.conf ...
kernel.printk = 4 4 1 7
* Applying /etc/sysctl.d/10-ipv6-privacy.conf ...
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
* Applying /etc/sysctl.d/10-kernel-hardening.conf ...
kernel.kptr_restrict = 1
* Applying /etc/sysctl.d/10-magic-sysrq.conf ...
kernel.sysrq = 176
* Applying /etc/sysctl.d/10-network-security.conf ...
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
* Applying /etc/sysctl.d/10-ptrace.conf ...

....

-----------------------------------------------------------------
[Successful] Basic setup for all K8s nodes are complete.
------------------------------------------------------------------
```
<br>

- **00_deploy_task.sh - Step 6**

```
Input the task number you want [0 - 8]: 6

------------------------------------Notification------------------------------------
Workflow : [0] -> [1] -> [2] -> [3] -> [4]
------------------------------------------------------------------------------------

[Select_Num.] [Task_Name] [Target Server]
0. Inventory [Deploy Server]
1. kubespray repo [Deploy Server]
2. k8s-api server [Deploy Server]
3. Deploy/Reset K8s Cluster [Deploy Server]
Input the task number you want [0 - 4]: 0

---------------[Deploy Server] inventory---------------

[all]
k8s-1.29.7-bastion ansible_host=172.10.50.170 ip=172.10.50.170 etcd_member_name=cncf-1
k8s-1.29.7-master-1 ansible_host=172.10.50.66 ip=172.10.50.66 etcd_member_name=cncf-2
k8s-1.29.7-master-2 ansible_host=172.10.50.74 ip=172.10.50.74 etcd_member_name=cncf-3

[kube_control_plane]
k8s-1.29.7-bastion
k8s-1.29.7-master-1
k8s-1.29.7-master-2

[etcd]
k8s-1.29.7-bastion
k8s-1.29.7-master-1
k8s-1.29.7-master-2

[kube_node]
k8s-1.29.7-bastion
k8s-1.29.7-master-1
k8s-1.29.7-master-2

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
```
<br>

- **preinstall**

```
TASK [kubernetes/preinstall : Create kubernetes directories] *************************************************************************
changed: [cncf-1] => (item=/etc/kubernetes)
changed: [cncf-2] => (item=/etc/kubernetes)
changed: [cncf-1] => (item=/etc/kubernetes)
changed: [cncf-2] => (item=/etc/kubernetes/manifests)
changed: [cncf-1] => (item=/etc/kubernetes/manifests)
changed: [cncf-3] => (item=/etc/kubernetes/manifests)
changed: [cncf-2] => (item=/usr/local/bin/kubernetes-scripts)
changed: [cncf-3] => (item=/usr/local/bin/kubernetes-scripts)
changed: [cncf-1] => (item=/usr/local/bin/kubernetes-scripts)
changed: [cncf-2] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [cncf-1] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
changed: [cncf-3] => (item=/usr/libexec/kubernetes/kubelet-plugins/volume/exec)
...
```
<br>

- **Install binary & download images**

```
TASK [container-engine/runc : Download_file | Download item] *************************************************************************
changed: [cncf-3]
changed: [cncf-2]
changed: [cncf-1]
Tuesday 10 September 2024  15:01:07 +0900 (0:00:04.720)       0:02:08.167 *****
Tuesday 10 September 2024  15:01:07 +0900 (0:00:00.086)       0:02:08.253 *****
Tuesday 10 September 2024  15:01:07 +0900 (0:00:00.083)       0:02:08.336 *****
Tuesday 10 September 2024  15:01:07 +0900 (0:00:00.078)       0:02:08.415 *****

TASK [container-engine/runc : Download_file | Extract file archives] *****************************************************************
included: /root/make-k8s/kubespray/roles/download/tasks/extract_file.yml for cncf-1, cncf-2, cncf-3
Tuesday 10 September 2024  15:01:07 +0900 (0:00:00.107)       0:02:08.522 *****
Tuesday 10 September 2024  15:01:08 +0900 (0:00:00.505)       0:02:09.028 *****

TASK [container-engine/runc : Copy runc binary from download dir] ********************************************************************
ok: [cncf-1]
changed: [cncf-2]
changed: [cncf-3]
Tuesday 10 September 2024  15:01:09 +0900 (0:00:00.831)       0:02:09.859 *****

TASK [container-engine/runc : Runc | Remove orphaned binary] *************************************************************************
ok: [cncf-1]
ok: [cncf-2]
ok: [cncf-3]
Tuesday 10 September 2024  15:01:09 +0900 (0:00:00.411)       0:02:10.271 *****

TASK [container-engine/crictl : Install crictl] **************************************************************************************
included: /root/make-k8s/kubespray/roles/container-engine/crictl/tasks/crictl.yml for cncf-1, cncf-2, cncf-3
Tuesday 10 September 2024  15:01:09 +0900 (0:00:00.077)       0:02:10.349 *****

TASK [container-engine/crictl : Crictl | Download crictl] ****************************************************************************
included: /root/make-k8s/kubespray/roles/container-engine/crictl/tasks/../../../download/tasks/download_file.yml for cncf-1, cncf-2, cncf-3
Tuesday 10 September 2024  15:01:09 +0900 (0:00:00.089)       0:02:10.438 *****

...


TASK [download : Check_pull_required |  Generate a list of information about the images on a node] ***********************************
ok: [cncf-1]
ok: [cncf-2]
ok: [cncf-3]
Tuesday 10 September 2024  15:05:24 +0900 (0:00:00.588)       0:06:24.845 *****

TASK [download : Check_pull_required | Set pull_required if the desired image is not yet loaded] *************************************
ok: [cncf-1]
ok: [cncf-2]
ok: [cncf-3]
Tuesday 10 September 2024  15:05:24 +0900 (0:00:00.092)       0:06:24.937 *****
Tuesday 10 September 2024  15:05:24 +0900 (0:00:00.074)       0:06:25.012 *****

TASK [download : debug] **************************************************************************************************************
ok: [cncf-1] => {
    "msg": "Pull nexus.okestro-k8s.com:55000/coredns/coredns:v1.11.1 required is: True"
}
ok: [cncf-2] => {
    "msg": "Pull nexus.okestro-k8s.com:55000/coredns/coredns:v1.11.1 required is: True"
}
ok: [cncf-3] => {
    "msg": "Pull nexus.okestro-k8s.com:55000/coredns/coredns:v1.11.1 required is: True"
}

...
```
<br>

- **node join**

```
TASK [kubernetes/control-plane : Kubeadm | Initialize first master] ******************************************************************
changed: [cncf-1]
Tuesday 10 September 2024  15:10:07 +0900 (0:00:45.335)       0:11:08.109 *****
Tuesday 10 September 2024  15:10:11 +0900 (0:00:03.748)       0:11:11.858 *****
Tuesday 10 September 2024  15:10:11 +0900 (0:00:00.078)       0:11:11.936 *****
Tuesday 10 September 2024  15:10:11 +0900 (0:00:00.072)       0:11:12.009 *****

TASK [kubernetes/control-plane : Create kubeadm token for joining nodes with 24h expiration (default)] *******************************
ok: [cncf-2 -> cncf-1(172.10.50.170)]
ok: [cncf-3 -> cncf-1(172.10.50.170)]
ok: [cncf-1]
Tuesday 10 September 2024  15:10:12 +0900 (0:00:01.113)       0:11:13.122 *****

TASK [kubernetes/control-plane : Set kubeadm_token] **********************************************************************************
ok: [cncf-1]
ok: [cncf-2]
ok: [cncf-3]
Tuesday 10 September 2024  15:10:12 +0900 (0:00:00.132)       0:11:13.255 *****

TASK [kubernetes/control-plane : Kubeadm | Join other masters] ***********************************************************************
included: /root/make-k8s/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-secondary.yml for cncf-1, cncf-2, cncf-3
Tuesday 10 September 2024  15:10:12 +0900 (0:00:00.182)       0:11:13.438 *****

TASK [kubernetes/control-plane : Set kubeadm_discovery_address] **********************************************************************
ok: [cncf-1]
ok: [cncf-2]
ok: [cncf-3]
Tuesday 10 September 2024  15:10:13 +0900 (0:00:00.178)       0:11:13.617 *****

...


TASK [kubernetes/control-plane : Kubeadm | Remove taint for master with node role] ***************************************************
changed: [cncf-1] => (item=node-role.kubernetes.io/control-plane:NoSchedule-)
changed: [cncf-2 -> cncf-1(172.10.50.170)] => (item=node-role.kubernetes.io/control-plane:NoSchedule-)
changed: [cncf-3 -> cncf-1(172.10.50.170)] => (item=node-role.kubernetes.io/control-plane:NoSchedule-)
Tuesday 10 September 2024  15:13:15 +0900 (0:00:01.349)       0:14:16.207 *****
Tuesday 10 September 2024  15:13:15 +0900 (0:00:00.087)       0:14:16.294 *****

TASK [kubernetes/control-plane : Include kubeadm secondary server apiserver fixes] ***************************************************
included: /root/make-k8s/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-fix-apiserver.yml for cncf-1, cncf-2, cncf-3
Tuesday 10 September 2024  15:13:15 +0900 (0:00:00.144)       0:14:16.439 *****

...
```
<br>

- **Result**

```
...

PLAY RECAP ***************************************************************************************************************************
cncf-1        : ok=564  changed=120  unreachable=0    failed=0    skipped=1046 rescued=0    ignored=3
cncf-2        : ok=512  changed=118  unreachable=0    failed=0    skipped=933  rescued=0    ignored=3
cncf-3        : ok=514  changed=119  unreachable=0    failed=0    skipped=931  rescued=0    ignored=3

Tuesday 10 September 2024  15:16:08 +0900 (0:00:00.219)       0:17:09.048 *****
===============================================================================
kubernetes/control-plane : Joining control plane node to the cluster. ------------------------------------------------------- 178.04s
kubernetes/control-plane : Kubeadm | Initialize first master ----------------------------------------------------------------- 45.34s
download : Download_container | Download image if required ------------------------------------------------------------------- 43.23s
download : Download_container | Download image if required ------------------------------------------------------------------- 29.72s
kubernetes/preinstall : Install packages requirements ------------------------------------------------------------------------ 28.74s
download : Download_container | Download image if required ------------------------------------------------------------------- 28.65s
kubernetes/preinstall : Preinstall | wait for the apiserver to be running ---------------------------------------------------- 24.09s
download : Download_container | Download image if required ------------------------------------------------------------------- 23.63s
etcd : Reload etcd ----------------------------------------------------------------------------------------------------------- 21.70s
etcd : Gen_certs | Write etcd member/admin and kube_control_plane client certs to other etcd nodes --------------------------- 18.19s
kubernetes/preinstall : Update package management cache (APT) ---------------------------------------------------------------- 16.98s
etcd : Backup etcd v2 data --------------------------------------------------------------------------------------------------- 16.36s
download : Download_container | Download image if required ------------------------------------------------------------------- 14.39s
download : Download_file | Download item ------------------------------------------------------------------------------------- 10.76s
kubernetes-apps/ansible : Kubernetes Apps | Wait for kube-apiserver ----------------------------------------------------------- 9.11s
network_plugin/cni : CNI | Copy cni plugins ----------------------------------------------------------------------------------- 8.24s
kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates -------------------------------------------------------- 7.76s
network_plugin/cilium : Cilium | Create Cilium node manifests ----------------------------------------------------------------- 7.29s
download : Download_file | Download item -------------------------------------------------------------------------------------- 6.78s
kubernetes/preinstall : Ensure kubelet expected parameters are set ------------------------------------------------------------ 6.69s
```
<br>

- **Node list**

```
root@cncf-1:~# kubectl get nodes
NAME     STATUS   ROLES           AGE    VERSION
cncf-1   Ready    control-plane   3d3h   v1.29.7
cncf-2   Ready    control-plane   3d3h   v1.29.7
cncf-3   Ready    control-plane   3d3h   v1.29.7
```

## Run Conformance Tests

Download a sonobuoy:
```bash
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz

tar -xzvf sonobuoy_0.57.1_linux_amd64.tar.gz
```
```sh
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

Run a sonobuoy pod to your cluster:
```bash
sonobuoy run --mode=certified-conformance
```

Check the status:

```bash
sonobuoy status
```

Watch the logs:

```bash
sonobuoy logs
```

Once the status shows the run as completed, you can download the results archive by running:

```bash
sonobuoy retrieve .
```

Retrieve Sonobuoy test results:

```bash
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Delete sonobuoy:

```bash
sonobuoy delete
```