# Kubespray v2.32.0 - Kubernetes v1.36 Conformance

Kubernetes v1.36.4 deployed with Kubespray v2.32.0 on three Ubuntu 24.04 VMs
(arm64) using the Calico network plugin.

## Download and install Kubespray 2.32.0

```shell
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git checkout v2.32.0

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
\$vm_memory = 4096
\$vm_cpus = 2
\$os = "ubuntu2404"
\$network_plugin = "calico"
\$instance_name_prefix = "kube"
\$subnet = "192.168.56"
__EOF__
```

`$kube_node_instances` is left at its default, so all three nodes join
`kube_node` and the conformance suite has three schedulable nodes.

Note: For ARM64 (Apple Silicon), use `$os = "ubuntu2404"` with the VirtualBox
provider (VirtualBox 7.1 or later).

## Start the deployment

Bring the nodes up one at a time. Booting them concurrently can starve the
guests during boot, leaving `systemd-networkd` failed and tasks blocked.

```shell
export PATH="$PWD/.venv/bin:$PATH"

vagrant up kube-1 --no-provision --provider=virtualbox
vagrant up kube-2 --no-provision
vagrant up kube-3 --no-provision

# Kubespray's Vagrantfile attaches the Ansible provisioner only to the last
# node (kube-3). Provisioning kube-3 runs cluster.yml against all three nodes,
# which deploys Kubernetes on kube-1, kube-2, and kube-3 in a single run.
vagrant provision kube-3
```

## Retrieve the kubeconfig

`admin.conf` points to `127.0.0.1`, so the server address is replaced with the
IP of `kube-1` to reach the API server from the host. The `sed -i ''` syntax is
for macOS; on Linux, use `sed -i` instead.

```shell
vagrant ssh kube-1 -c "sudo cat /etc/kubernetes/admin.conf" | tr -d '\r' > ./kube-kubeconfig
sed -i '' 's|server: https://127.0.0.1:6443|server: https://192.168.56.101:6443|' ./kube-kubeconfig
export KUBECONFIG=$PWD/kube-kubeconfig

kubectl get nodes -o wide
kubectl version -o json | jq -r .serverVersion.gitVersion
```

```
NAME     STATUS   ROLES           VERSION
kube-1   Ready    control-plane   v1.36.4
kube-2   Ready    <none>          v1.36.4
kube-3   Ready    <none>          v1.36.4
```

## Run the conformance tests

Because the nodes are arm64, the arm64 systemd-logs image is used.

```shell
sonobuoy run --mode=certified-conformance \
  --systemd-logs-image=sonobuoy/systemd-logs-arm64:v0.4
sonobuoy status
```

Sonobuoy v0.57.5 was used. The run took 1h55m55s.

## Retrieve the results

```shell
outfile=$(sonobuoy retrieve)
mkdir -p results && tar -xzf "$outfile" -C results
sonobuoy results "$outfile"
```

```
Plugin: e2e
Status: passed
Total: 7586
Passed: 453
Failed: 0
Skipped: 7133

Run Details:
API Server version: v1.36.4
Node health: 3/3 (100%)
Pods health: 22/22 (100%)
```

```
Ran 446 of 7579 Specs in 6955.080 seconds
SUCCESS! -- 446 Passed | 0 Failed | 0 Pending | 7133 Skipped
Test Suite Passed
```

The `e2e.log` and `junit_01.xml` in this directory come from
`results/plugins/e2e/results/global/`.

## Clean up

```shell
sonobuoy delete --wait
vagrant destroy -f
```
