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
- Setup 3 Ubuntu 18.04 LTS vm's (1 controlplane, 2 workers) each with 2 CPUs and 2GB of RAM
- Disable swap
- Install the Sonobuoy CLI tool
- Install Docker
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
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = "2"
    vb.memory = "2048"
  end

  folder     = "v1.14"
  apt_docker = "18.09.5-0ubuntu1~18.04.2"
  apt_k8s    = "1.14.2-00"
  v_k8s      = "1.14.2"
  v_sonobuoy = "0.14.2"

  num_controlplane = 1 # at the moment, scripts only support 1
  num_workers      = 2

  install = <<~SHELL
    set -ex
    # Make sure curl and apt SSL support is available
    apt-get update && apt-get install -y apt-transport-https curl
    # Download sonobuoy
    curl -sSL https://github.com/heptio/sonobuoy/releases/download/v#{v_sonobuoy}/sonobuoy_#{v_sonobuoy}_linux_amd64.tar.gz | tar -xz --exclude LICENSE -C /usr/bin
    # Add the Kubernetes apt signing key and repository
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    # Install kubeadm, kubelet, kubectl and docker
    apt-get update && apt-get install -y \
      docker.io=#{apt_docker} \
      kubelet=#{apt_k8s} \
      kubectl=#{apt_k8s} \
      kubeadm=#{apt_k8s}
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
    cat << EOF > /etc/netplan/90-k8s-services-eth1.yaml
    ---
    network:
      version: 2
      ethernets:        
        eth1:
          routes:
          - to: 10.96.0.0/16
            via: 0.0.0.0
    EOF
    netplan apply
  SHELL

  kubeadm_init = <<~SHELL
    set -ex
    # Configure kubectl for the kubeadm kubeconfig
    export KUBECONFIG=/etc/kubernetes/admin.conf
    cat << EOF >> /etc/bash.bashrc
      export KUBECONFIG=/etc/kubernetes/admin.conf
      alias k="kubectl"
      alias ks="kubectl -n kube-system"
      alias kt="kubectl -n heptio-sonobuoy"
    EOF
    # Init the cluster
    eth1_ip=$(ifconfig eth1 | awk '$1 == "inet" {print $2}')
    stat $KUBECONFIG || kubeadm init \
      --kubernetes-version v#{v_k8s} \
      --apiserver-advertise-address "${eth1_ip}" \
      --pod-network-cidr 10.96.0.0/16 \
      --token abcdef.0123456789abcdef
    # Install Weave Net as the Pod networking solution
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 -w0)"
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
        192.168.5.#{10 + 1}:6443
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
    sonobuoy run --wait
    # Fetch the results
    results=$(sonobuoy retrieve)
    # Extract to the host machine
    mkdir -p /vagrant/#{folder}
    tar xzf $results -C /vagrant/#{folder}
    # Print
    sonobuoy e2e $results
  SHELL

  config.vm.provision "shell", inline: install

  (1..num_workers).each do |i|
    config.vm.define "worker-#{i}" do |worker|
      worker.vm.hostname = "worker-#{i}"
      worker.vm.network "private_network", ip: "192.168.5.#{100 + i}"
      worker.vm.provision "shell", inline: kubeadm_join_async
    end
  end

  (1..num_controlplane).each do |i|
    config.vm.define "controlplane-#{i}" do |controlplane|
      controlplane.vm.hostname = "controlplane-#{i}"
      controlplane.vm.network "private_network", ip: "192.168.5.#{10 + i}"
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
vagrant up
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

Your results have been untarred to `conformance-results/v1.14/` on your host machine. (`/vagrant` is a shared folder)

The needed test files are:
- `conformance-results/v1.14/plugins/e2e/results/e2e.log`
- `conformance-results/v1.14/plugins/e2e/results/junit_01.xml`

## Cleanup

```bash
# on the host
cd conformance-results
vagrant destroy --force
```
