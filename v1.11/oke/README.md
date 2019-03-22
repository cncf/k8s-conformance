
 These instructions are for the [Oracle Cloud Infrastructure Container Engine For Kubernetes](https://cloud.oracle.com/containers/kubernetes-engine), which creates a Managed Kubernetes cluster on Oracle Cloud Infrastructure.
 
 To recreate these results:
 
 1. Visit https://cloud.oracle.com/en_US/tryit to sign up for an account
 2. Create a cluster using these [steps](http://www.oracle.com/webfolder/technetwork/tutorials/obe/oci/oke-full/index.html)
 3. Set up Kubectl for the cluster as described in the "Get Started" instructions in the UI
 4. Create a ClusterRoleBinding for the cluster bound to the "cluster-admin" ClusterRole similar to the following, where OCID is the user's user OCID - "kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --user=<user_OCID>"
 5. Follow the standard [conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to run the scan and download the results.