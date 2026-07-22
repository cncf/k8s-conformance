# ORKESTRIX

ORKESTRIX is a full-stack Kubernetes distribution developed by QUANTUM C&S. It automates the entire infrastructure lifecycle—from virtual machine provisioning on OpenStack using Terraform, through operating system configuration, to Kubernetes cluster installation using Ansible (kubeadm-based).

ORKESTRIX deploys upstream Kubernetes packages from `pkgs.k8s.io` and is designed to support both internet-connected and air-gapped environments.

**Documentation:** https://docs.quantumcns.ai

---

# Key Features

- **Multi-OS Support** — Supports Ubuntu and RedHat-based operating systems.
- **Flexible Networking** — Pluggable CNI support (e.g. Cilium) configurable for each environment.
- **Flexible Storage** — Supports pluggable CSI drivers including Ceph-based storage backends.
- **Air-Gapped Deployment** — Supports isolated environments using internally mirrored package repositories and container registries.
- **Online Deployment** — Installs Kubernetes packages directly from the official `pkgs.k8s.io` repository.
- **Platform Add-ons** — Optional installation of monitoring, logging, ingress, and other platform components.
- **Multiple Node Roles** — Supports control-plane, worker, GPU, NFS, Ceph, and CI/CD nodes.
- **Infrastructure Automation** — Terraform provisions infrastructure while Ansible performs end-to-end Kubernetes installation and configuration.

---

# Cluster Provisioning

## Prerequisites

- Terraform >= 1.0
- Ansible >= 2.12
- Access to an OpenStack environment
- ORKESTRIX deployment repository

---

## 1. Provision Virtual Machines

Navigate to the Terraform directory and create a `terraform.tfvars` file.

```hcl
inventory_file              = "../../../inventory/<cluster-name>/hosts.ubuntu"
qks_cluster_name            = "<cluster-name>"
qks_kube_node_keypair       = "<openstack-keypair-name>"
qks_kube_node_image_id      = "<ubuntu-image-id>"

create_lb                   = false

qks_kube_master_flavor      = "<master-flavor-id>"
qks_kube_master_num         = 1
qks_kube_master_volume_type = "CEPH_SSD"

qks_kube_worker_flavor      = "<worker-flavor-id>"
qks_kube_worker_num         = 2
qks_kube_worker_volume_type = "CEPH_SSD"

qks_kube_cicd_num           = 0
qks_kube_gpu_num            = 0
qks_kube_nfs_num            = 0
qks_kube_ceph_num           = 0
```

Provision the infrastructure.

```bash
cd terraform/openstack/<cluster-name>

terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Terraform automatically generates the Ansible inventory for the newly created cluster.

---

## 2. Install Kubernetes

Run the ORKESTRIX Ansible playbook.

```bash
ansible-playbook \
  -i inventory/<cluster-name>/hosts.ubuntu \
  k8s.yaml
```

This installs upstream Kubernetes using kubeadm together with containerd, Cilium CNI, and the required cluster components.

---

## 3. Access the Cluster

Retrieve the kubeconfig from the control-plane node.

```bash
scp ubuntu@<control-plane-ip>:~/.kube/config ./kubeconfig

export KUBECONFIG=./kubeconfig

kubectl get nodes
```

---

# Run Kubernetes Conformance Tests

Install Sonobuoy.

```bash
go install github.com/vmware-tanzu/sonobuoy@v0.56.17
```

Remove the default control-plane taints so Sonobuoy can schedule workloads.

```bash
kubectl taint nodes <control-plane-node> node-role.kubernetes.io/control-plane:NoSchedule-

kubectl taint nodes <control-plane-node> node-role.kubernetes.io/master:NoSchedule-
```

Run the certified Kubernetes conformance tests.

```bash
sonobuoy run --mode=certified-conformance
```

Monitor progress.

```bash
sonobuoy status
```

Retrieve the test results.

```bash
outfile=$(sonobuoy retrieve)

mkdir results

tar xzf "$outfile" -C results

sonobuoy results "$outfile"
```

The conformance artifacts are located under:

```text
results/plugins/e2e/results/global/e2e.log

results/plugins/e2e/results/global/junit_01.xml
```

Clean up Sonobuoy resources.

```bash
sonobuoy delete --wait
```