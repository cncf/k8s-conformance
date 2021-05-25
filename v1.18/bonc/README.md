
Run Conformance Test

On one of the worker node, install sonobuoy:

$ go get -u -v github.com/vmware-tanzu/sonobuoy

Run sonobuoy:

$ sonobuoy run --mode=certified-conformance

Watch logs:

$ sonobuoy logs

Check status:

$ sonobuoy status

Retrieve results:
Wait for around 60 minutes for the test to be finished, the log will show something like no-exit was specified, sonobuoy is now blocking to indicate that the test has been finished, then run the following command to extract the test results.

$ sonobuoy retrieve .

$ mkdir ./results; tar xzf *.tar.gz -C ./results

