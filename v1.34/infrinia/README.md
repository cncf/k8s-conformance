# Infrinia AI Cloud OS — Kubernetes v1.34 Conformance

## About Infrinia AI Cloud OS

Infrinia AI Cloud OS is a GPU-native managed Kubernetes platform purpose-built
for AI and ML workloads. It provides automated GPU infrastructure provisioning,
Kubernetes cluster orchestration, and MLOps tooling on NVIDIA GB200 NVL72 and
other high-end GPU hardware.

## Reproducing Conformance Results

### Cluster Configuration

| Component | Version |
|---|---|
| Kubernetes | v1.34.2 |
| CNI | Cilium v1.17.0 |
| Storage (default CSI) | Longhorn |
| Nodes | 3 control-plane, 2 workers |
| Architecture | linux/amd64 |

### Prerequisites

- A running Infrinia AI Cloud OS cluster
- `kubectl` configured with cluster-admin access
- [`hydrophone`](https://github.com/kubernetes-sigs/hydrophone) installed

```bash
go install sigs.k8s.io/hydrophone@latest
```

### Pre-flight Steps

Before running conformance tests on an Infrinia cluster, the following
platform-specific policies must be temporarily suspended as they enforce
production security controls that intentionally restrict operations the
conformance suite requires (privileged pods, hostPath volumes, namespace
creation, PV modifications):

```bash
# 1. Scale down the storage controller to prevent automatic PVC injection
#    into test namespaces
kubectl scale deployment storage-controller -n infrinia --replicas=0

# 2. Remove platform ValidatingAdmissionPolicy bindings
kubectl get validatingadmissionpolicybindings \
  --no-headers -o name | grep infrinia | \
  xargs kubectl delete

# 3. Remove platform admission webhooks
kubectl delete validatingwebhookconfiguration infrinia-vap-protection-webhook
kubectl delete mutatingwebhookconfiguration infrinia-tenant-mutator-webhook
kubectl delete mutatingwebhookconfiguration ingress-fqdn
```

### Run Conformance Tests

```bash
mkdir -p ./conformance-results

hydrophone --conformance --output-dir ./conformance-results/
```

The conformance suite runs 424 tests and completes in approximately 2 hours.

### Restore Platform Policies

After the conformance run, restore all production policies:

```bash
kubectl scale deployment storage-controller -n infrinia --replicas=1
# Re-apply VAP bindings and webhooks from your platform configuration
```

## Results

```
Ran 424 of 7137 Specs in 6403.994 seconds
SUCCESS! -- 424 Passed | 0 Failed | 0 Pending | 6713 Skipped
PASS
```

## Contact

For questions about this submission: thierno.diallo@infrinia.ai
