# To reproduce

## Create cluster

Log in to https://cloud.containership.io. From the create menu, choose "Cluster". In the creation wizard, choose "Digital Ocean" for provider, and "CKE" for engine. Complete the remaining required steps in the wizard. Once the cluster has completed provisioning, click on the cluster from the cluster list view, and copy the kubectl connection info.

## Run the conformance test

```
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f -n sonobuoy sonobuoy

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

$ untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
```

## Clean up
From the cluster list, select the cluster used for conformance testing, and select "Delete" from the side navigation.
