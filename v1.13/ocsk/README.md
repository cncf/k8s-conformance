Oracle Container Services for use with Kubernetes provides an installation tool (`kubeadm-ha-setup`) which utilizes `kubeadm` to simplify
the setup and use of Kubernetes clusters on the Oracle Linux 7 platform. The tool also includes upgrade, backup and restore functionality.

1. Please refer to the setup guide for instructions on how to get started: https://docs.oracle.com/cd/E52668_01/E88884/html/index.html
2. Please use container-registry.oracle.com/kubernetes_developer image registry
3. Create a yaml file having required values for kubernetes version, image registry, master ip etc
4. To create a master node `kubeadm-ha-setup up <yaml_file>`.
5. To join a worker node(s) `kubeadm-ha-setup join container-registry.oracle.com/kubernetes_developer --token aaa x.x.x.x:6443`.
6. Once the master and worker node(s) are created, `export KUBECONFIG=path to admin.conf`
7. Follow the standard [conformance instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to execute test.
