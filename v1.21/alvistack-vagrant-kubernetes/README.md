# AlviStack - Vagrant Box Packaging for Kubernetes

For running k8s conformance test we need a host, 2 vagrant instances as
master and 1 vagrant instance as node with following minimal system
requirement, e.g.

  - host
      - libvirt (or virtualbox)
      - nested virtualization enabled
      - Ubuntu 20.04
      - 8 CPUs
      - 32GB RAM
  - `kube01`
      - kubernetes master, etcd
      - cri-o, weave
      - 2 CPUs
      - 8GB RAM
  - `kube02`
      - kubernetes master, etcd
      - cri-o, weave
      - 2 CPUs
      - 8GB RAM
  - `kube03`
      - kubernetes node, etcd
      - cri-o, weave
      - 2 CPUs
      - 8GB RAM

## Bootstrap Host

Install some basic pacakges for host:

    root@host:~# apt update
    root@host:~# apt full-upgrade
    root@host:~# apt install aptitude git linux-generic-hwe-20.04 openssh-server python3 rsync vim

Install Libvirt:

    root@host:~# echo "deb http://ppa.launchpad.net/savoury1/virtualisation/ubuntu focal main" | tee /etc/apt/sources.list.d/savoury1.list
    root@host:~# curl -fsSL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xE996735927E427A733BB653E374C7797FB006459" | gpg --dearmor | tee /etc/apt/trusted.gpg.d/savoury1.gpg > /dev/null
    root@host:~# apt-get update
    root@host:~# apt-get install -y binutils bridge-utils dnsmasq-base ebtables gcc libarchive-tools libguestfs-tools libvirt-clients libvirt-daemon-system libvirt-dev make qemu-system qemu-utils ruby-dev virt-manager

Install Vagrant:

    root@host:# echo "deb [arch=amd64] https://apt.releases.hashicorp.com focal main" | tee /etc/apt/sources.list.d/hashicorp.list
    root@host:# curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/hashicorp.gpg > /dev/null
    root@host:# apt-get update
    root@host:# apt-get install -y vagrant

## Create Vagrant Instance

Create `Vagrantfile`:

    root@host:# mkdir /tmp/vagrant-kubernetes
    
    root@host:# cd /tmp/vagrant-kubernetes
    
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

    root@kube01:~# echo "kube01" > /etc/hostname
    
    root@kube02:~# echo "kube02" > /etc/hostname
    
    root@kube03:~# echo "kube03" > /etc/hostname

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
    64 bytes from kube01 (192.168.121.101): icmp_seq=1 ttl=64 time=0.089 ms
    --- kube01 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.089/0.089/0.089/0.000 ms
    
    root@kube01:~# ping -c1 kube02
    PING kube02 (192.168.121.102) 56(84) bytes of data.
    64 bytes from kube02 (192.168.121.102): icmp_seq=1 ttl=64 time=0.754 ms
    --- kube02 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.754/0.754/0.754/0.000 ms
    
    root@kube01:~# ping -c1 kube03
    PING kube03 (192.168.121.103) 56(84) bytes of data.
    64 bytes from kube03 (192.168.121.103): icmp_seq=1 ttl=64 time=0.472 ms
    --- kube03 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.472/0.472/0.472/0.000 ms

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

Test Ansible connectivity:

    root@kube01:~# ansible all -m shell -a "uname -a"
    kube01 | CHANGED | rc=0 >>
    Linux kube01 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    kube02 | CHANGED | rc=0 >>
    Linux kube02 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    kube03 | CHANGED | rc=0 >>
    Linux kube03 5.13.0-39-generic #44~20.04.1-Ubuntu SMP Thu Mar 24 16:43:35 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

## Deploy Kubernetes

Deploy kubernetes

    root@kube01:~# cd /etc/ansible
    
    root@kube01:~# ansible-playbook playbooks/verify.yml
    
    root@kube01:~# ansible-playbook playbooks/60-kube_weave-install.yml

Check result:

    root@kube01:~# kubectl get node
    NAME     STATUS   ROLES                  AGE   VERSION
    kube01   Ready    control-plane,master   84s   v1.21.11
    kube02   Ready    control-plane,master   55s   v1.21.11
    kube03   Ready    <none>                 24s   v1.21.11
    
    root@kube01:~# kubectl get pod --all-namespaces
    NAMESPACE     NAME                             READY   STATUS    RESTARTS   AGE
    kube-system   coredns-558bd4d5db-56v55         1/1     Running   0          100s
    kube-system   coredns-558bd4d5db-5b29v         1/1     Running   0          101s
    kube-system   kube-addon-manager-kube01        1/1     Running   0          49s
    kube-system   kube-addon-manager-kube02        1/1     Running   0          49s
    kube-system   kube-apiserver-kube01            1/1     Running   0          102s
    kube-system   kube-apiserver-kube02            1/1     Running   0          88s
    kube-system   kube-controller-manager-kube01   1/1     Running   0          102s
    kube-system   kube-controller-manager-kube02   1/1     Running   0          89s
    kube-system   kube-proxy-9fk6p                 1/1     Running   0          89s
    kube-system   kube-proxy-df6jq                 1/1     Running   0          100s
    kube-system   kube-proxy-wqc8w                 1/1     Running   0          58s
    kube-system   kube-scheduler-kube01            1/1     Running   0          116s
    kube-system   kube-scheduler-kube02            1/1     Running   0          62s
    kube-system   weave-net-cnxgm                  2/2     Running   1          42s
    kube-system   weave-net-dmd7g                  2/2     Running   1          42s
    kube-system   weave-net-l89lb                  2/2     Running   1          42s

Rolling reboot all nodes for new CNI:

    root@kube01:~# cd /etc/ansible
    
    root@kube01:~# ansible-playbook playbooks/reboot.yml

## Run Sonobuoy

Run sonobuoy for conformance test as official procedure
(<https://github.com/cncf/k8s-conformance/blob/master/instructions.md>):

    root@kube01:~# sonobuoy run --mode=certified-conformance
    
    root@kube01:~# sonobuoy status
    
    root@kube01:~# sonobuoy retrieve
