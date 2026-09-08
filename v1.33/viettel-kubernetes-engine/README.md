# Conformance Testing for Viettel Kubernetes Engine

## 1. Cluster Setup

Viettel Kubernetes Engine (VKE) enables users to easily provision and manage Kubernetes clusters through the Viettel Cloud Portal. Follow the steps below to create a cluster.

### 1.1 Create a Cluster

1. Access the [Viettel Cloud Console Portal](https://console.viettelcloud.vn) and log in to your account.
2. From the **Services** menu, select **Kubernetes**.
3. Click **Create Cluster**, provide the required cluster configurations.
4. Click **Add Node Pool**, then configure the node pool configurations.
5. Click **Create Node Pool** to proceed.
6. Review the estimated cost in the **Preview** section.
7. Click **Create** to initiate cluster provisioning.

When your cluster is in **Provisioned** state, you can download your kubeconfig and use it to verify K8s cluster is running properly.

```sh
$ export KUBECONFIG=<path/to/your/kubeconfig/file>
```

Now, you are ready to run conformance test.

---

## 2. Running Conformance Tests

To validate Kubernetes conformance, you can use the Sonobuoy tool.

### 2.1 Install Sonobuoy

```sh
go install github.com/vmware-tanzu/sonobuoy@v0.57.3
```

### 2.2 Execute Conformance Tests

Deploy Sonobuoy to the cluster using the following command:

```sh
sonobuoy run --mode=certified-conformance
```

### 2.3 Retrieve Test Results

After the test run is completed, retrieve the results archive:

```sh
outfile=$(sonobuoy retrieve)
```

Extract the results to a local directory:

```sh
mkdir ./results
tar xzf $outfile -C ./results
```

### 2.4 Clean Up Resources

Remove all Kubernetes resources created by Sonobuoy:

```sh
sonobuoy delete
```
