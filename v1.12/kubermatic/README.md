# To reproduce

## Set up the cluster

1. Login to https://cloud.kubermatic.io/
2. Press the "Create Cluster" button
3. Complete the create cluster wizard with AWS.

When the cluster is up and running,

1. Download the kubeconfig file.  
2. Set the KUBECONFIG environment variable `export KUBECONFIG=$PWD/kubeconfig`.

## Run the conformance test
