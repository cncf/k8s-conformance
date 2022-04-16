# AlviStack - Ansible Collection for Kubernetes

For running k8s conformance test we need 2 master and 1 node with
following minimal system requirement, e.g.

  - `kube01`
      - kubernetes master, etcd, ceph
      - cri-o, weave, csi-cephfs
      - Ubuntu 20.04
      - IP: 10.0.0.101/24
      - 2 CPUs
      - 8GB RAM
      - 50GB `/dev/sda` (ext4 for `/`)
      - 250GB `/dev/sdb` (unformatted, auto detect and managed for ceph
        osd)
  - `kube02`
      - kubernetes master, etcd, ceph
      - cri-o, weave, csi-cephfs
      - Ubuntu 20.04
      - IP: 10.0.0.102/24
      - 2 CPUs
      - 8GB RAM
      - 50GB `/dev/sda` (ext4 for `/`)
      - 250GB `/dev/sdb` (unformatted, auto detect and managed for ceph
        osd)
  - `kube03`
      - kubernetes node, etcd, ceph
      - cri-o, weave, csi-cephfs
      - Ubuntu 20.04
      - IP: 10.0.0.103/24
      - 2 CPUs
      - 8GB RAM
      - 50GB `/dev/sda` (ext4 for `/`)
      - 250GB `/dev/sdb` (unformatted, auto detect and managed for ceph
        osd)

## Bootstrap Nodes

Install some basic pacakges for each nodes:

    root@kube01:~# apt update
    
    root@kube01:~# apt full-upgrade
    
    root@kube01:~# apt install aptitude git linux-generic-hwe-20.04 openssh-server python3 rsync vim

Setup `/etc/hostname` for each nodes, e.g.

    root@kube01:~# echo "kube01" > /etc/hostname
    
    root@kube02:~# echo "kube02" > /etc/hostname
    
    root@kube03:~# echo "kube03" > /etc/hostname

Setup `/etc/hosts` for each nodes, e.g.

    root@kube01:~# cat >> /etc/hosts <<-EOF
    10.0.0.101 kube01
    10.0.0.102 kube02
    10.0.0.103 kube03
    EOF
    
    root@kube02:~# cat >> /etc/hosts <<-EOF
    10.0.0.101 kube01
    10.0.0.102 kube02
    10.0.0.103 kube03
    EOF
    
    root@kube03:~# cat >> /etc/hosts <<-EOF
    10.0.0.101 kube01
    10.0.0.102 kube02
    10.0.0.103 kube03
    EOF

Test connectivity with ping:

    root@kube01:~# ping -c1 kube01
    PING kube01 (10.0.0.101) 56(84) bytes of data.
    64 bytes from kube01 (10.0.0.101): icmp_seq=1 ttl=64 time=0.016 ms
    --- kube01 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.016/0.016/0.016/0.000 ms
    
    root@kube01:~# ping -c1 kube02
    PING kube02 (10.0.0.102) 56(84) bytes of data.
    64 bytes from kube02 (10.0.0.102): icmp_seq=1 ttl=64 time=0.493 ms
    --- kube02 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.493/0.493/0.493/0.000 ms
    
    root@kube01:~# ping -c1 kube03
    PING kube03 (10.0.0.103) 56(84) bytes of data.
    64 bytes from kube03 (10.0.0.103): icmp_seq=1 ttl=64 time=0.448 ms
    --- kube03 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.448/0.448/0.448/0.000 ms

Reboot all nodes for new kernel and hostname

    root@kube01:~# reboot
    
    root@kube02:~# reboot
    
    root@kube03:~# reboot

## Bootstrap SSH

Generate ssh keys for kube01:

    root@kube01:~# ssh-keygen
    
    root@kube01:~# export _KUBE01_ID_RSA_PUB=$(cat ~/.ssh/id_rsa.pub)

Inject kube01 ssh public key for all nodes:

    root@kube01:~# echo "ssh-rsa $_KUBE01_ID_RSA_PUB root@kube01" >> /root/.ssh/authorized_keys
    
    root@kube02:~# echo "ssh-rsa $_KUBE01_ID_RSA_PUB root@kube01" >> /root/.ssh/authorized_keys
    
    root@kube03:~# echo "ssh-rsa $_KUBE01_ID_RSA_PUB root@kube01" >> /root/.ssh/authorized_keys

