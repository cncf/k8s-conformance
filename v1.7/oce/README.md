
 These instructions are for the [Oracle Container Engine](http://www.wercker.com/product), which creates a Managed Kubernetes cluster on Oracle Cloud Infrastructure.
 
 To recreate these results:
 
 1. Visit http://www.wercker.com/product to sign up for an account
 2. Create a cluster using these [steps](http://devcenter.wercker.com/docs/getting-started-with-wercker-clusters)
 3. Set up Kubectl for the cluster as described in the "Get Started" instructions in the UI
 4. Leverage the scanner at https://scanner.heptio.com to run conformance tests against the cluster; uncheck the box "RBAC already enabled on this cluster"
 5. Wait for the scan to complete and download the results