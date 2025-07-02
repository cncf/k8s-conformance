# Conformance tests for vCloud Kubernetes Engine (VCKE)

vCloud Kubernetes Engine (VCKE) is a fully-managed Kubernetes platform hosted by VNETWORK, designed for high-availability, secure, and scalable enterprise workloads. It is built on top of internal vCloud Infrastructure, with integrated Autoscaler, CSI, Popular CNI (Calico, Cilium and Flannel), and more available built-in plugins.

## Prerequisites

- Access to a vCloud Kubernetes Engine (VCKE) environment via Partner Dashboard
- An Kubernetes cluster deployed and running
- kubectl configured to access the VCKE cluster
- Sonobuoy installed

## Running the tests

```bash
# Download and install Sonobuoy
go install github.com/vmware-tanzu/sonobuoy@latest

# Run the conformance tests
sonobuoy run --mode=certified-conformance --wait

# Retrieve the results
outfile=$(sonobuoy retrieve)

# Extract the results
mkdir ./results
tar xzf $outfile -C ./results

# The test results are located in:
# ./results/plugins/e2e/results/global/e2e.log
# ./results/plugins/e2e/results/global/junit_01.xml

# Clean up
sonobuoy delete
```

## Test Environment

- vCloud Kubernetes Engine (VCKE) version: v1.33
- Kubernetes version: 1.33.2
- Infrastructure: VNETWORK vCloud
- Node count: 3
- Node OS: Ubuntu 22.04