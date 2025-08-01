1. Create a k3s cluster
   curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.33.3+k3s1 sh -

2. Create k3k cluster following the steps below

    # Modify fs inotify host settings to allow multi node virtual clusters
    sudo sysctl -w fs.inotify.max_user_instances=2099999999
    sudo sysctl -w fs.inotify.max_queued_events=2099999999
    sudo sysctl -w fs.inotify.max_user_watches=2099999999

    # Add helm repo for k3k
    helm repo add k3k https://rancher.github.io/k3k
    helm repo update
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

    # Install k3k controller via helm chart
    helm install --namespace k3k-system --create-namespace k3k k3k/k3k --devel

    # Install k3kcli
     wget https://github.com/rancher/k3k/releases/download/v0.3.4-rc1/k3kcli-linux-amd64
    sudo mv k3kcli-linux-amd64 /usr/local/bin/k3kcli
    chmod u+x /usr/local/bin/k3kcli

    # Create a k3k cluster with 1 server and 1 agent
    k3kcli cluster create --namespace virtual --servers 1 --agents 1 --mode virtual k3kcluster
    export KUBECONFIG=/home/ubuntu/virtual-k3kcluster-kubeconfig.yaml

 3. Run Conformance test
    sonobuoy run --mode=certified-conformance --plugin=e2e --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v" --kubernetes-version=v1.33.3 --kubeconfig=/home/ec2-user/virtual-k3kcluster-kubeconfig.yaml
