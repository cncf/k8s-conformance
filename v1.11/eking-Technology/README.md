# eKing Cloud Container Platform (Eking-Technology Cloud Container Platform)

eKing Cloud Container Platform provides application lifecycle management platform based on container technology and provides users with code building, docker registry, container service, load balancing, persistent volume, monitoring, CI / CD, canary deployments, flexible scaling, etc. We support cloud native microservices architecture, bringing traditional infrastructure to the cloud data center, dramatically reducing the cost of enterprise IT infrastructure by making more efficient use of resources.

## Run conformance test 

1. Install eKing Cloud Container Platform 
2. SSH to the k8s master and Wait until all the components have completed.
3. Run the k8s conformance test on k8s master:
```
# curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```
Watch Sonobuoy's logs with `kubectl logs -f -n sonobuoy sonobuoy` and wait for the line `no-exit was specified, sonobuoy is now blocking`

4. get tarball, and expand the sonobuoy.tar.gz. retain the 2 files plugins/e2e/results/{e2e.log,junit.xml}
```
# kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy/*.tar.gz ~/sonobuoy.tar.gz
```

5. get version.txt
```
# kubectl version > version.txt
```
