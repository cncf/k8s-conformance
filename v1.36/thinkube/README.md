# Thinkube

Thinkube is an installer. It deploys unmodified upstream Kubernetes with kubeadm
onto your own hardware, then installs the platform components above it.

Thinkube installs unmodified upstream Kubernetes on your own machines and sets up a complete AI development environment on it: notebooks, your GPUs and your models, and a cluster to try what you build, all driven from a coding agent. Kubernetes is installed with kubeadm from the Kubernetes package repository, with containerd and Cilium; nothing in Kubernetes is patched.

## Reproducing the conformance result

### The cluster under test

Results were produced on 2026-09-30 against a three-node mixed-architecture
cluster installed by Thinkube:

| Node | Role | Arch | OS | Kernel |
|---|---|---|---|---|
| tkamd1 | control-plane | amd64 | Ubuntu 24.04.5 LTS | 6.8.0-142-generic |
| tkamd2 | worker | amd64 | Ubuntu 24.04.5 LTS | 6.8.0-142-generic |
| tkspark | worker | arm64 | Ubuntu 24.04.5 LTS | 7.0.0-1019-nvidia |

- Kubernetes v1.36.4 (`gitCommit bb826b1d48562f110659e64e8ec444327433db95`,
  `gitTreeState: clean` — the unmodified upstream release)
- containerd 2.2.4
- Cilium v1.20.1 as CNI

### Step 1 — install the cluster

Thinkube 0.1.0 installs Kubernetes v1.36.4. The install guide is
https://thinkube.org/thinkube-docs/install/overview.html.

1. Prepare the machines: Ubuntu Server 24.04 on each, the same sudo user and
   password, a running SSH server and internet access. The control plane is a
   physical machine with at least 16 CPU cores and 64 GB of memory
   (https://thinkube.org/thinkube-docs/install/node-setup.html).
2. Create the accounts the installer asks for: a domain with its DNS at
   Cloudflare, Tailscale, GitHub and Hugging Face
   (https://thinkube.org/thinkube-docs/install/overview.html#_accounts_and_tokens).
3. On an Ubuntu 24.04 desktop, download the installer for its architecture
   from the release `v0.1.0+k8s.1.36.4` at
   https://github.com/thinkube/thinkube-installer/releases, and install it:

   ```
   sudo apt install ./thinkube-installer_0.1.0_<architecture>.deb
   ```

4. Start *Thinkube Installer*, select the three machines, choose `tkamd1` as
   the control plane, and run the install. The others join as workers
   (https://thinkube.org/thinkube-docs/install/run-the-installer.html).
5. Check the cluster from the control plane:

   ```
   kubectl get nodes -o wide
   kubectl version
   ```

   All three nodes are `Ready`, and the server version is `v1.36.4`.

### Step 2 — run the conformance suite

Tests were run with [hydrophone](https://github.com/kubernetes-sigs/hydrophone)
v0.8.0, the upstream conformance runner.

```
hydrophone --conformance -o .
```

Serial execution, one test thread — hydrophone's default, and what a conformance
submission requires. The run takes about two hours.

It produces the two files submitted here:

- `e2e.log`
- `junit_01.xml`

### Result

```
Ran 446 of 7579 Specs in 7086.293 seconds
SUCCESS! -- 446 Passed | 0 Failed | 0 Pending | 7133 Skipped
```

Total elapsed time 1h58m.