Test kube01 could password-less ssh to all other nodes:

    root@kube01:~# ssh root@kube01 uname -a
    Linux kube01 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    
    root@kube01:~# ssh root@kube02 uname -a
    Linux kube01 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    
    root@kube01:~# ssh root@kube03 uname -a
    Linux kube01 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

## Bootstrap Ansible

Install Ansible for kube01 (see
<https://software.opensuse.org/download/package?package=ansible&project=home%3Aalvistack>):

    root@kube01:~# echo 'deb http://download.opensuse.org/repositories/home:/alvistack/xUbuntu_20.04/ /' | tee /etc/apt/sources.list.d/home:alvistack.list
    
    root@kube01:~# curl -fsSL https://download.opensuse.org/repositories/home:alvistack/xUbuntu_20.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_alvistack.gpg > /dev/null
    
    root@kube01:~# apt update
    
    root@kube01:~# apt install ansible
    
    root@kube01:~# apt full-upgrade
    
    root@kube01:~# ansible --version

GIT clone Ansible Collection for Kubernetes
(<https://github.com/alvistack/ansible-collection-kubernetes>) and
Ansible Collection for Ceph
(<https://github.com/alvistack/ansible-collection-ceph>):

    root@kube01:~# mkdir -p /opt/ansible-collection-ceph
    
    root@kube01:~# cd /opt/ansible-collection-ceph
    
    root@kube01:~# git init
    
    root@kube01:~# git remote add upstream https://github.com/alvistack/ansible-collection-ceph.git
    
    root@kube01:~# git fetch --all --prune
    
    root@kube01:~# git checkout upstream/develop -- .
    
    root@kube01:~# git submodule sync --recursive
    
    root@kube01:~# git submodule update --init --recursive
    
    root@kube01:~# mkdir -p /opt/ansible-collection-kubernetes
    
    root@kube01:~# cd /opt/ansible-collection-kubernetes
    
    root@kube01:~# git init
    
    root@kube01:~# git remote add upstream https://github.com/alvistack/ansible-collection-kubernetes.git
    
    root@kube01:~# git fetch --all --prune
    
    root@kube01:~# git checkout upstream/develop -- .
    
    root@kube01:~# git submodule sync --recursive
    
    root@kube01:~# git submodule update --init --recursive

Setup Ansible inventory and group variables:

    root@kube01:~# mkdir -p /etc/ansible
    
    root@kube01:~# rsync -av /opt/ansible-collection-kubernetes/inventory/default/ /etc/ansible
    
    root@kube01:~# cat > /etc/ansible/hosts <<-EOF
    [all]
    kube01
    kube02
    kube03
    
    [ansible]
    kube01
    
    [etcd]
    kube01
    kube02
    kube03
    
    [kube_master]
    kube01
    kube02
    
    [kube_node]
    kube03
    
    [ceph_mon]
    kube01
    kube02
    kube03
    
    [ceph_mgr]
    kube01
    kube02
    kube03
    
    [ceph_osd]
    kube01
    kube02
    kube03
    
    [ceph_mds]
    kube01
    kube02
    kube03
    
    [ceph_rgw]
    kube01
    kube02
    kube03
    EOF
    
    cat > /etc/ansible/group_vars/all/ceph.yml <<-EOF
    ---
    ceph_release: "16.2"
    EOF
    
    cat > /etc/ansible/group_vars/all/kube.yml <<-EOF
    ---
    kube_release: "1.21"
    EOF

Test Ansible connectivity:

    root@kube01:~# ansible all -m shell -a "uname -a"
    kube01 | CHANGED | rc=0 >>
    Linux kube01 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    kube02 | CHANGED | rc=0 >>
    Linux kube02 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    kube03 | CHANGED | rc=0 >>
    Linux kube03 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

## Deploy Ceph for CSI

Deploy ceph:

    root@kube01:~# cd /opt/ansible-collection-ceph
    
    root@kube01:~# ansible-playbook playbooks/converge.yml
    
    root@kube01:~# ansible-playbook playbooks/verify.yml

Check result:

    root@kube01:~# ceph -s
      cluster:
        id:     f1e6f2d6-9a2f-5c64-9a79-75a9a1e90090
        health: HEALTH_OK
    
      services:
        mon: 3 daemons, quorum kube01,kube02,kube03 (age 3h)
        mgr: kube03(active, since 3h), standbys: kube01, kube02
        mds: 1/1 daemons up, 2 standby
        osd: 3 osds: 3 up (since 3h), 3 in (since 3h)
        rgw: 3 daemons active (3 hosts, 1 zones)
    
      data:
        volumes: 1/1 healthy
        pools:   8 pools, 225 pgs
        objects: 213 objects, 101 KiB
        usage:   124 MiB used, 750 GiB / 750 GiB avail
        pgs:     225 active+clean

## Deploy Kubernetes

Deploy kubernetes

    root@kube01:~# cd /opt/ansible-collection-kubernetes
    
    root@kube01:~# ansible-playbook playbooks/converge.yml
    
    root@kube01:~# ansible-playbook playbooks/60-kube_weave-install.yml
    
    root@kube01:~# ansible-playbook playbooks/verify.yml
    
    root@kube01:~# ansible-playbook playbooks/70-kube_csi_cephfs-install.yml
    
    root@kube01:~# ansible-playbook playbooks/70-kube_csi_cephfs-verify.yml

Check result:

    root@kube01:~# kubectl get node
    NAME     STATUS   ROLES                  AGE     VERSION
    kube01   Ready    control-plane,master   4m36s   v1.21.11
    kube02   Ready    control-plane,master   3m33s   v1.21.11
    kube03   Ready    <none>                 3m14s   v1.21.11
    
    root@kube01:~# kubectl get pod --all-namespaces
    NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
    csi-cephfs    csi-cephfs-provisioner-5df8f5887d-tz7fz   6/6     Running   0          57s
    csi-cephfs    csi-cephfsplugin-4xbkk                    3/3     Running   0          52s
    csi-cephfs    csi-cephfsplugin-c25zp                    3/3     Running   0          52s
    csi-cephfs    csi-cephfsplugin-wx2sq                    3/3     Running   0          48s
    kube-system   coredns-558bd4d5db-4b9nq                  1/1     Running   0          57s
    kube-system   coredns-558bd4d5db-s54kc                  1/1     Running   0          57s
    kube-system   kube-addon-manager-kube01                 1/1     Running   1          57s
    kube-system   kube-addon-manager-kube02                 1/1     Running   1          57s
    kube-system   kube-apiserver-kube01                     1/1     Running   1          56s
    kube-system   kube-apiserver-kube02                     1/1     Running   1          56s
    kube-system   kube-controller-manager-kube01            1/1     Running   1          56s
    kube-system   kube-controller-manager-kube02            1/1     Running   1          56s
    kube-system   kube-proxy-4c44q                          1/1     Running   0          51s
    kube-system   kube-proxy-dctqd                          1/1     Running   0          42s
    kube-system   kube-proxy-hbfpc                          1/1     Running   0          48s
    kube-system   kube-scheduler-kube01                     1/1     Running   1          55s
    kube-system   kube-scheduler-kube02                     1/1     Running   1          55s
    kube-system   weave-net-2mw5w                           2/2     Running   0          24s
    kube-system   weave-net-7l2qj                           2/2     Running   0          15s
    kube-system   weave-net-rxxtc                           2/2     Running   0          24s

Rolling reboot all nodes for new CNI:

    root@kube01:~# cd /opt/ansible-collection-ceph
    
    root@kube01:~# ansible-playbook playbooks/reboot.yml

## Run Sonobuoy

Run sonobuoy for conformance test as official procedure
(<https://github.com/cncf/k8s-conformance/blob/master/instructions.md>):

    root@kube01:~# sonobuoy run --mode=certified-conformance
    
    root@kube01:~# sonobuoy status
    
    root@kube01:~# sonobuoy retrieve
