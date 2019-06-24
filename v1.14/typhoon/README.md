# Typhoon

## Setup

Install a Typhoon Kubernetes v1.14.x cluster on [bare-metal](https://typhoon.psdn.io/cl/bare-metal/), [AWS](https://typhoon.psdn.io/cl/aws/), or [Google Cloud](https://typhoon.psdn.io/cl/google-cloud/). You may pick any OS + platform combination marked [stable](https://github.com/poseidon/typhoon#modules).

Define a cluster at v1.14.0 and `terraform apply`. To achieve complete conformance, you must choose to enable aggregation with `enable_aggregation="true"`.

```
module "google-cloud-yavin" {
  source = "git::https://github.com/poseidon/typhoon//google-cloud/container-linux/kubernetes?ref=v1.14.0"

  providers = {
    google   = "google.default"
    local    = "local.default"
    null     = "null.default"
    template = "template.default"
    tls      = "tls.default"
  }

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
yavin-controller-0.c.example-com.internal     Ready    6m     v1.14.0
yavin-worker-jrbf.c.example-com.internal      Ready    5m     v1.14.0
yavin-worker-mzdm.c.example-com.internal      Ready    5m     v1.14.0
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
