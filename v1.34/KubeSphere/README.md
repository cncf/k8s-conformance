## How to Reproduce:
#### Provisioning a Kubernetes Cluster with KubeKey

**Step 1: Download KubeKey v4.0.3 and set executable permissions**
```shell
curl -sfL https://get-kk.kubesphere.io | sh -
```

**Step 2: Generate and Edit Your Cluster Inventory**
```shell
./kk create inventory -o .
```
The inventory file defines the nodes in your cluster and their grouping. Edit it to specify your cluster nodes and configuration as needed:
```yaml
apiVersion: kubekey.kubesphere.io/v1
kind: Inventory
metadata:
  name: default
  namespace: default
spec:
  groups:
    etcd:
      hosts:
      - scan-365lr3i
      vars: null
    image_registry:
      hosts: []
      vars: null
    k8s_cluster:
      groups:
      - kube_control_plane
      - kube_worker
      hosts: null
      vars: null
    kube_control_plane:
      hosts:
      - scan-365lr3i
      vars: null
    kube_worker:
      hosts:
      - scan-6lek66t
      - scan-rzmtjae
      vars: null
    nfs:
      hosts: []
      vars: null
  hosts:
    scan-6lek66t:
      connector:
        host: 192.168.6.19
      internal_ipv4: 192.168.6.19
      kubernetes:
        custom_labels: {}
    scan-365lr3i:
      connector:
        host: 192.168.6.16
      internal_ipv4: 192.168.6.16
      kubernetes:
        custom_labels: {}
    scan-rzmtjae:
      connector:
        host: 192.168.6.17
      internal_ipv4: 192.168.6.17
      kubernetes:
        custom_labels: {}
  vars: null

```

**Step 3: Generate and Edit Your Cluster Configuration**
```shell
./kk create config --with-kubernetes v1.34.3 -o .
```
The configuration file includes all common cluster settings, including ETCD, container runtimes, networking, storage, DNS, and more. Edit as required:
```yaml
apiVersion: kubekey.kubesphere.io/v1
kind: Config
spec:
  # If set to "cn", online downloads will prioritize domestic sources when available.
  zone: ""
  kubernetes:
    # Specify the Kubernetes version to be installed.
    kube_version: v1.34.3
    # Specify the Helm version to be installed.
    helm_version: v3.18.5
    # Tag for the sandbox (pause) image used by pods.
    sandbox_image:
      tag: "3.10.1"
    control_plane_endpoint:
      # Supported HA types: local, kube_vip, haproxy.
      # If set to local, configure local hostname resolution as follows:
      #   - Control-plane nodes: 127.0.0.1  .kubernetes.control_plane_endpoint.host
      #   - Worker nodes:  .init_kubernetes_node  .kubernetes.control_plane_endpoint.host
      type: local
      # Kube-vip image tag used for static pod deployment (when type is kube_vip).
      kube_vip:
        image:
          tag: v0.7.2
      # HAProxy image tag used for static pod deployment (when type is haproxy).
      haproxy:
        image:
          tag: 2.9.6-alpine
  etcd:
    # Specify the etcd version to be installed.
    etcd_version: v3.6.5
  image_registry:
    # Image registry type to install. Supported: harbor, docker-registry.
    # Leave empty to skip installation (assuming an existing registry is available).
    type: ""
    # auth:
    #   # Address of the private image registry
    #   registry: "dockerhub.kubekey.local"
    # Specify a VIP for image registry high availability. If set, enables HA.
    ha_vip: ""
    # ========== Image Registry - High Availability ==========
    # keepalived image tag for load balancing when multiple registry nodes exist.
    # keepalived_version: 2.0.20
    # ========== Image Registry - Harbor ==========
    # Harbor image tag (only valid if type is harbor).
    #harbor_version: v2.10.2
    # docker-compose binary
    #dockercompose_version: v2.20.3
    # ========== Image Registry - Docker Registry ==========
    # Docker Registry image tag (only valid if type is docker-registry).
    # docker_registry_version: 2.8.3
  cri:
    # Container runtime type. Supported: containerd, docker.
    container_manager: containerd
    # ========== CRI Tool ==========
    # crictl binary version.
    crictl_version: v1.34.0
    # ========== Docker Runtime ==========
    # Docker binary version.
    #docker_version: 25.0.5
    # cridockerd version (required for Kubernetes 1.24+).
    # cridockerd_version: v0.3.21
    # ========== Containerd Runtime ==========
    # containerd binary version (active only when container_manager is containerd).
    # containerd_version: v1.7.13
    # runc binary version (active only when container_manager is containerd).
    # runc_version: v1.1.12
  cni:
    # CNI plugin type. Supported: calico, cilium, flannel, hybridnet, kubeovn, other
    type: calico
    # ========== Multi-CNI ==========
    # Multi-CNI type. Supported: multus, spiderpool, none.
    multi_cni: none
    # ========== Multi-CNI - Multus ==========
    # Image tag for Multus (configure if needed).
    # multus:
    #   image:
    #    tag: v4.2.4
    # ========== Multi-CNI - Spiderpool ==========
    # Spiderpool version (configure if needed).
    # spiderpool_version: v1.1.1
    # ========== Calico CNI ==========
    # Calico version (effective only when type is calico).
    calico_version: v3.31.3
    # ========== Cilium CNI ==========
    # Cilium version (effective only when type is cilium).
    #cilium_version: 1.19.1
    # ========== Flannel CNI ==========
    # Flannel version (effective only when type is flannel).
    #flannel_version: v0.27.4
    # ========== Kube-OVN CNI ==========
    # Kube-OVN version (effective only when type is kubeovn).
    #kubeovn_version: v1.15.0
    # ========== Hybridnet CNI ==========
    # Hybridnet version (effective only when type is hybridnet).
    #hybridnet_version: 0.6.8
  storage_class:
    # ========== Storage Class Configuration ==========
    # ========== Local/OpenEBS Storage Class ==========
    # Local storage class settings.
    local:
      enabled: true   # Enable the local storage class.
      default: true   # Set as the default storage class.
    # openebs/dynamic-localpv-provisioner helm chart version.
    localpv_provisioner_version: 4.4.0
    # ========== NFS Storage Class ==========
    nfs:
      enabled: false  # Enable the NFS storage class.
    # nfs-provisioner Helm chart version.
    #nfs_provisioner_version: 4.0.18
  dns:
    # CoreDNS settings.
    coredns:
      image:
        tag: v1.12.1
    # NodeLocalDNS settings.
    nodelocaldns:
      enabled: true
      image:
        tag: 1.26.4
  # the external images will to add in packages
  image_manifests: []
```

