# Typhoon

## Setup

Define a Typhoon Kubernetes v1.36.x cluster in a Terraform workspace. Pick any OS + platform combination marked [stable](https://github.com/poseidon/typhoon/blob/e70e564811d2769c7f140f861173d1cae64fd1bd/README.md#modules) at the v1.36 release.

For example, the conformance results were produced on AWS with Fedora CoreOS and Flannel:

```tf
provider "aws" {
  region = "us-east-2"
}

data "aws_route53_zone" "clusters" {
  name = "aws.example.com"
}

module "aws-conform" {
  source = "git::https://github.com/poseidon/typhoon//aws/fedora-coreos/kubernetes?ref=e70e564811d2769c7f140f861173d1cae64fd1bd"

  # AWS
  cluster_name = "conform"
  dns_zone     = data.aws_route53_zone.clusters.name
  dns_zone_id  = data.aws_route53_zone.clusters.zone_id

  # instances
  os_stream              = "stable"
  controller_type        = "t4g.medium"
  controller_arch        = "arm64"
  controller_disk_size   = 15
  controller_cpu_credits = "standard"
  worker_count          = 2
  worker_type           = "m7a.medium"
  worker_price          = 0
  worker_disk_size      = 40

  # configuration
  ssh_authorized_key    = "ssh-ed25519 AAAAB3Nz..."
  networking            = "flannel"
  daemonset_tolerations = ["kubernetes.io/e2e-evict-taint-key"]
}

# Obtain cluster kubeconfig
resource "local_sensitive_file" "kubeconfig-conform" {
  content         = module.aws-conform.kubeconfig-admin
  filename        = "/home/user/.kube/configs/aws-conform-config"
  file_permission = "0600"
}

# Allow conformance tests to reach NodePort services
resource "aws_vpc_security_group_ingress_rule" "conform-conformance" {
  security_group_id = module.aws-conform.worker_security_groups[0]
  description       = "Allow conformance tests to reach NodePort services"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 30000
  to_port           = 32767
}
```

Apply the declared cluster.

```
terraform init
terraform apply
```

To achieve complete conformance, you **must**:

* Allow inbound NodePort (30000-32767) traffic via firewall rules
* Not use Spot instances

Use the generated `kubeconfig`.

```
$ export KUBECONFIG=/home/user/.kube/configs/aws-conform-config
$ kubectl get nodes
```

## Reproduce Conformance Results

Install the `sonobuoy` command line tool from [releases](https://github.com/vmware-tanzu/sonobuoy/releases).

```
$ sonobuoy version
Sonobuoy Version: v0.57.3
```

Run `sonobuoy`. Typhoon clusters taint controller nodes with `node-role.kubernetes.io/controller`, rather than the sonobuoy default `node-role.kubernetes.io/master`.

```
sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/controller" --mode=certified-conformance

sonobuoy status
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Inspect the results in `plugins/e2e/results/global/{e2e.log,junit_01.xml}`.
