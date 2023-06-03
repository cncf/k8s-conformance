# Red Hat OpenShift on IBM Cloud

You'll first need to get started with Red Hat OpenShift on IBM Cloud by setting up
an IBM Cloud account. For details, see the
[getting started](https://cloud.ibm.com/docs/openshift?topic=openshift-getting-started)
instructions. Then follow the steps below to create a cluster and run the conformance tests.

## Create a cluster

If you haven't already done so,
[install the IBM Cloud CLI and plug-ins](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift-cli#cs_cli_install_steps)
for Red Hat OpenShift on IBM Cloud. You may then create a cluster using the CLI or UI.

### CLI

```
$ # Option 1: Create a cluster on classic infrastructure.
$ ibmcloud oc cluster create classic --name conformance --version 4.10_openshift --zone ZONE --flavor FLAVOR --private-vlan VLAN --public-vlan VLAN --workers COUNT

$ # Option 2: Create a cluster on Virtual Private Cloud (VPC) infrastructure.
$ ibmcloud oc cluster create vpc-gen2 --name conformance --version 4.10_openshift --zone ZONE --flavor FLAVOR --vpc-id ID --subnet-id ID --cos-instance INSTANCE --workers COUNT
```

### UI

Go to [IBM Cloud catalog](https://cloud.ibm.com/catalog?category=containers#services)
and select `Red Hat OpenShift on IBM Cloud` to create a cluster. From the
cluster creation UI, select version 4.10.39 and choose either classic or VPC
infrastructure. Then choose an appropriate location and worker pool configuration.
Finally, give the cluster a name, such as `conformance`, and select `Create`.

## Run conformance tests

Wait for the cluster and all worker nodes to reach `normal` state.

```
$ ibmcloud oc cluster config --admin --cluster conformance
$ ibmcloud oc cluster get --cluster conformance
$ ibmcloud oc workers --cluster conformance
```

Prepare the cluster for conformance testing. This changes the default security
rules so that conformance tests can run as a cluster administrator. This allows
unprivileged users to run root level containers. Once conformance testing is
completed, you should restore the default security rules.

```
$ oc adm policy add-scc-to-group privileged system:authenticated system:serviceaccounts
$ oc adm policy add-scc-to-group anyuid system:authenticated system:serviceaccounts
```

Follow the
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests. You will need to add the
`--dns-namespace=openshift-dns --dns-pod-labels=dns.operator.openshift.io/daemonset-dns=default`
options to `sonobuoy run --mode=certified-conformance` so `sonobuoy` can find
the cluster DNS pods.

Once conformance testing is completed, restore the default security rules.

```
$ oc adm policy remove-scc-from-group anyuid system:authenticated system:serviceaccounts
$ oc adm policy remove-scc-from-group privileged system:authenticated system:serviceaccounts
```
