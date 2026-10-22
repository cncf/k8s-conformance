# NVIDIA Kubernetes Engine (NVKE)

NVIDIA Kubernetes Engine (NVKE) is open source software that AI cloud operators
install on their own infrastructure to create and run fleets of GPU-accelerated
clusters on upstream Kubernetes. An NVKE management plane runs on one durable
Kubernetes cluster and creates Kubernetes clusters on demand, each with its own
control plane, etcd and nodes.

These results are for NVKE v0.22.0 and a cluster running Kubernetes v1.36.3.

- Source: https://github.com/dsx-ai-factory/nvke (tag `v0.22.0`)
- Documentation: https://docs.nvidia.com/nvke
- Full walkthrough: [Your first cluster](https://github.com/dsx-ai-factory/nvke/blob/v0.22.0/docs/first-cluster.md#real-site)

## Tested environment

| Item | Value |
| --- | --- |
| NVKE | v0.22.0 |
| Kubernetes | v1.36.3 |
| Topology | 1 control-plane node, 2 worker nodes |
| Architecture | arm64 |
| Node OS | Ubuntu 24.04.5 LTS, NVKE node image |
| Container runtime | containerd 2.3.0 |
| CNI | OVN-Kubernetes 2.4.2 |
| Conformance runner | Sonobuoy v0.57.5, `--mode=certified-conformance` |

## 1. Install the NVKE management plane

Prerequisites on the machine that runs the bootstrap: `kind`, `nerdctl` with
containerd, `helm`, `kubectl`, `clusterctl`, and GNU Make 4.0+. Every node must
already be imaged with the NVKE node image and run `nvke-agent` and
`spire-agent`. You need each node's IP address and TPM EK thumbprint.

Build `nvkectl`:

```bash
git clone https://github.com/dsx-ai-factory/nvke.git
cd nvke
git checkout v0.22.0
make -C cli build
export PATH="$PWD/cli/bin:$PATH"
```

Generate and validate a site spec. `hosts.csv` lists `name,ip,tpm_ek_thumbprint`
for each management cluster node; use an odd number of nodes.

```bash
nvkectl generate sitespec my-site --nodes hosts.csv \
  --set cluster.controlPlaneVIP=<VIP> \
  --set cluster.podCidr=10.244.0.0/16 \
  --set spire.trustDomain=<trust-domain> \
  --set spire.upstreamCA=true > sitespec.yaml

export NVKECTL_SPIRE_CA_CERT_FILE=./spire-ca.crt NVKECTL_SPIRE_CA_KEY_FILE=./spire-ca.key
nvkectl bootstrap site -f sitespec.yaml --dry-run
```

Bootstrap the management cluster. This writes `my-site.kubeconfig`.

```bash
nvkectl bootstrap site -f sitespec.yaml
```

Install the management plane (Postgres, Temporal, SPIRE, Cluster API, the NICo
infrastructure provider and the NVKE controller) by following
[Run NVKE end to end on one machine](https://github.com/dsx-ai-factory/nvke/blob/v0.22.0/docs/get-started/local-site.md).
Then register the site and confirm the provider is ready:

```bash
nvkectl config set-site --name my-site --url http://<VIP>:30080 \
  --kubeconfig ./my-site.kubeconfig
nvkectl get providers      # nico must report CONFIGURED
```

## 2. Create a Kubernetes v1.36 cluster

Publish a machine image and releases for Kubernetes v1.36.3, starting from the
examples in `cli/examples/`:

```bash
cp cli/examples/machineimage.yaml cli/examples/clusterrelease.yaml \
   cli/examples/nodepoolrelease.yaml .
# Set metadata.name in all three files, and spec.machineImageRef.name in the
# two release files, to the same name. Set the image and Kubernetes version.
nvkectl create machineimage -f machineimage.yaml
nvkectl create clusterrelease -f clusterrelease.yaml
nvkectl create nodepoolrelease -f nodepoolrelease.yaml
```

Create a cluster with one control-plane node and two worker nodes, starting
from `cli/examples/nico-cluster.yaml`. Set each `release` to the name published
above, then create the cluster and fetch its kubeconfig:

```bash
nvkectl create cluster -f nico-cluster.yaml
nvkectl get clusters       # wait until the cluster is ready
nvkectl get kubeconfig <cluster> --output-file cluster.kubeconfig
export KUBECONFIG=$PWD/cluster.kubeconfig
kubectl get nodes          # all nodes Ready
```

## 3. Run the conformance tests

```bash
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results
tar xzf "$outfile" -C ./results
```

The submitted `e2e.log` and `junit_01.xml` are from
`./results/plugins/e2e/results/global/`.

Clean up:

```bash
sonobuoy delete --wait
```
