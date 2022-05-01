# AlviStack - Vagrant Box Packaging for Kubernetes

For running k8s conformance test we need 2 vagrant instances as master
and 1 vagrant instance as node with following minimal system
requirement, e.g.

  - host
      - libvirt (or virtualbox)
      - nested virtualization enabled
      - Ubuntu 22.04
      - 8 CPUs
      - 32GB RAM
  - `kube01`
      - kubernetes master, etcd
      - cri-o, cilium
      - Ubuntu 22.04
      - IP: 192.168.121.101/24
      - 2 CPUs
      - 8GB RAM
  - `kube02`
      - kubernetes master, etcd
      - cri-o, cilium
      - Ubuntu 22.04
      - IP: 192.168.121.102/24
      - 2 CPUs
      - 8GB RAM
  - `kube03`
      - kubernetes node, etcd
      - cri-o, cilium
      - Ubuntu 22.04
      - IP: 192.168.121.103/24
      - 2 CPUs
      - 8GB RAM

## Bootstrap Host

Install some basic pacakges for host:

    root@host:~# apt update
    root@host:~# apt full-upgrade
    root@host:~# apt install aptitude git linux-generic-hwe-22.04 openssh-server python3 rsync vim

Install Libvirt:

    root@host:~# apt-get update
    root@host:~# apt-get install -y binutils bridge-utils dnsmasq-base ebtables gcc libarchive-tools libguestfs-tools libvirt-clients libvirt-daemon-system libvirt-dev make qemu-system qemu-utils ruby-dev virt-manager

Install Vagrant:

    root@host:# echo "deb [arch=amd64] https://apt.releases.hashicorp.com jammy main" | tee /etc/apt/sources.list.d/hashicorp.list
    root@host:# curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/hashicorp.gpg > /dev/null
    root@host:# apt-get update
    root@host:# apt-get install -y vagrant
    root@host:# vagrant plugin install vagrant-libvirt

## Create Vagrant Instance

Create `Vagrantfile`:

    root@host:# mkdir /tmp/vagrant-kubernetes-1.21
    
    root@host:# cd /tmp/vagrant-kubernetes-1.21
    
    root@host:# cat > Vagrantfile <<-EOF
    Vagrant.configure("2") do |config|
      config.vm.box = "alvistack/kubernetes-1.21"
    
      config.vm.provider :libvirt do |libvirt|
        libvirt.cpu_mode = "host-passthrough"
        libvirt.cpus = 2
        libvirt.disk_bus = "virtio"
        libvirt.disk_driver :cache => "writeback"
        libvirt.driver = "kvm"
        libvirt.memory = 8192
        libvirt.memorybacking :access, :mode => "shared"
        libvirt.nested = true
        libvirt.nic_model_type = "virtio"
        libvirt.storage :file, bus: "virtio", cache: "writeback"
        libvirt.video_type = "virtio"
      end
    
      config.vm.provider :virtualbox do |virtualbox|
        virtualbox.cpus = 2
        virtualbox.memory = 8192
        virtualbox.customize ["modifyvm", :id, "--cpu-profile", "host"]
        virtualbox.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
      end
    
      config.vm.define "kube01" do |kube01|
        kube01.vm.hostname = "kube01"
        kube01.vm.provision :shell, inline: <<-SHELL
          systemctl stop guestfs-firstboot.service
          systemctl disable guestfs-firstboot.service
        SHELL
      end
    
      config.vm.define "kube02" do |kube02|
        kube02.vm.hostname = "kube02"
        kube02.vm.provision :shell, inline: <<-SHELL
          systemctl stop guestfs-firstboot.service
          systemctl disable guestfs-firstboot.service
        SHELL
      end
    
      config.vm.define "kube03" do |kube03|
        kube03.vm.hostname = "kube03"
        kube03.vm.provision :shell, inline: <<-SHELL
          systemctl stop guestfs-firstboot.service
          systemctl disable guestfs-firstboot.service
        SHELL
      end
    end
    EOF

Start all Vagrant instances:

    root@host:# vagrant up --provider=libvirt

All instances could be SSH and switch as root, e.g.

    root@host:# vagrant ssh kube01
    
    vagrant@kube01:~$ sudo su -

## Bootstrap Nodes

Gather the IP for each instances:

    root@host:# echo $(vagrant ssh kube01 -- ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2) kube01
    192.168.121.101 kube01
    
    root@host:# echo $(vagrant ssh kube02 -- ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2) kube02
    192.168.121.102 kube02
    
    root@host:# echo $(vagrant ssh kube03 -- ip a s eth0 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2) kube03
    192.168.121.103 kube03

Setup `/etc/hostname` for each nodes, e.g.

    root@kube01:~# hostnamectl set-hostname kube01
    
    root@kube02:~# hostnamectl set-hostname kube02
    
    root@kube03:~# hostnamectl set-hostname kube03

