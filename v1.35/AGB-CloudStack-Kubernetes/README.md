# AGB Kubernetes Managed Service

## Kubernetes Version
v1.35.2

**Cluster topology:**
- 3 control plane nodes (HA)
- 3 worker nodes
- CNI: Calico
- Storage: local-path provisioner (default StorageClass)

## How to Reproduce

### Prerequisites
- Access to an AGB Cloud environment
- kubectl v1.36.0+ configured with cluster-admin permissions
- Kubeconfig downloaded from AGB Cloud UI (Compute → Kubernetes → Download kubeconfig)

### Install Sonobuoy

**Option A — Install CLI from Go (v0.57.4):**
go install github.com/vmware-tanzu/sonobuoy@latest
export PATH=PATH:PATH:
PATH:(go env GOPATH)/bin

**Option B — Pre-built binary:**
curl -LO https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.17/sonobuoy_0.56.17_linux_amd64.tar.gz
tar -xzf sonobuoy_0.56.17_linux_amd64.tar.gz
sudo mv sonobuoy /usr/local/bin/

### Run Conformance Tests
sonobuoy run --mode=certified-conformance 
--sonobuoy-image=sonobuoy/sonobuoy:v0.56.17

> Note: The sonobuoy/sonobuoy:v0.56.17 image is used because v0.57.x images
> are not yet published to a public registry.

### Monitor Progress
sonobuoy status
sonobuoy logs -f

Tests run approximately 441 conformance specs and take 60–120 minutes.

### Retrieve Results
outfile=$(sonobuoy retrieve)
sonobuoy results $outfile
mkdir conformance-results
tar xzf $outfile -C conformance-results

