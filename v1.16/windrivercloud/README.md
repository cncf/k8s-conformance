# To Reproduce

Set up a cluster following the Wind River Cloud Platform documentation. 

These tests were done on a system with 2x master nodes and 2x worker nodes, and the WRCP 19.12 GA Load:

```
###
### Wind River Cloud Platform
###     Release 19.12
###
###     Wind River Systems, Inc.
###

SW_VERSION="19.12"
BUILD_TARGET="Host Installer"
BUILD_TYPE="Formal"
BUILD_ID="2019-12-13_19-03-42"
SRC_BUILD_ID="21"

JOB="WRCP_19.12_Build"
BUILD_BY="jenkins"
BUILD_NUMBER="21"
BUILD_HOST="yow-cgts4-lx.wrs.com"
BUILD_DATE="2019-12-13 19:04:39 -0500"
```

Make sure your KUBECONFIG environment variable is set correctly for communicating with your cluster.

Download sonobuoy_0.17.0_linux_amd64.tar from https://github.com/vmware-tanzu/sonobuoy/releases .

Run:
```
$ sonobuoy run --mode=certified-conformance
```

Wait for sonobuoy status to indicate complete.
```
$ sonobuoy status 
```
Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
```
$ outfile=$(sonobuoy retrieve)
```
This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
```
mkdir ./results; tar xzf $outfile -C ./results
```
NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:
```
sonobuoy delete
```
