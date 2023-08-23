To reproduce the test results, follow the steps to create a new Kubernetes cluster from scratch using Taikun:
* Create a new project
* Add 1 control plane node, 2 worker and 1 bastion
* Commit the project
* Wait for the cluster to be created
* Create a kubeconfig with cluster-admin rights and download it
* With the kubeconfig file you can run sonobouy as normal.
    * Replace ~/.kube/config, export KUBECONFIG=/wherever/kubeconfig.yaml, or use --kubeconfig.
    * You will need use a system able to connect to the cluster endpoint.
    * You will need to add the fllowing flags --plugin-env e2e.E2E_EXTRA_ARGS="--dns-domain=<CLUSTER_NAME>", with CLUSTER_NAME the name of your cluster in the kubeconfig file,
for instance: `sonobuoy run --plugin-env e2e.E2E_EXTRA_ARGS="--dns-domain=pawan-openstack-1-18760" --plugin-env e2e.E2E_SKIP=""`
