# Inspur ICKS

1. Upload ICKS installation package to the master node on which you are running the deploy scripts.
2. Modify "inventory.ini" to configure nodes information.
3. Execute the script "setup.sh" to deploy.
4. Wait for all the nodes reach the "Ready" status, launch the e2e conformance test with following the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
