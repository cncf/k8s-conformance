# Instruction for conformance test of SECloudit

## Setup the Kubernetes cluster
Kubernetes cluster should be prepared for conformance test.
- A cluster with at least 2 nodes without any taints are required for the conformance tests
- Conformance test results won't be affected by the type of computing machine, but for this test, we used OpenStack virtual machine. 
- Similarly, any Linux-based operating system which is compatible with Kubernetes will work. For this test, we used Ubuntu 24.04.  

1. Install kubelet, kubeadm, kubectl on every Kubernetes node
```bash
# Configure versions to 1.32
sudo apt install kubelet kubeadm kubectl
```

2. Control node configuration
```bash
sudo kubeadm init --apiserver-cert-extra-sans=<CONTROL_NODE_IP> --control-plane-endpoint=<CONTROL_NODE_IP:PORT>
```

3. Worker node configuration
```bash
<kubeadm join command provided by step 2>
```

4. Install a supported CNI
``` bash
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.3/manifests/calico.yaml -O

kubectl apply -f calico.yaml
```

## Register Kubernetes cluster on SECloudit
 - To make SECloudit available to manage the Kubernetes cluster, the user should register the cluster to SECloudit.
 - SECloudit will be installed by the vendor for licensed users.
 1. Login SECloudit
 - Login SECloudit with the administrative account.

 2. Register cluster
  - By providing the required information, registering the cluster to SECloudit starts.
  - After the registration process is successfully completed, SECloudit is ready to manage the cluster.

  ## Run conformance tests
The tests were performed with hydrophone
1. Run command
```bash
./hydrophone --conformance
```