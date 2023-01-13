# Conformance tests for RKE Kubernetes cluster

## Node Provisioning
Provision 3 nodes for your cluster. Follow the [OS requirements](https://rancher.com/docs/rke/latest/en/os/). In this case, Ubuntu 20.04 was used.

## Setup Your `cluster.yml` File

A minimal 3-node `cluster.yml` file should look like this:
```yaml
kubernetes_version: v1.25.5-rancher1-1
nodes:
  - address: xx.xx.xx.1
    hostname_override: node-1
    user: root
    role: [controlplane,worker,etcd]
  - address: xx.xx.xx.2
    hostname_override: node-2
    user: root
    role: [worker]
  - address: xx.xx.xx.3
    hostname_override: node-3
    user: root
    role: [worker]
services:
  kube-api:
     extra_args:
       service-account-issuer: https://xx.xx.xx.1:6443
ingress:
  provider: none
```

Save this file with your node IP addresses filled in.

## Run RKE
Follow the [installation](https://rancher.com/docs/rke/latest/en/installation/) to install the latest RKE release.

From your workstation, open a web browser and navigate to our [RKE Releases](https://github.com/rancher/rke/releases) page. Download the latest RKE installer applicable to your Operating System and Architecture:

MacOS: rke_darwin-amd64
Linux (Intel/AMD): rke_linux-amd64
Linux (ARM 32-bit): rke_linux-arm
Linux (ARM 64-bit): rke_linux-arm64
Windows (32-bit): rke_windows-386.exe
Windows (64-bit): rke_windows-amd64.exe

Copy the RKE binary to a folder in your $PATH and rename it rke (or rke.exe for Windows)

```
# MacOS
$ mv rke_darwin-amd64 rke
# Linux
$ mv rke_linux-amd64 rke
# Windows PowerShell
> mv rke_windows-amd64.exe rke.exe
```
If not on Windows, make the RKE binary that you just downloaded executable. Open Terminal, change directory to the location of the RKE binary, and:
```
$ chmod +x rke
```
2. In the same directory as your `cluster.yml` file, run:
```bash
$ rke up
```
3. Wait until the cluster deployment completes successfully.

## Run Conformance Test

Follow the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

The standard tool for running these tests is
[Sonobuoy](https://github.com/vmware-tanzu/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes.

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
