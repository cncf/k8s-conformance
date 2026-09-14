## How to Reproduce:
#### Provisioning a Kubernetes Cluster with KubeKey

**Step 1: Download KubeKey v4.0.7 and set executable permissions**
```shell
curl -sfL https://get-kk.kubesphere.io | sh -
```

**Step 2: Generate and Edit Your Cluster Inventory**
```shell
./kk create inventory -o .
```
The inventory file defines the nodes in your cluster and their grouping. This example uses one control-plane node and one worker node per cluster. Assign each node to the appropriate group:
```yaml
apiVersion: kubekey.kubesphere.io/v1
kind: Inventory
metadata:
  name: default
  namespace: default
spec:
  hosts:
    control-plane1:
      connector:
        type: ssh
        host: <control-plane-ip>
        port: 22
        user: root
        password: <password>
      internal_ipv4: <control-plane-ip>
    worker1:
      connector:
        type: ssh
        host: <worker-ip>
        port: 22
        user: root
        password: <password>
      internal_ipv4: <worker-ip>
  groups:
    k8s_cluster:
      groups:
        - kube_control_plane
        - kube_worker
    kube_control_plane:
      hosts:
        - control-plane1
    kube_worker:
      hosts:
        - worker1
    etcd:
      hosts:
        - control-plane1
```

**Step 3: Generate and Edit Your Cluster Configuration**
```shell
./kk create config --with-kubernetes v1.35.8 -o .
```
The configuration file includes all common cluster settings (ETCD, container runtime, networking, storage, DNS, and more). Key settings used:
```yaml
apiVersion: kubekey.kubesphere.io/v1
kind: Config
spec:
  zone: ""
  kubernetes:
    kube_version: v1.35.8
    helm_version: v3.18.5
    sandbox_image:
      tag: "3.10.1"
    control_plane_endpoint:
      type: local
  etcd:
    etcd_version: v3.6.6
  cri:
    container_manager: containerd
    crictl_version: v1.35.0
  cni:
    type: calico
    calico_version: v3.32.2
  storage_class:
    local:
      enabled: true
      default: true
    localpv_provisioner_version: 4.4.0
  dns:
    coredns:
      image:
        tag: v1.12.1
    nodelocaldns:
      enabled: true
      image:
        tag: 1.26.4
```

**Step 4: Start the Installation**
Run the installation as the root user on the control-plane node:
```shell
./kk create cluster -c config.yaml -i inventory.yaml
```

**Example successful install output:**
```shell
root@<control-plane> ~# ./kk create cluster -c config.yaml -i inventory.yaml
[Playbook default/create-cluster-xxxx] finish. total: 339, success: 327, ignored: 12, failed: 0
```

**Step 5: Install KubeSphere v4.3.0**
```shell
chart=oci://hub.kubesphere.com.cn/kse/ks-core
version=1.2.5
helm upgrade --install -n kubesphere-system --create-namespace ks-core $chart \
  --debug --wait --version $version --reset-values --take-ownership \
  --set global.imageRegistry=hub.kubesphere.com.cn,extension.imageRegistry=hub.kubesphere.com.cn
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
```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.
* Run the certified conformance suite against the v1.35.8 cluster with KubeSphere installed:
```shell
sonobuoy run --mode=certified-conformance --kubernetes-version=v1.35.8
sonobuoy status --wait
sonobuoy retrieve
```
