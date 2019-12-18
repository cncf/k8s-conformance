# VEXXHOST Managed Kubernetes

The VEXXHOST managed Kubernetes container service leverages the OpenStack Magnum
project in order to deploy fully-conformant Kubernetes clusters.

## Getting Started

You'll need to make sure that you have an account setup and that all your
credentials are loaded into the environment (such as `OS_AUTH_URL`,
`OS_PROJECT_NAME`, `OS_USERNAME`, etc.) before getting started.

You will need to make sure that both OpenStack and Magnum clients are installed
in your environment (`python-openstackclient` and `python-magnumclient`). Also,
you will need the `kubectl` binaries installed on your machine which will be
accessing the cluster.

## Reproducing results

1. **Start a Kubernetes cluster in your cloud environment**

   In this example the `v2-k8s-8-fedora29` is the cluster template for the Kubernetes
   offering that provides the best cost/performance ratio, `my-key` is the name
   of your keypair inside Nova (compute service) and `my-cluster` is the name
   of the cluster.

   ```console
   $ openstack coe cluster create --cluster-template v2-k8s-8-fedora29 \
                                  --keypair my-key \
                                  my-cluster
   ```

2. **Wait for the cluster to become ready**

   It may take a few minutes for the cluster to be fully deployed, you can track
   the progress of the deployment using the command below.  The status will be
   `CREATE_IN_PROGRESS` until the cluster is ready, where you'll see the status
   is now `CREATE_COMPLETE`.

   ```console
   $ openstack coe cluster show my-cluster
   ```

3. **Download configuration to access cluster**

   Inside a folder, you can run the following command which will download and
   setup all of your certificates, as well as automatically configure your
   environment variables to connect to the newly deployed cluster.

   ```console
   $ eval $(openstack coe cluster config my-cluster)
   ```

4. **Run the conformance checks**

   At this point the cluster is ready and accessible, you only need to run the
   tests with the [instructions provided](../instructions.md#running).
