# To reproduce:

## Create Kubernetes Cluster

Login to Gardener Dashboard to create a Kubernetes Clusters on Amazon Web Services, Microsoft Azure, Google Cloud Platform, or OpenStack cloud provider.

After the creation completed, copy the cluster's kubeconfig, which is provided by the Gardener Dashboard in the cluster's detail view, to ~/.kube/config and launch the Kubernetes E2E conformance tests.

## Launch E2E Conformance Tests
1. Launch e2e pod and sonobuoy master under namespace `sonobuoy`   
    ```shell
    curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
    ```

2. Check logs of `sonobuoy` pod to see when test can be finished   
Run

    ```shell
    kubectl logs -f -n sonobuoy sonobuoy
    ```
    and wait for line `no-exit was specified, sonobuoy is now blocking`.

3. Use `kubectl cp` to copy the results to the client   
Get the name of the <result archive> from the log output in step 2.

    ```shell
    kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy/<result archive> /home/result
    ```

4. Delete the conformance test resources

    ```shell
    curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl delete -f -
    ```

5. Untar the tarball

    ```shell
    cd /home/result
    tar -xzf *_sonobuoy_*.tar.gz
    ```

    The result files `e2e.log` and `junit_01.xml` are located in the in the directory `plugins/e2e/results/`.
