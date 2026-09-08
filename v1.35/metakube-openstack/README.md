# To reproduce

## Set up the cluster

1. Login to https://dashboard.syseleven.de/ (user credentials received during on-boarding to MetaKube)
2. Click on the cluster icon in the sidebar
3. Press the "Create" button - keep the default values unless specified differently in the next steps
4. Select a region
5. Choose an authentication method to provision infrastructure in the Syseleven Stack
6. Choose a name for the cluster and the version 1.35.1
7. Create at least one node of Ubuntu or Flatcar. Currently supported are Ubuntu 22, Ubuntu 24 and Flatcar Stable
8. Approve choices in the overview page and create the cluster

More details can be found in the [MetaKube docs](https://documentation.syseleven.de/en/products/metakube-core/usage/clusters/).

When the cluster is up and running,

1. Download the kubeconfig file.
2. Set the KUBECONFIG environment variable `export KUBECONFIG=$PWD/kubeconfig`.

## Run the conformance test

Follow the conformance suite instructions to test it.
