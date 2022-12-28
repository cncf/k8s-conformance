# Talos

## How to reproduce the results

**NOTE**: These steps are a reproduction of our QEMU docs at https://www.talos.dev/docs/v1.3/local-platforms/qemu.


## Requirements

- Linux
- a kernel with
  - KVM enabled (`/dev/kvm` must exist)
  - `CONFIG_NET_SCH_NETEM` enabled
  - `CONFIG_NET_SCH_INGRESS` enabled
- at least `CAP_SYS_ADMIN` and `CAP_NET_ADMIN` capabilities
- QEMU
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
[github.com/siderolabs/talos/releases](https://github.com/siderolabs/talos/releases)

```bash
curl https://github.com/siderolabs/talos/releases/download/<version>/talosctl-<platform>-<arch> -L -o talosctl
```

For example version `v0.14.0` for `linux` platform:

```bash
curl https://github.com/siderolabs/talos/releases/download/v0.14.0/talosctl-linux-amd64 -L -o talosctl
sudo cp talosctl /usr/local/bin
sudo chmod +x /usr/local/bin/talosctl
```

## Install Talos kernel and initramfs

QEMU provisioner depends on Talos kernel (`vmlinuz`) and initramfs (`initramfs.xz`).
These files can be downloaded from the Talos release:

```bash
mkdir -p _out/
curl https://github.com/siderolabs/talos/releases/download/<version>/vmlinuz-<arch> -L -o _out/vmlinuz-<arch>
curl https://github.com/siderolabs/talos/releases/download/<version>/initramfs-<arch>.xz -L -o _out/initramfs-<arch>.xz
```

For example version `v1.3.0`:

```bash
curl https://github.com/siderolabs/talos/releases/download/v1.3.0/vmlinuz-amd64 -L -o _out/vmlinuz-amd64
curl https://github.com/siderolabs/talos/releases/download/v1.3.0/initramfs-amd64.xz -L -o _out/initramfs-amd64.xz
```

## Create the Cluster

For the first time, create root state directory as your user so that you can inspect the logs as non-root user:

```bash
mkdir -p ~/.talos/clusters
```

Create the cluster:

```bash
sudo -E talosctl cluster create --provisioner qemu --memory 3072 --cpus 3 --masters 3 --workers 2
```

Once the above finishes successfully, your talosconfig(`~/.talos/config`) will be configured to point to the new cluster.

## Retrieve and Configure the `kubeconfig`

```bash
talosctl -n 10.5.0.2 kubeconfig .
```


## Running e2e tests

```
talosctl conformance kubernetes -n 10.5.0.2 --mode=certified
```
