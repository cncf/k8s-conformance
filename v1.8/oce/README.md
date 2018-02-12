
 These instructions are for the [Oracle Container Engine](http://www.wercker.com/product), which creates a Managed Kubernetes cluster on Oracle Cloud Infrastructure.
 
 To recreate these results:
 
 1. Visit http://www.wercker.com/product to sign up for an account
 2. Create a cluster using these [steps](http://devcenter.wercker.com/docs/getting-started-with-wercker-clusters)
 3. Set up Kubectl for the cluster as described in the "Get Started" instructions in the UI
 4. Create a ClusterRoleBinding for the cluster bound to the "cluster-admin" ClusterRole similar to the following, where <token> is the user's Wercker token - "kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --user=<token>"
 5. Follow the standard [conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to run the scan and download the results.