**Step 4: Start the Installation**
It is recommended to run the installation as the root user. Create your Kubernetes cluster using your customized inventory and configuration files:
```shell
# create cluster
./kk create cluster -i inventory.yaml -c config-v1.33.7.yaml
```
You will see detailed step-by-step output from KubeKey as it prepares, installs, and configures your cluster. For example:

```shell
root@scan-yr1njmp:~# ./kk create cluster -i inventory.yaml -c config-v1.34.3.yaml 


 _   __      _          _   __           
| | / /     | |        | | / /           
| |/ / _   _| |__   ___| |/ /  ___ _   _ 
|    \| | | | '_ \ / _ \    \ / _ \ | | |
| |\  \ |_| | |_) |  __/ |\  \  __/ |_| |
\_| \_/\__,_|_.__/ \___\_| \_/\___|\__, |
                                    __/ |
                                   |___/

18:26:09 CST [Playbook default/create-cluster-gw28t] start
18:26:09 CST gather_facts
⠋ [scan-365lr3i] success  [0s] 
⠋ [localhost]    success  [0s] 
⠼ [scan-rzmtjae] success  [0s] 
⠴ [scan-6lek66t] success  [0s] 
18:26:10 CST [roles/native/root] OS | Add sudo secure path
⠋ [scan-365lr3i] success  [0s] 
⠋ [localhost]    success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:10 CST [playbooks/hook] Pre | Copy pre-installation scripts to remote hosts
⠋ [localhost]    skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:10 CST [playbooks/hook] Pre | Copy pre-installation config scripts to remote hosts
⠋ [localhost]    skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:10 CST [playbooks/hook] Pre | Execute pre-installation scripts on remote hosts
⠋ [localhost]    success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:10 CST gather_facts
⠋ [localhost]    success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠹ [scan-rzmtjae] success  [0s] 
⠹ [scan-6lek66t] success  [0s] 
18:26:11 CST [roles/defaults] Defaults | Reset temporary directory
⠋ [scan-365lr3i] success  [0s] 
⠋ [localhost]    success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:11 CST [roles/defaults] Defaults | Load version-specific settings for Kubernetes
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [localhost]    success  [0s] 
18:26:11 CST [roles/defaults] Defaults | Load default templates download
⠋ [localhost]    success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:11 CST [roles/defaults] Defaults | Determine operating system architecture for each node
⠋ [scan-rzmtjae] success  [0s] 
⠋ [localhost]    success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:26:11 CST [roles/defaults] Defaults | Get kubelet.service LoadState
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:11 CST [roles/defaults] Defaults | Get kubelet.service ActiveState
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:12 CST [roles/defaults] Defaults | Get installed Kubernetes version
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
18:26:12 CST [roles/defaults] Defaults | Get etcd.service LoadState and save to variable
⠋ [localhost]    skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:26:12 CST [roles/defaults] Defaults | Get etcd.service ActiveState and save to variable
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:26:12 CST [roles/defaults] Defaults | Get installed etcd version
⠋ [localhost]    skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:26:12 CST [roles/defaults] Defaults | Select the initialization node for the cluster
⠋ [scan-rzmtjae] success  [0s] 
18:26:12 CST [roles/precheck/inventory] Inventory | Kubernetes groups must not be empty
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/inventory] Inventory | etcd group must not be empty
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/inventory] Inventory | Fail if the number of etcd hosts is even
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/image-registry/network] Cert | Copy check shell
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/image-registry/network] Cert | Set cert check command
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/image-registry/network] Cert | Exec check shell with input certs
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/image-registry/network] Cert | Exec check shell with local certs
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/image-registry/network] Cert | Set auth ca
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    skip     [0s] 
18:26:12 CST [roles/precheck/artifact] Artifact | Validate artifact file extension
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:12 CST [roles/precheck/artifact] Artifact | Verify artifact MD5 checksum
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [localhost]    skip     [0s] 
18:26:12 CST [roles/precheck/cri] CRI | Fail if container manager is not docker or containerd
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/cri] CRI | Validate minimum required containerd version
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/cni] CNI | Validate calico version is allowed for the selected Kubernetes version
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    success  [0s] 
18:26:12 CST [roles/precheck/cni] CNI | Validate cilium version is allowed for the selected Kubernetes version
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    skip     [0s] 
18:26:12 CST [roles/precheck/cni] CNI | Validate kubeovn version is allowed for the selected Kubernetes version
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:12 CST [roles/precheck/cni] CNI | Ensure Spiderpool is only configured alongside Calico or Cilium networking plugins
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:12 CST [roles/precheck/storageclass] StorageClass | Fail if localpv provisioner version is unsupported
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [localhost]    skip     [0s] 
18:26:12 CST [roles/precheck/os] OS | Validate inventory hostname is RFC-compliant
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:26:13 CST [roles/precheck/os] OS | Validate current host system hostname is RFC-compliant
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/os] OS | Fail if operating system is not supported
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
18:26:13 CST [roles/precheck/os] OS | Fail if architecture is not supported
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
18:26:13 CST [roles/precheck/os] OS | Fail if master node memory is insufficient
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:26:13 CST [roles/precheck/os] OS | Fail if worker node memory is insufficient
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
18:26:13 CST [roles/precheck/os] OS | Fail if kernel version is too old
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [scan-rzmtjae] success  [0s] 
18:26:13 CST [roles/precheck/network] Network | Ensure either internal_ipv4 or internal_ipv6 is defined
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [localhost]    skip     [0s] 
18:26:13 CST [roles/precheck/network] Network | Ensure required network interfaces are present
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:13 CST [roles/precheck/network] Network | Check pod CIDR includes both IPv4 and IPv6
⠋ [scan-rzmtjae] success  [0s] 
18:26:13 CST [roles/precheck/network] Network | Check service CIDR includes both IPv4 and IPv6
⠋ [scan-rzmtjae] success  [0s] 
18:26:13 CST [roles/precheck/network] Network | Ensure pod networking is properly configured for dual-stack
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/network] Network | Ensure service networking is properly configured for dual-stack
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/network] Network | Fail if the selected network plugin is not supported
⠋ [scan-rzmtjae] success  [0s] 
18:26:13 CST [roles/precheck/network] Network | Ensure enough IPv4 addresses are available for pods
⠋ [scan-rzmtjae] success  [0s] 
18:26:13 CST [roles/precheck/network] Network | Ensure enough IPv6 addresses are available for pods
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/network] Network | Fail if Kubernetes version is too old for hybridnet
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/kubernetes] Kubernetes | Validate kube-vip address
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/kubernetes] Kubernetes | Fail if unsupported Kubernetes version
⠋ [scan-rzmtjae] success  [0s] 
18:26:13 CST [roles/precheck/kubernetes] Kubernetes | Ensure kubelet service is active
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    skip     [0s] 
18:26:13 CST [roles/precheck/kubernetes] Kubernetes | Ensure installed Kubernetes version matches expected version
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/etcd] Kubernetes | Fail if etcd deployment type is not "internal" or "external"
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/etcd] ETCD | Verify etcd minimum version for exact Kubernetes release
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/etcd] ETCD | Verify etcd minimum version for Kubernetes minor release
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/etcd] ETCD | Check if fio is installed
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] ignore   [0s] 
18:26:13 CST [roles/precheck/etcd] ETCD | Execute fio and collect results
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:13 CST [roles/precheck/etcd] ETCD | Assert disk fsync latency meets requirements
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:13 CST [roles/precheck/etcd] ETCD | Clean up fio test data directory
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:13 CST [roles/precheck/nfs] NFS | Fail if more than one NFS server is defined
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [localhost]    skip     [0s] 
18:26:13 CST [roles/certs/init] Cert | Generate the root CA certificate file
⠋ [localhost]    skip     [0s] 
18:26:13 CST [roles/certs/init] Cert | Generate the Kubernetes CA certificate file
⠋ [localhost]    skip     [0s] 
18:26:13 CST [roles/certs/init] Cert | Generate the front-proxy CA certificate for Kubernetes
⠋ [localhost]    skip     [0s] 
18:26:13 CST [roles/certs/init] Cert | Generate the etcd certificate file
⠋ [localhost]    success  [0s] 
18:26:14 CST [roles/certs/init] Cert | Generate the etcd client certificate file
⠙ [localhost]    success  [0s] 
18:26:14 CST [roles/certs/init] Cert | Generate the image registry certificate file
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/certs/init] Cert | Change ownership of the PKI directory to the sudo user
⠋ [localhost]    success  [0s] 
18:26:14 CST [roles/download] Artifact | Extract artifact archive to working directory
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Artifact | Load architecture-specific download URLs for each artifact version
⠋ [localhost]    success  [0s] 
18:26:14 CST [roles/download] Binary | Ensure etcd binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure Kubernetes kubelet binaries are present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure Kubernetes kubeadm binaries are present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure Kubernetes kubectl binaries are present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure CNI plugins are present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure Helm binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure crictl binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure Docker binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure cri-dockerd binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure containerd binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure runc binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure calicoctl binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure Docker Registry binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure docker-compose binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure Harbor binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Binary | Ensure keepalived binary is present
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Helm | Ensure the Calico binary is available
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Helm | Ensure the Cilium binary is available
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Helm | Ensure the Flannel binary is available
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Helm | Ensure the Kube-OVN binary is available
⠋ [localhost]    skip     [0s] 
18:26:14 CST [roles/download] Helm | Ensure the Hybridnet binary is available
⠋ [localhost]    skip     [0s] 
18:26:15 CST [roles/download] Helm | Ensure the localpv Provisioner binary is available
⠋ [localhost]    skip     [0s] 
18:26:15 CST [roles/download] Helm | Ensure the NFS Provisioner binary is available
⠋ [localhost]    skip     [0s] 
18:26:15 CST [roles/download] Helm | Ensure the Spiderpool binary is available
⠋ [localhost]    skip     [0s] 
18:26:15 CST [roles/download] Image | Download container images
⠙ [localhost]    success  [7s] 
18:26:22 CST [roles/download] ISO | Download ISO files
⠙ [localhost]    skip     [0s] 
18:26:22 CST [roles/download] Tools | Download tools to artifact directory
⠋ [localhost]    skip     [0s] 
18:26:22 CST [roles/download] Artifact | Set ownership of working directory to sudo user
⠋ [localhost]    success  [0s] 
18:26:22 CST [roles/native/repository] Repository | Prepare tmp files
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:22 CST [roles/native/repository] Repository | Check system version when use Kylin
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:22 CST [roles/native/repository] Repository | Define the system string based on distribution
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [scan-rzmtjae] success  [0s] 
18:26:22 CST [roles/native/repository] Repository | Define the package file type by system info
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:26:22 CST [roles/native/repository] Repository | Set iso file name
⠋ [scan-rzmtjae] success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
18:26:22 CST [roles/native/repository] Repository | Copy local repository ISO file
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
18:26:23 CST [roles/native/repository] Repository | Mount repository ISO to temporary directory
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:23 CST [roles/native/repository] Repository | Check current host debian or rhel
⠋ [scan-365lr3i] success  [0s] 
⠋ [scan-6lek66t] success  [0s] 
⠋ [scan-rzmtjae] success  [0s] 
18:26:23 CST [roles/native/repository] Repository | Initialize Debian-based repository and install required system packages
⠸ [scan-365lr3i] success  [3s] 
⠋ [scan-rzmtjae] success  [4s] 
⠴ [scan-6lek66t] success  [4s] 
18:26:27 CST [roles/native/repository] Repository | Initialize RHEL-based repository and install required system packages
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:28 CST [roles/native/repository] Repository | Unmount repository ISO from temporary directory
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:28 CST [roles/native/nfs] NFS | Generate NFS server export configuration
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:28 CST [roles/native/nfs] NFS | Ensure NFS share directories exist with correct permissions
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:28 CST [roles/native/nfs] NFS | Export share directories and start NFS server service
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:28 CST [roles/native/ntp] NTP | Configure NTP server
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:28 CST [roles/native/ntp] Timezone | Set system timezone and NTP synchronization
⠋ [scan-365lr3i] success  [0s] 
⠹ [scan-rzmtjae] success  [0s] 
⠹ [scan-6lek66t] success  [0s] 
18:26:28 CST [roles/native/ntp] NTP | Restart NTP service
⠼ [scan-6lek66t] success  [0s] 
⠼ [scan-365lr3i] success  [0s] 
⠼ [scan-rzmtjae] success  [0s] 
18:26:29 CST [roles/native/init] OS | Set system hostname
⠙ [scan-365lr3i] success  [0s] 
⠹ [scan-rzmtjae] success  [0s] 
⠹ [scan-6lek66t] success  [0s] 
18:26:29 CST [roles/native/init] OS | Reset gather_fact
⠋ [scan-365lr3i] success  [0s] 
⠹ [scan-rzmtjae] success  [0s] 
⠹ [scan-6lek66t] success  [0s] 
18:26:29 CST [roles/native/init] OS | Synchronize initialization script to remote node
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:30 CST [roles/native/init] OS | Execute initialization script on remote node
⠴ [scan-rzmtjae] success  [0s] 
⠏ [scan-365lr3i] success  [0s] 
⠹ [scan-6lek66t] success  [1s] 
18:26:31 CST [roles/native/dns] DNS | Ensure local DNS entries are up-to-date
⠙ [scan-365lr3i] success  [0s] 
⠹ [scan-6lek66t] success  [0s] 
⠸ [scan-rzmtjae] success  [0s] 
18:26:31 CST [roles/native/dns] DNS | Ensure image registry control plane endpoint DNS is current
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:32 CST [roles/native/dns] DNS | Set local DNS for kubernetes control plane endpoint
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Detect installed, to-install, and to-remove etcd nodes
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Ensure target etcd version is not lower than installed version
⠋ [scan-365lr3i] skip     [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Copy etcd binary package to node
⠋ [scan-365lr3i] skip     [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Extract etcd binaries to /usr/local/bin/
⠋ [scan-365lr3i] skip     [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Check if ETCD_FORCE_NEW_CLUSTER exists in etcd.env
⠋ [scan-365lr3i] skip     [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Remove ETCD_FORCE_NEW_CLUSTER and restart etcd
⠋ [scan-365lr3i] skip     [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Copy CA certificate to etcd node
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Copy server certificate to etcd node
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/prepare] Prepare | Copy server key to etcd node
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/install] Install | Render /etc/etcd.env configuration file
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/install] Install | Create etcd system user
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/install] Install | Create etcd data directory and set ownership
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/install] Install | Deploy etcd systemd service file
⠋ [scan-365lr3i] success  [0s] 
18:26:32 CST [roles/etcd/install] Install | Set CPU governor to performance mode
⠋ [scan-365lr3i] skip     [0s] 
18:26:32 CST [roles/etcd/install] Install | Configure network traffic priority for etcd
⠋ [scan-365lr3i] skip     [0s] 
18:26:32 CST [roles/etcd/install] Install | Start and enable etcd systemd service
⠹ [scan-365lr3i] success  [1s] 
18:26:34 CST [roles/etcd/install] Backup | Synchronize custom etcd backup script
⠋ [scan-365lr3i] success  [0s] 
18:26:34 CST [roles/etcd/install] Backup | Deploy systemd service for etcd backup
⠋ [scan-365lr3i] success  [0s] 
18:26:34 CST [roles/etcd/install] Backup | Deploy systemd timer for scheduled etcd backup
⠋ [scan-365lr3i] success  [0s] 
18:26:34 CST [roles/etcd/install] Backup | Reload systemd and enable etcd backup timer
⠦ [scan-365lr3i] success  [0s] 
18:26:35 CST [roles/image-registry/push] ImageRegistry | Ensure Harbor project exists for each image
⠋ [localhost]    skip     [0s] 
18:26:35 CST [roles/image-registry/push] ImageRegistry | Push images package to image registry
⠋ [localhost]    skip     [0s] 
18:26:35 CST gather_facts
⠋ [scan-365lr3i] success  [0s] 
⠹ [scan-rzmtjae] success  [0s] 
⠹ [scan-6lek66t] success  [0s] 
18:26:35 CST [roles/cri/crictl] Crictl | Verify if crictl is installed on the system
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
18:26:35 CST [roles/cri/crictl] Crictl | Copy crictl binary archive to the remote node
⠋ [scan-365lr3i] success  [0s] 
⠹ [scan-rzmtjae] success  [1s] 
⠸ [scan-6lek66t] success  [1s] 
18:26:37 CST [roles/cri/crictl] Crictl | Extract crictl binary to /usr/local/bin
⠼ [scan-365lr3i] success  [0s] 
⠴ [scan-rzmtjae] success  [0s] 
⠦ [scan-6lek66t] success  [0s] 
18:26:37 CST [roles/cri/crictl] Crictl | Generate crictl configuration file
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:37 CST [roles/cri/docker] Docker | Check if Docker is installed on the system
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Copy Docker binary archive to the remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Extract Docker binaries to /usr/local/bin
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Generate Docker configuration file
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Deploy the Docker systemd service file
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Deploy the containerd systemd service file
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Start and enable Docker and containerd services
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Copy image registry CA certificate to the remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Copy image registry server certificate to the remote node
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Docker | Copy image registry server key to the remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Cridockerd | Check if cri-dockerd is installed on the system
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:38 CST [roles/cri/docker] Cridockerd | Copy cri-dockerd binary archive to the remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Cridockerd | Extract cri-dockerd binary to /usr/local/bin
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:38 CST [roles/cri/docker] Cridockerd | Generate cri-dockerd systemd service file
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:38 CST [roles/cri/docker] Cridockerd | Start and enable the cri-dockerd service
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:26:38 CST [roles/cri/containerd] Containerd | Verify if runc is installed on the system
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
18:26:38 CST [roles/cri/containerd] Containerd | Ensure the runc binary is present on the remote node
⠋ [scan-365lr3i] success  [0s] 
⠇ [scan-rzmtjae] success  [0s] 
⠇ [scan-6lek66t] success  [0s] 
18:26:39 CST [roles/cri/containerd] Containerd | Check if containerd is installed on the system
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
18:26:39 CST [roles/cri/containerd] Containerd | Copy containerd binary archive to the remote node
⠹ [scan-365lr3i] success  [0s] 
⠋ [scan-rzmtjae] success  [3s] 
⠙ [scan-6lek66t] success  [3s] 
18:26:43 CST [roles/cri/containerd] Containerd | Extract containerd binaries to /usr/local/bin
⠸ [scan-365lr3i] success  [1s] 
⠴ [scan-rzmtjae] success  [1s] 
⠦ [scan-6lek66t] success  [1s] 
18:26:44 CST [roles/cri/containerd] Containerd | Generate the containerd configuration file
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:26:45 CST [roles/cri/containerd] Containerd | Deploy the containerd systemd service file
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:26:45 CST [roles/cri/containerd] Containerd | Start and enable the containerd service
⠧ [scan-365lr3i] success  [0s] 
⠹ [scan-rzmtjae] success  [1s] 
⠹ [scan-6lek66t] success  [1s] 
18:26:46 CST [roles/cri/containerd] Containerd | Copy image registry CA certificate to the remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:46 CST [roles/cri/containerd] Containerd | Copy image registry server certificate to the remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:46 CST [roles/cri/containerd] Containerd | Copy image registry server key to the remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:46 CST [roles/kubernetes/pre-kubernetes] Binary | Verify if Helm is already installed
⠹ [scan-365lr3i] success  [0s] 
⠸ [scan-rzmtjae] success  [0s] 
⠴ [scan-6lek66t] success  [0s] 
18:26:47 CST [roles/kubernetes/pre-kubernetes] Binary | Copy Helm archive to remote host
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:26:47 CST [roles/kubernetes/pre-kubernetes] Binary | Extract and install Helm binary
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:26:47 CST [roles/kubernetes/pre-kubernetes] Binary | Check if kubeadm is installed
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
18:26:47 CST [roles/kubernetes/pre-kubernetes] Binary | Install kubeadm if not present or version mismatch
⠸ [scan-365lr3i] success  [0s] 
⠧ [scan-rzmtjae] success  [4s] 
⠇ [scan-6lek66t] success  [4s] 
18:26:52 CST [roles/kubernetes/pre-kubernetes] Binary | Check if kubectl is installed
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
18:26:52 CST [roles/kubernetes/pre-kubernetes] Binary | Install kubectl if not present or version mismatch
⠸ [scan-365lr3i] success  [0s] 
⠧ [scan-rzmtjae] success  [3s] 
⠇ [scan-6lek66t] success  [3s] 
18:26:56 CST [roles/kubernetes/pre-kubernetes] Binary | Check if kubelet is installed
⠋ [scan-365lr3i] ignore   [0s] 
⠙ [scan-rzmtjae] ignore   [0s] 
⠙ [scan-6lek66t] ignore   [0s] 
18:26:56 CST [roles/kubernetes/pre-kubernetes] Binary | Copy kubelet binary to remote host
⠹ [scan-365lr3i] success  [0s] 
⠧ [scan-rzmtjae] success  [3s] 
⠇ [scan-6lek66t] success  [3s] 
18:27:00 CST [roles/kubernetes/pre-kubernetes] Binary | Deploy kubelet environment configuration
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:27:00 CST [roles/kubernetes/pre-kubernetes] Binary | Copy kubelet systemd service file
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:27:01 CST [roles/kubernetes/pre-kubernetes] Binary | Reload systemd and enable kubelet service
⠦ [scan-365lr3i] success  [0s] 
⠇ [scan-rzmtjae] success  [0s] 
⠇ [scan-6lek66t] success  [0s] 
18:27:01 CST [roles/kubernetes/pre-kubernetes] Binary | Copy CNI plugins archive to remote host
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:27:01 CST [roles/kubernetes/pre-kubernetes] Binary | Extract and install CNI plugins
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] Kubevip | Gather all network interfaces with CIDR addresses
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] Kubevip | Select network interface matching kube-vip address
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] Kubevip | Ensure matching network interface exists
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] Kubevip | Generate kube-vip manifest file
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] Haproxy | Generate HAProxy configuration file
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] Haproxy | Calculate MD5 checksum of HAProxy configuration
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] Haproxy | Generate HAProxy manifest for Kubernetes
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Ensure the 'kube' system user exists
⠋ [scan-365lr3i] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
⠙ [scan-6lek66t] success  [0s] 
18:27:02 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Create and set ownership for required Kubernetes directories
⠹ [scan-365lr3i] success  [0s] 
⠸ [scan-rzmtjae] success  [1s] 
⠸ [scan-6lek66t] success  [1s] 
18:27:03 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Synchronize audit policy file to remote node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:03 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy CA certificate to control plane node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:27:04 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy CA private key to control plane node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:04 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy etcd CA certificate to control plane node
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:04 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy etcd client certificate to control plane node
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:04 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy etcd client key to control plane node
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:04 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy front-proxy CA certificate to control plane node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:04 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy front-proxy CA private key to control plane node
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:04 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Add patches to kubeadm init and join
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:04 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Configure control_plane_endpoint in local DNS files
⠋ [scan-365lr3i] skip     [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:27:04 CST [roles/kubernetes/init-kubernetes] Init | Generate kubeadm initialization configuration
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:04 CST [roles/kubernetes/init-kubernetes] Init | Pre-initialization for kube-vip
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:27:04 CST [roles/kubernetes/init-kubernetes] Init | Run kubeadm init
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠦ [scan-365lr3i] success  [38s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] Init | Post-initialization for kube-vip
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] Init | Reset local DNS for control_plane_endpoint
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] Init | Copy kubeconfig to default directory
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] Init | Remove master/control-plane taints from node
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] Init | Add worker label to node
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] Init | Add custom annotations to node
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] DNS | Generate CoreDNS configuration file
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:43 CST [roles/kubernetes/init-kubernetes] DNS | Apply CoreDNS configuration and restart deployment
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠦ [scan-365lr3i] success  [0s] 
18:27:44 CST [roles/kubernetes/init-kubernetes] DNS | Generate NodeLocalDNS DaemonSet manifest
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:44 CST [roles/kubernetes/init-kubernetes] DNS | Deploy NodeLocalDNS DaemonSet
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠸ [scan-365lr3i] success  [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Kubernetes Already Installed
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Fetch kubeconfig to local workspace
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Generate certificate key using kubeadm
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠙ [scan-365lr3i] success  [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Distribute certificate key to all cluster hosts
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Generate kubeadm join token
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠙ [scan-365lr3i] success  [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Share kubeadm token with all cluster hosts
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Generate kube-proxy yaml
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:27:45 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Deploy kube-proxy
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:45 CST [roles/kubernetes/join-kubernetes] Join | Generate kubeadm join configuration file
⠋ [scan-365lr3i] skip     [0s] 
⠼ [scan-rzmtjae] success  [0s] 
⠼ [scan-6lek66t] success  [0s] 
18:27:46 CST [roles/kubernetes/join-kubernetes] Join | Execute kubeadm join to add node to the Kubernetes cluster
⠋ [scan-365lr3i] skip     [0s] 
⠇ [scan-rzmtjae] success  [6s] 
⠇ [scan-6lek66t] success  [6s] 
18:27:53 CST [roles/kubernetes/join-kubernetes] Join | Synchronize kubeconfig to remote node for root
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
18:27:53 CST [roles/kubernetes/join-kubernetes] Join | Set kubeconfig permissions
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:53 CST [roles/kubernetes/join-kubernetes] Join | Remove master and control-plane taints from node
⠋ [scan-365lr3i] skip     [0s] 
⠹ [scan-6lek66t] ignore   [0s] 
⠹ [scan-rzmtjae] ignore   [0s] 
18:27:53 CST [roles/kubernetes/join-kubernetes] Join | Add worker label to node
⠋ [scan-365lr3i] skip     [0s] 
⠙ [scan-6lek66t] success  [0s] 
⠙ [scan-rzmtjae] success  [0s] 
18:27:53 CST [roles/kubernetes/join-kubernetes] Join | Add custom annotations to node
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:53 CST [roles/kubernetes/join-kubernetes] Join | Reset local DNS on control plane nodes
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:54 CST [roles/kubernetes/join-kubernetes] Join | Reset local DNS on worker nodes (for haproxy endpoint)
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:27:54 CST [roles/kubernetes/certs] Certs | Generate Kubernetes certificate renewal script
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:54 CST [roles/kubernetes/certs] Certs | Deploy certificate renewal systemd service
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:54 CST [roles/kubernetes/certs] Certs | Deploy certificate renewal systemd timer
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] success  [0s] 
18:27:54 CST [roles/kubernetes/certs] Certs | Enable and start certificate renewal timer
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠧ [scan-365lr3i] success  [0s] 
18:27:55 CST [playbooks] Add custom labels to the cluster nodes
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:27:55 CST [roles/cni/calico] Calico | Check if calicoctl is installed
⠋ [scan-365lr3i] ignore   [0s] 
18:27:55 CST [roles/cni/calico] Calico | Copy calicoctl binary to remote node
⠼ [scan-365lr3i] success  [0s] 
18:27:55 CST [roles/cni/calico] Calico | Copy Calico Helm package to remote node
⠋ [scan-365lr3i] success  [0s] 
18:27:55 CST [roles/cni/calico] Calico | Generate custom values file for Calico
⠋ [scan-365lr3i] skip     [0s] 
18:27:56 CST [roles/cni/calico] Calico | Generate default values file for Calico
⠋ [scan-365lr3i] success  [0s] 
18:27:56 CST [roles/cni/calico] Calico | Deploy Calico using Helm
⠏ [scan-365lr3i] success  [4s] 
18:28:01 CST [roles/cni/cilium] Cilium | Ensure the cilium Helm chart archive is available
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/cilium] Cilium | Create the cilium Helm custom values file
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/cilium] Cilium | Generate default values file for Cilium
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/cilium] Cilium | Deploy cilium with Helm
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/flannel] Flannel | Sync flannel package to remote node
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/flannel] Flannel | Generate flannel custom values file
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/flannel] Flannel | Generate default values file for Flannel
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/flannel] Flannel | Install flannel using Helm
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/kubeovn] Kubeovn | Synchronize Kube-OVN Helm chart package to remote node
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/kubeovn] Kubeovn | Generate Kube-OVN custom values file
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/kubeovn] Kubeovn | Generate default values file for Kubeovn
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/kubeovn] Kubeovn | Add Kube-OVN labels to nodes
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/kubeovn] Kubeovn | Install Kube-OVN using Helm with custom values
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/hybridnet] Hybridnet | Synchronize Hybridnet Helm chart package to remote node
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/hybridnet] Hybridnet | Generate Hybridnet custom values file
⠋ [scan-365lr3i] skip     [0s] 
18:28:01 CST [roles/cni/hybridnet] Hybridnet | Generate default values file for Hybridnet
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/cni/hybridnet] Hybridnet | Install Hybridnet using Helm
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/cni/multi-cni/multus] Multus | Generate Multus configuration YAML file
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/cni/multi-cni/multus] Multus | Apply Multus configuration to the cluster
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/cni/multi-cni/spiderpool] Spiderpool | Synchronize Spiderpool Helm chart package to remote node
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/cni/multi-cni/spiderpool] Spiderpool | Generate Spiderpool custom values file
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/cni/multi-cni/spiderpool] Spiderpool | Generate default values file for Spiderpool
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/cni/multi-cni/spiderpool] Spiderpool | Install Spiderpool using Helm with custom values
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/storageclass/local] LocalPV | Copy the LocalPV provisioner Helm chart to the remote host
⠋ [scan-365lr3i] success  [0s] 
18:28:02 CST [roles/storageclass/local] LocalPV | Create the LocalPV custom Helm values file
⠋ [scan-365lr3i] skip     [0s] 
18:28:02 CST [roles/storageclass/local] LocalPV | Generate the default Helm values file for LocalPV
⠋ [scan-365lr3i] success  [0s] 
18:28:02 CST [roles/storageclass/local] LocalPV | Deploy the LocalPV provisioner with Helm
⠴ [scan-365lr3i] success  [0s] 
18:28:03 CST [roles/storageclass/nfs] NFS | Copy the NFS Subdir External Provisioner Helm chart to the remote host
⠋ [scan-365lr3i] skip     [0s] 
18:28:03 CST [roles/storageclass/nfs] NFS | Generate the custom Helm values file for NFS provisioner
⠋ [scan-365lr3i] skip     [0s] 
18:28:03 CST [roles/storageclass/nfs] NFS | Create the default Helm values file for the NFS provisioner
⠋ [scan-365lr3i] skip     [0s] 
18:28:03 CST [roles/storageclass/nfs] NFS | Install or upgrade the NFS Subdir External Provisioner with Helm
⠋ [scan-365lr3i] skip     [0s] 
18:28:03 CST [roles/security] Security | Enhance etcd node security permissions
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:28:03 CST [roles/security] Security | Apply security best practices for control plane nodes
⠋ [scan-rzmtjae] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
18:28:03 CST [roles/security] Security | Apply security best practices for worker nodes
⠋ [scan-6lek66t] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:28:03 CST [playbooks/hook] Post | Copy post-installation scripts to remote hosts
⠋ [localhost]    skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:28:03 CST [playbooks/hook] Post | Copy post-installation config scripts to remote hosts
⠋ [scan-6lek66t] skip     [0s] 
⠋ [scan-365lr3i] skip     [0s] 
⠋ [localhost]    skip     [0s] 
⠋ [scan-rzmtjae] skip     [0s] 
18:28:03 CST [playbooks/hook] Post | Execute post-installation scripts on remote hosts
⠋ [localhost]    success  [0s] 
⠋ [scan-365lr3i] success  [0s] 
⠼ [scan-rzmtjae] success  [0s] 
⠼ [scan-6lek66t] success  [0s] 
18:28:04 CST [Playbook default/create-cluster-gw28t] finish. total: 288,success: 277,ignored: 11,failed: 0

```

