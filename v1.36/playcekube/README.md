# PlayceKube — Kubernetes v1.36 Conformance

[PlayceKube](https://playcecloud.gitbook.io/osci-docs/playcecloud/playcekube) is a Kubernetes distribution for on-premises environments developed by [Open Source Consulting Inc.](https://osci.kr/). It packages kubespray in a containerized deploy environment together with recommended default settings, and manages add-ons with Helm charts. It can also serve its own package repository and container registry for offline (air-gapped) installation; this conformance run was performed in an online environment.

## Test environment

| Item | Value |
|---|---|
| PlayceKube version | 1.0 |
| Kubernetes version | v1.36.4 (kubeadm, `imageRepository: registry.k8s.io`) |
| Node OS | Rocky Linux 10.2 (Red Quartz), kernel 6.12.0-211.65.1.el10_2.x86_64 |
| Container runtime | containerd 2.3.5, cgroup driver systemd |
| etcd | kubeadm-managed static pods on the 3 control-plane nodes |
| CNI | Cilium v1.20.2 — VXLAN tunnel, cluster-pool IPAM, L2 announcements and Gateway API enabled, kube-proxy replacement disabled |
| kube-proxy | v1.36.4, `nftables` mode, `strictARP: true` |
| DNS | CoreDNS v1.14.2 + cluster-proportional dns-autoscaler (nodelocaldns disabled) |
| Storage | NFS CSI driver v4.13.5 (`nfs.csi.k8s.io`), StorageClass `nfs-csi` set as default |
| Other add-ons | metrics-server v0.9.0 (Helm chart 3.14.0), Gateway API CRDs |
| Control-plane endpoint | `api.k8s.local.cloud:6443` (DNS / hosts entry, `loadbalancer_apiserver_localhost: false`) |
| Pod / Service CIDR | 10.233.64.0/18 / 10.233.0.0/18 |
| Nodes | 3 control-plane (k8s-master01..03) + 2 worker (k8s-worker01..02), 4 vCPU / 8 GB RAM each |
| Platform | KVM virtual machines on an on-premises OpenStack cloud |

## Reproducing the results

The steps below summarize how the cluster was deployed with PlayceKube. See the [PlayceKube documentation](https://playcecloud.gitbook.io/osci-docs/playcecloud/playcekube) for details.

### 1. Prepare the nodes

Create six Rocky Linux 10 VMs on the same L2 network: three control-plane nodes, two workers and one deploy server. Register the control-plane endpoint name on every node (or in DNS):

```bash
echo "<control-plane-endpoint-ip> api.k8s.local.cloud" >> /etc/hosts
```

### 2. Start the PlayceKube deploy environment

On the deploy server, install containerd / nerdctl and start the PlayceKube deploy container, which contains kubespray, ansible, kubectl and helm.

```bash
nerdctl -n default run -td --network host \
  -v /playcecloud:/playcecloud \
  -v /var/run/containerd:/var/run/containerd \
  --name playcekube playcecloud/kubespray-deploy:<version> /bin/bash

alias playcekube='nerdctl -n default exec -it playcekube /bin/bash'
```

### 3. Configure the inventory

Inside the container, copy the sample inventory and edit it for the target nodes.

```bash
playcekube
cp -rp /kubespray/inventory/sample /playcecloud/env/kubespray/k8s
```

`inventory.ini`

```ini
[all]
k8s-master01 ansible_host=<ip>
k8s-master02 ansible_host=<ip>
k8s-master03 ansible_host=<ip>
k8s-worker01 ansible_host=<ip>
k8s-worker02 ansible_host=<ip>

[kube_control_plane]
k8s-master01
k8s-master02
k8s-master03

[etcd:children]
kube_control_plane

[kube_node]
k8s-worker01
k8s-worker02
```

`group_vars` values that differ from the kubespray defaults:

```yaml
# group_vars/all/all.yml
loadbalancer_apiserver_localhost: false
apiserver_loadbalancer_domain_name: api.k8s.local.cloud
loadbalancer_apiserver:
  address: <control-plane-endpoint-ip>
  port: 6443

# group_vars/all/etcd.yml
etcd_deployment_type: kubeadm

# group_vars/k8s_cluster/k8s-cluster.yml
kube_version: v1.36.4
kube_network_plugin: cilium
kube_proxy_mode: nftables
kube_proxy_strict_arp: true
enable_nodelocaldns: false
supplementary_addresses_in_ssl_keys: [api.k8s.local.cloud]
auto_renew_certificates: true

# group_vars/k8s_cluster/k8s-net-cilium.yml
cilium_version: v1.20.2
cilium_kube_proxy_replacement: false
cilium_l2announcements: true
cilium_gateway_api_enabled: true
cilium_enable_portmap: true
cilium_extra_values:
  securityContext:
    privileged: true
  nodePort:
    enabled: true

# group_vars/k8s_cluster/addons.yml
helm_enabled: true
gateway_api_enabled: true
```

### 4. Deploy the cluster

```bash
playcekube
cd /kubespray
ansible-playbook -i /playcecloud/env/kubespray/k8s/inventory.ini cluster.yml
```

### 5. Install metrics-server

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server

cat << EOF > metrics-server-override.yaml
defaultArgs:
  - --cert-dir=/tmp
  - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
  - --kubelet-use-node-status-port
  - --metric-resolution=15s
  - --kubelet-insecure-tls
EOF

helm upgrade --install -n kube-system --create-namespace \
  metrics-server metrics-server/metrics-server \
  -f metrics-server-override.yaml
```

Verify that metrics are collected:

```bash
kubectl top node
kubectl top pod -A
```

### 6. Install the storage add-on

Install the NFS CSI driver with Helm and create a default StorageClass backed by an NFS server reachable from all nodes.

```bash
helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts

cat << EOF > csi-driver-nfs-override.yaml
controller:
  runOnMaster: false
  runOnControlPlane: true

storageClass:
  create: true
  name: nfs-csi
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  parameters:
    server: <nfs-server-ip>
    share: <nfs-export-path>
  reclaimPolicy: Retain
  volumeBindingMode: Immediate
  mountOptions:
    - hard
EOF

helm upgrade --install --create-namespace --namespace kube-system \
  csi-driver-nfs csi-driver-nfs/csi-driver-nfs \
  -f csi-driver-nfs-override.yaml
```

Verify the cluster before testing:

```bash
kubectl get nodes -o wide
kubectl get pods -n kube-system
kubectl get storageclass
```

### 7. Run the conformance tests

Install the Sonobuoy CLI (v0.57.5 was used) and run the tests in certified-conformance mode.

```bash
sonobuoy run --mode=certified-conformance --wait
sonobuoy status
```

### 8. Retrieve the results

```bash
outfile=$(sonobuoy retrieve)
mkdir ./results
tar xzf $outfile -C ./results
```

`e2e.log` and `junit_01.xml` in `./results/plugins/e2e/results/global/` are the files submitted here.

### 9. Clean up

```bash
sonobuoy delete --wait
```

## Result

```
Ran 446 of 7579 Specs in 9703.471 seconds
SUCCESS! -- 446 Passed | 0 Failed | 0 Pending | 7133 Skipped
```