# To reproduce

## Set up the cluster

Login in to https://stackpooint.io, access the cluster build page, 
select a cloud provider, the kubernetes version 1.8.1, and a minimal 
set of solutions.  

When the cluster is up and running, download the kubeconfig file from the UI 
and set the KUBECONFIG environment variable.

## Run the conformance test

The conformance test is configured with the resources defined in https://github.com/heptio/sonobuoy/blob/master/examples/quickstart.yaml
Copy this manifest file locally to *conformance-test.yaml*.  One of the 
resources defined is a configmap named `sonobuoy`.  In that configmap
data, change the value of the E2E_FOCUS variable
```
  - env:
    - name: E2E_FOCUS
      value: Conformance
```
so that all of the tests will be run.

Refer to https://github.com/heptio/sonobuoy/blob/master/docs/conformance-testing.md
for information on other parameters.

Begin the testing by applying this manifest.
```
  kubectl apply -f conformance-test.yaml
```

Watch sonobuoy's logs with `kubectl logs -f -n sonobuoy sonobuoy` and wait for the line *no-exit was specified, sonobuoy is now blocking*.  Once complete, the relevant data can be extracted and saved:
```
  TARGET_DIR=~/workspace/conformance/v1.8.1
  kubectl -n heptio-sonobuoy cp  sonobuoy:/tmp/sonobuoy/  $TARGET_DIR
  kubectl version > $TARGET_DIR/version.txt
```

## Clean up

Delete the cluster and the cloud-provider resources using the stackpoint.io UI.