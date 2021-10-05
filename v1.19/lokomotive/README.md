# Lokomotive

## Setup

Install a Lokomotive v1.19.x cluster on [AWS](https://github.com/kinvolk/lokomotive/blob/v0.5.0/docs/quickstarts/aws.md), [Packet](https://github.com/kinvolk/lokomotive/blob/v0.5.0/docs/quickstarts/packet.md), or [bare-metal](https://github.com/kinvolk/lokomotive/blob/v0.5.0/docs/quickstarts/baremetal.md).

To install, first define a configuration in a `cluster.lokocfg` file.
Here's an AWS config example.

```tf
variable "ssh_keys" {
  type = "list"
  default = [
    # Change SSH Public keys
    "ssh-rsa AAAAB3Nz...",
  ]
}

cluster "aws" {
  asset_dir        = "./assets"
  cluster_name     = "conformance"
  dns_zone         = "example.com"
  dns_zone_id      = "Z..."
  ssh_pubkeys      = var.ssh_keys
  expose_nodeports = true

  worker_pool "conformance-pool" {
    count       = 2
    ssh_pubkeys = var.ssh_keys
  }
}
```

Export the AWS credentials:

```
export AWS_ACCESS_KEY_ID=EXAMPLEID
export AWS_SECRET_ACCESS_KEY=EXAMPLEKEY
```

> **NOTE**: The AWS credentials file can be found at `~/.aws/credentials` if you have this set up and configured AWS CLI before. If you want to use that account, you don't need to specify any credentials for `lokoctl`.

Get the lokoctl binary for `v0.5.0`:

```bash
curl -LO https://github.com/kinvolk/lokomotive/releases/download/v0.5.0/lokoctl_0.5.0_linux_amd64.tar.gz
tar xvf lokoctl_0.5.0_linux_amd64.tar.gz
```

Apply the configuration:

```bash
lokoctl_0.5.0_linux_amd64/lokoctl cluster apply -v
```

Use the generated `kubeconfig` to check the cluster is ready.

```console
export KUBECONFIG=./assets/cluster-assets/auth/kubeconfig
kubectl delete MutatingWebhookConfiguration admission-webhook-server
```

## Conformance tests

Use `sonobuoy`.

```bash
go get -u -v github.com/vmware-tanzu/sonobuoy
sonobuoy run --mode=certified-conformance
sonobuoy status
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```
