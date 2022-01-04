# Reproducing the test results

## Prerequisites / compatibility

- This project has been tested under Ubuntu Focal 20.04.2 LTS with 12 hyper-threaded cores and 64 gigs of RAM
- It uses Virtual Box, and has been tested under 6.1.18. The Virtual Box version is important because the script installs Guest Additions into the guests and the version is hard-coded into the script. If you're running a different release of Virtual Box, probably the version incompatibility with Guest Additions would be a problem
- It is a Kubernetes 1.22.0 distribution and has been tested with kubectl 1.22.0
- This project creates a k8s cluster consisting of three CentOS guest VMs: one 4-CPU control plane guest and two 2-CPU worker node guests
- Each vm has 8 gigs of RAM
- So you need sufficient CPU and RAM on the desktop environment to stand up the cluster 

## Get Desktop Kubernetes

```shell
$ git clone --branch v1.0.0 https://github.com/aceeric/desktop-kubernetes.git
$ cd desktop-kubernetes
```

Tag v1.0.0 is the current release tested.

## Check requirements

This is a Bash shell script project and requires certain command-line utilities on the desktop. Run the `new-cluster` script first with the `--check-compatibility` option:

```shell
$ ./new-cluster --check-compatibility
Checking version compatibility
component              tested              found                 matches?
---------              ------              -----                 --------
openssl                1.1.1f              1.1.1f                Yes
openssh                OpenSSH_8.2p1       OpenSSH_8.2p1         Yes
genisoimage            1.1.11              1.1.11                Yes
virtual box            6.1.18r142142       6.1.18_Ubuntur142142  No
host operating system  Ubuntu 20.04.2 LTS  Ubuntu 20.04.3 LTS    No
kubectl (client only)  v1.22.0             v1.22.0               Yes
curl                   7.68.0              7.68.0                Yes

WARNING: Found mismatches between the tested configuration and your configuration
```

Virtualbox needs to be 6.1.18. The other components must exist, but version incompatibilities may not be an issue. You have to use your judgement. But, for example, the script uses the `genisoimage` utility to create ISOs to mount into the CentOS VMs during initialization. So if that utility is missing, the script will fail to gen the cluster. 

## Create the cluster

If all requirements are reasonably satistfied:

```shell
./new-cluster --host-only-network=50.1.1 --vboxdir=/sdb1/virtualbox --create-template\
 --networking=calico --storage=openebs
```

In the `--vboxdir` option, provide a directory for the Virtual Box files that makes sense for your environment. Above is what I use.

The example above will create the cluster by first creating a template VM named "bingo". It will then clone that template VM into a control plane / worker node VM named "doc". Next it will clone the template into two dedicated workers: "ham", and "monk". On completion, it will display a message telling you how to set your KUBECONFIG variable to access the cluster as an admin. The Virtual Box networking is host-only plus NAT. This provides host-to-host, host-to-guest, and guest-to-guest. The example also installs calico cluster networking. CoreDNS is installed by default. OpenEBS is installed for dynamic volume provisioning. (The hostpath provisioner is installed because it is simple and light weight.)

## Run the conformance tests

My procedure followed the guidance at: https://github.com/cncf/k8s-conformance/blob/master/instructions.md

Here are the steps I performed:

```shell
SONOGZIP=https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.53.2/sonobuoy_0.53.2_linux_amd64.tar.gz
[[ -f conformance/sonobuoy ]] || curl -sL $SONOGZIP | tar zxvf - -C conformance sonobuoy

conformance/sonobuoy run --mode=certified-conformance --timeout=30000

####  watch the tests run in one console window

watch 'sonobuoy status --json | json_pp'

####  watch the logs as the tests run in another console window

conformance/sonobuoy logs -f

####  get the test results upon completion

outfile=$(conformance/sonobuoy retrieve) &&\
mv $outfile conformance &&\
mkdir -p conformance/results && tar xzf conformance/$outfile -C conformance/results
```
