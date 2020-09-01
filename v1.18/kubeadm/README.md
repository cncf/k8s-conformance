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
- Provision a base image with:
  - Docker
  - Kubernetes + Kubeadm
  - Sonobuoy
  - Dependent Docker Images for Kubeadm / CNI / Conformance
- Setup 3 Ubuntu 18.04 LTS vm's (1 controlplane, 2 workers) each with 2 CPUs and 2GB of RAM
- Disable swap
- Bootstrap a multi-node Kubernetes cluster with upstream kubeadm
- Use Weave Net for the third-party networking layer (this is pluggable)
- Configure kubeconfig
- Start the Conformance testing suite via the Sonobuoy CLI
- Block until the tests finish
- Extract the results into a folder you can access on your host machine

The virtualbox provider is assumed.  
If you're not using vagrant, copy the provision script from the **SHELL** heredocs, and modify as needed for use on your target machine(s). Keep in mind you may need to substitute values for the Ruby interpolations. `ie: #{v_k8s}`
```ruby
Vagrant.configure("2") do |config|
  folder     = "v1.18"
  apt_docker = "18.09.7-0ubuntu1~18.04.4"
  apt_k8s    = "1.18.0-00"
  v_k8s      = "1.18.0"
  v_sonobuoy = "0.18.0"
  
  os_image = "bento/ubuntu-18.04"
  base_image = "k8s-#{v_k8s}"

  config.vm.box = "#{base_image}"
  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = "2"
    vb.memory = "2048"
  end

  num_controlplane = 1 # at the moment, scripts only support 1
  num_workers      = 2

  node_slash_24_prefix = "192.168.5."
  pod_network = "10.96.0.0/16"
  cni_manifest = "https://cloud.weave.works/k8s/v#{v_k8s}/net" # installs Weave Net

  install = <<~SHELL
    set -ex
    export DEBIAN_FRONTEND=noninteractive
    aptGet='apt-get -q'
    # Make sure curl and apt SSL support is available
    ${aptGet} update && ${aptGet} install -y apt-transport-https curl
    # Download sonobuoy
    curl -sSL https://github.com/heptio/sonobuoy/releases/download/v#{v_sonobuoy}/sonobuoy_#{v_sonobuoy}_linux_amd64.tar.gz | tar -xz --exclude LICENSE -C /usr/bin
    # Add the Kubernetes apt signing key and repository
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    # Install kubeadm, kubelet, kubectl and docker
    ${aptGet} update && ${aptGet} install -y \
      docker.io=#{apt_docker} \
      kubelet=#{apt_k8s} \
      kubectl=#{apt_k8s} \
      kubeadm=#{apt_k8s}
    # Pre-pull kubeadm images
    kubeadm config images pull --kubernetes-version v#{v_k8s}
    # Pre-pull CNI images
    curl -L #{cni_manifest} | grep image | tr -d "'" | awk '{print $2}' | xargs -n1 docker pull
    # Pre-pull conformance images
    for img in $(sonobuoy images --kubernetes-version v#{v_k8s}); do
      echo $img
      docker pull $img || true # authenticated and invalid images will fail -- this is fine, because the other images will still save a lot of bandwidth
    done
  SHELL

  config.vm.define "base-image", autostart: false do |baseimage|
    baseimage.vm.box = "#{os_image}"
    baseimage.vm.provision "shell", inline: install
    baseimage.trigger.after :up do |trigger|
      trigger.run  = {inline: "bash -c 'vagrant package base-image --output #{base_image}.box && vagrant box add #{base_image} #{base_image}.box'"}
    end
  end

  setup = <<~SHELL
    set -ex
    # Disable swap, it must not be used when Kubernetes is running
    swapoff -a
    sed -i /swap/d /etc/fstab
    # Enable the docker systemd service
    systemctl enable docker.service
    # Pre-configure the kubelet to bind to eth1
    #   ref: https://github.com/kubernetes/kubeadm/issues/203#issuecomment-335416377
    eth1_ip=$(ifconfig eth1 | awk '$1 == "inet" {print $2}')
    echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=${eth1_ip}\"" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    # Route the cluster CIDR via eth1
    #   ref: https://github.com/kubernetes/kubeadm/issues/102#issuecomment-291532883
    echo "---
    network:
      version: 2
      ethernets:
        eth1:
          routes:
          - to: #{pod_network} 
            via: 0.0.0.0
    " > /etc/netplan/90-k8s-services-eth1.yaml
    netplan apply
  SHELL

  kubeadm_init = <<~SHELL
    set -ex
    # Configure kubectl for the kubeadm kubeconfig
    export KUBECONFIG=/etc/kubernetes/admin.conf
    echo "
      export KUBECONFIG=/etc/kubernetes/admin.conf
      alias k="kubectl"
      alias ks="kubectl -n kube-system"
      alias kt="kubectl -n heptio-sonobuoy"
    " >> /etc/bash.bashrc
    # Init the cluster
    eth1_ip=$(ifconfig eth1 | awk '$1 == "inet" {print $2}')
    stat $KUBECONFIG || kubeadm init \
      --kubernetes-version v#{v_k8s} \
      --apiserver-advertise-address "${eth1_ip}" \
      --pod-network-cidr #{pod_network} \
      --token abcdef.0123456789abcdef
    # Install the Pod networking solution
    kubectl apply -f "#{cni_manifest}"
    # Make this control plane node able to run normal workloads
    kubectl taint nodes --all node-role.kubernetes.io/master- || true # fails if already untainted
  SHELL

  kubeadm_join_async = <<~SHELL
    set -ex
    # Join the cluster asynchronously
    nohup sh -c "
      until kubeadm join \\
        --token abcdef.0123456789abcdef \\
        --discovery-token-unsafe-skip-ca-verification \\
        #{node_slash_24_prefix}#{10 + 1}:6443
      do sleep 2
      done
    " >> /var/log/kubeadm_join_async.log 2>&1 & disown
  SHELL

  sonobuoy = <<~SHELL
    set -ex
    echo "Waiting for all nodes to join..."
    export KUBECONFIG=/etc/kubernetes/admin.conf
    num_expected="#{ [0,num_controlplane].max + [0,num_workers].max }"
    if timeout 300 sh -c "
        until kubectl get nodes -oname | wc -l | grep "^$num_expected$"
        do echo -n .; sleep 2
        done
      "
    then echo "All nodes joined the cluster"
    else echo "Timed out waiting for all nodes to join the cluster" 1>&2 && exit 1
    fi
    echo "Waiting for all nodes to be ready..."
    if timeout 100 sh -c "
        while kubectl get nodes | grep NotReady
        do echo -n .; sleep 2
        done
      "
    then echo "All nodes are now Ready"
    else echo "Timed out waiting for all nodes to become Ready" 1>&2 && exit 2
    fi
    echo "Waiting for all pods to run..."
    if timeout 100 sh -c "
        while kubectl get pods --all-namespaces | grep ContainerCreating
        do echo -n .; sleep 2
        done
      "
    then echo "All pods are now running"
    else echo "Timed out waiting for all pods to run" 1>&2 && exit 2
    fi
    # Run end to end tests
    sonobuoy run --wait --skip-preflight
    # Fetch the results
    results=$(sonobuoy retrieve)
    # Extract to the host machine
    mkdir -p /vagrant/#{folder}
    tar xzf $results -C /vagrant/#{folder}
    # Print
    sonobuoy e2e $results
  SHELL

  (1..num_workers).each do |i|
    config.vm.define "worker-#{i}" do |worker|
      worker.vm.hostname = "worker-#{i}"
      worker.vm.network "private_network", ip: "#{node_slash_24_prefix}#{100 + i}"
      worker.vm.provision "shell", inline: setup
      worker.vm.provision "shell", inline: kubeadm_join_async
    end
  end

  (1..num_controlplane).each do |i|
    config.vm.define "controlplane-#{i}" do |controlplane|
      controlplane.vm.hostname = "controlplane-#{i}"
      controlplane.vm.network "private_network", ip: "#{node_slash_24_prefix}#{10 + i}"
      controlplane.vm.provision "shell", inline: setup
      controlplane.vm.provision "shell", inline: kubeadm_init
      controlplane.vm.provision "shell", inline: sonobuoy
    end
  end

end
```

