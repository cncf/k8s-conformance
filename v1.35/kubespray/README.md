# Kubespray v2.31.0 - Kubernetes v1.35 Conformance

Kubernetes v1.35.4 deployed with Kubespray v2.31.0 on three Ubuntu 24.04 VMs
using the Calico network plugin.

## Download and install Kubespray 2.31.0

```shell
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git checkout v2.31.0

python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

## Create the Vagrant configuration

```shell
mkdir -p vagrant
cat > ./vagrant/config.rb <<__EOF__
\$num_instances = 3
\$control_plane_instances = 1
\$etcd_instances = 1
\$vm_memory = 2048
\$vm_cpus = 2
\$os = "ubuntu2404"
\$network_plugin = "calico"
\$instance_name_prefix = "conf"
\$subnet = "192.168.56"
__EOF__
```

`$kube_node_instances` is left at its default, so all three nodes join
`kube_node` and the conformance suite has three schedulable nodes.

The subnet is `192.168.56` because VirtualBox restricts host-only networks to
`192.168.56.0/21` unless `/etc/vbox/networks.conf` says otherwise, and because
the Vagrantfile default of `172.18.8` collides with Docker's bridge networks on
a typical developer machine.

## Start the deployment

Bring the nodes up one at a time. Booting them concurrently can starve the
guests during boot, leaving `systemd-networkd` failed and tasks blocked.

```shell
export PATH="$PWD/.venv/bin:$PATH"

vagrant up conf-1 --no-provision --provider=virtualbox
vagrant up conf-2 --no-provision
vagrant up conf-3 --no-provision

# the Vagrantfile attaches the Ansible provisioner to the last node only,
# so this runs cluster.yml against all three
vagrant provision conf-3
```

## Retrieve the kubeconfig

```shell
vagrant ssh conf-1 -c "sudo cat /etc/kubernetes/admin.conf" | tr -d '\r' > ./conf-kubeconfig
sed -i 's|server: https://127.0.0.1:6443|server: https://192.168.56.101:6443|' ./conf-kubeconfig
export KUBECONFIG=$PWD/conf-kubeconfig

kubectl get nodes -o wide
kubectl version -o json | jq -r .serverVersion.gitVersion
```

```
NAME     STATUS   ROLES           VERSION
conf-1   Ready    control-plane   v1.35.4
conf-2   Ready    <none>          v1.35.4
conf-3   Ready    <none>          v1.35.4
```

## Run the conformance tests

```shell
sonobuoy run --mode=certified-conformance
sonobuoy status
```

Sonobuoy v0.57.5 was used. The run took 2h8m46s.

## Retrieve the results

```shell
outfile=$(sonobuoy retrieve)
mkdir -p results && tar -xzf "$outfile" -C results
sonobuoy results "$outfile"
```

```
Plugin: e2e
Status: passed
Total: 7360
Passed: 446
Failed: 0
Skipped: 6914

Run Details:
API Server version: v1.35.4
Node health: 3/3 (100%)
Pods health: 23/23 (100%)
```

```
Ran 441 of 7355 Specs in 7724.949 seconds
SUCCESS! -- 441 Passed | 0 Failed | 0 Pending | 6914 Skipped
Test Suite Passed
```

The `e2e.log` and `junit_01.xml` in this directory come from
`results/plugins/e2e/results/global/`.

## Clean up

```shell
sonobuoy delete --wait
vagrant destroy -f
```
