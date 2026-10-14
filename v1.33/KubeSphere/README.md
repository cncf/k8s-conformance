## To reproduce:
#### Setup KubeSphere container management platform
* Deploy KubeSphere according to the [Kubesphere](https://github.com/kubesphere/kubekey) documentation.

**Step 1: Download KubeKey v4.0.3 and set executable permissions**
```shell
curl -sfL https://get-kk.kubesphere.io | VERSION=v4.0.3 sh -
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
spec:
  hosts: # your can set all nodes here. or set nodes on special groups.
    node1:
      connector:
        host: 192.168.6.4
      internal_ipv4: 192.168.6.4
    node2:
      connector:
        host: 192.168.6.5
      internal_ipv4: 192.168.6.5
    node3:
      connector:
        host: 192.168.6.6
      internal_ipv4: 192.168.6.6
  groups:
    # all kubernetes nodes.
    k8s_cluster:
      groups:
        - kube_control_plane
        - kube_worker
    # control_plane nodes
    kube_control_plane:
      hosts:
        - node1
    # worker nodes
    kube_worker:
      hosts:
        - node2
        - node3
    # etcd nodes when etcd_deployment_type is external
    etcd:
      hosts:
        - node1
#    image_registry:
#      hosts:
#        - localhost
    # nfs nodes for registry storage. and kubernetes nfs storage
#    nfs:
#      hosts:
#        - localhost

```

**Step 3: Generate and Edit Your Cluster Configuration**
```shell
./kk create config --with-kubernetes v1.33.7 -o .
```
The configuration file includes all common cluster settings, including ETCD, container runtimes, networking, storage, DNS, and more. Edit as required:
```yaml
apiVersion: kubekey.kubesphere.io/v1
kind: Config
spec:
  download:
    # If set to "cn", online downloads will prioritize domestic sources when available.
    zone: ""
  kubernetes:
    # Specify the Kubernetes version to be installed.
    kube_version: v1.33.7
    # Specify the Helm version to be installed.
    helm_version: v3.18.5
    # Tag for the sandbox (pause) image used by pods.
    sandbox_image:
      tag: "3.10"
    control_plane_endpoint:
      # Supported HA types: local, kube_vip, haproxy.
      # If set to local, configure local hostname resolution as follows:
      #   - Control-plane nodes: 127.0.0.1 <no value>
      #   - Worker nodes: <no value> <no value>
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
    etcd_version: v3.5.24
  image_registry:
    # Image registry type to install. Supported: harbor, docker-registry.
    # Leave empty to skip installation (assuming an existing registry is available).
    type: ""
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
    crictl_version: v1.33.0
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
    # ========== Multus ==========
    # Configuration for Multus plugin for multiple pod network interfaces.
    multus:
      enabled: false
      # Image tag for Multus (configure if needed).
      #image:
      #  tag: v4.3.0
    # ========== CNI Tools ==========
    # Version for cni-plugins (optional).
    # cni_plugins_version: v1.2.0
    # ========== Calico CNI ==========
    # Calico version (effective only when type is calico).
    calico_version: v3.31.3
    # ========== Cilium CNI ==========
    # Cilium version (effective only when type is cilium).
    #cilium_version: 1.18.5
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
    # CoreDNS image tag.
    dns_image:
      tag: v1.12.1
    # NodeLocalDNS image tag.
    dns_cache_image:
      tag: 1.25.0
  image_manifests:
    # calico for v3.31.3
    - quay.io/tigera/operator:v1.40.3
    - docker.io/calico/apiserver:v3.31.3
    - docker.io/calico/cni:v3.31.3
    - docker.io/calico/ctl:v3.31.3
    - docker.io/calico/csi:v3.31.3
    - docker.io/calico/kube-controllers:v3.31.3
    - docker.io/calico/node-driver-registrar:v3.31.3
    - docker.io/calico/node:v3.31.3
    - docker.io/calico/pod2daemon-flexvol:v3.31.3
    - docker.io/calico/typha:v3.31.3
    - docker.io/calico/goldmane:v3.31.3
    - docker.io/calico/whisker-backend:v3.31.3
    # dns
    - registry.k8s.io/coredns/coredns:v1.12.0
    - registry.k8s.io/dns/k8s-dns-node-cache:1.25.0
    # kubernetes
    - registry.k8s.io/kube-apiserver:v1.33.7
    - registry.k8s.io/kube-controller-manager:v1.33.7
    - registry.k8s.io/kube-proxy:v1.33.7
    - registry.k8s.io/kube-scheduler:v1.33.7
    - registry.k8s.io/pause:3.10
    # openebs/local for 4.4.0
    - docker.io/openebs/linux-utils:4.3.0
    - docker.io/openebs/provisioner-localpv:4.4.0
    # control_plane_endpoint ha
    - docker.io/library/haproxy:2.9.6-alpine
    - docker.io/plndr/kube-vip:v0.7.2
```

**Step 4: Start the Installation**
It is recommended to run the installation as the root user. Create your Kubernetes cluster using your customized inventory and configuration files:
```shell
# create cluster
./kk create cluster -i inventory.yaml -c config-v1.33.7.yaml
```

You will see detailed step-by-step output from KubeKey as it prepares, installs, and configures your cluster. For example:

```shell
root@i-ghlgtf1h:~# ./kk create cluster -i inventory.yaml -c config-v1.33.7.yaml


 _   __      _          _   __           
| | / /     | |        | | / /           
| |/ / _   _| |__   ___| |/ /  ___ _   _ 
|    \| | | | '_ \ / _ \    \ / _ \ | | |
| |\  \ |_| | |_) |  __/ |\  \  __/ |_| |
\_| \_/\__,_|_.__/ \___\_| \_/\___|\__, |
                                    __/ |
                                   |___/

12:41:09 CST [Playbook default/create-cluster-pzfr5] start
12:41:09 CST [roles/native/root] OS | Add sudo secure path
⠋ [localhost] success  [0s] 
⠋ [node1]     success  [0s] 
⠴ [node2]     success  [0s] 
⠴ [node3]     success  [0s] 
12:41:09 CST [playbooks/hook] Pre | Copy pre-installation scripts to remote hosts
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:41:09 CST [playbooks/hook] Pre | Copy pre-installation config scripts to remote hosts
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:09 CST [playbooks/hook] Pre | Execute pre-installation scripts on remote hosts
⠋ [node1]     success  [0s] 
⠋ [localhost] success  [0s] 
⠙ [node3]     success  [0s] 
⠙ [node2]     success  [0s] 
12:41:09 CST gather_facts
⠋ [node1]     success  [0s] 
⠋ [localhost] success  [0s] 
⠹ [node2]     success  [0s] 
⠹ [node3]     success  [0s] 
12:41:10 CST [roles/defaults] Defaults | Load version-specific settings for Kubernetes
⠋ [node2]     success  [0s] 
⠋ [node3]     success  [0s] 
⠋ [localhost] success  [0s] 
⠋ [node1]     success  [0s] 
12:41:10 CST [roles/defaults] Defaults | Load architecture-specific download URLs for each artifact version
⠋ [localhost] success  [0s] 
⠋ [node2]     success  [0s] 
⠋ [node3]     success  [0s] 
⠋ [node1]     success  [0s] 
12:41:10 CST [roles/defaults] Defaults | Reset temporary directory
⠋ [localhost] success  [0s] 
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠙ [node3]     success  [0s] 
12:41:10 CST [roles/defaults] Defaults | Determine operating system architecture for each node
⠋ [node1]     success  [0s] 
⠋ [localhost] success  [0s] 
⠋ [node3]     success  [0s] 
⠋ [node2]     success  [0s] 
12:41:10 CST [roles/defaults] Defaults | Get kubelet.service LoadState
⠋ [localhost] skip     [0s] 
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠹ [node3]     success  [0s] 
12:41:10 CST [roles/defaults] Defaults | Get kubelet.service ActiveState
⠋ [localhost] skip     [0s] 
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠹ [node3]     success  [0s] 
12:41:10 CST [roles/defaults] Defaults | Get installed Kubernetes version
⠋ [localhost] skip     [0s] 
⠋ [node1]     ignore   [0s] 
⠹ [node3]     ignore   [0s] 
⠹ [node2]     ignore   [0s] 
12:41:11 CST [roles/defaults] Defaults | Get etcd.service LoadState and save to variable
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:41:11 CST [roles/defaults] Defaults | Get etcd.service ActiveState and save to variable
⠋ [localhost] skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:41:11 CST [roles/defaults] Defaults | Get installed etcd version
⠋ [node3]     skip     [0s] 
⠋ [localhost] skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     ignore   [0s] 
12:41:11 CST [roles/defaults] Defaults | Select the initialization node for the cluster
⠋ [node1]     success  [0s] 
12:41:11 CST [roles/precheck/inventory] Inventory | Kubernetes groups must not be empty
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [localhost] success  [0s] 
12:41:11 CST [roles/precheck/inventory] Inventory | etcd group must not be empty
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [localhost] success  [0s] 
12:41:11 CST [roles/precheck/inventory] Inventory | Fail if the number of etcd hosts is even
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [localhost] success  [0s] 
⠋ [node3]     skip     [0s] 
12:41:11 CST [roles/precheck/image-registry/network] Cert | Copy check shell
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [localhost] success  [0s] 
12:41:11 CST [roles/precheck/image-registry/network] Cert | Set cert check command
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [localhost] success  [0s] 
⠋ [node1]     skip     [0s] 
12:41:11 CST [roles/precheck/image-registry/network] Cert | Exec check shell with input certs
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [localhost] success  [0s] 
12:41:11 CST [roles/precheck/image-registry/network] Cert | Exec check shell with local certs
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [localhost] success  [0s] 
12:41:11 CST [roles/precheck/image-registry/network] Cert | Set auth ca
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
12:41:11 CST [roles/precheck/artifact] Artifact | Ensure artifact file exists
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:11 CST [roles/precheck/artifact] Artifact | Validate artifact file extension
⠋ [node3]     skip     [0s] 
⠙ [node1]     skip     [0s] 
⠙ [localhost] skip     [0s] 
⠙ [node2]     skip     [0s] 
12:41:11 CST [roles/precheck/artifact] Artifact | Verify artifact MD5 checksum
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:41:11 CST [roles/precheck/cri] CRI | Fail if container manager is not docker or containerd
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [localhost] success  [0s] 
⠋ [node1]     skip     [0s] 
12:41:11 CST [roles/precheck/cri] CRI | Validate minimum required containerd version
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [localhost] success  [0s] 
⠋ [node3]     skip     [0s] 
12:41:11 CST [roles/precheck/cni] CNI | Validate calico version is allowed for the selected Kubernetes version
⠋ [node2]     skip     [0s] 
⠋ [localhost] success  [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:41:11 CST [roles/precheck/cni] CNI | Validate cilium version is allowed for the selected Kubernetes version
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:41:11 CST [roles/precheck/cni] CNI | Validate kubeovn version is allowed for the selected Kubernetes version
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:41:11 CST [roles/precheck/storageclass] StorageClass | Fail if localpv provisioner version is unsupported
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:11 CST [roles/precheck/os] OS | Validate inventory hostname is RFC-compliant
⠋ [localhost] skip     [0s] 
⠋ [node1]     success  [0s] 
⠋ [node2]     success  [0s] 
⠋ [node3]     success  [0s] 
12:41:11 CST [roles/precheck/os] OS | Validate current host system hostname is RFC-compliant
⠋ [node1]     skip     [0s] 
⠋ [localhost] skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:41:11 CST [roles/precheck/os] OS | Fail if operating system is not supported
⠋ [localhost] skip     [0s] 
⠋ [node2]     success  [0s] 
⠋ [node3]     success  [0s] 
⠋ [node1]     success  [0s] 
12:41:11 CST [roles/precheck/os] OS | Fail if architecture is not supported
⠋ [localhost] skip     [0s] 
⠋ [node2]     success  [0s] 
⠋ [node1]     success  [0s] 
⠋ [node3]     success  [0s] 
12:41:11 CST [roles/precheck/os] OS | Fail if master node memory is insufficient
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
⠋ [node2]     skip     [0s] 
12:41:11 CST [roles/precheck/os] OS | Fail if worker node memory is insufficient
⠋ [localhost] skip     [0s] 
⠋ [node2]     success  [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     success  [0s] 
12:41:12 CST [roles/precheck/os] OS | Fail if kernel version is too old
⠋ [localhost] skip     [0s] 
⠋ [node3]     success  [0s] 
⠋ [node1]     success  [0s] 
⠋ [node2]     success  [0s] 
12:41:12 CST [roles/precheck/network] Network | Ensure either internal_ipv4 or internal_ipv6 is defined
⠋ [localhost] skip     [0s] 
⠋ [node1]     success  [0s] 
⠋ [node2]     success  [0s] 
⠋ [node3]     success  [0s] 
12:41:12 CST [roles/precheck/network] Network | Ensure required network interfaces are present
⠋ [localhost] skip     [0s] 
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠙ [node3]     success  [0s] 
12:41:12 CST [roles/precheck/network] Network | Check pod CIDR includes both IPv4 and IPv6
⠋ [node1]     success  [0s] 
12:41:12 CST [roles/precheck/network] Network | Check service CIDR includes both IPv4 and IPv6
⠋ [node1]     success  [0s] 
12:41:12 CST [roles/precheck/network] Network | Ensure pod networking is properly configured for dual-stack
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/network] Network | Ensure service networking is properly configured for dual-stack
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/network] Network | Fail if the selected network plugin is not supported
⠋ [node1]     success  [0s] 
12:41:12 CST [roles/precheck/network] Network | Ensure enough IPv4 addresses are available for pods
⠋ [node1]     success  [0s] 
12:41:12 CST [roles/precheck/network] Network | Ensure enough IPv6 addresses are available for pods
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/network] Network | Fail if Kubernetes version is too old for hybridnet
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/kubernetes] Kubernetes | Validate kube-vip address
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/kubernetes] Kubernetes | Fail if unsupported Kubernetes version
⠋ [node1]     success  [0s] 
12:41:12 CST [roles/precheck/kubernetes] Kubernetes | Ensure kubelet service is active
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/kubernetes] Kubernetes | Ensure installed Kubernetes version matches expected version
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:12 CST [roles/precheck/kubernetes] ImageRegistry | Verify successful authentication to image registry
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:12 CST [roles/precheck/etcd] Kubernetes | Fail if etcd deployment type is not "internal" or "external"
⠋ [node1]     success  [0s] 
12:41:12 CST [roles/precheck/etcd] ETCD | Verify etcd minimum version for exact Kubernetes release
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/etcd] ETCD | Verify etcd minimum version for Kubernetes minor release
⠋ [node1]     success  [0s] 
12:41:12 CST [roles/precheck/etcd] ETCD | Check if fio is installed
⠋ [localhost] skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     ignore   [0s] 
12:41:12 CST [roles/precheck/etcd] ETCD | Execute fio and collect results
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/precheck/etcd] ETCD | Assert disk fsync latency meets requirements
⠋ [node3]     skip     [0s] 
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:12 CST [roles/precheck/etcd] ETCD | Clean up fio test data directory
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:12 CST [roles/precheck/nfs] NFS | Fail if more than one NFS server is defined
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:41:12 CST [roles/certs/init] Cert | Generate the root CA certificate file
⠋ [localhost] skip     [0s] 
12:41:12 CST [roles/certs/init] Cert | Generate the Kubernetes CA certificate file
⠋ [localhost] skip     [0s] 
12:41:12 CST [roles/certs/init] Cert | Generate the front-proxy CA certificate for Kubernetes
⠋ [localhost] skip     [0s] 
12:41:12 CST [roles/certs/init] Cert | Generate the etcd certificate file
⠋ [localhost] skip     [0s] 
12:41:12 CST [roles/certs/init] Cert | Generate the image registry certificate file
⠋ [localhost] skip     [0s] 
12:41:12 CST [roles/certs/init] Cert | Change ownership of the PKI directory to the sudo user
⠋ [localhost] success  [0s] 
12:41:12 CST [roles/download] Artifact | Extract artifact archive to working directory
⠋ [localhost] skip     [0s] 
12:41:12 CST [roles/download] Binary | Ensure etcd binary is present
⠋ [localhost] success  [0s] 
12:41:12 CST [roles/download] Binary | Ensure Kubernetes binaries are present
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Binary | Ensure CNI plugins are present
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Binary | Ensure Helm binary is present
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Binary | Ensure crictl binary is present
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Binary | Ensure Docker binary is present
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Binary | Ensure cri-dockerd binary is present
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Binary | Ensure containerd binary is present
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Binary | Ensure runc binary is present
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Binary | Ensure calicoctl binary is present
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Binary | Ensure Docker Registry binary is present
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Binary | Ensure docker-compose binary is present
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Binary | Ensure Harbor binary is present
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Binary | Ensure keepalived binary is present
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Helm | Ensure the Calico binary is available
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Helm | Ensure the Cilium binary is available
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Helm | Ensure the Flannel binary is available
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Helm | Ensure the Kube-OVN binary is available
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Helm | Ensure the Hybridnet binary is available
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Helm | Ensure the localpv Provisioner binary is available
⠋ [localhost] success  [0s] 
12:41:13 CST [roles/download] Helm | Ensure the NFS Provisioner binary is available
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Image | Download container images
⠋ [localhost] skip     [0s] 
12:41:13 CST [roles/download] ISO | Download ISO files
⠹ [localhost] skip     [0s] 
12:41:13 CST [roles/download] Artifact | Set ownership of working directory to sudo user
⠋ [localhost] success  [0s] 
12:41:14 CST [roles/native/repository] Repository | Prepare tmp files
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠙ [node3]     success  [0s] 
12:41:14 CST [roles/native/repository] Repository | Check system version when use Kylin
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:14 CST [roles/native/repository] Repository | Define the system string based on distribution
⠋ [node2]     success  [0s] 
⠋ [node3]     success  [0s] 
⠋ [node1]     success  [0s] 
12:41:14 CST [roles/native/repository] Repository | Define the package file type by system info
⠋ [node1]     success  [0s] 
⠋ [node3]     success  [0s] 
⠋ [node2]     success  [0s] 
12:41:14 CST [roles/native/repository] Repository | Set iso file name
⠋ [node3]     success  [0s] 
⠋ [node1]     success  [0s] 
⠋ [node2]     success  [0s] 
12:41:14 CST [roles/native/repository] Repository | Copy local repository ISO file
⠋ [node1]     ignore   [0s] 
⠙ [node2]     ignore   [0s] 
⠙ [node3]     ignore   [0s] 
12:41:14 CST [roles/native/repository] Repository | Mount repository ISO to temporary directory
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠙ [node3]     success  [0s] 
12:41:14 CST [roles/native/repository] Repository | Check current host debian or rhel
⠋ [node2]     success  [0s] 
⠋ [node3]     success  [0s] 
⠋ [node1]     success  [0s] 
12:41:14 CST [roles/native/repository] Repository | Initialize Debian-based repository and install required system packages
⠹ [node1]     success  [8s] 
⠇ [node3]     success  [31s] 
⠸ [node2]     success  [36s] 
12:41:51 CST [roles/native/repository] Repository | Initialize RHEL-based repository and install required system packages
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:51 CST [roles/native/repository] Repository | Unmount repository ISO from temporary directory
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠙ [node3]     success  [0s] 
12:41:51 CST [roles/native/nfs] NFS | Generate NFS server export configuration
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:51 CST [roles/native/nfs] NFS | Ensure NFS share directories exist with correct permissions
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:41:51 CST [roles/native/nfs] NFS | Export share directories and start NFS server service
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:41:51 CST [roles/native/ntp] NTP | Configure NTP server
⠋ [node1]     success  [0s] 
⠼ [node2]     success  [3s] 
⠹ [node3]     success  [4s] 
12:41:55 CST [roles/native/ntp] Timezone | Set system timezone and NTP synchronization
⠙ [node1]     success  [0s] 
⠹ [node3]     success  [0s] 
⠹ [node2]     success  [0s] 
12:41:56 CST [roles/native/ntp] NTP | Restart NTP service
⠹ [node3]     success  [0s] 
⠸ [node2]     success  [0s] 
⠸ [node1]     success  [0s] 
12:41:56 CST [roles/native/dns] DNS | Ensure local DNS entries are up-to-date
⠋ [node1]     success  [0s] 
⠹ [node2]     success  [0s] 
⠴ [node3]     success  [0s] 
12:41:57 CST [roles/native/dns] DNS | Ensure image registry control plane endpoint DNS is current
⠋ [node1]     success  [0s] 
⠹ [node2]     success  [0s] 
⠹ [node3]     success  [0s] 
12:41:57 CST [roles/native/dns] DNS | Set local DNS for kubernetes control plane endpoint
⠋ [node1]     success  [0s] 
⠹ [node3]     success  [0s] 
⠹ [node2]     success  [0s] 
12:41:57 CST [roles/native/init] OS | Set system hostname
⠙ [node1]     success  [0s] 
⠹ [node2]     success  [0s] 
⠹ [node3]     success  [0s] 
12:41:57 CST [roles/native/init] OS | Synchronize initialization script to remote node
⠋ [node1]     success  [0s] 
⠙ [node3]     success  [0s] 
⠙ [node2]     success  [0s] 
12:41:58 CST [roles/native/init] OS | Execute initialization script on remote node
⠴ [node1]     success  [1s] 
⠋ [node3]     success  [4s] 
⠴ [node2]     success  [4s] 
12:42:02 CST [roles/etcd] Prepare | Ensure installed etcd is running and healthy
⠋ [node1]     skip     [0s] 
12:42:02 CST [roles/etcd] Prepare | Identify nodes with installed or missing etcd
⠋ [node1]     success  [0s] 
12:42:02 CST [roles/etcd] Prepare | Ensure target etcd version is not lower than installed version
⠋ [node1]     skip     [0s] 
12:42:02 CST [roles/etcd] Prepare | Copy etcd binary package to remote node
⠼ [node1]     success  [0s] 
12:42:03 CST [roles/etcd] Prepare | Extract etcd binary package to /usr/local/bin/
⠴ [node1]     success  [0s] 
12:42:03 CST [roles/etcd] Prepare | Copy CA certificate to etcd node
⠋ [node1]     success  [0s] 
12:42:03 CST [roles/etcd] Prepare | Copy server certificate to etcd node
⠋ [node1]     success  [0s] 
12:42:04 CST [roles/etcd] Prepare | Copy server key to etcd node
⠋ [node1]     success  [0s] 
12:42:04 CST [roles/etcd] Upgrade | Backup etcd data before upgrade
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Upgrade | Restart etcd service after upgrade
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Upgrade | Ensure etcd service becomes healthy within 1 minute
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Expansion | Update /etc/etcd.env configuration file
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Expansion | Restart etcd service
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Expansion | Verify etcd service becomes healthy within 1 minute
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Expansion | Add new etcd member from non-installed node
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Install | Create etcd system user
⠋ [node1]     success  [0s] 
12:42:04 CST [roles/etcd] Install | Create etcd data directory and set ownership
⠋ [node1]     success  [0s] 
12:42:04 CST [roles/etcd] Install | Generate etcd environment configuration file
⠋ [node1]     success  [0s] 
12:42:04 CST [roles/etcd] Install | Deploy etcd systemd service file
⠋ [node1]     success  [0s] 
12:42:04 CST [roles/etcd] Install | Set CPU governor to performance mode
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Install | Configure network traffic priority for etcd
⠋ [node1]     skip     [0s] 
12:42:04 CST [roles/etcd] Install | Start and enable etcd systemd service
⠏ [node1]     success  [3s] 
12:42:08 CST [roles/etcd] Backup | Synchronize custom etcd backup script
⠋ [node1]     success  [0s] 
12:42:08 CST [roles/etcd] Backup | Deploy systemd service for etcd backup
⠋ [node1]     success  [0s] 
12:42:08 CST [roles/etcd] Backup | Deploy systemd timer for scheduled etcd backup
⠋ [node1]     success  [0s] 
12:42:08 CST [roles/etcd] Backup | Reload systemd and enable etcd backup timer
⠴ [node1]     success  [0s] 
12:42:09 CST gather_facts
⠋ [node1]     success  [0s] 
⠸ [node3]     success  [0s] 
⠸ [node2]     success  [0s] 
12:42:09 CST [roles/cri/crictl] Crictl | Verify if crictl is installed on the system
⠋ [node1]     ignore   [0s] 
⠇ [node2]     ignore   [0s] 
⠏ [node3]     ignore   [0s] 
12:42:10 CST [roles/cri/crictl] Crictl | Copy crictl binary archive to the remote node
⠸ [node1]     success  [0s] 
⠦ [node2]     success  [0s] 
⠦ [node3]     success  [0s] 
12:42:11 CST [roles/cri/crictl] Crictl | Extract crictl binary to /usr/local/bin
⠸ [node1]     success  [0s] 
⠴ [node2]     success  [0s] 
⠴ [node3]     success  [0s] 
12:42:11 CST [roles/cri/crictl] Crictl | Generate crictl configuration file
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠙ [node3]     success  [0s] 
12:42:12 CST [roles/cri/docker] Docker | Check if Docker is installed on the system
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Copy Docker binary archive to the remote node
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Extract Docker binaries to /usr/local/bin
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Generate Docker configuration file
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Deploy the Docker systemd service file
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Deploy the containerd systemd service file
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Start and enable Docker and containerd services
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Copy image registry CA certificate to the remote node
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Copy image registry server certificate to the remote node
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Docker | Copy image registry server key to the remote node
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Cridockerd | Check if cri-dockerd is installed on the system
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Cridockerd | Copy cri-dockerd binary archive to the remote node
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Cridockerd | Extract cri-dockerd binary to /usr/local/bin
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Cridockerd | Generate cri-dockerd systemd service file
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:12 CST [roles/cri/docker] Cridockerd | Start and enable the cri-dockerd service
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:12 CST [roles/cri/containerd] Containerd | Verify if runc is installed on the system
⠋ [node1]     ignore   [0s] 
⠙ [node2]     ignore   [0s] 
⠹ [node3]     ignore   [0s] 
12:42:12 CST [roles/cri/containerd] Containerd | Ensure the runc binary is present on the remote node
⠙ [node1]     success  [0s] 
⠸ [node3]     success  [0s] 
⠸ [node2]     success  [0s] 
12:42:13 CST [roles/cri/containerd] Containerd | Check if containerd is installed on the system
⠋ [node1]     ignore   [0s] 
⠙ [node2]     ignore   [0s] 
⠙ [node3]     ignore   [0s] 
12:42:13 CST [roles/cri/containerd] Containerd | Copy containerd binary archive to the remote node
⠇ [node1]     success  [0s] 
⠴ [node3]     success  [1s] 
⠴ [node2]     success  [1s] 
12:42:15 CST [roles/cri/containerd] Containerd | Extract containerd binaries to /usr/local/bin
⠏ [node1]     success  [0s] 
⠹ [node3]     success  [1s] 
⠴ [node2]     success  [1s] 
12:42:16 CST [roles/cri/containerd] Containerd | Generate the containerd configuration file
⠋ [node1]     success  [0s] 
⠙ [node3]     success  [0s] 
⠙ [node2]     success  [0s] 
12:42:16 CST [roles/cri/containerd] Containerd | Deploy the containerd systemd service file
⠋ [node1]     success  [0s] 
⠙ [node2]     success  [0s] 
⠙ [node3]     success  [0s] 
12:42:17 CST [roles/cri/containerd] Containerd | Start and enable the containerd service
⠦ [node1]     success  [0s] 
⠇ [node2]     success  [0s] 
⠏ [node3]     success  [0s] 
12:42:18 CST [roles/cri/containerd] Containerd | Copy image registry CA certificate to the remote node
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:18 CST [roles/cri/containerd] Containerd | Copy image registry server certificate to the remote node
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:18 CST [roles/cri/containerd] Containerd | Copy image registry server key to the remote node
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:18 CST [roles/kubernetes/pre-kubernetes] Binary | Verify if Helm is already installed
⠙ [node2]     ignore   [0s] 
⠹ [node3]     ignore   [0s] 
⠧ [node1]     success  [0s] 
12:42:19 CST [roles/kubernetes/pre-kubernetes] Binary | Copy Helm archive to remote host
⠋ [node1]     skip     [0s] 
⠦ [node2]     success  [0s] 
⠦ [node3]     success  [0s] 
12:42:19 CST [roles/kubernetes/pre-kubernetes] Binary | Extract and install Helm binary
⠋ [node1]     skip     [0s] 
⠦ [node2]     success  [0s] 
⠦ [node3]     success  [0s] 
12:42:20 CST [roles/kubernetes/pre-kubernetes] Binary | Check if kubeadm is installed
⠋ [node1]     ignore   [0s] 
⠙ [node2]     ignore   [0s] 
⠹ [node3]     ignore   [0s] 
12:42:20 CST [roles/kubernetes/pre-kubernetes] Binary | Install kubeadm if not present or version mismatch
⠼ [node1]     success  [1s] 
⠼ [node2]     success  [2s] 
⠼ [node3]     success  [2s] 
12:42:23 CST [roles/kubernetes/pre-kubernetes] Binary | Check if kubectl is installed
⠋ [node1]     ignore   [0s] 
⠙ [node2]     ignore   [0s] 
⠙ [node3]     ignore   [0s] 
12:42:23 CST [roles/kubernetes/pre-kubernetes] Binary | Install kubectl if not present or version mismatch
⠙ [node1]     success  [1s] 
⠏ [node2]     success  [1s] 
⠏ [node3]     success  [1s] 
12:42:25 CST [roles/kubernetes/pre-kubernetes] Binary | Check if kubelet is installed
⠋ [node1]     ignore   [0s] 
⠙ [node3]     ignore   [0s] 
⠙ [node2]     ignore   [0s] 
12:42:25 CST [roles/kubernetes/pre-kubernetes] Binary | Copy kubelet binary to remote host
⠴ [node1]     success  [1s] 
⠇ [node2]     success  [3s] 
⠙ [node3]     success  [4s] 
12:42:29 CST [roles/kubernetes/pre-kubernetes] Binary | Deploy kubelet environment configuration
⠋ [node1]     success  [0s] 
⠙ [node3]     success  [0s] 
⠙ [node2]     success  [0s] 
12:42:30 CST [roles/kubernetes/pre-kubernetes] Binary | Copy kubelet systemd service file
⠋ [node1]     success  [0s] 
⠙ [node3]     success  [0s] 
⠙ [node2]     success  [0s] 
12:42:30 CST [roles/kubernetes/pre-kubernetes] Binary | Reload systemd and enable kubelet service
⠼ [node1]     success  [0s] 
⠦ [node2]     success  [0s] 
⠦ [node3]     success  [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Binary | Copy CNI plugins archive to remote host
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Binary | Extract and install CNI plugins
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Kubevip | Gather all network interfaces with CIDR addresses
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Kubevip | Select network interface matching kube-vip address
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Kubevip | Ensure matching network interface exists
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Kubevip | Generate kube-vip manifest file
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Haproxy | Generate HAProxy configuration file
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Haproxy | Calculate MD5 checksum of HAProxy configuration
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] Haproxy | Generate HAProxy manifest for Kubernetes
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Ensure the 'kube' system user exists
⠋ [node1]     success  [0s] 
⠹ [node2]     success  [0s] 
⠹ [node3]     success  [0s] 
12:42:31 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Create and set ownership for required Kubernetes directories
⠸ [node1]     success  [0s] 
⠦ [node3]     success  [3s] 
⠦ [node2]     success  [3s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Synchronize audit policy file to remote node
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy CA certificate to control plane node
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy CA private key to control plane node
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy etcd CA certificate to control plane node
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy etcd client certificate to control plane node
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy etcd client key to control plane node
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy front-proxy CA certificate to control plane node
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:35 CST [roles/kubernetes/pre-kubernetes] PreKubernetes | Copy front-proxy CA private key to control plane node
⠋ [node1]     skip     [0s] 
                            
⠋ [node2]     skip     [0s] 
12:42:35 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Configure control_plane_endpoint in local DNS files
⠋ [node1]     skip     [0s] 
⠹ [node3]     success  [0s] 
⠹ [node2]     success  [0s] 
12:42:36 CST [roles/kubernetes/init-kubernetes] Init | Generate kubeadm initialization configuration
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:42:36 CST [roles/kubernetes/init-kubernetes] Init | Pre-initialization for kube-vip
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:42:36 CST [roles/kubernetes/init-kubernetes] Init | Run kubeadm init
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠏ [node1]     success  [46s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] Init | Post-initialization for kube-vip
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] Init | Reset local DNS for control_plane_endpoint
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] Init | Copy kubeconfig to default directory
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] Init | Remove master/control-plane taints from node
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] Init | Add worker label to node
⠋ [node3]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] Init | Add custom annotations to node
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] DNS | Generate CoreDNS configuration file
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:43:23 CST [roles/kubernetes/init-kubernetes] DNS | Apply CoreDNS configuration and restart deployment
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠴ [node1]     success  [0s] 
12:43:24 CST [roles/kubernetes/init-kubernetes] DNS | Generate NodeLocalDNS DaemonSet manifest
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:43:24 CST [roles/kubernetes/init-kubernetes] DNS | Deploy NodeLocalDNS DaemonSet
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠸ [node1]     success  [0s] 
12:43:24 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Kubernetes Already Installed
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:24 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Fetch kubeconfig to local workspace
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:43:24 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Generate certificate key using kubeadm
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠙ [node1]     success  [0s] 
12:43:24 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Distribute certificate key to all cluster hosts
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node1]     success  [0s] 
12:43:24 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Generate kubeadm join token
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠙ [node1]     success  [0s] 
12:43:25 CST [roles/kubernetes/init-kubernetes] InitKubernetes | Share kubeadm token with all cluster hosts
⠋ [node2]     skip     [0s] 
⠋ [node1]     success  [0s] 
⠋ [node3]     skip     [0s] 
12:43:25 CST [roles/kubernetes/join-kubernetes] Join | Generate kubeadm join configuration file
⠋ [node1]     skip     [0s] 
⠴ [node2]     success  [0s] 
⠴ [node3]     success  [0s] 
12:43:25 CST [roles/kubernetes/join-kubernetes] Join | Execute kubeadm join to add node to the Kubernetes cluster
⠋ [node1]     skip     [0s] 
⠦ [node3]     success  [6s] 
⠦ [node2]     success  [7s] 
12:43:33 CST [roles/kubernetes/join-kubernetes] Join | Synchronize kubeconfig to remote node for current user
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:33 CST [roles/kubernetes/join-kubernetes] Join | Synchronize kubeconfig to remote node for root
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:33 CST [roles/kubernetes/join-kubernetes] Join | Remove master and control-plane taints from node
⠋ [node1]     skip     [0s] 
⠴ [node2]     ignore   [0s] 
⠴ [node3]     ignore   [0s] 
12:43:34 CST [roles/kubernetes/join-kubernetes] Join | Add worker label to node
⠋ [node1]     skip     [0s] 
⠙ [node2]     success  [0s] 
⠸ [node3]     success  [0s] 
12:43:34 CST [roles/kubernetes/join-kubernetes] Join | Add custom annotations to node
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:34 CST [roles/kubernetes/join-kubernetes] Join | Reset local DNS on control plane nodes
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:34 CST [roles/kubernetes/join-kubernetes] Join | Reset local DNS on worker nodes (for haproxy endpoint)
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:34 CST [roles/kubernetes/certs] Certs | Generate Kubernetes certificate renewal script
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:34 CST [roles/kubernetes/certs] Certs | Deploy certificate renewal systemd service
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:34 CST [roles/kubernetes/certs] Certs | Deploy certificate renewal systemd timer
⠋ [node2]     skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:34 CST [roles/kubernetes/certs] Certs | Enable and start certificate renewal timer
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:35 CST [playbooks] Add custom labels to the cluster nodes
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:35 CST [roles/cni/multus] Multus | Generate Multus configuration YAML file
⠋ [node1]     skip     [0s] 
12:43:35 CST [roles/cni/multus] Multus | Apply Multus configuration to the cluster
⠋ [node1]     skip     [0s] 
12:43:35 CST [roles/cni/calico] Calico | Check if calicoctl is installed
⠋ [node1]     ignore   [0s] 
12:43:35 CST [roles/cni/calico] Calico | Copy calicoctl binary to remote node
⠦ [node1]     success  [1s] 
12:43:37 CST [roles/cni/calico] Calico | Copy Calico Helm package to remote node
⠋ [node1]     success  [0s] 
12:43:37 CST [roles/cni/calico] Calico | Generate custom values file for Calico
⠋ [node1]     skip     [0s] 
12:43:37 CST [roles/cni/calico] Calico | Generate default values file for Calico
⠋ [node1]     success  [0s] 
12:43:37 CST [roles/cni/calico] Calico | Deploy Calico using Helm
⠧ [node1]     success  [4s] 
12:43:42 CST [roles/cni/cilium] Cilium | Ensure the cilium Helm chart archive is available
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/cilium] Cilium | Create the cilium Helm custom values file
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/cilium] Cilium | Generate default values file for Cilium
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/cilium] Cilium | Deploy cilium with Helm
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/flannel] Flannel | Sync flannel package to remote node
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/flannel] Flannel | Generate flannel custom values file
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/flannel] Flannel | Generate default values file for Flannel
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/flannel] Flannel | Install flannel using Helm
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/kubeovn] Kubeovn | Synchronize Kube-OVN Helm chart package to remote node
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/kubeovn] Kubeovn | Generate Kube-OVN custom values file
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/kubeovn] Kubeovn | Generate default values file for Kubeovn
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/kubeovn] Kubeovn | Add Kube-OVN labels to nodes
⠋ [node1]     skip     [0s] 
12:43:42 CST [roles/cni/kubeovn] Kubeovn | Install Kube-OVN using Helm with custom values
⠋ [node1]     skip     [0s] 
12:43:43 CST [roles/cni/hybridnet] Hybridnet | Synchronize Hybridnet Helm chart package to remote node
⠋ [node1]     skip     [0s] 
12:43:43 CST [roles/cni/hybridnet] Hybridnet | Generate Hybridnet custom values file
⠋ [node1]     skip     [0s] 
12:43:43 CST [roles/cni/hybridnet] Hybridnet | Generate default values file for Hybridnet
⠋ [node1]     skip     [0s] 
12:43:43 CST [roles/cni/hybridnet] Hybridnet | Install Hybridnet using Helm
⠋ [node1]     skip     [0s] 
12:43:43 CST [roles/storageclass/local] LocalPV | Copy the LocalPV provisioner Helm chart to the remote host
⠋ [node1]     success  [0s] 
12:43:43 CST [roles/storageclass/local] LocalPV | Create the LocalPV custom Helm values file
⠋ [node1]     skip     [0s] 
12:43:43 CST [roles/storageclass/local] LocalPV | Generate the default Helm values file for LocalPV
⠋ [node1]     success  [0s] 
12:43:43 CST [roles/storageclass/local] LocalPV | Deploy the LocalPV provisioner with Helm
⠸ [node1]     success  [0s] 
12:43:43 CST [roles/storageclass/nfs] NFS | Copy the NFS Subdir External Provisioner Helm chart to the remote host
⠋ [node1]     skip     [0s] 
12:43:44 CST [roles/storageclass/nfs] NFS | Generate the custom Helm values file for NFS provisioner
⠋ [node1]     skip     [0s] 
12:43:44 CST [roles/storageclass/nfs] NFS | Create the default Helm values file for the NFS provisioner
⠋ [node1]     skip     [0s] 
12:43:44 CST [roles/storageclass/nfs] NFS | Install or upgrade the NFS Subdir External Provisioner with Helm
⠋ [node1]     skip     [0s] 
12:43:44 CST [roles/security] Security | Enhance etcd node security permissions
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 

12:43:44 CST [roles/security] Security | Apply security best practices for control plane nodes
⠋ [node1]     skip     [0s] 
⠋ [localhost] skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:44 CST [roles/security] Security | Apply security best practices for worker nodes
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
12:43:44 CST [playbooks/hook] Post | Copy post-installation scripts to remote hosts
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node2]     skip     [0s] 
⠋ [node3]     skip     [0s] 
12:43:44 CST [playbooks/hook] Post | Copy post-installation config scripts to remote hosts
⠋ [localhost] skip     [0s] 
⠋ [node1]     skip     [0s] 
⠋ [node3]     skip     [0s] 
⠋ [node2]     skip     [0s] 
12:43:44 CST [playbooks/hook] Post | Execute post-installation scripts on remote hosts
⠋ [localhost] success  [0s] 
⠋ [node1]     success  [0s] 
⠙ [node3]     success  [0s] 
⠙ [node2]     success  [0s] 
12:43:44 CST [Playbook default/create-cluster-pzfr5] finish. total: 278,success: 265,ignored: 13,failed: 0

```

**Step 5: Install KubeSphere 4.2.0** 
```shell
chart=oci://hub.kubesphere.com.cn/kse/ks-core
version=1.2.3-20251118
helm upgrade --install -n kubesphere-system --create-namespace ks-core $chart --debug --wait --version $version --reset-values
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
