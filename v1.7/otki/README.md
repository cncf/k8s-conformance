
 These instructions are for the open source [Oracle Terraform Kubernetes Installer](https://github.com/oracle/terraform-kubernetes-installer), which creates a Kubernetes cluster on Oracle Cloud Infrastructure.
 
 To recreate these results:
 
 1. Follow the instructions to create a cluster on Oracle Cloud Infrastructure [Oracle Terraform Kubernetes Installer](https://github.com/oracle/terraform-kubernetes-installer)
 2. Set up kubectl following the steps in the above REAMDE
 3. Verify the cluster using the provided ["cluster-check.sh"](https://github.com/oracle/terraform-kubernetes-installer#verifying-your-cluster) script 
 4. Clone the heptio/sonobuoy repo https://github.com/heptio/sonobuoy
 5. Edit the `examples/quickstart.yaml` and change `value: Pods should be submitted and removed` to `value: Conformance`
 6. Follow the steps in the [README](https://github.com/heptio/sonobuoy/blob/master/README.md)