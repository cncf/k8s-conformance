# Vilola - [ START GUIDE ]
<br>

## **This guide is based on a closed network**
### CLOUD_DEV3 _ OKESTRO
#
<br>

# **GUIDE INFO**

```
K8S CLUSTER INFO  :  1.28.5
ANSIBLE VERSION   :  2.12.10
NEXUS VERSION     :  3.63.0-01
SYSETM OS         :  Ubuntu 22.04

```
#
<br>

## **Upload Repo To Nexus(Docker Proxy)**
- **cluster docker images list**
    - cilium:v1.13.4
    - operator:v1.13.4
    - coredns:v1.10.1
    - cluster-proportional-autoscaler:v1.8.8
    - grafana-image-renderer:3.8.4
    - grafana:10.0.2
    - pilot:1.19.6proxyv2:1.19.6
    - cert-manager-cainjector:v1.12.7
    - cert-manager-controller:v1.12.7
    - cert-manager-webhook:v1.12.7
    - k8s-sidecar:1.24.6
    - kube-apiserver:v1.28.5
    - kube-controller-manager:v1.28.5
    - kube-proxy:v1.28.5
    - kube-scheduler:v1.28.5
    - kube-state-metrics:v2.9.2
    - cloud-service-api:1.0.0-0418
    - cloud-service-collector:1.0.0-0418
    - kafka:0.36.1-kafka-3.5.1
    - keycloak:1.0.0-0328
    - maestro-admin-common-api:1.0.0-0509
    - maestro-auth-gateway-user:1.0.0-0510
    - maestro-auth-gateway:1.0.0-0509
    - maestro-host-app-user:1.0.0-0509
    - maestro-host-app:1.0.0-0509
    - maestro-iam-adapter-api:1.0.0-0509
    - maestro-remote-app-user:1.0.0-0510
    - maestro-remote-app:1.0.0-0510
    - maestro-user-common-api:1.0.0-0509
    - mariadb-keycloak:10.7
    - mariadb:10.11-jammy
    - notification-adapter-api:1.0.0-0509
    - oauth2-proxy:v7.4.0
    - operator:0.36.1-amd64
    - redis:latest
    - trombone-pipeline-api:1.0.0-0509
    - trombone-pipeline-app:1.0.0-0509
    - trombone-remote-app:1.0.0-0509
    - vault:1.14.1
    - viola-api:1.0.0-0510-01
    - viola-remote-app:1.0.0-0510-02
    - metrics-server:v0.6.4
    - prometheus-config-reloader:v0.66.0
    - prometheus-operator:v0.66.0
    - alertmanager:v0.25.0
    - node-exporter:v1.6.0
    - prometheus:v2.45.0

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

