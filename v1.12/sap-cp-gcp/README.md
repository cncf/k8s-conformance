# To reproduce:

## Create Kubernetes Cluster

Login to SAP Gardener Dashboard to create a Kubernetes Cluster on Amazon Web Services, Microsoft Azure, Google Cloud Platform, or OpenStack cloud provider.

After the creation completed, copy the cluster's kubeconfig file from the Gardener Dashboard to ~/.kube/config and launch the Kubernetes E2E conformance tests as described below (based on these [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)).

## Launch E2E Conformance Tests
1. Download latest sonobuoy binary release
   ```shell
   go get -u -v github.com/heptio/sonobuoy 
   ```
2. Run sonobuoy
   ```shell
   sonobuoy run
   ```

3. Check the status
   ```shell
   sonobuoy status
   ```
   and wait until the run is `completed`

4. Get the logs and extract the archive

    ```shell
    sonobuoy retrieve .
    mkdir ./results; tar xzf *.tar.gz -C ./results
    ```
    The result files `e2e.log` and `junit_01.xml` required for submission are located in the in the directory `./results/plugins/e2e/results/`

5. Delete the conformance test resources

   ```shell
   sonobuoy delete 
   ```
