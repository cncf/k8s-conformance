# To reproduce

1. Apply account from http://ku8.com.cn
2. Login to KEM Control Plane.
3. Create new Kubernetes cluster using KEM Control Plane.

When the cluster is up and running, run the conformance test

```
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

$ kubectl logs -f -n sonobuoy sonobuoy

$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results

$ untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
```
