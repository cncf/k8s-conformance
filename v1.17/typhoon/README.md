# Typhoon

## Setup

Install a Typhoon Kubernetes v1.17.x cluster on [AWS](https://typhoon.psdn.io/cl/aws/), [Azure](https://typhoon.psdn.io/cl/azure/), [bare-metal](https://typhoon.psdn.io/cl/bare-metal/), [DigitalOcean](https://typhoon.psdn.io/cl/digitalocean/) or [Google Cloud](https://typhoon.psdn.io/cl/google-cloud/). Pick any OS + platform combination marked [stable](https://github.com/poseidon/typhoon#modules).

Define a cluster at v1.17.x and `terraform apply`.

```
module "google-cloud-yavin" {
  source = "git::https://github.com/poseidon/typhoon//google-cloud/container-linux/kubernetes?ref=v1.17.0"

  # Google Cloud
  cluster_name  = "yavin"
  region        = "us-central1"
  dns_zone      = "example.com"
  dns_zone_name = "example-zone"

  # configuration
  ssh_authorized_key = "ssh-rsa AAAAB3Nz..."

  # optional
  worker_count       = 2
  enable_aggregation = "true"
}

# Obtain cluster kubeconfig
resource "local_file" "kubeconfig-yavin" {
  content  = module.yavin.kubeconfig-admin
  filename = "/home/user/.kube/configs/yavin-config"
}
```

To achieve complete conformance, you **must**:

* Enable aggregation with `enable_aggregation="true"`
* Allow inbound NodePort (30000-32767) traffic via cloud firewall rules
* Not use Preemptible, Spot, or Low Priority instances

Use the generated `kubeconfig` from `ASSETS_DIR/auth/kubeconfig`.

```
$ export KUBECONFIG=/home/user/.kube/configs/yavin-config
$ kubectl get nodes
NAME                                      STATUS ROLES   AGE VERSION
yavin-controller-0.c.example-com.internal Ready  <none>  6m  v1.17.0
yavin-worker-jrbf.c.example-com.internal  Ready  <none>  5m  v1.17.0
yavin-worker-mzdm.c.example-com.internal  Ready  <none>  5m  v1.17.0
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
