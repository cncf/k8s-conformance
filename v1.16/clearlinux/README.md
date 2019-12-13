# Conformance tests for Clear Linux



To be able to reproduce these results, you can create a 3-node vagrant setup following the instructions below. These instructions are copied from the [example page](https://github.com/clearlinux/cloud-native-setup/tree/master/clr-k8s-examples) on github. 

You may also use any installation of Clear Linux with the [cloud-native-basic bundle](https://clearlinux.org/software/bundle/cloud-native-basic) installed in order to reproduce these results. Further information on running Kubernetes on Clear Linux using the cloud-native-basic bundle may be found on the [Clear Linux documentation site](https://docs.01.org/clearlinux/latest/tutorials/kubernetes.html).



## Install Vagrant

On Clear Linux host, run these commands

```sh
sudo swupd update
```

Make sure all the prerequisite packages are installed

```sh
sudo swupd bundle-add unzip rsync wget kvm-host
```

Install the Vagrant on Clear Linux

```sh
wget https://raw.githubusercontent.com/AntonioMeireles/ClearLinux-packer/master/extras/clearlinux/setup/libvirtd.sh
chmod +x libvirtd.sh
./libvirtd.sh
wget https://raw.githubusercontent.com/AntonioMeireles/ClearLinux-packer/master/extras/clearlinux/setup/vagrant.sh
chmod +x vagrant.sh
./vagrant.sh
```

Clone the cloud-native-setup repo
```sh
git clone https://github.com/clearlinux/cloud-native-setup.git
```


Run vagrant up
```sh
cd cloud-native-setup/clr-k8s-examples/
vagrant up --provider=libvirt
```

Once the `vagrant up` command completes, you will have a 3 node cluster, each of them having 4 vCPU, 8GB Memory, 2x10GB disks, and 1 additional private network. In addition the Vagrant command will have run the setup_system.sh script

This setup_system.sh  script ensures the following

- Clear Linux is updated to the latest version
- Installs the bundles the Clearlinux needs to support Kubernetes, CRIO and Kata
- Customizes the system to ensure correct defaults are setup (IP Forwarding, Swap off,...)
- Ensures all the dependencies are loaded on boot (kernel modules)

> NOTE: This script uses the runtime specified in the `RUNNER` environment variable and defaults to `crio`. To use the `containerd` runtime, set the `RUNNER` environment variable to `containerd` prior to the `vagrant up`.



## Bring up the master

Login to the master node, change to the cloud-native-setup directory, and run create_stack.sh

```sh
vagrant ssh clr-01
cd clr-k8s-examples
./create_stack.sh minimal
```



## Join Workers to the cluster

On workers just use the join command that the master spits out. There nothing
else you need to run on the worker. All the other Kubernetes customizations are pushed
in from master via the values setup in the `kubeadm.yaml` file.

```sh
vagrant ssh clr-02
sudo su
kubeadm join <master-ip>:<master-port> --token <token> --discovery-token-ca-cert-hash <hash>
```

```sh
vagrant ssh clr-03
sudo su
kubeadm join <master-ip>:<master-port> --token <token> --discovery-token-ca-cert-hash <hash>
```



## Run Conformance Test

The conformance tests are run according to the [instructions](https://github.com/vmware-tanzu/sonobuoy/) found on the Sonobuoy github.

1. Download Sonobuoy:

```sh
vagrant ssh clr-01
mkdir $HOME/bin
VERSION=0.16.5 OS=linux && \
    curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_${OS}_amd64.tar.gz" --output $HOME/bin/sonobuoy.tar.gz && \
    tar -xzf $HOME/bin/sonobuoy.tar.gz -C $HOME/bin && \
    chmod +x $HOME/bin/sonobuoy && \
    rm $HOME/bin/sonobuoy.tar.gz
```

2. Run sonobuoy:
```sh
$HOME/bin/sonobuoy run --mode=certified-conformance --wait
```

3. Check the status:
```sh
sonobuoy status
```

4. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
sonobuoy retrieve
```



## Cleaning up the cluster (Hard reset to a clean state)

Run `reset_stack.sh` on all the nodes


