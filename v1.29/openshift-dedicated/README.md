# OpenShift Dedicated (OSD)

## Create an [OpenShift Dedicated cluster](https://docs.openshift.com/dedicated/4/getting_started/accessing-your-services.html)

* Log in to https://cloud.redhat.com/openshift
* Select *Create Cluster* -> *Red Hat OpenShift Dedicated*.
* Under Billing model, select the *Customer cloud subscription* infrastructure type to deploy OSD in an existing cloud provider account that you own.
* Select *Run on Amazon Web Services*. Review and complete the listed prerequisites, then select the checkbox.
* Provide your AWS account details. Enter your AWS account ID, AWS access key ID and AWS secret access key for your AWS IAM user account.
* On the Cluster details page, enter your *Cluster name*, *Version* and select an *AWS Region*.
* Verify the *Monitoring* section is unchecked as we will be self monitoring the cluster during conformance testing.
* Select your *Node Type*. The number and types of nodes available to you depend upon your OpenShift Dedicated subscription.
* Configure custom classless inter-domain routing (CIDR) ranges or use the defaults that are provided:

   * Node CIDR: 10.0.0.0/16

   * Service CIDR: 172.30.0.0/16

   * Pod CIDR: 10.128.0.0/14

   * Host Prefix: /23

* Review the summary and click *Create cluster* to start the cluster installation, which will take about 30-40 minutes.
* In the *Overview* tab under the *Details* heading will have a *Status* indicator. This will indicate that your cluster is *Ready* for use.
* Click the *Access control* tab, then add a preferred identity provider.
   * For this execution we will use the HTPasswd identity provider. Click *Add HTPasswd* and enter a username and password.
* In the *Cluster Roles and Access* tab, click *Add user*. Provide a *User ID* and select the *Cluster-admins* group.
* In the *OCM Roles and Access* tab, click *Grant role*. Enter your Red Hat account username and choose the *Cluster editor* role.
* Allow a few minutes to pass, 5-15 minutes, if the HTPasswd credentials do not work.
* Once logged in wait for the *Status* to show all green.
   * Cluster, Control Plane, Operators, Insights, Dynamic Plugins


## Accessing your cluster

To access your OpenShift Dedicated cluster:

* From https://cloud.redhat.com/openshift, click on the cluster you want to access.
* *Download OC CLI* if you haven't installed the OpenShift cluster command-line interfaces (OC CLI) yet.
* Click *Open Console*. Log in to the cluster with *HTPasswd* and enter your username and password you have set.
* Click on your username to access the dropdown menu, then click *Copy login command*.Click *display Token*, and then you can *Log in with this token* on the CLI.
* To access `.kubeconfig` file, after fetching the token and authenticating locally, execute the following commands:
   ```
   oc config view -o yaml --raw=true > .kubeconfig # to fetch kubeconfig
   ```
* Set the environment variable KUBECONFIG
    ```
    export KUBECONFIG=PATH_TO_KUBECONFIG
    ```

## Running Conformance

**OSD locks down several things required by conformance testing. To be able to run tests, do the following:**

1. By default, OSD locks down the `default` namespace. Kubernetes E2E tests expect this namespace to be usable. To enable use of this
   namespace you must:
   1. Contact OSD-SRE and have them pause Hive Syncing from applying to the cluster (provide the cluster ID and environment). Also, ask the SRE team to place the cluster in *limited support*.
      Once this has been completed the console will show the following warning:
         ```
         This cluster has limited support.
         Cluster is in Limited Support due to unsupported cluster configuration
         Requested through OHSS-XYZ Finish testing and update the ticket
         ```
   2. Delete the SRE Namespace validation, sre-regular-user-validation and  sre-node-validation-osd webhooks:
         ```
         oc delete validatingwebhookconfigurations.admissionregistration.k8s.io sre-namespace-validation
         oc delete validatingwebhookconfigurations.admissionregistration.k8s.io sre-node-validation-osd
         oc delete validatingwebhookconfigurations.admissionregistration.k8s.io sre-regular-user-validation
         ```
   3. These will be readded once Hive Syncing is resumed.

2. By default OpenShift security rules do not allow running with privileged access.
   Below commands allow unprivileged users to run root level containers.
   Once conformance testing is completed, you will restore the default security rules.
      ```
      oc adm policy add-scc-to-group privileged system:authenticated system:serviceaccounts
      oc adm policy add-scc-to-group anyuid system:authenticated system:serviceaccounts
      ```

3. Changes will have to be made to the infrastructure nodes as the CNCF conformance suite requires scheduling in those nodes.
   By nature OSD/Rosa taints infra nodes with NoSchedule, follow these steps to temporarily remove these restrictions.
   1. Edit the `machineset` resource for infrastructure nodes to remove NoSchedule taint.
   machinesets in Openshift manage the infra and worker nodes.
   WARNING: Do not delete machinesets as this will also delete the managed nodes.
      ```
      oc get machineset -n openshift-machine-api | grep infra | awk '{print $1}' | xargs oc edit machineset -n openshift-machine-api
      ```
   2. Delete `infra` nodes and wait for them to be recreated.
      ```
      oc get nodes | grep infra | awk '{print $1}' | xargs oc delete node
      ```
   3. Then verify the taint does not exist in the new infra nodes.
      ```
      oc get nodes | grep infra | awk '{print $1}' | xargs oc get nodes -o yaml | grep 'NoSchedule'
      ```

4. Follow the [test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
   to run the conformance tests. Here we use [Hydrophone](https://github.com/kubernetes-sigs/hydrophone).
   OpenShift cluster disables scheduling on control plane nodes in the default installation, so you need to pass `--plugin-env=e2e.E2E_EXTRA_ARGS="--allowed-not-ready-nodes=3" `to inform testing framework it should take that into account.
      ```
      go install sigs.k8s.io/hydrophone@latest
      hydrophone --conformance --conformance-image registry.k8s.io/conformance:v1.29.5 --extra-args="--allowed-not-ready-nodes=3"
      ```

5. Once conformance testing is completed, if you do not have the cluster cleaned up, be sure to restore the default security rules:
      ```
      oc adm policy remove-scc-from-group anyuid system:authenticated system:serviceaccounts
      oc adm policy remove-scc-from-group privileged system:authenticated system:serviceaccounts
      ```

6. contact OSD-SRE to resume Hive Syncing
   Note: This step is required to uninstall the created cluster.