Setup `/etc/hosts` for each nodes, e.g.

    root@kube01:~# cat >> /etc/hosts <<-EOF
    192.168.121.101 kube01
    192.168.121.102 kube02
    192.168.121.103 kube03
    EOF
    
    root@kube02:~# cat >> /etc/hosts <<-EOF
    192.168.121.101 kube01
    192.168.121.102 kube02
    192.168.121.103 kube03
    EOF
    
    root@kube03:~# cat >> /etc/hosts <<-EOF
    192.168.121.101 kube01
    192.168.121.102 kube02
    192.168.121.103 kube03
    EOF

Test connectivity with ping:

    root@kube01:~# ping -c1 kube01
    PING kube01 (192.168.121.101) 56(84) bytes of data.
    64 bytes from kube01 (192.168.121.101): icmp_seq=1 ttl=64 time=0.016 ms
    --- kube01 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.016/0.016/0.016/0.000 ms
    
    root@kube01:~# ping -c1 kube02
    PING kube02 (192.168.121.102) 56(84) bytes of data.
    64 bytes from kube02 (192.168.121.102): icmp_seq=1 ttl=64 time=0.493 ms
    --- kube02 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.493/0.493/0.493/0.000 ms
    
    root@kube01:~# ping -c1 kube03
    PING kube03 (192.168.121.103) 56(84) bytes of data.
    64 bytes from kube03 (192.168.121.103): icmp_seq=1 ttl=64 time=0.448 ms
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
    Linux kube01 5.15.0-27-generic #28-Ubuntu SMP Thu Apr 14 04:55:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    
    root@kube01:~# ssh root@kube02 uname -a
    Linux kube02 5.15.0-27-generic #28-Ubuntu SMP Thu Apr 14 04:55:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    
    root@kube01:~# ssh root@kube03 uname -a
    Linux kube03 5.15.0-27-generic #28-Ubuntu SMP Thu Apr 14 04:55:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

## Bootstrap Ansible

Setup Ansible inventory and group variables:

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
    EOF
    
    cat > /etc/ansible/group_vars/all/99-packer.yml <<-EOF
    ---
    kube_release: "1.21"
    EOF

Test Ansible connectivity:

    root@kube01:~# ansible all -m shell -a "uname -a"
    kube01 | CHANGED | rc=0 >>
    Linux kube01 5.15.0-27-generic #28-Ubuntu SMP Thu Apr 14 04:55:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    kube02 | CHANGED | rc=0 >>
    Linux kube02 5.15.0-27-generic #28-Ubuntu SMP Thu Apr 14 04:55:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    kube03 | CHANGED | rc=0 >>
    Linux kube03 5.15.0-27-generic #28-Ubuntu SMP Thu Apr 14 04:55:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

## Deploy Kubernetes

Deploy kubernetes

    root@kube01:~# cd /etc/ansible
    
    root@kube01:~# ansible-playbook playbooks/verify.yml
    
    root@kube01:~# ansible-playbook playbooks/60-kube_cilium-install.yml

Check result:

    root@kube01:~# kubectl get node
    NAME     STATUS   ROLES                  AGE     VERSION
    kube01   Ready    control-plane,master   9m38s   v1.21.12
    kube02   Ready    control-plane,master   8m32s   v1.21.12
    kube03   Ready    <none>                 8m14s   v1.21.12
    
    root@kube01:~# kubectl get pod --all-namespaces
    NAMESPACE     NAME                              READY   STATUS    RESTARTS   AGE
    kube-system   cilium-ggspc                      1/1     Running   0          36s
    kube-system   cilium-hxrxv                      1/1     Running   0          44s
    kube-system   cilium-operator-89b8c57bc-8wbc4   1/1     Running   0          50s
    kube-system   cilium-r5j5k                      1/1     Running   0          46s
    kube-system   coredns-558bd4d5db-mtp98          1/1     Running   0          49s
    kube-system   coredns-558bd4d5db-xjm66          1/1     Running   0          49s
    kube-system   kube-addon-manager-kube01         1/1     Running   0          49s
    kube-system   kube-addon-manager-kube02         1/1     Running   0          49s
    kube-system   kube-apiserver-kube01             1/1     Running   1          49s
    kube-system   kube-apiserver-kube02             1/1     Running   1          49s
    kube-system   kube-controller-manager-kube01    1/1     Running   1          49s
    kube-system   kube-controller-manager-kube02    1/1     Running   1          49s
    kube-system   kube-proxy-j4zh8                  1/1     Running   0          36s
    kube-system   kube-proxy-wtnj5                  1/1     Running   0          46s
    kube-system   kube-proxy-z9psl                  1/1     Running   0          45s
    kube-system   kube-scheduler-kube01             1/1     Running   1          49s
    kube-system   kube-scheduler-kube02             1/1     Running   1          48s

Rolling reboot all nodes for new CNI:

    root@kube01:~# cd /etc/ansible
    
    root@kube01:~# ansible-playbook playbooks/reboot.yml

## Run Sonobuoy

Run sonobuoy for conformance test as official procedure
(<https://github.com/cncf/k8s-conformance/blob/master/instructions.md>):

    root@kube01:~# sonobuoy run --mode=certified-conformance
    
    root@kube01:~# sonobuoy status
    
    root@kube01:~# sonobuoy retrieve
