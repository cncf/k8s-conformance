# Red Hat OpenShift on IBM Cloud

You'll first need to get started with Red Hat OpenShift on IBM Cloud by setting
up an IBM Cloud account. For details, see the
[getting started](https://cloud.ibm.com/docs/openshift?topic=openshift-getting-started)
instructions. Then follow the steps below to create a cluster and run the
conformance tests.

## Create a cluster

If you haven't already done so,
[install the CLI](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift-cli)
for Red Hat OpenShift on IBM Cloud. You may then create a cluster using the CLI
or UI.

### CLI

```
$ ibmcloud ks cluster-create --name conformance --kube-version 3.11_openshift --zone <zone name> --machine-type <machine type> [--workers <number of workers>] [--private-vlan <private VLAN> --public-vlan <public VLAN>]
```

### UI

Go to the [IBM Cloud catalog](https://cloud.ibm.com/catalog?category=containers)
and select `Red Hat OpenShift Cluster` and follow the instructions to create a
cluster.

## Run conformance tests

Wait for the cluster and all worker nodes to reach `normal` state.

```
$ ibmcloud ks cluster-config --admin conformance
$ ibmcloud ks cluster-get conformance
$ ibmcloud ks workers conformance
```

Run the following commands to disable container security.

```
$ oc adm policy add-scc-to-group privileged system:authenticated system:serviceaccounts
$ oc adm policy remove-scc-from-group restricted system:authenticated
$ oc adm policy remove-scc-from-group anyuid system:cluster-admins
```

Next follow the
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests. You must add the `--skip-preflight` and
`--sonobuoy-image gcr.io/heptio-images/sonobuoy:v0.11.6` options to
`sonobuoy run`.

After the tests have completed, run the following commands to enable container
security.

```
$ oc adm policy add-scc-to-group anyuid system:cluster-admins
$ oc adm policy add-scc-to-group restricted system:authenticated
$ oc adm policy remove-scc-from-group privileged system:authenticated system:serviceaccounts
```
