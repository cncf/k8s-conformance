# Typhoon

## Setup

Install a Typhoon Kubernetes v1.15.x cluster on [AWS](https://typhoon.psdn.io/cl/aws/), [Azure](https://typhoon.psdn.io/cl/azure/), [bare-metal](https://typhoon.psdn.io/cl/bare-metal/), [DigitalOcean](https://typhoon.psdn.io/cl/digitalocean/) or [Google Cloud](https://typhoon.psdn.io/cl/google-cloud/). Pick any OS + platform combination marked [stable](https://github.com/poseidon/typhoon#modules) for conformance.

Define a cluster at v1.15.x and `terraform apply`. To achieve complete conformance, you must choose to enable aggregation with `enable_aggregation="true"`.

```
module "google-cloud-yavin" {
  source = "git::https://github.com/poseidon/typhoon//google-cloud/container-linux/kubernetes?ref=v1.15.0"

  # Google Cloud
  cluster_name  = "yavin"
  region        = "us-central1"
  dns_zone      = "example.com"
  dns_zone_name = "example-zone"

  # configuration
  ssh_authorized_key = "ssh-rsa AAAAB3Nz..."
  asset_dir          = "/home/user/.secrets/clusters/yavin"

  # optional
  worker_count       = 2
  enable_aggregation = "true"
}
```

Use the generated `kubeconfig` from `ASSETS_DIR/auth/kubeconfig`.

```
$ export KUBECONFIG=/home/user/.secrets/clusters/yavin/auth/kubeconfig
$ kubectl get nodes
NAME                                          STATUS   AGE    VERSION
yavin-controller-0.c.example-com.internal     Ready    6m     v1.15.0
yavin-worker-jrbf.c.example-com.internal      Ready    5m     v1.15.0
yavin-worker-mzdm.c.example-com.internal      Ready    5m     v1.15.0
```

## Reproduce Conformance Results

Use the `sonobuoy` command line tool (requires Go).

```
go get -u -v github.com/heptio/sonobuoy
sonobuoy run
sonobuoy status
sonobuoy retrieve .
mkdir ./results; tar xzf *.tar.gz -C ./results
```

Inspect the results in `plugins/e2e/results/{e2e.log,junit.xml}`.
