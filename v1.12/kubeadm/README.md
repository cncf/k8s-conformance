# kubeadm
Official documentation:
 - https://kubernetes.io/docs/setup/independent/install-kubeadm/
 - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/


# Reproduce Conformance Results:

## Pre-Reqs
- vagrant + virtualbox

## Provision
The following Vagrantfile will:
- setup an Ubuntu 17.10 vm with 4 CPUs and 4GB of RAM
- disable swap
- install golang
- build the sonobuoy cli
- install docker
- install a single node k8s cluster with upstream kubeadm, and Weave Net
- configure kubeconfig
- start sonobuoy via the cli

The virtualbox provider is assumed.  
If you're not using vagrant, copy the provision script from the **SHELL** heredoc, and modify as needed for use on your target machine. 
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-17.10"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = "4"
    vb.memory = "4096"
  end

  config.vm.provision "shell", inline: <<-SHELL
    #!/bin/sh
    set -ex
    
    apt-get update && apt-get install -y apt-transport-https curl
    
    goversion="1.10.4"
    curl --silent -O https://storage.googleapis.com/golang/go${goversion}.linux-amd64.tar.gz
    tar -C /usr/local -xf go${goversion}.linux-amd64.tar.gz
    echo 'export GOPATH=$HOME/go' >> ~/.profile
    echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.profile
    source ~/.profile

    go get github.com/heptio/sonobuoy

    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    apt-get update && apt-get install -y \
      docker.io=1.13.1-0ubuntu6 \
      kubelet=1.12.0-00 \
      kubectl=1.12.0-00 \
      kubeadm=1.12.0-00
    
    swapoff -a
    sed -i /swap/d /etc/fstab
    systemctl enable docker.service

    kubeadm init --kubernetes-version 1.12.0
    export KUBECONFIG=/etc/kubernetes/admin.conf
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bash.bashrc
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    kubectl taint nodes --all node-role.kubernetes.io/master-

    sleep 30 # wait for kubernetes components to converge
    sonobuoy run
  SHELL
end
```

## Shell
```bash
mkdir conformance-results
cd conformance-results
## save Vagrantfile in this directory ##
vagrant up && vagrant ssh -- -tt sudo bash
  # you now have a root shell on the vagrant vm
```

## Observe Sonobuoy
```bash
# as root on vagrantbox
## watch cluster state
watch kubectl get all --all-namespaces
## watch sonobuoy
sonobuoy status
sonobuoy logs -f
  # e2e test logs only show up if you run this after the pod becomes ready
```

## Untar the Conformance Results
When you see `level=info msg="no-exit was specified, sonobuoy is now blocking"` in the sonobuoy logs, you can fetch your test results.
The sonobuoy container is hanging so we can copy the tarball to our vagrantbox from its EmptyDir:
```bash
# as root on the vagrantbox
mkdir -p /vagrant/v1.12
cd /vagrant/v1.12
sonobuoy retrieve
tar -xvf *_sonobuoy_*.tar.gz
```
Your untarred results and `version.txt` should now be in `conformance-results/v1.12/` on your host machine. (`/vagrant` is a shared folder)

The needed test files are:
- `conformance-results/v1.12/plugins/e2e/results/e2e.log`
- `conformance-results/v1.12/plugins/e2e/results/junit_01.xml`


## Cleanup
```bash
# on the host
cd conformance-results
vagrant destroy --force
```
