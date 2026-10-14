# Kubespray v2.30.0 - Kubernetes v1.34 Conformance

Download and install Kubespray 2.30.0
```shell
git clone https://github.com/kubernetes-sigs/kubespray.git
git checkout v2.30.0
```

Create vagrant configuration

```shell
mkdir -p vagrant
cat > ./vagrant/config.rb <<__EOF__
$instance_name_prefix = "kube"
$vm_cpus = 2
$vm_memory = 4096
$num_instances = 3
$os = "ubuntu2404"
$subnet = "10.2.20"
$inventory = "inventory/k8s-conformance"
$network_plugin = "calico"
__EOF__
mkdir -p inventory/k8s-conformance
```

Note: For ARM64 (Apple Silicon/M1), use `$os = "ubuntu2404"` with VMware Fusion provider.

Start vagrant deployment and access kube-master
```shell
$ vagrant up
$ vagrant ssh kube-1
```

Fix DNS on ALL nodes (required for Ubuntu/Fedora with systemd-resolved):

The kubelet requires `/run/systemd/resolve/resolv.conf` to exist. After disabling systemd-resolved, create a symlink to the static resolv.conf.

**Run on each node (kube-1, kube-2, kube-3):**
```shell
$ vagrant ssh kube-1  # Repeat for kube-2, kube-3
$ sudo systemctl stop systemd-resolved
$ sudo systemctl disable systemd-resolved
$ sudo rm -f /etc/resolv.conf
$ echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4' | sudo tee /etc/resolv.conf
$ sudo mkdir -p /run/systemd/resolve
$ sudo ln -sf /etc/resolv.conf /run/systemd/resolve/resolv.conf
$ sudo systemctl restart containerd kubelet
```

**Note:** Wait 2-3 minutes after applying the fix for the cluster to stabilize before running Sonobuoy.

Run [Sonobuoy](https://github.com/vmware-tanzu/sonobuoy) as instructed [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).

```shell
$ sudo -i
# curl -sfL -O https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.2/sonobuoy_0.57.2_linux_arm64.tar.gz
# tar -xzvf sonobuoy_0.57.2_linux_arm64.tar.gz
# export SONOBUOY_IMAGE_VERSION=v0.57
# export SONOBUOY_LOGS_IMAGE_VERSION=v0.4
# ./sonobuoy run --mode=certified-conformance \
    --sonobuoy-image=sonobuoy/sonobuoy:$SONOBUOY_IMAGE_VERSION \
    --systemd-logs-image=sonobuoy/systemd-logs-arm64:$SONOBUOY_LOGS_IMAGE_VERSION \
    --wait
# ./sonobuoy status
# ./sonobuoy retrieve
```
