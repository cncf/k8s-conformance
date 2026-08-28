# Tencent Kubernetes Engine (TKE) Conformance

## Product Information

| Field | Value |
| --- | --- |
| Vendor | Tencent Cloud |
| Product | Tencent Kubernetes Engine (TKE) |
| Kubernetes Version | v1.36.2 |
| Product Type | Hosted Platform |
| Website | https://intl.cloud.tencent.com/product/tke |
| Documentation | https://intl.cloud.tencent.com/document/product/457 |

## Table of Contents

- [Prerequisites](#prerequisites)
- [Create a TKE Cluster](#create-a-tke-cluster)
- [Connect to the Cluster](#connect-to-the-cluster)
- [Run the Conformance Test](#run-the-conformance-test)
- [Clean Up](#clean-up)

## Prerequisites

Before creating a cluster, make sure you have:

- A valid [Tencent Cloud Account](https://intl.cloud.tencent.com/register).
- Completed real-name verification for the account.
- A VPC and at least one subnet available in the target region. If you do not have one, create a [VPC and subnet](https://intl.cloud.tencent.com/document/product/215) first.
- Sufficient quota for CVM instances in the target region (at least two nodes are recommended for the conformance test).

## Create a TKE Cluster

1. Log in to the [Tencent Kubernetes Engine console](https://console.cloud.tencent.com/tke2/cluster).
2. Click **Create** and select **Standard Cluster**.
3. Configure the cluster with the following settings:

   | Setting | Value |
   | --- | --- |
   | Cluster Name | `conformance-v1.36` (or any name) |
   | Region | Any region outside of mainland China (e.g. **Bangkok**) |
   | Kubernetes Version | **1.36.2** |
   | Runtime | containerd |
   | Network Plugin | Global Router or VPC-CNI |
   | Cluster CIDR | Use the default or your own CIDR (e.g. `172.16.0.0/16`) |

4. Add a **node pool** with at least two worker nodes. The recommended node spec is at least **4 vCPU / 8 GiB**.
5. Enable **public network access** for the cluster API server (or enable VPC access and connect from a jump host inside the VPC), then click **Create**.
6. Wait for the cluster status to become **Running**.

## Connect to the Cluster

1. On the cluster details page, click **Obtain kubeconfig** (or use the `tccli` CLI) to download the kubeconfig file.
2. Configure `kubectl` and verify the cluster is reachable:

   ```shell
   export KUBECONFIG=/path/to/your/kubeconfig
   kubectl cluster-info
   kubectl get nodes
   ```

3. Make sure all nodes are in the `Ready` state before running the conformance test.

## Run the Conformance Test

1. Install the Sonobuoy CLI. Download the latest [release binary](https://github.com/vmware-tanzu/sonobuoy/releases) for your platform (for example):

   ```shell
   VERSION=v0.57.2
   curl -LO "https://github.com/vmware-tanzu/sonobuoy/releases/download/${VERSION}/sonobuoy_${VERSION}_linux_amd64.tar.gz"
   tar xzf "sonobuoy_${VERSION}_linux_amd64.tar.gz"
   sudo install -m 0755 sonobuoy /usr/local/bin/sonobuoy
   ```

2. Run the conformance test:

   ```shell
   sonobuoy run --mode=certified-conformance --wait
   ```

3. Watch the status until the run completes:

   ```shell
   sonobuoy status
   ```

4. Once the status shows `complete`, retrieve the results:

   ```shell
   outfile=$(sonobuoy retrieve)
   mkdir -p ./results && tar xzf "$outfile" -C ./results
   ```

5. Verify that the tests passed:

   ```shell
   sonobuoy results "$outfile"
   ```

   The expected output indicates `446 Passed | 0 Failed` for the conformance specs.

6. The `e2e.log` and `junit_01.xml` files produced by this run are the ones included in this submission.

See the [conformance suite instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) for more details.

## Clean Up

After the test completes, delete the Sonobuoy resources from the cluster:

```shell
sonobuoy delete --wait
```

If you no longer need the cluster, delete it from the TKE console to avoid ongoing charges.
