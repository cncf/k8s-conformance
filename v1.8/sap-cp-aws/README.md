## To reproduce:

#### Create Kubernetes Cluster

1. Login

Login to [SAP Gardener (currently only available SAP internally)](https://gardener.kubernetes.sap.corp) Website.

2. Creating a kubernetes cluster

Use Gardener to create a kubernetes cluster on Amazon Web Services, Microsoft Azure or Google Cloud Engine
After the creation completed, copy the cluster's kubeconfig to ~/.kube/config
and launch the kubernetes e2e conformance tests on any node of the cluster.

#### Launch E2E Conformance Tests
1. Launch e2e pod and sonobuoy master under namespace `sonobuoy`.

 ```shell
 curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
 ```

2. Check logs of `sonobuoy` pod to see when test can be finished.

 ```shell
 kubectl logs -f -n sonobuoy sonobuoy
 ```

 wait for line `no-exit was specified, sonobuoy is now blocking`.

3. Use `kubectl cp` to bring the results to local machine.

 ```shell
 kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy /home/result
 ```

4. Delete the conformance test resources.

 ```shell
 curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl delete -f -
 ```

5. Untar the tarball

 ```shell
 cd /home/result
 tar -xzf *_sonobuoy_*.tar.gz
 ```

 In `plugins/e2e/results/` you can find e2e result logs and other relative output files.
