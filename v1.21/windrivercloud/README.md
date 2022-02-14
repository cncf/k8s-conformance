# To Reproduce

These tests were done on a system with 2x master/worker (i.e. All-In-One) nodes, and the WRCP 21.12 GA Load:
BUILD: wrcp_dev_build_2022-01-08_23-30-07
Kubernetes Version: 1.21

Set up a cluster following the Wind River Cloud Platform documentation.

Remove nginx controller validating webhook, see https://github.com/kubernetes/kubernetes/pull/100449 for background.
```
$ kubectl delete ValidatingWebhookConfiguration ic-nginx-ingress-ingress-nginx-admission
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
