# openSUSE Kubic

## System Requirements

System Requirements
 -  Main memory: minimal 2 GB physical RAM (8 GB recommended, additional memory may be needed depending on your workload)
 -  Hard disk: minimal 30 GB available disk space (40GB+ recommended, increasing based on the needs of your container workloads)
 -  2 CPUs or more
 -  Full network connectivity between all machines in the cluster (public or private network is fine)
 -  Unique hostname and MAC address for every node
 -  Swap disabled. You MUST disable swap in order for kubernetes to work properly

openSUSE Kubic is supported on any Bare Metal or Virtualised environment that meets the official System Requirements

## Installation Instructions

Download either MicroOS\*-Kubic-kubeadm-\* VM or Cloud image from our [appliance download repository](https://download.opensuse.org/tumbleweed/appliances) or alternatively download an installer ISO from our [iso download repository](https://download.opensuse.org/tumbleweed/iso/) and install the `kubeadm` system role.

### Setting up Kubernetes master
On the node to be your cluster master, login using the root password set during the installation.
We recommend using ssh to login to the machine remotely, as it will likely simplify things like copy-and-pasting between machines needed later.

Now run `kubeadm init`

After a brief period, your Master should now be initialised.

Take a note/copy of the line beginning with kubeadm join. You are going to need it to join Nodes to your cluster.

As mentioned in the success message, configure the root user to be able to talk to the cluster by running `mkdir -p ~/.kube`, then `cp -i /etc/kubernetes/admin.conf ~/.kube/config`

### Setting up the network plugin

Setup weave by running `kubectl apply -f /usr/share/k8s-yaml/weave/weave.yaml`

### Joining nodes to the cluster

This now means your master is fully set up and ready for other nodes to join it. You install them the same way as your Master, selecting the kubeadm Node role just as before.

However, unlike on your master, you run the `kubeadm join` command by pasting the line that was presented at the end of the `kubeadm init` run from the Master.

After a short run, you should get the following confirmation that your node has joined the cluster.

### Verifying the cluster

Now from your master node (or any system with `kubectl` installed and the `/etc/kubernetes/admin.config` file from the master copied to your users `$HOME/.kube/config` file) you can run `kubectl get nodes` to confirm your cluster is operational.

Congratulations! You now have a working Kubernetes cluster.

## Compliance Test Reproduction Steps

## The tests

The standard set of conformance tests is currently those defined by the
`[Conformance]` tag in the
[kubernetes e2e](https://github.com/kubernetes/kubernetes/tree/master/test/e2e)
suite.

## Running

The standard tool for running these tests is
[Sonobuoy](https://github.com/vmware-tanzu/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes.

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
sonobuoy run --mode=certified-conformance
```

**NOTE:** The `--mode=certified-conformance` flag is required for certification runs since Kubernetes v1.16 (and Sonobuoy v0.16). Without this flag, tests which may be disruptive to your other workloads may be skipped. A valid certification run may not skip any conformance tests. If you're setting the test focus/skip values manually, certification runs require `E2E_FOCUS=\[Conformance\]` and no value for `E2E_SKIP`.

**NOTE:** You can run the command synchronously by adding the flag `--wait` but be aware that running the conformance tests can take an hour or more.

View actively running pods:

```
sonobuoy status
```

To inspect the logs:

```
sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit_01.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