## Start Vagrant and SSH into it

Make a new folder somewhere, and paste the `Vagrantfile` in there, and start the VM like this:

```bash
mkdir conformance-results
cd conformance-results
## save Vagrantfile in this directory ##
# provision the base image and run the conformance cluster if provisioning succeeds
vagrant up --provision base-image \
  && vagrant up
```

## Observe Sonobuoy

Running all the conformance tests often takes an hour or two.

```bash
# in a separate shell once sonobuoy is running
vagrant ssh controlplane-1 -- -tt sudo bash
# you now have a root shell on the vagrant vm

## watch cluster state
watch kubectl get all --all-namespaces
## watch sonobuoy
sonobuoy status
sonobuoy logs -f
  # e2e test logs only show up if you run this after the pod becomes ready
```

## Collect the Conformance Results

If the `vagrant up` exits without error, you've run through the test suites!
Look for the message: `failed tests: 0`

Your results have been untarred to `conformance-results/v1.18/` on your host machine. (`/vagrant` is a shared folder)

The needed test files are:
- `conformance-results/v1.18/plugins/e2e/results/e2e.log`
- `conformance-results/v1.18/plugins/e2e/results/junit_01.xml`

## Cleanup

```bash
# on the host
cd conformance-results
vagrant destroy --force
```
