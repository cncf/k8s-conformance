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
- install docker
- install a single node k8s cluster with upstream kubeadm, and Weave Net
- configure kubeconfig
- start Sonobuoy /w e2e kube-conformance via [sonobuoy-conformance.yaml](../../sonobuoy-conformance.yaml)

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
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    apt-get update && apt-get install -y \
      docker.io=1.13.1-0ubuntu6 \
      kubelet=1.11.0-00 \
      kubectl=1.11.0-00 \
      kubeadm=1.11.0-00
    
    swapoff -a
    systemctl enable docker.service

    kubeadm init --kubernetes-version 1.11.0
    export KUBECONFIG=/etc/kubernetes/admin.conf
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bash.bashrc
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    kubectl taint nodes --all node-role.kubernetes.io/master-

    curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
  SHELL
end
```

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
## follow sonobuoy logs
kubectl -n sonobuoy logs sonobuoy -f
## follow sonobuoy e2e kube-conformance logs
kubectl -n sonobuoy logs sonobuoy-e2e-job-${AUTOGEN_JOB_ID} -c e2e -f
```

## Generate version.txt
**Important:** do this before conformance tests finish or the pod will die.
```bash
# as root on vagrantbox
mkdir -p /vagrant/v1.11
kubectl exec -it -n sonobuoy sonobuoy-e2e-job-${AUTOGEN_JOB_ID} -c e2e kubectl version > /vagrant/v1.11/version.txt
```

## Untar the Conformance Results
When you see `level=info msg="no-exit was specified, sonobuoy is now blocking"` in the sonobuoy logs, you can fetch your test results.
The sonobuoy container is hanging so we can copy the tarball to our vagrantbox from its EmptyDir:
```bash
# as root on the vagrantbox
# grep the results path from the sonobuoy log
RESULTS_TAR=$(kubectl -n sonobuoy logs sonobuoy | grep "Results available" | grep -o '/tmp/[^"]*')
cd /vagrant/v1.11
kubectl -n sonobuoy cp sonobuoy:${RESULTS_TAR} sonobuoy.tar.gz
tar -xvf sonobuoy.tar.gz
```
Your untarred results and `version.txt` should now be in `conformance-results/v1.11/` on your host machine. (`/vagrant` is a shared folder)

The needed test files are:
- `conformance-results/v1.11/version.txt`
- `conformance-results/v1.11/plugins/e2e/results/e2e.log`
- `conformance-results/v1.11/plugins/e2e/results/junit_01.xml`


## Cleanup
```bash
# on the host
cd conformance-results
vagrant destroy --force
```
