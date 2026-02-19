To reproduce the test results, follow the steps to create a new Kubernetes cluster from scratch using Nirmata:

- On board your cloud resources to Nirmata using VMware vSphere Host Groups or by creating a cloud provider host group.

- Wait for all hosts to connect.
- If no cluster type exists for your cloud provider or generic create a cluster type for v1.33.0
  - Remove any addons.
- Go to the Clusters panel and click on the Add Cluster button to launch the wizard.
  - Select Install and Manage Kubernetes.
    - Provide the cluster name.
    - Select the cluster type from above.
    - Add the host group that you would like to install the cluster on.
    - Select the master nodes in case you want a specific master node or if you are using HA cluster.
    - Click on "Finished" button to proceed with the cluster install.
- Within a few minutes, the cluster will be deployed, the Nirmata controller should connect and the cluster state will show as Connected (green).
- Once the cluster is deployed and in Ready state download the kubeconfig file for the cluster.
- With the kubeconfig file you can run sonobuoy as normal.
  - Replace ~/.kube/config, export KUBECONFIG=/wherever/kubeconfig.yaml, or use --kubeconfig.
  - You will need to use a system able to connect to the cluster endpoint.

## Running Conformance Tests

```bash
# Download and install Sonobuoy
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
tar -xzf sonobuoy_0.57.3_linux_amd64.tar.gz
sudo mv sonobuoy /usr/local/bin/

# Run conformance tests
sonobuoy run --mode=certified-conformance --wait

# Retrieve results
outfile=$(sonobuoy retrieve)
sonobuoy results $outfile

# Extract artifacts
mkdir -p ./results
tar xzf $outfile -C ./results
cp ./results/plugins/e2e/results/global/e2e.log .
cp ./results/plugins/e2e/results/global/junit_01.xml .

# Cleanup
sonobuoy delete --wait
```
