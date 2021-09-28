# Kubernetes Conformance tests on SKE

## Setup SKE cluster
To setup a Kubernetes cluster you have to create a STACKIT portal project, navigate to the runtimes and create yourself a SKE project. In the SKE project you can create yourself Kubernetes clusters on your demand. Further description can be found in: [create SKE Kubernetes clusters via Portal] (https://docs.stackit.cloud/display/public/STACKIT/Create+a+Kubernetes+Cluster+via+Portal)

## Run conformance tests

Download sonobuoy from [github.com/vmware-tanzu/sonobuoy/releases](https://github.com/vmware-tanzu/sonobuoy/releases)

```
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

Required files are located in `results/plugins/e2e/results/global/`