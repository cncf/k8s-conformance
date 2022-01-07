# k3s
Lightweight Kubernetes
## To Reproduce

1. Create two machines, any modern Linux will work but this test was done with Ubuntu 20.04
2. K3s provides an installation script that is a convenient way to install it as a service on systemd or openrc based systems. This script is available at https://get.k3s.io. To install K3s using this method, just run:

    curl -sfL https://get.k3s.io | sh -

3. To install on worker nodes and add them to the cluster, run the installation script with the K3S_URL and K3S_TOKEN environment variables. Here is an example showing how to join a worker node. The value to use for K3S_TOKEN is stored at /var/lib/rancher/k3s/server/node-token on your server node

    curl -sfL https://get.k3s.io | K3S_URL=https://serverone:6443 K3S_TOKEN=<TOKEN> sh -

4. Run sonobuoy v0.55.1
