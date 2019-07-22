# Inspur Incloud K8s for arm64


1. Upload Incloud k8s installation package to the master node on which you are running the deploy scripts.
2. Modify "inventory.ini" to configure nodes information.
3. Execute the script "setup.sh" to deploy.
4. Wait for all the nodes reach the "Ready" status, launch the e2e conformance test with following the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)

**Note:**
More information:
- System: Linux Host OS (Kylin 4.0.2, GNU/Linux 4.4.58, aarch64)
- Installation package with k8s images for arm64