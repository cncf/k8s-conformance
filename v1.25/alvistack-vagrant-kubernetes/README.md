# AlviStack - Vagrant Box Packaging for Kubernetes

For running k8s conformance test we need 2 vagrant instances as master
and 1 vagrant instance as node with following minimal system
requirement, e.g.

-   host
    -   libvirt
    -   nested virtualization enabled
    -   Ubuntu 22.04
    -   8 CPUs
    -   32GB RAM
-   `kube01`
    -   kubernetes master, etcd
    -   cri-o, cilium
    -   Ubuntu 22.04
    -   IP: 192.168.121.101/24
    -   2 CPUs
    -   8GB RAM
-   `kube02`
    -   kubernetes master, etcd
    -   cri-o, cilium
    -   Ubuntu 22.04
    -   IP: 192.168.121.102/24
    -   2 CPUs
    -   8GB RAM
-   `kube03`
    -   kubernetes node, etcd
    -   cri-o, cilium
    -   Ubuntu 22.04
    -   IP: 192.168.121.103/24
    -   2 CPUs
    -   8GB RAM

## Bootstrap Host

Install some basic pacakges for host:

    apt update
    apt full-upgrade
    apt install -y aptitude git linux-generic-hwe-22.04 openssh-server python3 pwgen rsync vim

Install Libvirt:

    apt update
    apt install -y binutils bridge-utils dnsmasq-base ebtables gcc libarchive-tools libguestfs-tools libvirt-clients libvirt-daemon-system libvirt-dev make qemu-system qemu-utils ruby-dev virt-manager

Install Vagrant:

    echo "deb [arch=amd64] https://apt.releases.hashicorp.com jammy main" | tee /etc/apt/sources.list.d/hashicorp.list
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/hashicorp.gpg > /dev/null
    apt update
    apt install -y vagrant
    vagrant plugin install vagrant-libvirt

## Bootstrap Ansible

Install Ansible (see
<https://software.opensuse.org/download/package?package=ansible&project=home%3Aalvistack>):

    echo "deb http://download.opensuse.org/repositories/home:/alvistack/xUbuntu_22.04/ /" | tee /etc/apt/sources.list.d/home:alvistack.list
    curl -fsSL https://download.opensuse.org/repositories/home:alvistack/xUbuntu_22.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_alvistack.gpg > /dev/null
    apt update
    apt install -y ansible python3-ansible-lint python3-docker python3-netaddr python3-vagrant

Install Molecule:

    echo "deb http://download.opensuse.org/repositories/home:/alvistack/xUbuntu_22.04/ /" | tee /etc/apt/sources.list.d/home:alvistack.list
    curl -fsSL https://download.opensuse.org/repositories/home:alvistack/xUbuntu_22.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_alvistack.gpg > /dev/null
    apt update
    apt install -y python3-molecule python3-molecule-docker python3-molecule-vagrant

GIT clone Vagrant Box Packaging for Kubernetes
(<https://github.com/alvistack/vagrant-kubernetes>):

    mkdir -p /opt/vagrant-kubernetes
    cd /opt/vagrant-kubernetes
    git init
    git remote add upstream https://github.com/alvistack/vagrant-kubernetes.git
    git fetch --all --prune
    git checkout upstream/develop -- .
    git submodule sync --recursive
    git submodule update --init --recursive

## Deploy Kubernetes

Deploy kubernetes:

    cd /opt/vagrant-kubernetes
    export _MOLECULE_INSTANCE_NAME="$(pwgen -1AB 12)"
    molecule converge -s kubernetes-1.25-libvirt -- -e 'kube_release=1.25'
    molecule verify -s kubernetes-1.25-libvirt

All instances could be SSH and switch as root with `sudo su -`, e.g.

    cd /opt/vagrant-kubernetes
    molecule login -s kubernetes-1.25-libvirt -h $_MOLECULE_INSTANCE_NAME-1

Check result:

    root@kube01:~# kubectl get node
    NAME     STATUS   ROLES           AGE     VERSION
    kube01   Ready    control-plane   3h41m   v1.25.12
    kube02   Ready    control-plane   3h40m   v1.25.12
    kube03   Ready    <none>          3h36m   v1.25.12

    root@kube01:~# kubectl get pod --all-namespaces
    NAMESPACE     NAME                             READY   STATUS    RESTARTS   AGE
    kube-system   cilium-2cncz                     1/1     Running   0          3h36m
    kube-system   cilium-9tkfg                     1/1     Running   0          3h39m
    kube-system   cilium-node-init-8b7n2           1/1     Running   0          3h39m
    kube-system   cilium-node-init-979mb           1/1     Running   0          3h36m
    kube-system   cilium-node-init-s84z5           1/1     Running   0          3h39m
    kube-system   cilium-operator-59d7d77cdc-lppbd 1/1     Running   0          3h39m
    kube-system   cilium-r4lc4                     1/1     Running   0          3h39m
    kube-system   coredns-565d847f94-5nh2n         1/1     Running   0          3h38m
    kube-system   coredns-565d847f94-qqvf6         1/1     Running   0          3h38m
    kube-system   kube-addon-manager-kube01        1/1     Running   0          3h40m
    kube-system   kube-addon-manager-kube02        1/1     Running   0          3h40m
    kube-system   kube-apiserver-kube01            1/1     Running   0          3h41m
    kube-system   kube-apiserver-kube02            1/1     Running   0          3h40m
    kube-system   kube-controller-manager-kube01   1/1     Running   0          3h41m
    kube-system   kube-controller-manager-kube02   1/1     Running   0          3h40m
    kube-system   kube-proxy-22s9q                 1/1     Running   0          3h36m
    kube-system   kube-proxy-cm4qg                 1/1     Running   0          3h40m
    kube-system   kube-proxy-d66m7                 1/1     Running   0          3h40m
    kube-system   kube-scheduler-kube01            1/1     Running   0          3h41m
    kube-system   kube-scheduler-kube02            1/1     Running   0          3h40m

## Run Sonobuoy

Run sonobuoy for conformance test as official procedure
(<https://github.com/cncf/k8s-conformance/blob/master/instructions.md>):

    root@kube01:~# sonobuoy run --mode=certified-conformance

    root@kube01:~# sonobuoy status

    root@kube01:~# sonobuoy retrieve
