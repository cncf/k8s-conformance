# To Reproduce

Set up a cluster following the Wind River Cloud Platform documentation.

These tests were done on a system with 2x master nodes and 2x worker nodes, and the WRCP 20.06 GA Load:


###
### Wind River Cloud Platform
###     Release 20.06
###
###     Wind River Systems, Inc.
###

SW_VERSION="20.06"
BUILD_TARGET="Host Installer"
BUILD_TYPE="Formal"
BUILD_ID="2020-06-27_00-41-42"
SRC_BUILD_ID="37"

JOB="WRCP_20.06_Build"
BUILD_BY="jenkins"
BUILD_NUMBER="37"
BUILD_HOST="yow-cgts4-lx.wrs.com"
BUILD_DATE="2020-06-27 00:44:03 -0400"


Make sure your KUBECONFIG environment variable is set correctly for communicating with your cluster.

Download sonobuoy_0.18.3_linux_amd64.tar.gz from https://github.com/vmware-tanzu/sonobuoy/releases.

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
