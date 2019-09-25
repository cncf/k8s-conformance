# Typhoon

## Setup

Install a Typhoon Kubernetes v1.16.x cluster on [AWS](https://typhoon.psdn.io/cl/aws/), [Azure](https://typhoon.psdn.io/cl/azure/), [bare-metal](https://typhoon.psdn.io/cl/bare-metal/), [DigitalOcean](https://typhoon.psdn.io/cl/digitalocean/) or [Google Cloud](https://typhoon.psdn.io/cl/google-cloud/). Pick any OS + platform combination marked [stable](https://github.com/poseidon/typhoon#modules).

Define a cluster at v1.16.x and `terraform apply`.

```
module "google-cloud-yavin" {
  source = "git::https://github.com/poseidon/typhoon//google-cloud/container-linux/kubernetes?ref=v1.16.0"

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

To achieve complete conformance, you **must**:

* Enable aggregation with `enable_aggregation="true"`
* Allow inbound NodePort (30000-32767) traffic via cloud firewall rules
* Not use Preemptible, Spot, or Low Priority instances

Use the generated `kubeconfig` from `ASSETS_DIR/auth/kubeconfig`.

```
$ export KUBECONFIG=/home/user/.secrets/clusters/yavin/auth/kubeconfig
$ kubectl get nodes
NAME                                      STATUS ROLES   AGE VERSION
yavin-controller-0.c.example-com.internal Ready  <none>  6m  v1.16.0
yavin-worker-jrbf.c.example-com.internal  Ready  <none>  5m  v1.16.0
yavin-worker-mzdm.c.example-com.internal  Ready  <none>  5m  v1.16.0
```

Typhoon taints master nodes to isolate the control plane from workloads. E2E/`sonobuoy` requires all nodes be schedulable to start tests (except nodes with the now legacy `node-role.kubernetes.io/master` role). Kubernetes [v1.17 will allow tests to tolerate taints](https://github.com/heptio/sonobuoy/issues/599#issuecomment-531003615), but for v1.16, set the legacy role on all controllers to allow sonobuoy tests to run.

```
$ kubectl label node yavin-controller-0.c.example.com.internal node-role.kubernetes.io/master=true 
$ kubectl get nodes
NAME                                      STATUS ROLES   AGE VERSION
yavin-controller-0.c.example-com.internal Ready  master  6m  v1.16.0
yavin-worker-jrbf.c.example-com.internal  Ready  <none>  5m  v1.16.0
yavin-worker-mzdm.c.example-com.internal  Ready  <none>  5m  v1.16.0
```

You may remove this label later.

```
$ kubectl label node yavin-controller-0.c.example.com.internal node-role.kubernetes.io/master-
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
