Oracle Container Services for use with Kubernetes provides an installation script (`kubeadm-setup.sh`) which utilizes `kubeadm` to simplify
the setup and use of Kubernetes clusters on the Oracle Linux 7 platform. The script also includes upgrade, backup and restore functionality.

1. Please refer to the setup guide for instructions on how to get started: https://docs.oracle.com/cd/E52668_01/E88884/html/index.html
2. To create a master node `kubeadm-setup.sh up`.
3. To join a worker node(s) `kubeadm-setup.sh join --token aaa x.x.x.x:6443`.
4. Once the master and worker node(s) are created, `export KUBECONFIG=path to admin.conf` and run the following commands:
- `curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -`
- `kubectl logs -f -n sonobuoy sonobuoy` (and wait for message such as -> `level=info msg="no-exit was specified, sonobuoy is now blocking"` )
- `kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./resultdir`
