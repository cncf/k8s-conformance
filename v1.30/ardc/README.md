# Nectar Research Cloud Magnum Service

## Creating your account and project

1. Log in to the [Nectar Research Cloud
   dashboard](https://dashboard.rc.nectar.org.au/).

1. Request for an allocation by following the [Allocation
   guide](https://tutorials.rc.nectar.org.au/allocation-management/).

## Creating your cluster

1. Log in to the [Nectar Research Cloud
   Dashboard](https://dashboard.rc.nectar.org.au/).

1. Navigate to *Project* - *Container Infra* - *Clusters*.

1. Create a cluster with the 'CREATE CLUSTER' button.

1. In the 'Details' tab, choose the
   `kubernetes-v1.30.5-<availability_zone>-<vX>` template, where `vX` is the
highest version available.

1. In the 'Size' tab, use `3` for both 'Number of Control Plane' and 'Number of
   Worker Nodes'

1. Wait a while for the cluster to reach the `CREATE_COMPLETE` stage.

1. Fetch your KUBECONFIG file using the OpenStack CLI client.

    ```openstack coe cluster config mycluster```

    For more information, check out the [Kubernetes tutorial](https://tutorials.rc.nectar.org.au/kubernetes/).

1. Set your KUBECONFIG environment variable.

    ```export KUBECONFIG=./config```

1. Run the sonobuoy test suite following the instructions on the
   [k8s-conformance](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)
site.
