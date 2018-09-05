# To reproduce: 

## Create Kubernetes Cluster 

Install Bocloud BeyondContainer to creat kubernetes cluster.

After the creation completed, add the test cluster and launch the Kubernetes e2e conformance tests.

## Kubernetes e2e conformance test

1. Launch the e2e conformance test with following command, and this will launch a pod named as `sonobuoy` under namespace sonobuoy.
    ```shell 
    curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f - 
    ``` 
    
2. Check logs of `sonobuoy`pod to see when this can be finished.
Run

    ```shell
    kubectl logs -f -n sonobuoy sonobuoy 
    ``` 
    
3. Watch sonobuoy's logs with above command and wait for the line `no-exit was specified, sonobuoy is now blocking`.

4. Use kubectl cp to bring the results to your local machine by the following command:
    ```
    kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
    ```
 
5. Expand the tarball, and retain `plugins/e2e/results/{e2e.log,junit.xml}`by below command:
    ```
    cd results
    tar xfz *_sonobuoy_*.tar.gz
    ```
    

