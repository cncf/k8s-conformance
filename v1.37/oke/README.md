These instructions are for [Oracle Cloud Infrastructure Container Engine for Kubernetes (OKE)](https://cloud.oracle.com/containers/kubernetes-engine), which creates a managed Kubernetes cluster on Oracle Cloud Infrastructure.

To recreate these results:

1. Sign up for an [Oracle Cloud account](https://www.oracle.com/cloud/free/) or use an existing tenancy.
2. Prepare the tenancy for OKE cluster creation:
   - Sign in to the Oracle Cloud Infrastructure Console and select your tenancy.
   - Create or select a compartment for the cluster and its network resources.
   - Use the tenancy's Administrators group or a group granted the appropriate OKE permissions. See [Policy Configuration for Cluster Creation and Deployment](https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengpolicyconfig.htm).
3. Create a Kubernetes cluster:
   - Open **Developer Services > Kubernetes Clusters (OKE)**, select the compartment, and click **Create cluster**.
   - Select **Quick create** and enter a cluster name.
   - Select Kubernetes **v1.37.1** and create a managed node pool with three Linux amd64 worker nodes using **Oracle Linux 8.10** and the **VM.Standard.E3.Flex** shape.
   - Use Flannel pod networking and configure the cluster's VCN, subnets, and API endpoint access.
   - Review the configuration, create the cluster, and wait for the cluster to become Active and the workers to become Ready.
   - See the [Quick Create workflow](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingclusterusingoke_topic-Using_the_Console_to_create_a_Quick_Cluster_with_Default_Settings.htm) for details.
4. Configure access to the cluster:
   - On the **Cluster Details** page, click **Access Cluster**.
   - Use Cloud Shell or a local machine with the OCI CLI and kubectl installed.
   - Run the kubeconfig command displayed in the access dialog and select the resulting cluster context.
   - Ensure the machine running Sonobuoy can reach the Kubernetes API endpoint. See [Accessing a Cluster](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengdownloadkubeconfigfile.htm).
   - Verify the API server and all three workers report Kubernetes v1.37.1:
     ```sh
     kubectl version
     kubectl get nodes -o wide
     ```
5. Install [Sonobuoy v0.57.5](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.57.5) and run the certified conformance suite:
   ```sh
   sonobuoy run \
     --namespace sonobuoy \
     --mode certified-conformance \
     --kubernetes-version v1.37.1 \
     --plugin e2e \
     --sonobuoy-image docker.io/sonobuoy/sonobuoy:v0.57.5 \
     --wait
   ```
   The fully qualified Sonobuoy image name is required when CRI-O enforces short-name resolution. The e2e image is `registry.k8s.io/conformance:v1.37.1`. Certified conformance mode selects `\[Conformance\]` with an empty skip filter.

   To check progress:
   ```sh
   sonobuoy status --namespace sonobuoy
   sonobuoy logs --namespace sonobuoy
   ```
6. After Sonobuoy completes, retrieve and extract the results:
   ```sh
   outfile="$(sonobuoy retrieve --namespace sonobuoy)"
   mkdir -p results
   tar -xzf "$outfile" -C results
   ```
   The submission files are `results/plugins/e2e/results/global/e2e.log` and `results/plugins/e2e/results/global/junit_01.xml`.

This run used Kubernetes v1.37.1, CRI-O 1.37.1, and Sonobuoy v0.57.5. All 462 conformance tests passed with no failures or skipped conformance tests. For the program requirements, see the [CNCF conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).
