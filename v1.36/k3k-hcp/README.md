1. Create a K3s host cluster running Kubernetes v1.36.2.

    ```bash
    curl -sfL https://get.k3s.io | \
      INSTALL_K3S_VERSION=v1.36.2+k3s1 \
      INSTALL_K3S_EXEC="--write-kubeconfig-mode=777" \
      sh -

    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

    kubectl cluster-info
    kubectl get nodes
    ```

2. Install the latest k3k release (v1.2.0).

    ```bash
    helm repo add k3k https://rancher.github.io/k3k
    helm repo update
    helm install --namespace k3k-system --create-namespace \
      --version 1.2.0 \
      k3k k3k/k3k

    wget -qO k3kcli \
      https://github.com/rancher/k3k/releases/download/v1.2.0/k3kcli-linux-amd64
    chmod +x k3kcli
    sudo mv k3kcli /usr/local/bin/

    kubectl wait -n k3k-system deployment \
      -l "app.kubernetes.io/name=k3k" \
      --for=condition=Available \
      --timeout=5m

    k3kcli -v
    ```
  
3. Create the HCP-mode cluster on the host using k3kcli:

   ```bash
   k3kcli cluster create \
     --mode hcp \
     --namespace k3k-mycluster \
     --tls-sans <external-ip-or-hostname> \
     --kubeconfig-server <routable-api-server-address> \
     mycluster
   ```

   The command creates the namespace, waits for the cluster to become ready,
   and writes the kubeconfig to
   `k3k-mycluster-mycluster-kubeconfig.yaml`.

4. Join external worker node(s) to the HCP cluster

5. Run the conformance suite with Hydrophone:

   ```bash
   hydrophone --conformance --parallel 4 \
     --kubeconfig ./k3k-mycluster-mycluster-kubeconfig.yaml \
     --output-dir /tmp
   ```
