# GoldenRay Cloud and AI Platform — Kubernetes v1.36 Conformance

## Product Overview

GoldenRay Cloud and AI Platform is an enterprise-grade cloud-native AI platform built on composable CNCF upstream Kubernetes components. It provides GPU-accelerated model serving, MLOps pipelines, agentic workload orchestration, and multi-tenant observability — all deployed on vanilla upstream Kubernetes with no proprietary distributions.

## Conformance Results

| Metric | Value |
|---|---|
| **Result** | **PASSED** |
| **Total Tests** | 7,586 |
| **Passed** | 453 |
| **Failed** | 0 |
| **Skipped** | 7,133 (non-conformance tests, expected) |
| **systemd-logs** | PASSED (8/8 nodes) |
| **Sonobuoy Version** | v0.57.5 |
| **Run Mode** | `certified-conformance` |

## Cluster Configuration

| Property | Value |
|---|---|
| Kubernetes Version | v1.36.0 |
| Node Count | 8 (3 control-plane, 5 workers) |
| OS | Ubuntu 24.04.4 LTS |
| Kernel | 6.17.0-aws |
| Container Runtime | containerd 2.2.5 |
| CNI | Calico (Tigera) v3.30.1 — VXLAN mode |
| Storage | Rook-Ceph v1.20.1 (block + filesystem) |
| Infrastructure | AWS EC2 (m6i.4xlarge + g6.2xlarge GPU node) |

## Reproducing Results

### Prerequisites

- Upstream Kubernetes v1.36.0 cluster (3 control-plane + 4+ worker nodes)
- `kubectl` with cluster-admin access
- `sonobuoy` v0.57.5+

### Pre-flight Checks (Important)

Before running conformance tests, ensure the following:

**1. Metrics Server is deployed:**
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system \
  --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
# Verify:
kubectl top nodes
```

**2. No long-running Pending pods (blocks SchedulerPredicates tests):**
```bash
kubectl get pods -A --field-selector=status.phase=Pending
# Scale down any Pending deployments with missing PVCs before running tests
```

**3. If Kueue is installed — verify webhook endpoints are live:**
```bash
kubectl get endpoints -n kueue-system kueue-webhook-service
# Kueue webhook must have live endpoints, or Job/CronJob tests will fail
# Ensure webhookConfig.failurePolicy: Ignore in Kueue Helm values
```

**4. Ensure no stuck Terminating namespaces:**
```bash
kubectl get namespaces | grep Terminating
```

### Run Conformance Tests

```bash
sonobuoy run --mode=certified-conformance
```

**Monitor progress:**
```bash
sonobuoy status
# Runs take 60–120 minutes depending on cluster size and workload
```

**Retrieve and inspect results:**
```bash
mkdir results/
sonobuoy retrieve results/
sonobuoy results results/<tarball>
```

**Extract submission artifacts:**
```bash
cd results/
tar xzf <tarball>
cp plugins/e2e/results/global/e2e.log ../
cp plugins/e2e/results/global/junit_01.xml ../
```

## Platform Components

The GoldenRay AI Platform includes the following CNCF components deployed on upstream Kubernetes:

| Layer | Components |
|---|---|
| Networking | Calico (Tigera) CNI |
| Storage | Rook-Ceph (block, filesystem, object) |
| GPU | NVIDIA GPU Operator, DCGM Exporter |
| Scheduling | Kueue, KubeRay, KEDA, Training Operator |
| Serving | KServe, vLLM, APISIX API Gateway |
| Pipelines | Flyte, ArgoCD |
| Observability | Prometheus, Grafana, OpenTelemetry, Jaeger, Langfuse |
| Identity | Keycloak, cert-manager |
| Registry | Harbor |
| Notebooks | JupyterHub |
| MLOps | MLflow, Feast, Milvus |
