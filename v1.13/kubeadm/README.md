# kubeadm

Official documentation:
 - https://kubernetes.io/docs/setup/independent/install-kubeadm/
 - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

By following these steps you may reproduce the kubeadm Conformance e2e
results.

## Requirements

- Vagrant + Virtualbox

Note that any other supported environment mentioned in the official documentation
should also work when reproducing these results. The following is just an example.

## Provision a VM to run tests in with Vagrant

The following Vagrantfile will:
- Setup an Ubuntu 17.10 vm with 4 CPUs and 4GB of RAM
- Disable swap
- Install the Sonobuoy CLI tool
- Install Docker
- Install a single node Kubernetes cluster with upstream kubeadm
- Use Weave Net for the third-party networking layer (this is pluggable)
- Configure kubeconfig
- Start the Conformance testing suite via the Sonobuoy CLI

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
    # Make sure curl and apt SSL support is available
    apt-get update && apt-get install -y apt-transport-https curl
    # Download sonobuoy
    curl -sSL https://github.com/heptio/sonobuoy/releases/download/v0.13.0/sonobuoy_0.13.0_linux_amd64.tar.gz | tar -xz --exclude LICENSE -C /usr/bin
    # Add the Kubernetes apt signing key and repository
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    # Install kubeadm, kubelet, kubectl and docker
    apt-get update && apt-get install -y \
      docker.io=1.13.1-0ubuntu6 \
      kubelet=1.13.0-00 \
      kubectl=1.13.0-00 \
      kubeadm=1.13.0-00
    # Disable swap, it must not be used when Kubernetes is running
    swapoff -a
    sed -i /swap/d /etc/fstab
    # Enable the docker systemd service
    systemctl enable docker.service
    # Bootstrap a v1.13 cluster
    kubeadm init --kubernetes-version v1.13.0
    # Make kubectl use the kubeconfig file with credentials to the cluster
    export KUBECONFIG=/etc/kubernetes/admin.conf
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bash.bashrc
    # Install Weave Net as the Pod networking solution
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    # Make this control plane node able to run normal workloads
    kubectl taint nodes --all node-role.kubernetes.io/master-
    # Wait for kubernetes components to initialize correctly
    sleep 30
    # Start running end to end tests
    sonobuoy run
  SHELL
end
```

## Start Vagrant and SSH into it

Make a new folder somewhere, and paste the `Vagrantfile` in there, and start the VM like this:

```bash
mkdir conformance-results
cd conformance-results
## save Vagrantfile in this directory ##
vagrant up && vagrant ssh -- -tt sudo bash
# you now have a root shell on the vagrant vm
```

## Observe Sonobuoy

Running all the conformance tests often take about an hour.

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
mkdir -p /vagrant/v1.13
cd /vagrant/v1.13
sonobuoy retrieve
tar -xvf *_sonobuoy_*.tar.gz
kubectl version > version.txt
```

Your untarred results should now be in `conformance-results/v1.13/` on your host machine. (`/vagrant` is a shared folder)

The needed test files are:
- `conformance-results/v1.13/version.txt`
- `conformance-results/v1.13/plugins/e2e/results/e2e.log`
- `conformance-results/v1.13/plugins/e2e/results/junit_01.xml`

## Cleanup

```bash
# on the host
cd conformance-results
vagrant destroy --force
```
