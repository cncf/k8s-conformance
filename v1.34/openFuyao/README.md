# CNCF Conformance Certification

This document provides complete steps for deploying a Kubernetes cluster using openFuyao tools and running the CNCF conformance test suite (Sonobuoy).

## 1. Hardware Requirements

**Table 1** Minimum Deployment Hardware Configuration (1 master + 1 node)

| Node Type | Node Quantity | vCPU (Count) | Memory (GB) | Hard Disk | Operating System |
|---------|---------|-----------|-----------|------|---------|
| Bootstrap Node | 1 | 2 | 4 | System disk ≥ 100G | openEuler 22.03 LTS SP3/24.03 LTS |
| Master Node | 1 | 8 | 16 | System disk ≥ 100G | openEuler 22.03 LTS SP3/24.03 LTS |
| Worker Node | 1 | 8 | 16 | System disk ≥ 100G | openEuler 22.03 LTS SP3/24.03 LTS |

> **Notice:**
> - The node environment should be a bare metal operating system with no docker or Kubernetes components installed, otherwise version conflicts may occur and cause installation failure.
> - The bootstrap node needs to have the `tar` tool installed.
> - The bootstrap node and service cluster nodes must be able to communicate over the network using IPv4 addresses.
> - The CNCF conformance test suite creates a large number of temporary Pods during execution. It is recommended to reserve additional resources for Worker nodes.

## 2. Download Installation Tools

Download and install tools on the bootstrap node.

```bash
# Quick download
curl -sfL https://openfuyao.obs.cn-north-4.myhuaweicloud.com/openFuyao/bkeadm/releases/download/26.6.0/download.sh | bash
```

## 3. Create Bootstrap Node

Initialize a lightweight K3s bootstrap cluster on the bootstrap node. This step deploys cluster-api, provider-bke, and openFuyao components for installation and deployment.

```bash
# Online bootstrap node initialization
bke init --onlineImage cr.openfuyao.cn/openfuyao/bke-online-installed:26.6.0
```

## 4. Create Cluster Template Files

Modify the cluster and node template files on the bootstrap node. Clusters are managed declaratively using CRDs, with cluster configuration (BKECluster) and node configuration (BKENode) separated.
- Default BKECluster path: /bke/cluster/1master-cluster.yaml  
- Default BKENode path: /bke/cluster/1master-node.yaml  

### 4.1 Cluster Template File `/bke/cluster/1master-cluster.yaml`

The cluster template file needs to add the following parameters in spec.clusterConfig.cluster.apiServer.extraArgs:

- requestheader-username-headers: "X-Remote-User"
- requestheader-group-headers: "X-Remote-Group"
- requestheader-extra-headers-prefix: "X-Remote-Extra-"
- requestheader-allowed-names: "front-proxy-client"

The following is an example of the modified section:

```yaml
- name: openfuyao-system-controller
      param:
        helmRepo: https://helm.openfuyao.cn/_core
        tagVersion: 26.6.0
      version: v26.6.0
    cluster:
      agentHealthPort: "58080"
      apiServer:
        extraArgs:
          max-mutating-requests-inflight: "3000"
          max-requests-inflight: "1000"
          watch-cache-sizes: node#1000,pod#5000
          requestheader-username-headers: "X-Remote-User"  # add
          requestheader-group-headers: "X-Remote-Group"  # add
          requestheader-extra-headers-prefix: "X-Remote-Extra-"  # add
          requestheader-allowed-names: "front-proxy-client"  # add
      certificatesDir: /etc/kubernetes/pki
      chartRepo:
        domain: cr.openfuyao.cn
        ip: 119.3.216.97
        port: "443"
        prefix: charts
      containerRuntime:
        cri: containerd
```

### 4.2 Node Template File `/bke/cluster/1master-node.yaml`

```yaml
apiVersion: bke.bocloud.com/v1beta1
kind: BKENode
metadata:
  creationTimestamp: null
  labels:
    cluster.x-k8s.io/cluster-name: bke-cluster
  name: bke-cluster-m1
  namespace: bke-cluster
spec:
  hostname: m1
  ip: xxx.xxx.xxx.xxx        # Please replace IP according to actual environment
  password: '********'         # Please replace password according to actual environment
  port: "22"
  role:
  - master/node
  - etcd
  username: root
status: {}
---
apiVersion: bke.bocloud.com/v1beta1
kind: BKENode
metadata:
  creationTimestamp: null
  labels:
    cluster.x-k8s.io/cluster-name: bke-cluster
  name: bke-cluster-n1
  namespace: bke-cluster
spec:
  hostname: n1
  ip: xxx.xxx.xxx.xxx        # Please replace IP according to actual environment
  password: '********'         # Please replace password according to actual environment
  port: "22"
  role:
  - node
  username: root
status: {}
```

> **Note:**
> - Please replace IP and password according to your actual environment.
> - This example demonstrates a 1 master + 1 worker cluster.


## 5. Create Cluster

Execute the following command on the bootstrap node to create the service cluster based on template files:

```bash
bke cluster create -f /bke/cluster/1master-cluster.yaml -n /bke/cluster/1master-node.yaml
```

After the command executes, cluster creation tasks will be submitted. You can view the creation progress through terminal logs, and the key log "cluster is ready" will be output at the end.

## 6. Check Cluster Status

After the cluster creation task is complete, login to the Master node to check the BKECluster resource status:

```bash
kubectl get bc -A
```

Expected output:

```
NAMESPACE     NAME          PHASE           STATE     CLUSTER STATUS   ENDPOINT         ENDPOINT PORT   VERSION        AGENT STATUS   AGE
bke-cluster   bke-cluster   EnsureCluster   Healthy   Ready            xxx.xxx.xxx.xxx   6443            v1.34.3-of.1   2/2            4h16m
```

- **STATE=Healthy**: Cluster state is healthy.
- **CLUSTER STATUS=Ready**: Cluster is ready.
- **AGENT STATUS**: Node Agent count (e.g., 2/2 indicates all 2 node Agents are ready).

## 7. Run CNCF Conformance Test Suite

After the cluster is ready, run the conformance test suite following the official CNCF process: <https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running>

## 8. Cleanup

Clean up temporary namespaces and test pods created by Sonobuoy:

```bash
sonobuoy delete --wait
```

## References

- [CNCF Kubernetes Conformance Certification Instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)
- [openFuyao Online Bootstrap Cluster Installation](https://gitcode.com/openFuyao/sig-installation/blob/openFuyao-v26.06/docs/zh/installation_guide/online_bootstrap_cluster_installation.md)
- [openFuyao Cluster Lifecycle Management](https://gitcode.com/openFuyao/sig-installation/blob/openFuyao-v26.06/docs/zh/user_guide/cluster_installation_deployment/cluster_lifecycle_management.md)
- [Sonobuoy Official Documentation](https://sonobuoy.io/)