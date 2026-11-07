# ORKESTRIX Distro — Kubernetes v1.37 Conformance

## 1. Product overview

ORKESTRIX Distro (formerly ORKESTRIX) is an enterprise Kubernetes distribution developed by QUANTUM C&S.

It provides Ansible-based automation for infrastructure provisioning, Kubernetes cluster installation, and environment-specific back-office component configuration.

ORKESTRIX Distro supports deployment in both connected and air-gapped environments, including infrastructure without direct Internet access.

The distribution also supports flexible networking and storage configurations tailored to customer infrastructure requirements, enabling Kubernetes deployment across different enterprise and private cloud environments.

For Kubernetes v1.37 conformance testing, ORKESTRIX Distro was validated against a Kubernetes v1.37.1 cluster deployed using its Kubernetes distribution and installation framework.

- Vendor: QUANTUM C&S
- Offering: ORKESTRIX Distro (Distribution)
- Previous product name: ORKESTRIX
- Kubernetes conformance version: **v1.37**
- Kubernetes patch release tested: **v1.37.1**
- Sonobuoy release: **v0.57.5**
- Conformance result: **462 passed, 0 failed**
- Product software version: **v1.0.0**

## 2. Architecture and deployment model

The product deploys and configures Kubernetes using Ansible-managed inventory, variables and playbooks. The tested deployment is a conventional Kubernetes cluster with dedicated control-plane and worker nodes. Cilium networking, CoreDNS and containerd are part of the observed environment; their release numbers and configuration must match the tested inventory when reproducing the result.

**Previously recorded test-environment details requiring final confirmation against the successful run:**

| Component | Recorded configuration |
| --- | --- |
| Infrastructure | OpenStack virtual machines / private infrastructure |
| Operating system | Ubuntu 24.04 LTS |
| Topology | Three control-plane nodes and three worker nodes |
| Container runtime | containerd v2.3.0; runc (`io.containerd.runc.v2`) |
| Networking | Cilium v1.20.3, eBPF kube-proxy replacement, VXLAN |
| Cluster DNS | CoreDNS, `cluster.local` |

The values in this table come from prior installation/testing notes and **must be checked against the final Distro test cluster before PR submission**. They are not a substitute for deployment evidence.

## 3. Reproduce the Kubernetes installation

### 3.1 Prerequisites

Provide Linux hosts or VMs and an Ansible control host with network connectivity, adequate CPU/memory/storage, supported OS images, time synchronization, SSH access, required load-balancer/control-plane connectivity and an image/package registry reachable from the hosts. Provision the host quantities and resources declared by the released product documentation.

Prepare:

1. The **actual ORKESTRIX Distro release** used for this test (repository/release link and immutable commit or tag).
2. A sanitized sample **Ansible inventory** and variable file containing the Kubernetes v1.37.1 version selection, host roles, cluster DNS and selected CNI/CRI settings.
3. Cluster-specific endpoints, DNS, certificates, registry mirroring and storage parameters. Do not publish private endpoints or credentials.
4. Offline installation assets and registry mappings, if testing the air-gapped configuration.

### 3.2 Apply the ORKESTRIX Distro installer

The installation automation previously inspected in the project includes an `all.yaml` playbook and inventory-based execution similar to:

```bash
# REFERENCE ONLY — replace SITE and variables with the validated Distro release.
# Confirm the inventory and playbook paths against the published product package.
./install.sh ubuntu k8s.yaml
```

**Important:** This command is from prior Ansible automation code review, **not verified as the exact successful ORKESTRIX Distro v1.37.1 deployment invocation**. The official submission should replace this reference with the real product-specific commands, download URL, release revision, and publicly reproducible inventory. Do not use generic `kubeadm init` instructions as a substitute for the product installation process.

### 3.3 Validate the installed Kubernetes cluster

On an administration host, configure an administrator kubeconfig for the installed Distro cluster:

```bash
export KUBECONFIG=/path/to/distro-admin-kubeconfig
kubectl --kubeconfig "$KUBECONFIG" config current-context
kubectl --kubeconfig "$KUBECONFIG" version
kubectl --kubeconfig "$KUBECONFIG" get nodes -o wide
kubectl --kubeconfig "$KUBECONFIG" get pods -A
kubectl --kubeconfig "$KUBECONFIG" get --raw='/readyz?verbose'
```

Confirm the API Server and the relevant nodes report **v1.37.1**, all required nodes are `Ready`, and networking/DNS work. Preserve the verified output internally. Never upload administrator kubeconfig or keys to the public conformance repository.

## 4. Install Sonobuoy

Use a Linux amd64 administration host with `kubectl`, `curl` and `tar` installed and access to the tested cluster:

```bash
SONOBUOY_VERSION=0.57.5
mkdir -p "$HOME/sonobuoy-v1.37" && cd "$HOME/sonobuoy-v1.37"
curl -fL \
  "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz" \
  -o sonobuoy.tar.gz
tar -xzf sonobuoy.tar.gz sonobuoy
chmod +x ./sonobuoy
./sonobuoy version
```

Verify the Sonobuoy download integrity using the release's published checksums where available. Ensure the Sonobuoy aggregator and `registry.k8s.io/conformance:v1.37.1` test image can be pulled (or are mirrored according to the supported installation instructions).

## 5. Execute the certified conformance suite

Use a **dedicated test cluster** because E2E tests can create/delete Kubernetes resources.

```bash
# Inspect the generated test settings before execution.
./sonobuoy gen \
  --kubeconfig "$KUBECONFIG" \
  --mode=certified-conformance > distro-conformance-v1.37.yaml

grep -n -A3 'E2E_FOCUS' distro-conformance-v1.37.yaml

# Run the complete Conformance focus without manually excluding failing cases.
./sonobuoy run \
  --kubeconfig "$KUBECONFIG" \
  --mode=certified-conformance

# Monitor progress.
./sonobuoy status --kubeconfig "$KUBECONFIG"
kubectl --kubeconfig "$KUBECONFIG" get pods -n sonobuoy -o wide
```

**Execution-options check:** The successful Distro run's original command/manifest must be compared with the commands above. If a product-specific flag was used, document it exactly here rather than omitting it.

## 6. Retrieve and validate results

Wait for the `e2e` plugin to complete with a `passed` result. Save the raw results to durable storage before deleting Sonobuoy resources:

```bash
mkdir -p results/extracted
./sonobuoy retrieve ./results \
  --kubeconfig "$KUBECONFIG" \
  --filename distro-sonobuoy-v1.37.1-final.tar.gz
./sonobuoy results ./results/distro-sonobuoy-v1.37.1-final.tar.gz
sha256sum ./results/distro-sonobuoy-v1.37.1-final.tar.gz

tar -xzf ./results/distro-sonobuoy-v1.37.1-final.tar.gz \
  -C ./results/extracted
cp ./results/extracted/plugins/e2e/results/global/e2e.log ./e2e.log
cp ./results/extracted/plugins/e2e/results/global/junit_01.xml ./junit_01.xml
```

Recorded final result for ORKESTRIX Distro: **462 Conformance Passed / 0 Failed**. Validate this independently against the **Distro's own** `e2e.log` and `junit_01.xml` before submitting. Do not use the QKS test evidence in this directory.

After verification and backup:

```bash
./sonobuoy delete --kubeconfig "$KUBECONFIG" --wait
```