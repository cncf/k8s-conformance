# Reproducing the Stratum conformance results

This document reproduces the Kubernetes conformance results for Stratum
Kubernetes Engine `v1.37`. It installs a cluster of three control-plane nodes
and two workers from a published release, then runs the upstream conformance
suite with [Hydrophone](https://github.com/kubernetes-sigs/hydrophone), the
same way the results in this submission were produced.

Each submission uses the same steps. Replace the placeholders throughout:

| Placeholder | Meaning | Example |
|---|---|---|
| `<arch>` | `amd64` or `arm64` | `amd64` |

All commands on a node run as root. `#` marks a root prompt and `$` an
unprivileged one.

## 1. Host prerequisites

Five Linux hosts, all `amd64` or all `arm64`:

- **cgroup v2.** Stratum does not support cgroup v1. Check with
  `test -e /sys/fs/cgroup/cgroup.controllers`, which succeeds on a cgroup v2
  host.
- Linux kernel 4.19.57 or later. Kernel 5.10 or later is recommended.
- About 2 GB of free disk space for the binary and its unpacked payload, plus
  room for the conformance test images.
- Root access.
- Network: every node reaches every other node on its node IP, and every node
  can pull images from `registry.k8s.io` and the other registries the
  conformance tests use. Stratum itself needs no registry, but the conformance
  image and the test images are pulled from upstream.

The results were produced on Rocky Linux 9 with SELinux enforcing. On a host
where SELinux is enabled, install the SELinux policy packages on every node:

```console
# dnf install container-selinux policycoreutils-python-utils libselinux-utils
```

### Ports between nodes

`stratum up` opens no ports between nodes. If a host firewall runs, open these
on every node:

| Port | From → to | Used by |
|---|---|---|
| 6443/tcp | every node → control planes | API server; workers join through it |
| 10250/tcp | control planes → every node | kubelet: `kubectl logs`, `exec` and `top` |
| 2379-2380/tcp | control plane ↔ control plane | etcd client and peer traffic |
| 9448/tcp | control plane ↔ control plane | Stratum operator admission webhook |
| 8472/udp | every node ↔ every node | Cilium VXLAN: pod traffic between nodes |
| 4240/tcp | every node ↔ every node | Cilium health checks |
| ICMP echo (types 8 and 0) | every node ↔ every node | Cilium health checks |

Pods on one node must also reach the API server on another node from the pod
range (`10.245.0.0/16` by default). With firewalld on the nftables backend,
this configuration does both. Run it on every node, replacing `10.50.0.0/24`
with your node subnet:

```console
# firewall-cmd --permanent --new-zone=stratum

# firewall-cmd --permanent --zone=stratum --add-source=10.50.0.0/24

# firewall-cmd --permanent --zone=stratum \
  --add-port=6443/tcp --add-port=10250/tcp --add-port=2379-2380/tcp \
  --add-port=8472/udp --add-port=4240/tcp --add-port=9448/tcp

# firewall-cmd --permanent --zone=stratum --add-service=ssh

# firewall-cmd --permanent --zone=trusted --add-source=10.245.0.0/16

# firewall-cmd --reload
```

Keep `--add-service=ssh` in its own command: firewalld 2.4 rejects it combined
with `--add-port`. Do not stop firewalld instead. Stratum's Cilium runs with
its host firewall off, so firewalld is the only filter on the node.

## 2. Download the release

Stratum ships as one executable that carries every component and container
image. On each node, download the executable for the node's architecture and
the signed checksum index from the release page,
`https://github.com/ctrliq/stratum/releases/tag/v1.37.1-stratum.0`:

```console
# curl -fLO https://github.com/ctrliq/stratum/releases/download/v1.37.1-stratum.0/stratum-linux-<arch>

# curl -fLO https://github.com/ctrliq/stratum/releases/download/v1.37.1-stratum.0/sha256sums.txt

# sha256sum --check --ignore-missing sha256sums.txt
```

`sha256sum` prints `stratum-linux-<arch>: OK`. To check the signature too,
download `sha256sums.txt.sig` and `sha256sums.txt.pem` from the same release
and verify them with [cosign](https://github.com/sigstore/cosign):

```console
$ cosign verify-blob sha256sums.txt \
  --signature sha256sums.txt.sig --certificate sha256sums.txt.pem \
  --certificate-identity https://github.com/ctrliq/stratum/.github/workflows/release.yml@refs/tags/v1.37.1-stratum.0 \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

Install the executable and check that it runs:

```console
# install -m 0755 stratum-linux-<arch> /usr/local/bin/stratum

# /usr/local/bin/stratum version
```

The commands below call it by its full path, because `sudo` may not search
`/usr/local/bin`.

## 3. Bring up the cluster

The cluster has three control-plane nodes, `cp1`, `cp2` and `cp3`, and two
workers, `w1` and `w2`. `stratum up` stays in the foreground as the node's
supervisor, so run it in its own terminal (or a `tmux` session) on each node
and run the other commands from a second terminal.

### First control plane

On `cp1`:

```console
# /usr/local/bin/stratum up
```

`stratum up` creates the cluster's certificates, imports the container images,
starts containerd, kubelet, etcd and the control plane, and applies Cilium,
CoreDNS and the `local-path` StorageClass. When the node has registered it
prints `stratum: node <name> registered after <time>`. Check that it is
`Ready`:

```console
# /usr/local/bin/stratum kubectl get nodes
```

`stratum up` also installs and enables `stratum.service`, so each node starts
again after a reboot.

### Second and third control planes

Join the control planes one at a time: start the next join only after the
previous node is `Ready`. Each join adds an etcd member, and two concurrent
joins race the quorum.

1. On `cp1`, mint a control-plane join token:

    ```console
    # /usr/local/bin/stratum token create --control-plane
    ```

    It prints the join command with the token and the CA pin, and writes the
    certificate key, which decrypts the shared cluster CA material, to a `0600`
    file whose path it prints.

2. Copy the certificate key file to `cp2`, for example with `scp`.

3. On `cp2`, run the printed join command with the path of the copied key
   file. It has this form:

    ```console
    # /usr/local/bin/stratum up --join https://<cp1-ip>:6443 \
      --token <token> \
      --discovery-token-ca-cert-hash sha256:<pin> \
      --certificate-key-file <path-to-copied-key-file>
    ```

4. On `cp1`, wait until `cp2` is `Ready`:

    ```console
    # /usr/local/bin/stratum kubectl get nodes
    ```

5. Repeat steps 1 to 4 for `cp3`, with a new token.

Delete the certificate key files from every node once all three control planes
are `Ready`.

### Workers

1. On `cp1`, mint a worker join token:

    ```console
    # /usr/local/bin/stratum token create
    ```

2. On `w1` and on `w2`, run the printed command. It has this form:

    ```console
    # /usr/local/bin/stratum up --worker --server https://<cp1-ip>:6443 \
      --token <token> \
      --discovery-token-ca-cert-hash sha256:<pin>
    ```

3. On `cp1`, check that all five nodes are `Ready` and every pod is `Running`:

    ```console
    # /usr/local/bin/stratum kubectl get nodes

    # /usr/local/bin/stratum kubectl get pods -A
    ```

A token expires after 24 hours. If a join fails with
`cluster-info carries no jws-kubeconfig-<token-id> signature`, mint a new
token.

The results were produced without a virtual IP, so every node joins through
`cp1`'s address. To front the API server with a virtual IP instead, set
`spec.vip.address` in `/etc/stratum/config.yaml` on `cp1` before its first
`stratum up`; `stratum token create` then prints the virtual IP in the join
commands. See the High Availability page of the Stratum documentation.

## 4. Get a kubeconfig

On a control plane, the admin kubeconfig is
`/var/lib/stratum/kubeconfig/admin.conf`. The steps below run the suite from
`cp1`:

```console
# export KUBECONFIG=/var/lib/stratum/kubeconfig/admin.conf
```

To run from another machine instead, copy that file there and set
`KUBECONFIG` to its path. The machine must reach the API server address the
file names.

## 5. Run the conformance suite

Install Hydrophone `v0.8.0` on `cp1` from its
[release page](https://github.com/kubernetes-sigs/hydrophone/releases/tag/v0.8.0).
Upstream names the archive by machine architecture: replace `<hw>` with
`x86_64` on an `amd64` node and with `arm64` on an `arm64` node.

```console
# curl -fLO https://github.com/kubernetes-sigs/hydrophone/releases/download/v0.8.0/hydrophone_Linux_<hw>.tar.gz

# curl -fLO https://github.com/kubernetes-sigs/hydrophone/releases/download/v0.8.0/hydrophone_0.8.0_checksums.txt

# sha256sum --check --ignore-missing hydrophone_0.8.0_checksums.txt

# tar -xzf hydrophone_Linux_<hw>.tar.gz hydrophone

# install -m 0755 hydrophone /usr/local/bin/hydrophone
```

Read the API server's version. Stratum's `gitVersion` carries a `-stratum`
suffix; the conformance image tag is the upstream version without it,
`v1.37.1`:

```console
# /usr/local/bin/stratum kubectl version
```

Remove anything a previous run left, then run the full conformance suite
against the upstream conformance image for that version:

```console
# hydrophone --cleanup

# hydrophone --conformance \
  --conformance-image registry.k8s.io/conformance:v1.37.1 \
  --output-dir ./conformance-results
```

The suite takes several hours. Hydrophone exits `0` when every test passes and
nonzero when any test fails. When it finishes, remove its namespace and pods:

```console
# hydrophone --cleanup
```

`./conformance-results` holds `e2e.log` and `junit_01.xml`, the two files this
submission carries. The end of `e2e.log` reports the number of tests that ran
and passed, and `0 Failed`.
