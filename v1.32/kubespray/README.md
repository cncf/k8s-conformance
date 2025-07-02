Download and install Kubespray 2.28.0
```shell
$ git clone https://github.com/kubernetes-sigs/kubespray.git
$ cd kubespray
$ git checkout v2.28.0
```

Install Kubespray’s python dependencies

```shell
pip install -r requirements.txt
```

Create vagrant configuration

```shell
$ mkdir -p vagrant
$ cat > ./vagrant/config.rb <<__EOF__
$instance_name_prefix = "kube"
$vm_cpus = 4
$vm_memory = 4096
$num_instances = 3
$os = "ubuntu2404"
$subnet = "10.2.20"
$inventory = "inventory/k8s-conformance"
$network_plugin = "calico"
__EOF__
$ mkdir -p inventory/k8s-conformance
```

Start vagrant deployment and access kube-master
```shell
$ vagrant up
$ vagrant ssh kube-1
```

Run [Sonobuoy](https://github.com/heptio/sonobuoy) as instructed [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).

```shell
$ sudo -i
$ curl -sfL -O  https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
$ tar -xzvf sonobuoy_0.57.3_linux_amd64.tar.gz
$ ./sonobuoy run --mode=certified-conformance --wait
$ ./sonobuoy status
$ ./sonobuoy retrieve
```
