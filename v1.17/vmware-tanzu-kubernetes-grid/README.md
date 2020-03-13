## To Reproduce:

Set up a cluster following the Tanzu Kuberneted Grid documentation. We tested with one control plane node and two worker nodes.

Make sure your `KUBECONFIG` environment variable is set correctly for communicating with your cluster.

Run:

```
sonobuoy gen --image-pull-policy IfNotPresent | kubectl apply -f -
```

Watch the sonobuoy logs. The tests are complete when it shows `no-exit was specified, sonobuoy is now blocking`. Run:

```
kubectl -n heptio-sonobuoy logs sonobuoy -f
```

Retrieve the results:

```
mkdir results
cd results
sonobuoy retrieve .
```

Untar the tarball. The e2e results are `plugins/e2e/results/{e2e.log,junit_01.xml}`.