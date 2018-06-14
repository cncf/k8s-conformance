## To reproduce:

#### Setup Huawei FusionStage Kubernetes Cluster

Deploy Huawei FusionStage Kubernetes Cluster according to the FusionStage documentation.

#### Launch E2E Conformance Tests

1. Launch e2e pod and sonobuoy master under namespace `sonobuoy`.

get the conformance yaml from [https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml](https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml), then create sonobuoy resources:

 ```
 kubectl apply -f sonobuoy-conformance.yaml
 ```
 
2. Check logs of `sonobuoy` pod to see when test can be finished.
 
 ```
 kubectl logs -f -n sonobuoy sonobuoy
 ```
 
 wait for line `no-exit was specified, sonobuoy is now blocking`.
 
3. Use `kubectl cp` to bring the results to local machine.

 ```
 kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy /home/result
 ```
 
4. Delete the conformance test resources.
 
 ```
 kubectl delete namespace sonobuoy
 ```
 
5. Untar the tarball
 
 ```
 cd /home/result
 tar -xzf *_sonobuoy_*.tar.gz
 ```
 
 In `plugins/e2e/results/` you can find e2e result logs and other relative output files.
