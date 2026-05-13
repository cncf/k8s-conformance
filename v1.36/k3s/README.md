# K3S - Lightweight Kubernetes

The certified Kubernetes distribution built for IoT & Edge computing.

## Cluster Setup

1. Create two machines, any modern Linux will work. For this test, the cluster was created with 1 control-plane,etcd node and 1 worker node using **SUSE Linux Enterprise Server 16.0**.
2. K3s provides an installation script that is a convenient way to install it as a service on *systemd* or *openrc* based systems. This script is available at https://get.k3s.io. To install K3s using this method, just run:
    ```
    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.36.0+k3s1 sh -
    ```
3. To install on worker nodes and add them to the cluster, run the installation script with the **K3S_URL** and **K3S_TOKEN** environment variables. Here is an example showing how to join a worker node. The value to use for K3S_TOKEN is stored at */var/lib/rancher/k3s/server/node-token* on your server node.
    ```
    curl -sfL https://get.k3s.io | K3S_URL=https://<serverOne-ip>:6443 K3S_TOKEN=<TOKEN> INSTALL_K3S_VERSION=v1.36.0+k3s1 sh -
    ```
## Running Conformance Tests

1. Download, extract and run sonobuoy version **v0.57.3**.
    ```
    sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/controller --ginkgo.v" --mode=certified-conformance --kubernetes-version=v1.36.0 --kubeconfig=/etc/rancher/k3s/k3s.yaml
    ```
2. Check sonobouy status. (It may take 60 minutes or longer to run)
   ```
   $ sonobuoy status --kubeconfig=/etc/rancher/k3s/k3s.yaml
         PLUGIN     STATUS   RESULT   COUNT   PROGRESS
            e2e   complete   passed       1
   systemd-logs   complete   passed       2

   Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
   ```
3. Retrieve results. (Once all the tests are completed)
   ```
   $ sonobuoy retrieve --kubeconfig=/etc/rancher/k3s/k3s.yaml
   ```
4. Review results using the tar file. 
   ```
   $ sonobuoy results <tar.gz file>
   ```