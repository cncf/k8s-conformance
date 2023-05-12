To reproduce the test results, follow the steps to create a new Kubernetes cluster from scratch using Nirmata:

- On board your cloud resources to Nirmata using VMware vSphere Host Groups or by creating a cloud provider host group.

- Wait for all hosts to connect.
- If no cluster type exists for your cloud provider or generic create a cluster type for v1.25.5
  - Remove the any addons.
- Go to the Clusters panel and click on the Add Cluster button to launch the wizard.
  - Select Install and Manage Kubernetes.
    - Provide the cluster name.
    - Select the cluster type from above.
    - Add the host group that you would like to install the cluster on.
    - Select the master nodes in case you want a specific master node or if you are using HA cluster.
    - Click on "Finished" button to proceed with the cluster install.
- Within a few minutes, the cluster will be deployed, the Nirmata controller should connect and the cluster state will show as Connected (green).
- Once the cluster is deployed and in Ready state download the kubeconfig file for the cluster.
- With the kubeconfig file you can run sonobouy as normal.
  - Replace ~/.kube/config, export KUEBCONFIG=/wherever/kubeconfig.yaml, or use --kubeconfig.
  - You will need use a system able to connect to the cluster endpoint.
