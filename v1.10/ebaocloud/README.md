1. Start the conformance tests:
    ```shell
    curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
    ```

2. Check logs and wait for the follow line to show up.  
Run

    ```shell
    kubectl logs -f -n sonobuoy sonobuoy
    ```
    and wait for line `no-exit was specified, sonobuoy is now blocking`.

3. copy the results to the working directory.
    ```shell
    kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy/<result archive> ./resuts.tar.gz
    ```

4. unarchive the tarball,then grab `plugins/e2e/results/{e2e.log,junit_01.xml}`.


5.  Clean-up.

    ```shell
    curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl delete -f -
    ```

