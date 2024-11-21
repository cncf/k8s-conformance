# Reproducing the test results

The project can use either KVM or VirtualBox to provision the cluster VMs. The default is to use KVM.

## Prerequisites / compatibility

- This project has been tested under Ubuntu Focal 22.04.4 LTS with 12 hyper-threaded cores and 64 gigs of RAM
- It uses KVM to provision VMs to run Kubernetes
- It is a Kubernetes 1.31.0 distribution and has been tested with kubectl v1.31.0
- This project creates a k8s cluster consisting of three Alma 8 guest VMs configured per the project root `config.yaml` file with each vm having 8 gigs of RAM and 3 CPUs
- So you need sufficient CPU and RAM on the desktop environment to stand up the cluster 

## Get Desktop Kubernetes

```shell
$ git clone --branch v1.31.0 https://github.com/aceeric/desktop-kubernetes.git
$ cd desktop-kubernetes
```

Tag v1.31.0 is the current release tested, which mirrors the release of Kubernetes that the project deploys.

## Check requirements

This is a Bash shell script project and requires certain command-line utilities on the desktop. Run the `dtk` script first with the `--check-compatibility` option. This will compare your versions to what has been tested:

```shell
$ ./dtk --check-compatibility
checking version compatibility
component              tested                found                 matches?
---------              ------                -----                 --------
openssl                3.0.2                 3.0.2                 Yes
openssh                OpenSSH_8.9p1         OpenSSH_8.9p1         Yes
genisoimage            1.1.11                1.1.11                Yes
virtual box            7.0.18_Ubuntur162988  7.0.18_Ubuntur162988  Yes
host operating system  Ubuntu 22.04.4 LTS    Ubuntu 22.04.4 LTS    Yes
kubectl (client only)  v1.31.0               v1.31.0               Yes
curl                   7.81.0                7.81.0                Yes
helm                   v3.13.1               v3.13.1               Yes
yq                     4.40.5                4.40.5                Yes
virt-install           4.0.0                 4.0.0                 Yes
virsh                  8.0.0                 8.0.0                 Yes
qemu-img               6.2.0                 6.2.0                 Yes
```

Version incompatibilities may not be an issue. You have to use your judgement. (Since KVM is the default virtualization, any VirtualBox discrepancies are not relevant for conformance.)

## Create the cluster

If all requirements are reasonably satistfied you create a cluster by running the `dtk` script which in turn reads the cluster configuration from `config.yaml`:

```shell
$ ./dtk
```

The example above will create the cluster by first creating a template VM named `alma8`. It will then clone that template VM into three VMs: `vm1`, `vm2`, and `vm3`, and then proceed to install Kubernetes. On completion, it will display a message telling you how to set your KUBECONFIG environment variable to access the cluster as a cluster admin. The KVM networking is NAT. This provides host-to-guest, guest-to-guest, and guest-to-internet. The example also installs calico cluster networking. CoreDNS is installed by default. OpenEBS is installed for dynamic volume provisioning. (The hostpath provisioner is installed because it is simple and light weight.)

## Run the conformance tests

My procedure follows the guidance at: https://github.com/cncf/k8s-conformance/blob/master/instructions.md

### Here are the steps I performed:

```shell
SONOVER=0.57.2
SONOGZIP=https://github.com/vmware-tanzu/sonobuoy/releases/download/v$SONOVER/sonobuoy_${SONOVER}_linux_amd64.tar.gz
rm -f conformance/sonobuoy
curl -sL $SONOGZIP | tar zxvf - -C conformance sonobuoy
conformance/sonobuoy run --mode=certified-conformance --timeout=30000 --dns-namespace coredns
```

###  Watch the tests run in one console window
```
$ watch 'sonobuoy status --json | json_pp'
```

###  Watch the logs as the tests run in another console window
```
$ conformance/sonobuoy logs -f
```

###  Get the test results upon completion
```
$ outfile=$(conformance/sonobuoy retrieve) &&\
  mv $outfile conformance &&\
  rm -rf conformance/results &&\
  mkdir -p conformance/results &&\
  tar xzf conformance/$outfile -C conformance/results
```