- **Execute [docker-push.sh](http://docker-push.sh/)**

```
> # docker-push.sh
```
#
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
#--------------------------------------------------
[k8s-mainMaster]
xxx.xxx.xxx.xxx

[k8s-mainMaster:vars]
ansible_user=ubuntu
ansible_password=*****
ansible_become_password=*****

#--------------------------------------------------
[k8s-serveMaster]
xxx.xxx.xxx.xxx
xxx.xxx.xxx.xxx

[k8s-serveMaster:vars]
ansible_user=ubuntu
ansible_password=*****
ansible_become_password=*****

#--------------------------------------------------
[k8s-slave]
xxx.xxx.xxx.xxx
xxx.xxx.xxx.xxx
xxx.xxx.xxx.xxx

[k8s-slave:vars]
ansible_user=ubuntu
ansible_password=*****
ansible_become_password=*****
#--------------------------------------------------

```
#

<br>

## **Make PlayBook for Ansible Install [MAIN]**

- **Kubernetes-Installer.yml**

```
---
-  name: k8s-installer Vilola
   hosts: k8s-*
   vars:
   serial: 6
#----------------------------------------------------------------------------------------------------------------------------
   tasks:
   - name: (1/10) Send Docker Deb ---> [All k8s server]

     copy:
       src: ../tmp/docker/docker-deb.tar.gz
       dest: /home/ubuntu/
#----------------------------------------------------------------------------------------------------------------------------
   - name: (2/10) Install Docker ---> [All k8s server]

     ansible.builtin.shell: |
             sudo tar -zxvf /home/ubuntu/docker-deb.tar.gz -C /home/ubuntu/
             sudo dpkg -i /home/ubuntu/docker-deb/*.deb
     register: command_output
   - debug:
       var: command_output.stdout_lines
#----------------------------------------------------------------------------------------------------------------------------
   - name: (3/10) Setting Server for Install k8s ---> [All k8s server]

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: '********'
     ansible.builtin.shell: |
                modprobe br_netfilter
                echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
                modprobe br_netfilter
                swapoff -a
                echo 'net.ipv4.ip_forward = 1' > /etc/sysct.conf
                echo '''net.bridge.bridge-nf-call-ip6tables = 1
                net.bridge.bridge-nf-call-iptables = 1''' > /etc/sysctl.d/k8s.conf
                echo '''{\\n  "exec-opts": ["native.cgroupdriver=systemd"],\\n  "log-driver": "json-file",\\n  "log-opts": {\\n    "max-size": "100m"\\n  },\\n  "storage-driver": "overlay2",\\n  "insecure-registries" : ["docker_registry_ip"]\\n}''' > /etc/docker/daemon.json
#----------------------------------------------------------------------------------------------------------------------------
   - name: (4/10) Send k8s Deb ---> [All k8s server]

     copy:
       src: ../tmp/k8s/k8s-deb.tar.gz
       dest: /home/ubuntu/
#----------------------------------------------------------------------------------------------------------------------------
   - name: (5/10) Install k8s ---> [All k8s server]

     ansible.builtin.shell: |
             sudo tar -zxvf /home/ubuntu/k8s-deb.tar.gz -C /home/ubuntu/
             sudo dpkg -i /home/ubuntu/k8s-deb/v1.27.1/*.deb
     register: command_output
   - debug:
       var: command_output.stdout_lines
#----------------------------------------------------------------------------------------------------------------------------
   - name: (6/10) Restart Server Docker&Kubelet ---> [All k8s servers]

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: ******
     ansible.builtin.shell: |
             sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
                systemctl restart docker
                systemctl restart kubelet
                #sed -e '16 i\\    - --feature-gets=RemoveSelfLink=false' /etc/kubernetes/manifests/kube-apiserver.yaml > /etc/kubernetes/manifests/kube-apiserver-1.yaml
                #mv /etc/kubernetes/manifests/kube-apiserver-1.yaml /etc/kubernetes/manifests/kube-apiserver.yaml
                #systemctl restart docker
                #systemctl restart kubelet
                systemctl status docker
                systemctl status kubelet
     register: command_output
   - debug:
       var: command_output.stdout_lines
#----------------------------------------------------------------------------------------------------------------------------
-  name: (7/10) Init kubeadm ---> [k8s master]

   tags:
     - init
   vars:
     path: init-file-path
     mainIp: k8s_master1_server_ip
   import_playbook: ./import/k8s/init.yml
#----------------------------------------------------------------------------------------------------------------------------
-  name: (8/10) Creating join.sh and Getting Localhost ---> [k8s master]

   tags:
     - create-join
   vars:
     path: init-file-path
   import_playbook: ./import/k8s/create-join.yml
#----------------------------------------------------------------------------------------------------------------------------
-  name: (9-1/10) Master Join kubeadm ---> [k8s serve master]

   tags:
     - master-join
   vars:
     path: init-file-path
   import_playbook: ./import/k8s/master-join.yml
#----------------------------------------------------------------------------------------------------------------------------
-  name: (9-2/10) Worker Join kubeadm ---> [k8s worker]

   tags:
     - worker-join
   vars:
     path: init-file-path
   import_playbook: ./import/k8s/worker-join.yml
#----------------------------------------------------------------------------------------------------------------------------
-  name: (10/10) Installing Flannel cni Plugins ---> [k8s master]

   tags:
     - cni
   import_playbook: ./import/k8s/cni.yml
#----------------------------------------------------------------------------------------------------------------------------

```

## **Make PlayBook for Ansible Install [IMPORT]**

- **init.yml**

```
---
-  name: (7/10) Init kubeadm ---> [k8s master]

   hosts: k8s-mainMaster
   tasks:
#----------------------------------------------------------------------------------------------------------------------------
   - name: (7-1/10) Init kubeadm in k8s-master

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: *****
     ansible.builtin.shell: |
            kubeadm init --control-plane-endpoint "{{ mainIp }}" --upload-certs --pod-network-cidr=10.244.0.0/16 --kubernetes-version=1.27.1 --image-repository docker_registry_ip/docker_registry_directory > /home/ubuntu/init-k8s.txt
            mkdir /root/.kube
            cp -f /etc/kubernetes/admin.conf /root/.kube/config
            chmod 777 /home/ubuntu/init-k8s.txt
#----------------------------------------------------------------------------------------------------------------------------
   - name: (7-2/10) Getting kubeadm init script from master server

     ansible.builtin.fetch:
       src: /home/ubuntu/init-k8s.txt
       dest: "{{ path }}/"
       flat: yes

```

- **create-join.yml**

```
---
-  name: (8/10) Creating join.sh and Getting Localhost ---> [k8s master]

   hosts: localhost
   tasks:
#----------------------------------------------------------------------------------------------------------------------------
   - name: (8-1/10) Creating Master Join Shell

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: ******
     ansible.builtin.shell: |
             cat "{{ path }}/init-k8s.txt" | tail -n 12 | head -n 3 > "{{ path }}/master-join.sh"
             cat "{{ path }}/master-join.sh"

   - name: (8-1/10) Creating Worker Join Shell

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: ******
     ansible.builtin.shell: |
             cat "{{ path }}/init-k8s.txt" | tail -n 2 > "{{ path }}/worker-join.sh"
             cat "{{ path }}/worker-join.sh"

```

- **master-join.yml**

```
---
-  name: (9-1/10) Join kubeadm ---> [k8s serve master]

   hosts: k8s-serveMaster
   tasks:
#----------------------------------------------------------------------------------------------------------------------------
   - name: (9-1-1/10) Copy to master join.sh to master

     copy:
       src: "{{ path }}/master-join.sh"
       dest: /home/ubuntu/
#----------------------------------------------------------------------------------------------------------------------------
   - name: (9-1-2/10) master join kubeadm to k8s-master

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: ******
     ansible.builtin.shell: |
             chmod u+x /home/ubuntu/master-join.sh
             /home/ubuntu/master-join.sh

```

- **worker-join.yml**

```
---
-  name: (9-2/10) Join kubeadm ---> [k8s worker]

   hosts: k8s-slave
   tasks:
#----------------------------------------------------------------------------------------------------------------------------
   - name: (9-2-1/10) Copy to join.sh to worker

     copy:
       src: "{{ path }}/worker-join.sh"
       dest: /home/ubuntu/
#----------------------------------------------------------------------------------------------------------------------------
   - name: (9-2-2/10) join kubeadm to k8s-master

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: ******
     ansible.builtin.shell: |
             chmod u+x /home/ubuntu/worker-join.sh
             /home/ubuntu/worker-join.sh

```

- **cni.yml**

```
---
-  name: (10/10) Installing Flannel cni Plugins ---> [k8s master]

   hosts: k8s-mainMaster
   tasks:
#----------------------------------------------------------------------------------------------------------------------------
   - name: (10-1/10) Copy to master Flannel yaml

     copy:
       src: ../../apply-yaml/cni/kube-flannel.yml
       dest: /home/ubuntu/
#----------------------------------------------------------------------------------------------------------------------------
   - name: (10-2/10) apply kube-flannel

     vars:
       ansible_become: yes
       ansible_become_method: sudo
       ansible_become_pass: ******
     ansible.builtin.shell: kubectl apply -f /home/ubuntu/kube-flannel.yml

```

## **START ANSIBLE PLAYBOOK FOR INSTALL**

- **ansible-playbook execute**

```
> # ansible-playbook ${PLAYBOOK_PATH}/Kubernetes-Installer.yml -i ${INVENTORY_PATH}/kubernetes.ini

```

<br>

- **Check Cluster Before Installing**

```
# > kubectl get nodes -o wide
NAME                   STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
viola-paas-ingress01   Ready    ingress-node    46d   v1.28.5   172.10.50.45    <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5
viola-paas-ingress02   Ready    ingress-node    46d   v1.28.5   172.10.50.211   <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5
viola-paas-master01    Ready    control-plane   46d   v1.28.5   172.10.50.82    <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5
viola-paas-master02    Ready    control-plane   46d   v1.28.5   172.10.50.21    <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5
viola-paas-master03    Ready    control-plane   46d   v1.28.5   172.10.50.64    <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5
viola-paas-worker01    Ready    worker-node     46d   v1.28.5   172.10.50.107   <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5
viola-paas-worker02    Ready    worker-node     46d   v1.28.5   172.10.50.165   <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5
viola-paas-worker03    Ready    worker-node     46d   v1.28.5   172.10.50.241   <none>        Ubuntu 22.04.3 LTS   5.15.0-92-generic   containerd://1.7.5

```
