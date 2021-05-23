Conformance test for CKE
========================

This document describes steps to run the conformance test for certified Kubernetes.

## Prepare environment

1. Prepare Ubuntu or Debian machine that can run KVM virtual machines.
2. Install [Docker CE][].
3. Install [Go][].

## Checkout CKE source code

To test a certain CKE version, checkout the version tag:

```console
$ git clone https://github.com/cybozu-go/cke
$ cd cke/sonobuoy
$ git checkout v1.19.2
```

## Run Sonobuoy

Setup `docker-compose` and Vagrant, use them to setup CKE and its Kubernetes, then run [Sonobuoy][]
with the following commands.

```console
$ sudo make setup-vagrant
$ make run-on-vagrant
$ make sonobuoy
```

When Sonobuoy finishes successfully, it leaves `sonobuoy.tar.gz` file that contains test results.

## Cleanup

Stop and clean Vagrant VMs and Docker containers as follows:

```console
$ make clean
$ vagrant destroy
```

[Sonobuoy]: https://github.com/vmware-tanzu/sonobuoy
[Docker CE]: https://docs.docker.com/install/linux/docker-ce/ubuntu/
[Go]: https://golang.org/doc/install#install
