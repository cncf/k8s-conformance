# Kubernetes Conformance tests on SKE

## Setup a STACKIT user account

Setup a STACKIT user account following this document:

[Setup a STACKIT user account](https://docs.stackit.cloud/stackit/en/step-2-setup-a-user-account-35914426.html)


## How to create and manage a STACKIT project

Afterwards you have to create a STACKIT project:

[How to create and manage a project](https://docs.stackit.cloud/display/STACKIT/How+to+create+and+manage+a+project)

## Setup Kubernetes cluster

To setup a Kubernetes cluster you have to navigate to the runtimes section, where you can create yourself a Kubernetes project. In the Kubernetes project you can then create yourself Kubernetes clusters on your demand. 

ATM you can only create Kubernetes cluster via the STACKIT portal. There you can configure the cluster as you prefer, e.g. Kubernetes version 1.24, node size, etc.

Further description can be found in: [create SKE Kubernetes clusters via Portal](https://docs.stackit.cloud/stackit/en/step-1-create-a-kubernetes-cluster-ske-10125556.html)

## Run conformance tests

Download sonobuoy from [github.com/vmware-tanzu/sonobuoy/releases](https://github.com/vmware-tanzu/sonobuoy/releases)

```
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

Required files are located in `results/plugins/e2e/results/global/`