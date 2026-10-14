## How to Reproduce

This submission covers QingCloud Kubernetes Engine (QKE) v3.4.0 running Kubernetes v1.35.8.

### Login

Sign in to [QingCloud Console](https://console.qingcloud.com/) with your own account.

### Create QKE Cluster

You can create a QKE cluster according to the [QKE User Guide](https://docsv3.qingcloud.com/container/qke_plus/).

- Choose Product & Services and navigate to QKE cluster.

- Create a QKE v3.4.0 cluster and select Kubernetes v1.35.8.
- Use a highly available cluster topology with three control-plane nodes and three worker nodes.
- The submitted result was produced in the AP2-A region on a linux/amd64 cluster. Each worker node had 4 vCPUs, approximately 8 GiB of memory, and a 50 GiB system disk.

- Connect to a Linux test host with network access to the cluster and configure a kubeconfig with cluster-admin permissions.

> The cluster nodes must be able to pull the images required by the Kubernetes conformance suite. In an environment with restricted registry access, preload the required images while preserving their original image references.

### Run Conformance Tests

Install [Sonobuoy v0.57.3](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.57.3) on the test host and verify the downloaded binary against the published checksum. Confirm that the selected kubeconfig points to the Kubernetes v1.35.8 cluster and has cluster-admin permissions:

```shell
export KUBECONFIG=/path/to/admin.conf
kubectl version
kubectl get nodes
kubectl auth can-i '*' '*' --all-namespaces
kubectl auth can-i create clusterrolebindings.rbac.authorization.k8s.io
sonobuoy version
```

Both permission checks must return `yes`. Do not start the test with a read-only or namespace-scoped kubeconfig.

Start the complete certified conformance test suite. Do not configure an E2E skip filter:

```shell
sonobuoy run --mode=certified-conformance --kubernetes-version=v1.35.8
```

This command starts the test resources and then returns. A successful command exit only confirms that the run was launched; it does not mean that the conformance tests passed.

Monitor the run until Sonobuoy reports that it has completed and every plugin has `RESULT: passed`:

```shell
sonobuoy status
sonobuoy logs -f
```

Only after completion, retrieve the result archive and extract it into a new directory. The directory check prevents results from different runs from being mixed:

```shell
OUTPUT_PATH=$(sonobuoy retrieve)
echo "${OUTPUT_PATH}"
RESULTS_DIR=$(mktemp -d ./results-v1.35.8-XXXXXX)
tar xzf "${OUTPUT_PATH}" -C "${RESULTS_DIR}"
```

The two generated test-result files used for this submission are:

```text
${RESULTS_DIR}/plugins/e2e/results/global/e2e.log
${RESULTS_DIR}/plugins/e2e/results/global/junit_01.xml
```

The submitted run completed in approximately 1 hour and 50 minutes with the following result:

```text
Status: passed
Conformance specs: 441
Failed: 0
Pending: 0
Skipped non-conformance specs: 6914
```

Clean up the Sonobuoy resources after preserving the result archive:

```shell
sonobuoy delete
```
