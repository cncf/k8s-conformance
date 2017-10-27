# To reproduce

## Set up the cluster

1. Login to https://stackpoint.io, 
1. Press the "Add Cluster" button
1. Complete the create cluster wizard. 

Kubernetes version 1.8.1 is set by default with a minimal set of solutions.  

When the cluster is up and running, 

1. Press the cluster name from the list view. 
1. Download the kubeconfig file.  
2. Set the KUBECONFIG environment variable.

## Run the conformance test

The conformance test is configured with the resources defined in https://github.com/heptio/sonobuoy/blob/master/examples/quickstart.yaml

1. Copy the manifest file locally to *conformance-test.yaml*. 
1. A resource defined is a configmap named `sonobuoy`. In that configmap data, change the value of the E2E_FOCUS variable so  all of the tests will be run.
```
  - env:
    - name: E2E_FOCUS
      value: Conformance
```

Refer to https://github.com/heptio/sonobuoy/blob/master/docs/conformance-testing.md for information on other parameters.

3. Begin the testing by applying the manifest.
```
  kubectl apply -f conformance-test.yaml
```

4. Watch sonobuoy's logs with `kubectl logs -f -n sonobuoy sonobuoy` and wait for the line *no-exit was specified, sonobuoy is now blocking*.  
5. Once complete, the relevant data can be extracted and saved:
```
  TARGET_DIR=~/workspace/conformance/v1.8.1
  kubectl -n heptio-sonobuoy cp  sonobuoy:/tmp/sonobuoy/  $TARGET_DIR
  kubectl version > $TARGET_DIR/version.txt
```

## Clean up
From the list view, press the more actions button on the cluster and select "Delete". 
