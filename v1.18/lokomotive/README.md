# Lokomotive

## Setup

Install a Lokomotive v1.18.x cluster on [AWS](https://github.com/kinvolk/lokomotive/blob/v0.3.0/docs/quickstarts/aws.md), [Packet](https://github.com/kinvolk/lokomotive/blob/v0.3.0/docs/quickstarts/packet.md), or [bare-metal](https://github.com/kinvolk/lokomotive/blob/v0.3.0/docs/quickstarts/baremetal.md).

To install, first define a configuration in a `cluster.lokocfg` file.
Here's an AWS config example.

```
variable "ssh_keys" {
  type = "list"
  default = [
    "ssh-rsa AAAAB3Nz...",
  ]
}

cluster "aws" {
  asset_dir = "./assets"

  cluster_name = "conformance"

  dns_zone = "example.com"
  dns_zone_id = "Z..."

  # Change SSH Public keys
  ssh_pubkeys = var.ssh_keys

  worker_pool "conformance-pool" {
    count = 2
    ssh_pubkeys = var.ssh_keys
  }
}
```

Get the lokoctl binary for v0.3.0:

```
curl -L 'https://github.com/kinvolk/lokomotive/releases/download/v0.3.0/lokoctl_0.3.0_linux_amd64.tar.gz' -O
tar xvf lokoctl_0.3.0_linux_amd64.tar.gz
```

Apply the configuration.

```
lokoctl_0.3.0_linux_amd64/lokoctl cluster apply
```

To get the full conformance tests passing you need to

* Enable aggregation with `enable_aggregation = true`.
* Allow inbound NodePort (30000-32767) traffic via firewall rules.

Use the generated `kubeconfig` to check the cluster is ready.

```console
$ export KUBECONFIG=./assets/cluster-assets/auth/kubeconfig
$ kubectl get nodes
NAME             STATUS   ROLES    AGE     VERSION
ip-10-0-15-205   Ready    <none>   3m16s   v1.18.6
ip-10-0-24-252   Ready    <none>   3m11s   v1.18.6
ip-10-0-7-206    Ready    <none>   3m17s   v1.18.6
```

## Conformance tests

Use `sonobuoy`.

```
go get -u -v github.com/vmware-tanzu/sonobuoy
sonobuoy run
sonobuoy status
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

Inspect the results in `plugins/e2e/results/{e2e.log,junit_01.xml}`.
