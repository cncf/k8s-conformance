# ACME k8s a fake company for testing purposes 


## Install ACME  

### Download the package

## Run Conformance Test

1. On one of the worker node, install sonobuoy:

```sh
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

2. Run sonobuoy:

```sh
$ sonobuoy run --mode=certified-conformance
```

3. Watch logs:

```sh
$ sonobuoy logs
```

4. Check status:

```sh
$ sonobuoy status
```

5. Retrieve results:

Wait for around 50 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```sh
$ sonobuoy retrieve .
$ mkdir ./results; tar xzf *.tar.gz -C ./results
```
