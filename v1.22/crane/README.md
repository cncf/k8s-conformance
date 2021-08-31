# Conformance tests for Crane Kubernetes

## Setup the Crane and the Kubernetes cluster

First install Crane by documentation [documentation](https://github.com/slzcc/crane/blob/master/docs/INSTALL.md).

Or use videos to describe the installation process [videos](https://asciinema.org/a/uyVFgcNEUiv9AciahaTFCRvM6)

1. System Requirements
* Operating system of CentOS 7.x or Ubuntu 2x.xx .   
* Hard disk: minimal 30 GB available disk space (40GB+ recommended, increasing based on the needs of your container workloads)
* 2 CPUs or more
* If the host cannot access the Internet at all, Modify it in the file `crane/group_vars/all.yml` in `Http_proxy` and `https_proxy` to continue.
* No CRI needs to be installed per cluster.  
* The SELinux and Firewall deployment process is closed.

2. Access to the source code
```sh
$ git clone https://github.com/slzcc/crane.git && cd crane
```

3. Set kube-apiserver VIP or LB IP address
```sh
$ sed -i "s/k8s_load_balance_ip:.*/k8s_load_balance_ip: 1.2.3.4/g" crane/group_vars/all.yml
```

4. Set the nic driver name (Because calico is used as a third-party network by default, this operation can be ignored if Cilium is used)
```sh
$ sed -i "s/os_network_device_name:.*/os_network_device_name: 'ens4'/g" crane/group_vars/all.yml
```

5. Set nodePortAddresses in kube-proxy
```sh
$ sed -i "s/kube_proxy_node_port_addresses:.*/kube_proxy_node_port_addresses: ['10.140.0.0\/24']/g" crane/group_vars/all.yml
```

6. Set up the machine list (non-Sudo users available)
```sh
$ cat > crane/nodes <<EOF
[kube-master]
10.140.0.1

[kube-node]
[etcd]
10.140.0.1

[all:vars]
ansible_ssh_public_key_file='~/.ssh/id_rsa.pub'
ansible_ssh_private_key_file='~/.ssh/id_rsa'
ansible_ssh_port=22
ansible_ssh_user=shilei

...
EOF
```

7. Install Crane
```sh
$ make run_main
```

8. Check Kubernetes Cluster
```sh
$ kubectl get node
NAME         STATUS   ROLES                  AGE     VERSION
instance-1   Ready    control-plane,master   21h   v1.22.1
```

## Run Conformance Test

1. Download a binary release of [sonobuoy](https://github.com/heptio/sonobuoy/releases), or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

2. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

3. Check the status:
```sh
$ sonobuoy status
```

4. Once the status shows the run as completed, you can download the results archive by running:
```sh
$ sonobuoy retrieve
```
