To reproduce the test results, follow the steps to create a new Kubernetes cluster from scratch using Nirmata:

On board your cloud resources to Nirmata using Direct Connect or by creating a cloud provider host group
Once all the hosts are connected, create a cluster policy for v1.15 or if already created, pick the v1.15 policy for creating the cluster. Go to the Clusters panel and click on the Add Cluster button to launch the wizard.
Select Kubernetes as the Container Orchestrator and on the next page select: No - Install and manage Kubernetes for me
Provide the cluster namei, pick cluster policy to use baed on your Kubernetes version and cloud-provider based on your host-group and add host groups that you would like to install the cluster on. Select the master nodes in case you want a specific node or if you are using HA cluster. Click on "Create cluster and start the installation" button to proceed with the cluster install.
Within a few minutes, the cluster will be deployed, the Nirmata controller should connect and the cluster state will show as Connected.
Once the cluster is deployed and in Ready state, you can run the conformance tests using kubectl: curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f - or Deploy with the sonobouy executable 
