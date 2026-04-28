# To reproduce

## Set up the cluster

1. Login to https://portal.previder.com
2. Make sure you have your infrastructure all setup (Network, Gateway, DNS, DHCP)
2. Navigate to menu option Kubernetes and choose Clusters
2. Press the "New Cluster" button.
2. Create a cluster with the next specifications:
   - Any type
   - High available control plane off
   - At least medium worker node size
   - At least 2 worker nodes
2. Choose a cluster name e.g. "Conformance 1.36"
2. Disable the automatic updates option and select Kubernetes version v1.36.x.
2. Choose Cilium or Calico as pre-installed CNI

Download the kubeconfig file, when the cluster state is ready, via the endpoints tab in the cluster details.

## Run Sonobuoy conformance test
Download the latest [Sonobuoy binary](https://github.com/vmware-tanzu/sonobuoy/releases) and run with your downloaded config.
```bash
./sonobuoy run --mode=certified-conformance --wait --kubeconfig ~/Downloads/Conformance\ 1.36-kubeconfig
```

These tests will take up to two hours, depending on your cluster's capacity.

## Get Sonobuoy results
After the tests finish, retrieve the results using your downloaded kubeconfig.
```bash
outfile=$(./sonobuoy retrieve --kubeconfig ~/Downloads/Conformance\ 1.36-kubeconfig)
mkdir ./results; tar xzf $outfile -C ./results
```

