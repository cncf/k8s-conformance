# Typhoon

## Setup

Define a Typhoon Kubernetes v1.26.x cluster in a Terraform workspace. Pick any OS + platform combination marked [stable](https://github.com/poseidon/typhoon/blob/v1.26.0/README.md#modules) at the v1.26 release.

For example, a cluster on Google Cloud with Fedora CoreOS:

```tf
module "google-cloud-yavin" {
  source = "git::https://github.com/poseidon/typhoon//google-cloud/fedora-coreos/kubernetes?ref=v1.26.0"

  # Google Cloud
  cluster_name  = "yavin"
  region        = "us-central1"
  dns_zone      = "example.com"
  dns_zone_name = "example-zone"

  # configuration
  networking         = "calico"
  ssh_authorized_key = "ssh-ed25519 AAAAB3Nz..."

  # optional
  worker_count       = 2
}

# Obtain cluster kubeconfig
resource "local_file" "kubeconfig-yavin" {
  content  = module.yavin.kubeconfig-admin
  filename = "/home/user/.kube/configs/yavin-config"
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
$ export KUBECONFIG=/home/user/.kube/configs/yavin-config
$ kubectl get nodes
NAME                                      STATUS ROLES   AGE VERSION
yavin-controller-0.c.example-com.internal Ready  <none>  6m  v1.26.0
yavin-worker-jrbf.c.example-com.internal  Ready  <none>  5m  v1.26.0
yavin-worker-mzdm.c.example-com.internal  Ready  <none>  5m  v1.26.0
```

## Reproduce Conformance Results

Install the `sonobuoy` command line tool from [releases](https://github.com/vmware-tanzu/sonobuoy/releases).

```
$ sonobuoy version
Sonobuoy Version: v0.56.10
```

Run `sonobuoy`. Typhoon clusters taint controller nodes with `node-role.kubernetes.io/controller`, rather than the sonobuoy default `node-role.kubernetes.io/master`.

```
sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/controller" --mode=certified-conformance

sonobuoy status
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Inspect the results in `plugins/e2e/results/{e2e.log,junit.xml}`.
