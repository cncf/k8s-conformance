# OpenShift Dedicated (OSD)

## Create an [OpenShift Dedicated cluster](https://docs.openshift.com/dedicated/4/getting_started/accessing-your-services.html)

* Log in to https://cloud.redhat.com/openshift
* Select *Create Cluster* -> *Red Hat OpenShift Dedicated*.
* Enter your *Cluster name*, number of *Compute nodes*, and select an *AWS Region*.
* Select your *Node Type*. The number and types of nodes available to you depend
upon your OpenShift Dedicated subscription.
* If you want to configure your networking IP ranges under *Advanced Options*, the
following are the default ranges available to use:
** Node CIDR: 10.0.0.0/16
** Service CIDR: 172.30.0.0/16
** Pod CIDR: 10.128.0.0/16
** Host Prefix: /23
* Add your Identity provider by clicking the *Add OAuth Configuration* link.
** Add a user by clicking the *Users* tab, then *Add User*. Input the user's name, then click *Add*.
** In the *Overview* tab under the *Details* heading will have a *Status* indicator. This will indicate that your cluster is *Ready* for use.

## Accessing your cluster

To access your OpenShift Dedicated cluster:

* From https://cloud.redhat.com/openshift, click on the cluster you want to access.
* Click *Launch Console*.
* To access `.kubeconfig` file you could use the `OCM` cli [tool](https://github.com/openshift-online/ocm-cli). After fetching the token and authenticating locally, execute the following commands:
   ```
   ocm get /api/clusters_mgmt/v1/clusters --parameter search="name like 'clustername%'" # to get cluster id
   ocm get /api/clusters_mgmt/v1/clusters/cluster_id/credentials | jq -r .kubeconfig > .kubeconfig # to fetch kubeconfig
   ```
* Set the environment variable KUBECONFIG
    ```
    export KUBECONFIG=PATH_TO_KUBECONFIG
    ```

## Running Conformance

**OSD locks down several things required by conformance testing. To be able to run tests, do the following:**

1. By default OpenShift security rules do not allow running with privileged access.
   Below commands allow unprivileged users to run root level containers. Once
   conformance testing is completed, you should restore the default security rules.

```
oc adm policy add-scc-to-group privileged system:authenticated system:serviceaccounts
oc adm policy add-scc-to-group anyuid system:authenticated system:serviceaccounts
```

2. By default, OSD locks down the `default` namespace. Kubernetes E2E tests expect this namespace to be usable. To enable use of this
   namespace you must:
   1. Contact OSD-SRE and have them pause Hive Syncing from applying to the cluster (provide the cluster ID and environment)
   2. Delete the SRE Namespace validating webhook:

```
kubectl edit validatingwebhookconfigurations.admissionregistration.k8s.io sre-namespace-validation
```

3. Edit the `machineset` resource for infrastructure nodes to remove NoSchedule taint.

```
oc edit machineset -n openshift-machine-api <machineset-name>
```

4. Follow the [test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
   to run the conformance tests. You will need to add the `--dns-namespace=openshift-dns`
   and `--dns-pod-labels=dns.operator.openshift.io/daemonset-dns=default`
   options so `sonobuoy` can find the cluster DNS pods:

```
sonobuoy run --mode=certified-conformance --dns-namespace=openshift-dns --dns-pod-labels=dns.operator.openshift.io/daemonset-dns=default
```

5. Once conformance testing is completed, if you do not have the cluster cleaned up, be sure to restore the default security rules:

```
oc adm policy remove-scc-from-group anyuid system:authenticated system:serviceaccounts
oc adm policy remove-scc-from-group privileged system:authenticated system:serviceaccounts
```

And contact OSD-SRE to resume Hive Syncing
Note: This step is required to uninstall the created cluster.