Conformance test for CKE
========================

This document describes steps to run the conformance test for certified Kubernetes.

## Prepare environment

1. Prepare a Linux environment that runs on an x86_64 machine.
   * Prepare `make`, `curl`, and `ssh-keygen` commands.
   * The restriction of the architecture comes from the URL of CoreOS Container Linux Config Transpiler in `sonobuoy/Makefile` .  You would be able to use another type of machine with a better Makefile.
2. Prepare a [Google Cloud Platform][] (GCP) account that can run 4 virtual machines.
   * Prepare `gcloud` command.

## Checkout CKE source code

To test a certain CKE version, checkout the version tag:

```console
$ git clone https://github.com/cybozu-go/cke
$ cd cke
$ git checkout v1.24.0
```

## Write down your GCP/GCE information

Edit the following lines in `bin/env-sonobuoy` to give information about your GCP account and GCE configuration.
Please choose an appropriate ZONE to run C2 machine family VMs.

```
PROJECT=neco-test
ZONE=asia-northeast1-c
SERVICE_ACCOUNT=neco-test@neco-test.iam.gserviceaccount.com
```

## Run Sonobuoy

Run `bin/run-sonobuoy.sh`.
This script creates 4 GCE VMs, runs CKE on VM #0 by using `docker-compose`, runs Kubernetes deployed by CKE on VM #1~#3, and runs [Sonobuoy][] on VM #0.

```console
$ env INSTANCE_NAME=sonobuoy-vm GITHUB_SHA=v1.24.0 GITHUB_REPOSITORY=cybozu-go/cke ./bin/run-sonobuoy.sh
```

When Sonobuoy finishes successfully, it leaves `/tmp/sonobuoy.tar.gz` file, which contains test results.

### inspection

You can inspect the Sonobuoy environment by logging in VM #0.

```console
$ gcloud compute ssh --project=PROJECT sonobuoy-vm-0

$ sudo su -
# cd go/src/github.com/cybozu-go/cke/sonobuoy
# export KUBECONFIG=$(pwd)/.kubeconfig
# ./bin/sonobuoy logs
# ./bin/kubectl get pods -A
```

## Cleanup

If the test fails, GCE VMs are left running for investigation.
Please don't forget to stop and delete those VMs by yourself.


[Sonobuoy]: https://github.com/vmware-tanzu/sonobuoy
[Google Cloud Platform]: https://cloud.google.com/
