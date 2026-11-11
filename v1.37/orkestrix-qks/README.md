# ORKESTRIX QKS — Kubernetes v1.37 Conformance

## 1. Product overview

**ORKESTRIX QKS** (formerly **QKS – Quantum Kubernetes Service**) is a hosted Kubernetes management platform developed by **QUANTUM C&S**.

It provides a web-based graphical user interface (GUI) for provisioning Kubernetes clusters and centrally managing multiple clusters and tenants. The platform supports automated cluster lifecycle operations—including provisioning, node pool management, scaling and version upgrades—as well as virtual machine creation and lifecycle management, integrated monitoring, alerting and operational management.

ORKESTRIX QKS uses a QKS-managed, Kamaji-based hosted control-plane model. Kubernetes workloads execute on the worker nodes assigned to each tenant cluster.

### Certified conformance test environment (actual run)

The values in this table identify the **specific environment used to generate the submitted test evidence**. They are not required names for new customer clusters.

| Item | Tested value |
| --- | --- |
| Vendor | QUANTUM C&S |
| Product | ORKESTRIX QKS (Hosted Platform) |
| Previous name | QKS (Quantum Kubernetes Service) |
| Kubernetes conformance version | **v1.37** |
| Kubernetes version tested | **v1.37.1** |
| Tenant cluster name | `ck-test` |
| Tenant cluster DNS domain | `ck-test.local` |
| Worker nodes | 3, all Ready |
| Container runtime | containerd v2.3.6 (as recorded on the test workers) |
| Networking / DNS | Cilium / CoreDNS |
| Control plane | QKS-managed, Kamaji-based |
| Sonobuoy CLI | v0.57.5 |
| Final test date | 2026-10-28 (UTC) |
| Product software release | **To be confirmed by vendor** |

## 2. Architecture and prerequisites

QKS manages the tenant Kubernetes control plane and provisions worker node pools. The certified test used three v1.37.1 workers with Cilium, CoreDNS and Konnectivity agents.

To reproduce the conformance run, prepare:

1. Access to a supported ORKESTRIX QKS deployment and an account with permission to create clusters.
2. Capacity for a dedicated Kubernetes **v1.37.1** tenant cluster with three worker nodes.
3. A reachable Kubernetes API endpoint, cluster-admin credentials and `kubectl` on a Linux amd64 administration host, or access to the QKS browser-based **Connect** terminal.
4. Access to Sonobuoy/conformance container images, or an approved image mirror in isolated environments.
5. Permission for Sonobuoy to create and delete temporary test resources.

The vendor should supply the public QKS installation guide and the product release identifier. Node flavor, OS, storage and network selections specific to the tested environment should be verified against its deployment records rather than inferred.

## 3. Create a tenant Kubernetes cluster with QKS

**Choose your own valid cluster name.** `ck-test` was the name of the particular cluster used for the submitted results; it is **not** a required name or a Sonobuoy setting.

The QKS User Manual documents the following workflow:

1. Sign in to the QKS web console.
2. Navigate to **Clusters → + Create Clusters**.
3. **Basic Information:** enter your desired cluster name (for example, `conformance-test`) and select Kubernetes **v1.37.1**.
4. **Node Pools:** configure an initial pool with **three worker nodes** and select an appropriate node specification.
5. **Network & Add-ons:** configure the network and add-ons supported by your QKS deployment. For a reproduction of the submitted setup, use the corresponding Cilium/CoreDNS configuration.
6. **Review & Create:** verify the configuration and submit the creation request.
7. Open the new cluster's detail page to verify **Node Pools**, **Worker Nodes** (three **Ready** nodes) and the **Operations** status.

> Cluster names, generated kubeconfig filenames and cluster DNS domains can differ between deployments. Use the values of the cluster you actually created. **Do not assume that the DNS domain is always `<cluster-name>.local`**; confirm the configured domain before running Conformance tests.

## 4. Connect to the new cluster

QKS supports two access methods:

- **Kubeconfig:** on **Clusters → [your cluster] → Kubeconfig**, download `<cluster-name>-kubeconfig.yaml` and use it on an administration host.
- **Connect:** open the QKS browser-based terminal for the selected cluster. In the certified test, this was an ephemeral shell; its local `/tmp` files could disappear when the shell Pod was replaced.

On an external administration host, substitute the name of the kubeconfig you downloaded:

```bash
# Replace 'conformance-test' with the name of the cluster you created.
export CLUSTER_NAME="conformance-test"
export KUBECONFIG="$HOME/.kube/${CLUSTER_NAME}-kubeconfig.yaml"

kubectl --kubeconfig "$KUBECONFIG" config current-context
kubectl --kubeconfig "$KUBECONFIG" version
kubectl --kubeconfig "$KUBECONFIG" get nodes -o wide
kubectl --kubeconfig "$KUBECONFIG" get pods -A
```

For the QKS **Connect** terminal, use its provided kubeconfig/context rather than overwriting a working `KUBECONFIG` value.

**Credentials:** never commit kubeconfig, tokens, private keys or internal endpoints to the public conformance repository.

### Determine the actual cluster DNS domain

Open the new cluster's **Cluster DNS Domain** field in QKS cluster details. Verify it against CoreDNS and the kubelet configuration when possible:

```bash
kubectl --kubeconfig "$KUBECONFIG" -n kube-system get configmap coredns -o yaml
# Inspect the 'kubernetes <domain>' stanza in the Corefile.
```

