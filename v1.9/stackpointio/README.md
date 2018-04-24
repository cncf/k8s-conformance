# To reproduce

## Set up the cluster

1. Login to https://stackpoint.io, 
1. Press the "Add Cluster" button
1. Complete the create cluster wizard. 

Kubernetes version 1.9.6 is set by default with a minimal set of solutions.  

When the cluster is up and running, 

1. Press the cluster name from the list view. 
1. Download the kubeconfig file.  
2. Set the KUBECONFIG environment variable.

## Run the conformance test

```
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f -n sonobuoy sonobuoy

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

$ untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
```

## Clean up
From the list view, press the more actions button on the cluster and select "Delete". 
