# Conformance tests for ORKESTRIX mK8s (QKS) v1.0.0

## Product Overview

**ORKESTRIX mK8s** is a multi-tenant, multi-cluster Kubernetes distribution — QKS (Quantum Kubernetes Service) — by QUANTUM C&S. It enables organizations to provision and operate multiple isolated Kubernetes clusters at scale on customer on-premises infrastructure via the ORKESTRIX platform, with full automation of cluster lifecycle including provisioning, scaling, upgrades, and day-2 operations.

- **Vendor**: QUANTUM C&S
- **Website**: https://quantumcns.ai
- **Documentation**: https://docs.quantumcns.ai
- **Kubernetes Version**: v1.36.1

## Sonobuoy Test Cluster Configuration

| Component | Details |
|-----------|---------|
| Control Plane | QUANTUM C&S hosted control plane |
| Worker Nodes | 3 nodes |
| CNI | Cilium (eBPF kube-proxy replacement) |
| CRI | containerd |
| DNS | CoreDNS v1.11.1 |

## Creating a Cluster

Clusters are provisioned through the QKS console available with the ORKESTRIX platform. During cluster creation, users configure:

- Cluster name and Kubernetes version
- Worker node pool (count and resource flavor)
- Network settings and optional add-ons

Once provisioned, the kubeconfig file can be downloaded directly from the cluster detail page via the download button in the QKS console.

> For access to the QKS console, contact QUANTUM C&S at business@quantumcns.ai

## Reproducing Conformance Results

### Prerequisites

- [sonobuoy](https://github.com/vmware-tanzu/sonobuoy) installed (`go install github.com/vmware-tanzu/sonobuoy@v0.56.17`)
- kubeconfig for the target cluster

```bash
export KUBECONFIG=~/<cluster-name>.kubeconfig
export PATH=$PATH:$(go env GOPATH)/bin
```

### 1. Verify cluster is healthy

```bash
kubectl get nodes
kubectl get pods -A
```

All nodes must be `Ready` and all system pods `Running` before proceeding.

### 2. Check cluster DNS domain

QKS clusters use the cluster name as the DNS service domain (e.g., `<cluster-name>.local`). Confirm the domain in use:

```bash
kubectl get configmap coredns -n kube-system \
  -o jsonpath='{.data.Corefile}' | grep kubernetes
# e.g.: kubernetes test-aila.local in-addr.arpa ip6.arpa {
```

Note the domain name — it is required for the next step.

### 3. Run conformance tests

```bash
KUBECONFIG=~/<cluster-name>.kubeconfig sonobuoy run \
  --mode=certified-conformance \
  --plugin-env e2e.E2E_EXTRA_ARGS="--dns-domain=<cluster-name>.local" \
  --wait
```

The test suite runs 446 conformance tests and takes approximately 2 hours to complete.

### 4. Monitor progress

In a separate terminal:

```bash
KUBECONFIG=~/<cluster-name>.kubeconfig sonobuoy logs -f
```

### 5. Retrieve and verify results

```bash
outfile=$(sonobuoy retrieve)
mkdir ./results
tar xzf $outfile -C ./results

# Expected: 446 Passed | 0 Failed
cat ./results/plugins/e2e/results/global/e2e.log | grep -E "Passed|Failed" | tail -5
```

The conformance test results (`e2e.log`, `junit_01.xml`) are located at:
```
./results/plugins/e2e/results/global/
```

### 6. Clean up

```bash
sonobuoy delete --wait
```