Set the domain from the observed cluster configuration; **do not construct it solely from the cluster name**:

```bash
# EXAMPLE ONLY: replace with the DNS domain shown for your own cluster.
export CLUSTER_DNS_DOMAIN="conformance-test.local"
```

In the **submitted test run**, the actual domain was `ck-test.local`, as configured in CoreDNS and kubelet. Explicitly passing the correct DNS domain is important when it differs from the default `cluster.local`.

## 5. Install Sonobuoy v0.57.5

The certified test used Sonobuoy v0.57.5 on Linux amd64:

```bash
mkdir -p /tmp/sonobuoy-install
cd /tmp/sonobuoy-install

curl -fL \
  https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.5/sonobuoy_0.57.5_linux_amd64.tar.gz \
  -o sonobuoy.tar.gz

tar -xzf sonobuoy.tar.gz sonobuoy
chmod +x ./sonobuoy
./sonobuoy version
```

Verify the downloaded release against the upstream published checksum when available. The browser terminal is ephemeral; a persistent Linux administration host is preferable for retaining evidence.

## 6. Generate and inspect the Conformance configuration

Use the **actual cluster DNS domain** that you set in `CLUSTER_DNS_DOMAIN`. This procedure does **not** require the cluster to be named `ck-test`.

```bash
cd /tmp/sonobuoy-install
: "${KUBECONFIG:?Set KUBECONFIG to your cluster kubeconfig}"
: "${CLUSTER_DNS_DOMAIN:?Set CLUSTER_DNS_DOMAIN from your cluster configuration}"

./sonobuoy gen \
  --kubeconfig "$KUBECONFIG" \
  --mode=certified-conformance \
  --plugin-env "e2e.E2E_EXTRA_ARGS=--dns-domain=${CLUSTER_DNS_DOMAIN}" \
  > qks-sonobuoy-conformance.yaml

grep -n -A4 -B3 'E2E_EXTRA_ARGS' qks-sonobuoy-conformance.yaml
```

Expected generated plugin environment (with the domain substituted):

```yaml
env:
  - name: E2E_EXTRA_ARGS
    value: --dns-domain=<your-actual-cluster-domain>
  - name: E2E_FOCUS
    value: \[Conformance\]
```

No additional Conformance test exclusions were used in the submitted run.

## 7. Run and monitor certified conformance

```bash
./sonobuoy run \
  --kubeconfig "$KUBECONFIG" \
  --mode=certified-conformance \
  --plugin-env "e2e.E2E_EXTRA_ARGS=--dns-domain=${CLUSTER_DNS_DOMAIN}"

./sonobuoy status --kubeconfig "$KUBECONFIG"
kubectl --kubeconfig "$KUBECONFIG" get pods -n sonobuoy -o wide
kubectl --kubeconfig "$KUBECONFIG" -n sonobuoy get configmap sonobuoy-plugins-cm -o yaml
```

The `e2e` plugin reports `running` while tests execute, then `complete` with a `passed` or `failed` result. The `systemd-logs` plugin reports per-node results. The Sonobuoy aggregator Pod can stay `Running` after the suite is complete. Do not delete Sonobuoy resources until the results have been retrieved and backed up.

## 8. Retrieve and validate results

```bash
mkdir -p ./results/extracted

./sonobuoy retrieve ./results \
  --kubeconfig "$KUBECONFIG" \
  --filename qks-sonobuoy-v1.37.1-final.tar.gz

./sonobuoy results ./results/qks-sonobuoy-v1.37.1-final.tar.gz
sha256sum ./results/qks-sonobuoy-v1.37.1-final.tar.gz

tar -xzf ./results/qks-sonobuoy-v1.37.1-final.tar.gz -C ./results/extracted
find ./results/extracted -type f \( -name 'e2e.log' -o -name 'junit*.xml' \)
```

Use the paths shown by `find` to copy `e2e.log` and `junit_01.xml` into the product's submission directory. Keep the original Sonobuoy archive in persistent storage.

### Actual certified test result

The **2026-10-28** run against the QKS cluster **`ck-test`**, with `--dns-domain=ck-test.local`, produced:

```text
E2E plugin: passed
Conformance tests: 462 Passed / 0 Failed / 0 Pending / 2744 Skipped
JUnit: 3213 total; 469 Passed (including 7 setup/report cases), 0 Failed, 2744 Skipped
systemd-logs: 3/3 Passed
API Server: v1.37.1
Node health: 3/3
```

The original archive's SHA256 was:

```text
71e689945e4372e65b6eeaf2f2474cb35612ede3f459f3866400f23df2c8e163
```

**This checksum is evidence of the actual submitted run, not an expected checksum for subsequent independent runs.** A new run will produce its own archive and hash.

A previous run without the explicit `--dns-domain=ck-test.local` option failed `[sig-network] DNS should provide /etc/hosts entries for the cluster [Conformance]` and reported Pod Proxy API lookup errors. The corrected final run passed all 462 Conformance tests. The Pod Proxy error's independent root cause was not established.

If results were downloaded inside the QKS **Connect** terminal, copy them to persistent storage before that temporary shell is removed. As an alternative, use a persistent host with the tenant kubeconfig to run `sonobuoy retrieve` directly. If using `kubectl cp` against the `orkestrix-shell` namespace, use a kubeconfig with access to the cluster where that shell Pod actually resides.

After verifying a persistent backup, you may clean up:

```bash
./sonobuoy delete --kubeconfig "$KUBECONFIG" --wait
```