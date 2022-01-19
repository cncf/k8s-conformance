# To Reproduce

Set up a cluster following the Wind River Cloud Platform documentation.

These tests were done on a system with 2x master/worker (i.e. All-In-One) nodes, and the WRCP 21.12 GA Load:
BUILD: wrcp_dev_build_2021-12-2021-12-01_20-00-09

NOTE: RESULTS had one failure due to following issue with nginx-ingress:  https://github.com/kubernetes/kubernetes/pull/100449 
Any guidance on what to do here ?
```
Ran 311 of 5668 Specs in 5370.227 seconds
FAIL! -- 310 Passed | 1 Failed | 0 Pending | 5357 Skipped
--- FAIL: TestE2E (5370.27s)
FAIL

Ginkgo ran 1 suite in 1h29m31.65524392s
Test Suite Failed

Summarizing 1 Failure:

[Fail] [sig-network] Ingress API [It] should support creating Ingress API operations [Conformance]
/workspace/src/k8s.io/kubernetes/_output/dockerized/go/src/k8s.io/kubernetes/test/e2e/network/ingress.go:1020
```






Make sure your KUBECONFIG environment variable is set correctly for communicating with your cluster.

Download sonobuoy_<VERSION>_linux_amd64.tar.gz from https://github.com/vmware-tanzu/sonobuoy/releases.

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
