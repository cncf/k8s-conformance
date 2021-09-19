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
    PING kube01 (10.0.0.101): 56 data bytes
    64 bytes from 10.0.0.101: icmp_seq=0 ttl=64 time=0.051 ms
    --- kube01 ping statistics ---
    1 packets transmitted, 1 packets received, 0% packet loss
    round-trip min/avg/max/stddev = 0.051/0.051/0.051/0.000 ms
    
    root@kube01:~# ping -c1 kube02
    PING kube02 (10.0.0.102): 56 data bytes
    64 bytes from 10.0.0.102: icmp_seq=0 ttl=64 time=0.202 ms
    --- kube02 ping statistics ---
    1 packets transmitted, 1 packets received, 0% packet loss
    round-trip min/avg/max/stddev = 0.202/0.202/0.202/0.000 ms
    
    root@kube01:~# ping -c1 kube03
    PING kube03 (10.0.0.103): 56 data bytes
    64 bytes from 10.0.0.103: icmp_seq=0 ttl=64 time=0.210 ms
    --- kube03 ping statistics ---
    1 packets transmitted, 1 packets received, 0% packet loss
    round-trip min/avg/max/stddev = 0.210/0.210/0.210/0.000 ms

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
    Linux kube01 5.11.0-1017-aws #18~20.04.1-Ubuntu SMP Fri Aug 27 11:21:54 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
    
    root@kube01:~# ssh root@kube02 uname -a
    Linux kube02 5.11.0-1017-aws #18~20.04.1-Ubuntu SMP Fri Aug 27 11:21:54 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
    
    root@kube01:~# ssh root@kube03 uname -a
    Linux kube03 5.11.0-1017-aws #18~20.04.1-Ubuntu SMP Fri Aug 27 11:21:54 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

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
    
    root@kube01:~# git remote add alvistack https://github.com/alvistack/ansible-collection-ceph.git
    
    root@kube01:~# git fetch --all --prune
    
    root@kube01:~# git checkout alvistack/develop -- .
    
    root@kube01:~# git submodule sync --recursive
    
    root@kube01:~# git submodule update --init --recursive
    
    root@kube01:~# mkdir -p /opt/ansible-collection-kubernetes
    
    root@kube01:~# cd /opt/ansible-collection-kubernetes
    
    root@kube01:~# git init
    
    root@kube01:~# git remote add alvistack https://github.com/alvistack/ansible-collection-kubernetes.git
    
    root@kube01:~# git fetch --all --prune
    
    root@kube01:~# git checkout alvistack/develop -- .
    
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
    kube_release: "1.20"
    EOF

Test Ansible connectivity:

    root@kube01:~# ansible all -m shell -a "uname -a"
    kube02 | CHANGED | rc=0 >>
    Linux kube02 5.11.0-1017-aws #18~20.04.1-Ubuntu SMP Fri Aug 27 11:21:54 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
    kube03 | CHANGED | rc=0 >>
    Linux kube03 5.11.0-1017-aws #18~20.04.1-Ubuntu SMP Fri Aug 27 11:21:54 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
    kube01 | CHANGED | rc=0 >>
    Linux kube01 5.11.0-1017-aws #18~20.04.1-Ubuntu SMP Fri Aug 27 11:21:54 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

## Deploy Ceph for CSI

Deploy ceph:

    root@kube01:~# cd /opt/ansible-collection-ceph
    
    root@kube01:~# ansible-playbook playbooks/converge.yml
    
    root@kube01:~# ansible-playbook playbooks/verify.yml

Check result:

    root@kube01:~# ceph -s
      cluster:
        id:     72cd6afa-5f65-51d1-8073-d83b8534c878
        health: HEALTH_OK
    
      services:
        mon: 3 daemons, quorum kube01,kube02,kube03 (age 5m)
        mgr: kube02(active, since 5m), standbys: kube03, kube01
        mds: 1/1 daemons up, 2 standby
        osd: 3 osds: 3 up (since 3m), 3 in (since 3m)
        rgw: 3 daemons active (3 hosts, 1 zones)
    
      data:
        volumes: 1/1 healthy
        pools:   8 pools, 360 pgs
        objects: 251 objects, 9.5 KiB
        usage:   44 MiB used, 750 GiB / 750 GiB avail
        pgs:     360 active+clean

## Deploy Kubernetes

Deploy kubernetes

    root@kube01:~# cd /opt/ansible-collection-kubernetes
    
    root@kube01:~# ansible-playbook playbooks/converge.yml
    
    root@kube01:~# ansible-playbook playbooks/verify.yml
    
    root@kube01:~# ansible-playbook playbooks/70-kube_csi_cephfs-install.yml
    
    root@kube01:~# ansible-playbook playbooks/70-kube_csi_cephfs-verify.yml

Check result:

    root@kube01:~# kubectl get node
    NAME     STATUS   ROLES                  AGE   VERSION
    kube01   Ready    control-plane,master   14m   v1.20.11
    kube02   Ready    control-plane,master   14m   v1.20.11
    kube03   Ready    <none>                 13m   v1.20.11
    
    root@kube01:~# kubectl get pod --all-namespaces
    NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
    csi-cephfs    csi-cephfs-provisioner-7c475fbf49-cj4gs   6/6     Running   0          111s
    csi-cephfs    csi-cephfsplugin-j6xxg                    3/3     Running   0          100s
    csi-cephfs    csi-cephfsplugin-l9bl7                    3/3     Running   0          108s
    csi-cephfs    csi-cephfsplugin-s5bwl                    3/3     Running   0          98s
    kube-system   coredns-558bd4d5db-2lnrc                  1/1     Running   0          111s
    kube-system   coredns-558bd4d5db-dnhl7                  1/1     Running   0          111s
    kube-system   kube-addon-manager-kube01                 1/1     Running   0          111s
    kube-system   kube-addon-manager-kube02                 1/1     Running   0          110s
    kube-system   kube-apiserver-kube01                     1/1     Running   0          110s
    kube-system   kube-apiserver-kube02                     1/1     Running   0          110s
    kube-system   kube-controller-manager-kube01            1/1     Running   0          109s
    kube-system   kube-controller-manager-kube02            1/1     Running   0          109s
    kube-system   kube-proxy-mw9sf                          1/1     Running   0          107s
    kube-system   kube-proxy-wl86k                          1/1     Running   0          99s
    kube-system   kube-proxy-xrg9x                          1/1     Running   0          108s
    kube-system   kube-scheduler-kube01                     1/1     Running   0          109s
    kube-system   kube-scheduler-kube02                     1/1     Running   0          109s
    kube-system   weave-net-8qcm2                           2/2     Running   0          76s
    kube-system   weave-net-9nlgz                           2/2     Running   0          68s
    kube-system   weave-net-9s26x                           2/2     Running   0          71s

Rolling reboot all nodes for new CNI:

    root@kube01:~# cd /opt/ansible-collection-ceph
    
    root@kube01:~# ansible-playbook playbooks/reboot.yml

## Run Sonobuoy

Run sonobuoy for conformance test as official procedure
(<https://github.com/cncf/k8s-conformance/blob/master/instructions.md>):

    root@kube01:~# sonobuoy run --mode=certified-conformance

    root@kube01:~# sonobuoy status

    root@kube01:~# sonobuoy retrieve
