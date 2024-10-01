# IBM Cloud Kubernetes Service

You'll first need to get started with IBM Cloud Kubernetes Service by setting up
an IBM Cloud account. For details, see the
[getting started](https://cloud.ibm.com/docs/containers?topic=containers-getting-started)
instructions. Then follow the steps below to create a cluster and run the conformance tests.

## Create a cluster

If you haven't already done so, [install the CLI](https://cloud.ibm.com/docs/containers?topic=containers-cli-install)
for IBM Cloud Kubernetes Service. You may then create a cluster using the CLI or UI.

### CLI

```
# Create a cluster on Virtual Private Cloud (VPC) infrastructure.
ibmcloud ks cluster create vpc-gen2 --name conformance --version 1.31 --zone ZONE --flavor FLAVOR --vpc-id ID --subnet-id ID --workers COUNT
```

### UI

Go to [IBM Cloud catalog](https://cloud.ibm.com/catalog?category=containers#services)
and select `Kubernetes Service` to create a cluster. From the cluster creation
UI, select version 1.31.1 and choose the appropriate infrastructure, location, and
worker pool configuration. Finally, give the cluster a name, such as `conformance`,
and select `Create`.

## Run conformance tests

Wait for the cluster and all worker nodes to reach `normal` state.

```
ibmcloud ks cluster config --admin --cluster conformance
ibmcloud ks cluster get --cluster conformance
ibmcloud ks workers --cluster conformance
```

If you created a cluster on VPC infrastructure, you must disable outbound traffic
protection in order to run the conformance tests.

```
ibmcloud ks vpc outbound-traffic-protection disable -f --cluster conformance
```

Then follow the
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests.