**Example successful install output:**
```shell
root@scan-yr1njmp:~# kubectl get node -o wide
NAME           STATUS     ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
scan-365lr3i   NotReady   control-plane   10m   v1.34.3   192.168.6.16   <none>        Ubuntu 24.04.1 LTS   6.8.0-41-generic   containerd://1.7.13
scan-6lek66t   NotReady   worker          10m   v1.34.3   192.168.6.19   <none>        Ubuntu 24.04.1 LTS   6.8.0-41-generic   containerd://1.7.13
scan-rzmtjae   NotReady   worker          10m   v1.34.3   192.168.6.17   <none>        Ubuntu 24.04.1 LTS   6.8.0-41-generic   containerd://1.7.13
root@scan-yr1njmp:~# 

```

**Step 5: Install KubeSphere 4.2.1** 
```shell
chart=oci://hub.kubesphere.com.cn/kse/ks-core
version=1.2.4
helm upgrade --install -n kubesphere-system --create-namespace ks-core $chart --debug --wait --version $version --reset-values --take-ownership
```

**Step 6: Waiting for installation to complete** 

The installation is complete when you see the following information
```
NOTES:
Thank you for choosing KubeSphere Helm Chart.

Please be patient and wait for several seconds for the KubeSphere deployment to complete.

1. Wait for Deployment Completion

    Confirm that all KubeSphere components are running by executing the following command:

    kubectl get pods -n kubesphere-system
2. Access the KubeSphere Console

    Once the deployment is complete, you can access the KubeSphere console using the following URL:  

    http://192.168.6.4:30880

3. Login to KubeSphere Console

    Use the following credentials to log in:

    Account: admin
    Password: P@88w0rd

NOTE: It is highly recommended to change the default password immediately after the first login.
For additional information and details, please visit https://kubesphere.io.

```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.
