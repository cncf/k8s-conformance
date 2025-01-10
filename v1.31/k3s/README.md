# k3s
Lightweight Kubernetes

## To Reproduce

1. Create two machines, any modern Linux will work. This test was done with SUSE Linux Enterprise Server 15 SP5 LTS.
2. K3s provides an installation script that is a convenient way to install it as a service on systemd or openrc based systems. This script is available at https://get.k3s.io. To install K3s using this method, just run:

    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.31.0+k3s1 sh -

3. To install on worker nodes and add them to the cluster, run the installation script with the K3S_URL and K3S_TOKEN environment variables. Here is an example showing how to join a worker node. The value to use for K3S_TOKEN is stored at /var/lib/rancher/k3s/server/node-token on your server node.

    curl -sfL https://get.k3s.io | K3S_URL=https://serverone:6443 K3S_TOKEN=<TOKEN> INSTALL_K3S_VERSION=v1.31.0+k3s1 sh -

4. Run sonobuoy v0.57.1: `sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/controller --ginkgo.v" --mode=certified-conformance --kubernetes-version=v1.31.0 --kubeconfig=/etc/rancher/k3s/k3s.yaml`
