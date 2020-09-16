# Talos

## How to reproduce the results

**NOTE**: These steps are a reproduction of our QEMU docs at https://www.talos.dev/docs/v0.6/en/guides/local/qemu.


## Requirements

- Linux
- a kernel with
  - KVM enabled (`/dev/kvm` must exist)
  - `CONFIG_NET_SCH_NETEM` enabled
  - `CONFIG_NET_SCH_INGRESS` enabled
- at least `CAP_SYS_ADMIN` and `CAP_NET_ADMIN` capabilities
- QEMU
- `bridge`, `static` and `firewall` CNI plugins from the [standard CNI plugins](https://github.com/containernetworking/cni), and `tc-redirect-tap` CNI plugin from the [awslabs tc-redirect-tap](https://github.com/awslabs/tc-redirect-tap) installed to `/opt/cni/bin`
- iptables
- `/etc/cni/conf.d` directory should exist
- `/var/run/netns` directory should exist

## Installation

### How to get QEMU

Install QEMU with your operating system package manager.
For example, on Ubuntu for x86:

```bash
apt install qemu-system-x86 qemu-kvm
```

### Install talosctl

You can download `talosctl` and all required binaries via
[github.com/talos-systems/talos/releases](https://github.com/talos-systems/talos/releases)

```bash
curl https://github.com/talos-systems/talos/releases/download/<version>/talosctl-<platform>-<arch> -L -o talosctl
```

For example version `v0.6.1` for `linux` platform:

```bash
curl https://github.com/talos-systems/talos/releases/download/v0.6.1/talosctl-linux-amd64 -L -o talosctl
sudo cp talosctl /usr/local/bin
sudo chmod +x /usr/local/bin/talosctl
```

### Install bridge, firewall and static required CNI plugins

You can download standard CNI required plugins via
[github.com/containernetworking/plugins/releases](https://github.com/containernetworking/plugins/releases)

```bash
curl https://github.com/containernetworking/plugins/releases/download/<version>/cni-plugins-<platform>-<arch>-<version>tgz -L -o cni-plugins-<platform>-<arch>-<version>.tgz
```

For example version `v0.8.5` for `linux` platform:

```bash
curl https://github.com/containernetworking/plugins/releases/download/v0.8.5/cni-plugins-linux-amd64-v0.8.5.tgz -L -o cni-plugins-linux-amd64-v0.8.5.tgz
mkdir cni-plugins-linux
tar -xf cni-plugins-linux-amd64-v0.8.5.tgz -C cni-plugins-linux
sudo mkdir -p /opt/cni/bin
sudo cp cni-plugins-linux/{bridge,firewall,static} /opt/cni/bin
```

### Install tc-redirect-tap CNI plugin

You should install CNI plugin from the `tc-redirect-tap` repository [github.com/awslabs/tc-redirect-tap](https://github.com/awslabs/tc-redirect-tap)

```bash
go get -d github.com/awslabs/tc-redirect-tap/cmd/tc-redirect-tap
cd $GOPATH/src/github.com/awslabs/tc-redirect-tap
make all
sudo cp tc-redirect-tap /opt/cni/bin
```

> Note: if `$GOPATH` is not set, it defaults to `~/go`.

## Install Talos kernel and initramfs

QEMU provisioner depends on Talos kernel (`vmlinuz`) and initramfs (`initramfs.xz`).
These files can be downloaded from the Talos release:

```bash
mkdir -p _out/
curl https://github.com/talos-systems/talos/releases/download/<version>/vmlinuz -L -o _out/vmlinuz
curl https://github.com/talos-systems/talos/releases/download/<version>/initramfs.xz -L -o _out/initramfs.xz
```

For example version `v0.6.1`:

```bash
curl https://github.com/talos-systems/talos/releases/download/v0.6.1/vmlinuz -L -o _out/vmlinuz
curl https://github.com/talos-systems/talos/releases/download/v0.6.1/initramfs.xz -L -o _out/initramfs.xz
```

## Create the Cluster

For the first time, create root state directory as your user so that you can inspect the logs as non-root user:

```bash
mkdir -p ~/.talos/clusters
```

Create the cluster:

```bash
sudo -E talosctl cluster create --provisioner qemu --memory 3072 --cpus 3 --masters 3 --workers 2 --kubernetes-version 1.19.1
```

Once the above finishes successfully, your talosconfig(`~/.talos/config`) will be configured to point to the new cluster.

## Retrieve and Configure the `kubeconfig`

```bash
talosctl -n 10.5.0.2 kubeconfig .
```


## Running e2e tests

```
go get -u -v github.com/heptio/sonobuoy
sonobuoy run --wait --skip-preflight --mode=certified-conformance --plugin e2e --plugin-env e2e.E2E_USE_GO_RUNNER=true
results=$(sonobuoy retrieve)
sonobuoy e2e $results
mkdir ./results; tar xzf ${results} -C ./results
```
