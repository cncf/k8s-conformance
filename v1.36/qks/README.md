# QKS (Quantum Kubernetes Service)

QKS is a managed multi-tenant Kubernetes platform by QUANTUM C&S,
designed for on-premises enterprise environments. QKS provides fully
managed Kubernetes clusters without requiring users to operate or
maintain the control plane directly.

## Key Features

- **Managed Control Plane** — Control plane is fully managed by QKS; no manual operation required
- **Easy Kubernetes Upgrades** — Upgrade clusters to newer Kubernetes versions with a single click from the web console
- **Multi-Tenant RBAC** — Manage teams and groups with fine-grained role-based access control
- **GPU Workload Support** — Create node pools with NVIDIA GPU resources for AI/ML workloads
- **Air-Gapped Deployment** — Supports fully isolated environments with no external internet access
- **Integrated Monitoring** — Built-in cluster and node metrics, GPU monitoring via Prometheus/Grafana
- **Node Pool Scaling** — Dynamically scale worker node counts per node pool
- **Cluster Mesh** — Connect multiple clusters with cross-cluster networking
- **Web-based kubectl Terminal** — Run kubectl commands directly from the browser
- **Webhook Notifications** — Integrate cluster lifecycle events with external systems

## Create a QKS Cluster

1. Log in to the QKS console at https://qks.quantumcns.ai/
2. Navigate to **Clusters** → **Create Cluster**
3. Select Kubernetes version **v1.36.1** and configure node pools
4. Once the cluster status becomes **Running**, download the kubeconfig from the cluster detail page

## Run Conformance Tests

Install sonobuoy:

```bash
go install github.com/vmware-tanzu/sonobuoy@v0.56.17
```

Run the conformance tests:

```bash
export KUBECONFIG=<path-to-kubeconfig>

sonobuoy run \
  --mode=certified-conformance \
  --plugin-env=e2e.E2E_EXTRA_ARGS="--dns-domain=<cluster-dns-domain>" \
  --wait
```

Retrieve and inspect results:

```bash
outfile=$(sonobuoy retrieve)
sonobuoy results $outfile
```

Clean up:

```bash
sonobuoy delete --wait
```
