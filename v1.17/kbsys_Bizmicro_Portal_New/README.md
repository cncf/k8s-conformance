Conformance tests for bizmicro kubernetes cluster

How to submit conformance results

The standard tool for running these tests is Sonobuoy. Sonobuoy is regularly built and kept up to date to execute against all currently supported versions of kubernetes.

Do the following:
$ wget sonobuoy_0.19.0_linux_386.tar.gz

Perform the following command:
$ tar -xvf sonobuoy_0.19.0_linux_386.tar.gz

$ sonobuoy run --mode=certified-conformance
NOTE: The --mode=certified-conformance flag is required for certification runs since Kubernetes v1.16 (and Sonobuoy v0.16). Without this flag, tests which may be disruptive to your other workloads may be skipped. A valid certification run may not skip any conformance tests. If you're setting the test focus/skip values manually, certification runs require E2E_FOCUS=\[Conformance\] and no value for E2E_SKIP.

NOTE: You can run the command synchronously by adding the flag --wait but be aware that running the conformance tests can take an hour or more.

View actively running pods:

$ sonobuoy status
To inspect the logs:

$ sonobuoy logs
Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

$ outfile=$(sonobuoy retrieve)
This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

mkdir ./results; tar xzf $outfile -C ./results
NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/global/{e2e.log,junit_01.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:

sonobuoy delete





