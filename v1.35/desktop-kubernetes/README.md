# Reproducing the test results

The project can use either KVM or VirtualBox to provision the cluster VMs. The default is to use KVM.

## Prerequisites / compatibility

- This project has been tested under Ubuntu Focal 24.04 LTS with 12 hyper-threaded cores and 64 gigs of RAM.
- It uses KVM to provision VMs to run Kubernetes.
- It is a Kubernetes v1.35.0 distribution.
- This project creates a k8s cluster consisting of four Alma 9 guest VMs configured per the project root config file `conformance.config.yaml`. Each vm has 6 gigs of RAM and 2 CPUs. (So you need sufficient CPU and RAM on the desktop environment to stand up the cluster.)

## Get Desktop Kubernetes

```shell
$ git clone --branch v1.35.0 https://github.com/aceeric/desktop-kubernetes.git
$ cd desktop-kubernetes
```

Tag `v1.35.0` is the tested release, which mirrors the release of Kubernetes that the project deploys.

## Check requirements

This is a Bash shell script project and requires various command-line utilities on the desktop. Run the `dtk` script first with the `check-tools` command:`./dtk check-tools`. This will compare your versions to what has been tested. This is the output for the tested environment (Virtual box is omitted since the test uses KVM):

```shell
component              tested                found                 matches?
---------              ------                -----                 --------
openssl                3.0.13                3.0.13                Yes
openssh                OpenSSH_9.6p1         OpenSSH_9.6p1         Yes
host operating system  Ubuntu 24.04.3 LTS    Ubuntu 24.04.3 LTS    Yes
kubectl (client only)  v1.33.1               v1.33.1               Yes
curl                   8.5.0                 8.5.0                 Yes
helm                   v3.18.0               v3.18.0               Yes
yq                     4.40.5                4.40.5                Yes
virt-install           4.1.0                 4.1.0                 Yes
virsh                  10.0.0                10.0.0                Yes
```

Version incompatibilities may not be an issue. You have to use your judgement. (Since KVM is the default virtualization, any VirtualBox or genisoimage discrepancies are not relevant for conformance since those are not used as part of KVM provisioning.)

> You must install the needed utilities - the project tries not to mutate your desktop.

## Create the cluster

```shell
./dtk --config conformance.config.yaml cluster create
```

The example above creates the cluster by first creating a template VM named `alma9.7`. It then clones that template VM into four VMs: `kronos`, `atlas`, `hyperion`, and `perses`. The script then proceeds to install Kubernetes, Cilium CNI, and CoreDNS. On completion, it displays a message telling you how to set your `KUBECONFIG` environment variable to access the cluster as a cluster admin. The KVM networking is NAT. This provides host-to-guest, guest-to-guest, and guest-to-internet.

Wait for all pods to be running before proceeding.

## Run the conformance tests

The project uses Hydrophone. To install Hydrophone: `go install sigs.k8s.io/hydrophone@latest`. For this submission, version [v0.7.0](https://github.com/kubernetes-sigs/hydrophone/releases/tag/v0.7.0) was used.

Then, run the tests:

```shell
hydrophone --conformance --parallel 5
```

## Verify the test results

Test results are placed in the current working directory by `hydrophone`.
