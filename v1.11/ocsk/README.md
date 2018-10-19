Oracle Container Services for use with Kubernetes provides an installation script (`kubeadm-setup.sh`) which utilizes `kubeadm` to simplify
the setup and use of Kubernetes clusters on the Oracle Linux 7 platform. The script also includes upgrade, backup and restore functionality.

1. Please refer to the setup guide for instructions on how to get started: https://docs.oracle.com/cd/E52668_01/E88884/html/index.html
2. Please use container-registry.oracle.com/kubernetes_developer repository and export it as `KUBE_REPO_PREFIX` variable
3. To create a master node `kubeadm-setup.sh up`.
4. To join a worker node(s) `kubeadm-setup.sh join --token aaa x.x.x.x:6443`.
5. Once the master and worker node(s) are created, `export KUBECONFIG=path to admin.conf`
6. Follow the standard [conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to execute test.
