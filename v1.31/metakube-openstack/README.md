# To reproduce

## Set up the cluster

1. Login to https://metakube.syseleven.de/
2. Press the "Create Cluster" button - keep the default values unless specified differently in the next steps
3. Choose provider: openstack and select any region
4. Choose a name for the cluster and the version 1.31
5. Provide the openstack credentials for SysEleven Stack (received during on-boarding to MetaKube)
6. Create at least one node of Ubuntu or Flatcar. Currently supported are Ubuntu 20, Ubuntu 22 and Flatcar Stable
7. Approve choices in the overview page and create the cluster

More details can be found in the [MetaKube docs](https://docs.syseleven.de/metakube/de/tutorials/create-a-cluster).

When the cluster is up and running,

1. Download the kubeconfig file.  
2. Set the KUBECONFIG environment variable `export KUBECONFIG=$PWD/kubeconfig`.

## Run the conformance test

Follow the conformance suite instructions to test it.
