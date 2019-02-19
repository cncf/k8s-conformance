# To reproduce: 

## Create Kubernetes Cluster 

Install Robin platform v5

After the installation and configuration, add the test cluster and launch the Kubernetes e2e conformance tests.

## Kubernetes e2e conformance test

1. Download the binary release of sonobuoy
    ```shell 
    curl -O https://github.com/heptio/sonobuoy/releases/download/v0.11.6/sonobuoy_0.11.6_linux_amd64.tar.gz
    sonobuoy run
    sonobuoy status
    sonobuoy retrieve .
    cd results/plugins/e2e/results/
    ``` 
