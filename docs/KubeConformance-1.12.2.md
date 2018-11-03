# Kubernetes Conformance Test Suite - v1.12.2

## **Summary**
This document provides a summary of the tests included in the Kubernetes conformance test suite.
Each test lists a set of formal requirements that a platform that meets conformance requirements  must adhere to.

The tests are a subset of the "e2e" tests that make up the Kubernetes testing infrastructure.
Each test is identified by the presence of the `[Conformance]` keyword in the ginkgo descriptive function calls.
The contents of this document are extracted from comments preceding those `[Conformance]` keywords
and those comments are expected to include a descriptive overview of what the test is validating using
RFC2119 keywords. This will provide a clear distinction between which bits of code in the tests are
there for the purposes of validating the platform rather than simply infrastructure logic used to setup, or
clean up the tests.

Example:
```
/*
  Testname: Kubelet-OutputToLogs
  Description: By default the stdout and stderr from the process
           being executed in a pod MUST be sent to the pod's logs.
*/
// Note this test needs to be fixed to also test for stderr
It("it should print the output to logs [Conformance]", func() {
```

would generate the following documentation for the test. Note that the "TestName" from the Documentation above will
be used to document the test which make it more human readable. The "Description" field will be used as the
documentation for that test.

### **Output:**
## [Kubelet-OutputToLogs](https://github.com/kubernetes/kubernetes/blob/release-1.9/test/e2e_node/kubelet_test.go#L42)

By default the stdout and stderr from the process
being executed in a pod MUST be sent to the pod's logs.
Note this test needs to be fixed to also test for stderr

Notational Conventions when documenting the tests with the key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

Note: Please see the Summary at the end of this document to find the number of tests documented for conformance.

## **List of Tests**


## [Custom Resource Definition, create](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/custom_resource_definition.go#L41)

Release : v1.9
Create a API extension client, define a random custom resource definition, create the custom resource. API server MUST be able to create the custom resource.



## [Garbage Collector, delete replication controller, propagation policy background](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/garbage_collector.go#L308)

Release : v1.9
Create a replication controller with 2 Pods. Once RC is created and the first Pod is created, delete RC with deleteOptions.PropagationPolicy set to Background. Deleting the Replication Controller MUST cause pods created by that RC to be deleted.



## [Garbage Collector, delete replication controller, propagation policy orphan](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/garbage_collector.go#L366)

Release : v1.9
Create a replication controller with maximum allocatable Pods between 10 and 100 replicas. Once RC is created and the all Pods are created, delete RC with deleteOptions.PropagationPolicy set to Orphan. Deleting the Replication Controller MUST cause pods created by that RC to be orphaned.



## [Garbage Collector, delete deployment,  propagation policy background](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/garbage_collector.go#L481)

Release : v1.9
Create a deployment with a replicaset. Once replicaset is created , delete the deployment  with deleteOptions.PropagationPolicy set to Background. Deleting the deployment MUST delete the replicaset created by the deployment and also the Pods that belong to the deployments MUST be deleted.



## [Garbage Collector, delete deployment, propagation policy orphan](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/garbage_collector.go#L540)

Release : v1.9
Create a deployment with a replicaset. Once replicaset is created , delete the deployment  with deleteOptions.PropagationPolicy set to Orphan. Deleting the deployment MUST cause the replicaset created by the deployment to be orphaned, also the Pods created by the deployments MUST be orphaned.



## [Garbage Collector, delete replication controller, after owned pods](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/garbage_collector.go#L614)

Release : v1.9
Create a replication controller with maximum allocatable Pods between 10 and 100 replicas. Once RC is created and the all Pods are created, delete RC with deleteOptions.PropagationPolicy set to Foreground. Deleting the Replication Controller MUST cause pods created by that RC to be deleted before the RC is deleted.



## [Garbage Collector, multiple owners](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/garbage_collector.go#L702)

TODO: this should be an integration test

Release : v1.9
Create a replication controller RC1, with maximum allocatable Pods between 10 and 100 replicas. Create second replication controller RC2 and set RC2 as owner for half of those replicas. Once RC1 is created and the all Pods are created, delete RC1 with deleteOptions.PropagationPolicy set to Foreground. Half of the Pods that has RC2 as owner MUST not be deleted but have a deletion timestamp. Deleting the Replication Controller MUST not delete Pods that are owned by multiple replication controllers.



## [Garbage Collector, dependency cycle](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/garbage_collector.go#L816)

TODO: should be an integration test

Release : v1.9
Create three pods, patch them with Owner references such that pod1 has pod3, pod2 has pod1 and pod3 has pod2 as owner references respectively. Delete pod1 MUST delete all pods. The dependency cycle MUST not block the garbage collection.



## [namespace-deletion-removes-pods](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/namespace.go#L269)

Ensure that if a namespace is deleted then all pods are removed from that namespace.



## [namespace-deletion-removes-services](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/namespace.go#L276)

Ensure that if a namespace is deleted then all services are removed from that namespace.



## [watch-configmaps-with-multiple-watchers](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/watch.go#L52)

Ensure that multiple watchers are able to receive all add,
update, and delete notifications on configmaps that match a label selector and do
not receive notifications for configmaps which do not match that label selector.



## [watch-configmaps-from-resource-version](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/watch.go#L137)

Ensure that a watch can be opened from a particular resource version
in the past and only notifications happening after that resource version are observed.



## [watch-configmaps-closed-and-restarted](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/watch.go#L185)

Ensure that a watch can be reopened from the last resource version
observed by the previous watch, and it will continue delivering notifications from
that point in time.



## [watch-configmaps-label-changed](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apimachinery/watch.go#L249)

Ensure that a watched object stops meeting the requirements of
a watch's selector, the watch will observe a delete, and will not observe
notifications for that object until it meets the selector's requirements again.



## [DaemonSet-Creation](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/daemon_set.go#L121)

A conformant Kubernetes distribution MUST support the creation of DaemonSets. When a DaemonSet
Pod is deleted, the DaemonSet controller MUST create a replacement Pod.



## [DaemonSet-NodeSelection](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/daemon_set.go#L148)

A conformant Kubernetes distribution MUST support DaemonSet Pod node selection via label
selectors.



## [DaemonSet-FailedPodCreation](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/daemon_set.go#L247)

A conformant Kubernetes distribution MUST create new DaemonSet Pods when they fail.



## [DaemonSet-RollingUpdate](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/daemon_set.go#L326)

A conformant Kubernetes distribution MUST support DaemonSet RollingUpdates.



## [DaemonSet-Rollback](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/daemon_set.go#L376)

A conformant Kubernetes distribution MUST support automated, minimally disruptive
rollback of updates to a DaemonSet.



## [Deployment RollingUpdate](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/deployment.go#L77)

A conformant Kubernetes distribution MUST support the Deployment with RollingUpdate strategy.



## [Deployment Recreate](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/deployment.go#L84)

A conformant Kubernetes distribution MUST support the Deployment with Recreate strategy.



## [Deployment RevisionHistoryLimit](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/deployment.go#L92)

A conformant Kubernetes distribution MUST clean up Deployment's ReplicaSets based on
the Deployment's `.spec.revisionHistoryLimit`.



## [Deployment Rollover](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/deployment.go#L101)

A conformant Kubernetes distribution MUST support Deployment rollover,
i.e. allow arbitrary number of changes to desired state during rolling update
before the rollout finishes.



## [Deployment Proportional Scaling](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/deployment.go#L119)

A conformant Kubernetes distribution MUST support Deployment
proportional scaling, i.e. proportionally scale a Deployment's ReplicaSets
when a Deployment is scaled.



## [Replication Controller, run basic image](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/rc.go#L47)

Release : v1.9
Replication Controller MUST create a Pod with Basic Image and MUST run the service with the provided image. Image MUST be tested by dialing into the service listening through TCP, UDP and HTTP.



## [Replica Set, run basic image](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/replica_set.go#L90)

Release : v1.9
Create a ReplicaSet with a Pod and a single Container. Make sure that the Pod is running. Pod SHOULD send a valid response when queried.



## [StatefulSet, Rolling Update](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/statefulset.go#L266)

Release : v1.9
StatefulSet MUST support the RollingUpdate strategy to automatically replace Pods one at a time when the Pod template changes. The StatefulSet's status MUST indicate the CurrentRevision and UpdateRevision. If the template is changed to match a prior revision, StatefulSet MUST detect this as a rollback instead of creating a new revision. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Rolling Update with Partition](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/statefulset.go#L277)

Release : v1.9
StatefulSet's RollingUpdate strategy MUST support the Partition parameter for canaries and phased rollouts. If a Pod is deleted while a rolling update is in progress, StatefulSet MUST restore the Pod without violating the Partition. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Scaling](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/statefulset.go#L573)

Release : v1.9
StatefulSet MUST create Pods in ascending order by ordinal index when scaling up, and delete Pods in descending order when scaling down. Scaling up or down MUST pause if any Pods belonging to the StatefulSet are unhealthy. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Burst Scaling](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/statefulset.go#L658)

Release : v1.9
StatefulSet MUST support the Parallel PodManagementPolicy for burst scaling. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Recreate Failed Pod](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/apps/statefulset.go#L701)

Release : v1.9
StatefulSet MUST delete and recreate Pods it owns that go into a Failed state, such as when they are rejected or evicted by a Node. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [Service Account Tokens Must AutoMount](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/auth/service_accounts.go#L165)

Release: v1.9
Ensure that Service Account keys are mounted into the Container. Pod
contains three containers each will read Service Account token,
root CA and default namespace respectively from the default API
Token Mount path. All these three files MUST exist and the Service
Account mount path MUST be auto mounted to the Container.



## [Service account tokens auto mount optionally](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/auth/service_accounts.go#L272)

Release: v1.9
Ensure that Service Account keys are mounted into the Pod only
when AutoMountServiceToken is not set to false. We test the
following scenarios here.
1. Create Pod, Pod Spec has AutomountServiceAccountToken set to nil
a) Service Account with default value,
b) Service Account is an configured AutomountServiceAccountToken set to true,
c) Service Account is an configured AutomountServiceAccountToken set to false
2. Create Pod, Pod Spec has AutomountServiceAccountToken set to true
a) Service Account with default value,
b) Service Account is configured with AutomountServiceAccountToken set to true,
c) Service Account is configured with AutomountServiceAccountToken set to false
3. Create Pod, Pod Spec has AutomountServiceAccountToken set to false
a) Service Account with default value,
b) Service Account is configured with AutomountServiceAccountToken set to true,
c) Service Account is configured with AutomountServiceAccountToken set to false

The Containers running in these pods MUST verify that the ServiceTokenVolume path is
auto mounted only when Pod Spec has AutomountServiceAccountToken not set to false
and ServiceAccount object has AutomountServiceAccountToken not set to false, this
include test cases 1a,1b,2a,2b and 2c.
In the test cases 1c,3a,3b and 3c the ServiceTokenVolume MUST not be auto mounted.



## [ConfigMap, from environment field](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap.go#L38)

Release : v1.9
Create a Pod with an environment variable value set using a value from ConfigMap. A ConfigMap value MUST be accessible in the container environment.



## [ConfigMap, from environment variables](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap.go#L86)

Release: v1.9
Create a Pod with a environment source from ConfigMap. All ConfigMap values MUST be available as environment variables in the container.



## [ConfigMap Volume, without mapping](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L41)

Release : v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST default to 0x644.



## [ConfigMap Volume, without mapping, volume mode set](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L50)

Release : v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. File mode is changed to a custom value of '0x400'. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value of ‘0x400’



## [ConfigMap Volume, without mapping, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L65)

Release : v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Pod is run as a non-root user with uid=1000. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The file on the volume MUST have file mode set to default value of 0x644.



## [ConfigMap Volume, with mapping](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L78)

Release : v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST default to 0x644.



## [ConfigMap Volume, with mapping, volume mode set](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L87)

Release : v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. File mode is changed to a custom value of '0x400'. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value of ‘0x400’



## [ConfigMap Volume, with mapping, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L97)

Release : v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. Pod is run as a non-root user with uid=1000. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The file on the volume MUST have file mode set to default value of 0x644.



## [ConfigMap Volume, update](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L110)

Release : v1.9
The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the ConfigMap is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod.



## [ConfigMap Volume, text data, binary data](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L193)

Release: v1.12
The ConfigMap that is created with text data and binary data MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. ConfigMap's text data and binary data MUST be verified by reading the content from the mounted files in the Pod.



## [ConfigMap Volume, create, update and delete](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L289)

Release : v1.9
The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the config map is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod. Also when the item(file) is deleted from the map that MUST result in a error reading that item(file).



## [ConfigMap Volume, multiple volume maps](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/configmap_volume.go#L472)

Release : v1.9
The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to multiple paths in the Pod. The content MUST be accessible from all the mapped volume mounts.



## [Pod readiness probe, with initial delay](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/container_probe.go#L57)

Release : v1.9
Create a Pod that is configured with a initial delay set on the readiness probe. Check the Pod Start time to compare to the initial delay. The Pod MUST be ready only after the specified initial delay.



## [Pod readiness probe, failure](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/container_probe.go#L90)

Release : v1.9
Create a Pod with a readiness probe that fails consistently. When this Pod is created,
then the Pod MUST never be ready, never be running and restart count MUST be zero.



## [Pod liveness probe, using local file, restart](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/container_probe.go#L115)

Release : v1.9
Create a Pod with liveness probe that that uses ExecAction handler to cat /temp/health file. The Container deletes the file /temp/health after 10 second, triggering liveness probe to fail. The Pod MUST now be killed and restarted incrementing restart count to 1.



## [Pod liveness probe, using local file, no restart](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/container_probe.go#L147)

Release : v1.9
Pod is created with liveness probe that uses ‘exec’ command to cat /temp/health file. Liveness probe MUST not fail to check health and the restart count should remain 0.



## [Pod liveness probe, using http endpoint, restart](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/container_probe.go#L179)

Release : v1.9
A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod MUST now be killed and restarted incrementing restart count to 1.



## [Pod liveness probe, using http endpoint, multiple restarts (slow)](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/container_probe.go#L213)

Slow by design (5 min)

Release : v1.9
A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod MUST now be killed and restarted incrementing restart count to 1. The liveness probe must fail again after restart once the http handler for /healthz enpoind on the Pod returns an http error after 10 seconds from the start. Restart counts MUST increment everytime health check fails, measure upto 5 restart.



## [Pod liveness probe, using http endpoint, failure](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/container_probe.go#L246)

Release : v1.9
A Pod is created with liveness probe on http endpoint ‘/’. Liveness probe on this endpoint will not fail. When liveness probe does not fail then the restart count MUST remain zero.



## [Docker containers, without command and arguments](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/docker_containers.go#L35)

Release : v1.9
Default command and arguments from the docker image entrypoint MUST be used when Pod does not specify the container command



## [Docker containers, with arguments](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/docker_containers.go#L46)

Release : v1.9
Default command and  from the docker image entrypoint MUST be used when Pod does not specify the container command but the arguments from Pod spec MUST override when specified.



## [Docker containers, with command](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/docker_containers.go#L62)

Note: when you override the entrypoint, the image's arguments (docker cmd)
are ignored.

Release : v1.9
Default command from the docker image entrypoint MUST NOT be used when Pod specifies the container command.  Command from Pod spec MUST override the command in the image.



## [Docker containers, with command and arguments](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/docker_containers.go#L76)

Release : v1.9
Default command and arguments from the docker image entrypoint MUST NOT be used when Pod specifies the container command and arguments.  Command and arguments from Pod spec MUST override the command and arguments in the image.



## [DownwardAPI, environment for name, namespace and ip](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downward_api.go#L46)

Release : v1.9
Downward API MUST expose Pod and Container fields as environment variables. Specify Pod Name, namespace and IP as environment variable in the Pod Spec are visible at runtime in the container.



## [DownwardAPI, environment for host ip](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downward_api.go#L92)

Release : v1.9
Downward API MUST expose Pod and Container fields as environment variables. Specify host IP as environment variable in the Pod Spec are visible at runtime in the container.



## [DownwardAPI, environment for CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downward_api.go#L119)

Release : v1.9
Downward API MUST expose CPU request amd Memory request set through environment variables at runtime in the container.



## [DownwardAPI, environment for default CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downward_api.go#L170)

Release : v1.9
Downward API MUST expose CPU request amd Memory limits set through environment variables at runtime in the container.



## [DownwardAPI, environment for Pod UID](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downward_api.go#L220)

Release : v1.9
Downward API MUST expose Pod UID set through environment variables at runtime in the container.



## [DownwardAPI volume, pod name](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L48)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.



## [DownwardAPI volume, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L62)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource with the volumesource mode set to -r-------- and DownwardAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.



## [DownwardAPI volume, file mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L77)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the Pod name with the file mode set to -r--------. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.



## [DownwardAPI volume, update label](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L121)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains list of items for each of the Pod labels. The container runtime MUST be able to access Pod labels from the specified path on the mounted volume. Update the labels by adding a new label to the running Pod. The new label MUST be available from the mounted volume.



## [DownwardAPI volume, update annotations](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L153)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains list of items for each of the Pod annotations. The container runtime MUST be able to access Pod annotations from the specified path on the mounted volume. Update the annotations by adding a new annotation to the running Pod. The new annotation MUST be available from the mounted volume.



## [DownwardAPI volume, CPU limits](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L187)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the CPU limits. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume.



## [DownwardAPI volume, memory limits](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L201)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the memory limits. The container runtime MUST be able to access memory limits from the specified path on the mounted volume.



## [DownwardAPI volume, CPU request](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L215)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the CPU request. The container runtime MUST be able to access CPU request from the specified path on the mounted volume.



## [DownwardAPI volume, memory request](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L229)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the memory request. The container runtime MUST be able to access memory request from the specified path on the mounted volume.



## [DownwardAPI volume, CPU limit, default node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L243)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the CPU limits. CPU limits is not specified for the container. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume and the value MUST be default node allocatable.



## [DownwardAPI volume, memory limit, default node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/downwardapi_volume.go#L255)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the memory limits. memory limits is not specified for the container. The container runtime MUST be able to access memory limits from the specified path on the mounted volume and the value MUST be default node allocatable.



## [EmptyDir, medium memory, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L74)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs.



## [EmptyDir, medium memory, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L83)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L92)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L101)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0644, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L110)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0666,, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L119)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0777, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L128)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L137)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs.



## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L146)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L155)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L164)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L173)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L182)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/empty_dir.go#L191)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [Environment variables, expansion](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/expansion.go#L41)

Release : v1.9
Create a Pod with environment variables. Environment variables defined using previously defined environment variables MUST expand to proper values.



## [Environment variables, command expansion](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/expansion.go#L86)

Release : v1.9
Create a Pod with environment variables and container command using them. Container command using the  defined environment variables MUST expand to proper values.



## [Environment variables, command argument expansion](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/expansion.go#L121)

Release : v1.9
Create a Pod with environment variables and container command arguments using them. Container command arguments using the  defined environment variables MUST expand to proper values.



## [Host path, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/host_path.go#L48)

Release : v1.9
Create a Pod with host volume mounted. The volume mounted MUST be a directory with permissions mode -rwxrwxrwx and that is has the sticky bit (mode flag t) set.



## [init-container-starts-app-restartnever-pod](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/init_container.go#L55)

Release: v1.12
Ensure that all InitContainers are started
and all containers in pod are voluntarily terminated with exit status 0,
and the system is not going to restart any of these containers
when Pod has restart policy as RestartNever.



## [init-container-starts-app-restartalways-pod](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/init_container.go#L122)

Release: v1.12
Ensure that all InitContainers are started
and all containers in pod started
and at least one container is still running or is in the process of being restarted
when Pod has restart policy as RestartAlways.



## [init-container-fails-stops-app-restartalways-pod](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/init_container.go#L193)

Release: v1.12
Ensure that app container is not started
when all InitContainers failed to start
and Pod has restarted for few occurrences
and pod has restart policy as RestartAlways.



## [init-container-fails-stops-app-restartnever-pod](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/init_container.go#L309)

Release: v1.12
Ensure that app container is not started
when atleast one InitContainer fails to start and Pod has restart policy as RestartNever.



## [Kubelet, managed etc hosts](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/kubelet_etc_hosts.go#L61)

Release : v1.9
Create a Pod with containers with hostNetwork set to false, one of the containers mounts the /etc/hosts file form the host. Create a second Pod with hostNetwork set to true.
1. The Pod with hostNetwork=false MUST have /etc/hosts of containers managed by the Kubelet.
2. The Pod with hostNetwork=false but the container mounts /etc/hosts file from the host. The /etc/hosts file MUST not be managed by the Kubelet.
3. The Pod with hostNetwork=true , /etc/hosts file MUST not be managed by the Kubelet.



## [Pod Lifecycle, post start exec hook](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/lifecycle_hook.go#L92)

Release : v1.9
When a post start handler is specified in the container lifecycle using a ‘Exec’ action, then the handler MUST be invoked after the start of the container. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a post start that invokes the server pod using ExecAction to validate that the post start is executed.



## [Pod Lifecycle, prestop exec hook](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/lifecycle_hook.go#L108)

Release : v1.9
When a pre-stop handler is specified in the container lifecycle using a ‘Exec’ action, then the handler MUST be invoked before the container is terminated. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a pre-stop that invokes the server pod using ExecAction to validate that the pre-stop is executed.



## [Pod Lifecycle, post start http hook](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/lifecycle_hook.go#L124)

Release : v1.9
When a post start handler is specified in the container lifecycle using a HttpGet action, then the handler MUST be invoked after the start of the container. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a post start that invokes the server pod to validate that the post start is executed.



## [Pod Lifecycle, prestop http hook](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/lifecycle_hook.go#L142)

Release : v1.9
When a pre-stop handler is specified in the container lifecycle using a ‘HttpGet’ action, then the handler MUST be invoked before the container is terminated. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a pre-stop that invokes the server pod to validate that the pre-stop is executed.



## [Networking, intra pod http](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/networking.go#L39)

Try to hit all endpoints through a test container, retry 5 times,
expect exactly one unique hostname. Each of these endpoints reports
its own hostname.

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.



## [Networking, intra pod udp](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/networking.go#L52)

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a udp port on the each of service proxy endpoints in the cluster and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.



## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/networking.go#L65)

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=tcp)  and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.



## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/networking.go#L78)

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=udp)  and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.



## [Pods, assigned hostip](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/pods.go#L141)

Release : v1.9
Create a Pod. Pod status MUST return successfully and contains a valid IP address.



## [Pods, lifecycle](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/pods.go#L163)

Release : v1.9
A Pod is created with a unique label. Pod MUST be accessible when queried using the label selector upon creation. Add a watch, check if the Pod is running. Pod then deleted, The pod deletion timestamp is observed. The watch MUST return the pod deleted event. Query with the original selector for the Pod MUST return empty list.



## [Pods, update](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/pods.go#L289)

Release : v1.9
Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. Update the pod to change the value of the Label. Query for the Pod with the new value for the label MUST be successful.



## [Pods, ActiveDeadlineSeconds](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/pods.go#L343)

Release : v1.9
Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. The Pod is updated with ActiveDeadlineSeconds set on the Pod spec. Pod MUST terminate of the specified time elapses.



## [Pods, service environment variables](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/pods.go#L389)

Release : v1.9
Create a server Pod listening on port 9376. A Service called fooservice is created for the server Pod listening on port 8765 targeting port 8080. If a new Pod is created in the cluster then the Pod MUST have the fooservice environment variables available from this new Pod. The new create Pod MUST have environment variables such as FOOSERVICE_SERVICE_HOST, FOOSERVICE_SERVICE_PORT, FOOSERVICE_PORT, FOOSERVICE_PORT_8765_TCP_PORT, FOOSERVICE_PORT_8765_TCP_PROTO, FOOSERVICE_PORT_8765_TCP and FOOSERVICE_PORT_8765_TCP_ADDR that are populated with proper values.



## [Projected Volume, Secrets, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L44)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with default permission mode. Pod MUST be able to read the content of the key successfully and the mode MUST be -rw-r--r-- by default.



## [Projected Volume, Secrets, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L53)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with permission mode set to 0x400 on the Pod. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————.



## [Project Volume, Secrets, non-root, custom fsGroup](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L63)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key. The volume has permission mode set to 0440, fsgroup set to 1001 and user set to non-root uid of 1000. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-r————-.



## [Projected Volume, Secrets, mapped](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L75)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with default permission mode. The secret is also mapped to a custom path. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————— on the mapped volume.



## [Projected Volume, Secrets, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L84)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with permission mode set to 0400. The secret is also mapped to a specific name. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————— on the mapped volume.



## [Projected Volume, Secrets, mapped, multiple paths](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L115)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key. The secret is mapped to two different volume mounts. Pod MUST be able to read the content of the key successfully from the two volume mounts and the mode MUST be -r—-—————— on the mapped volumes.



## [Projected Volume, Secrets, create, update delete](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L209)

Release : v1.9
Create a Pod with three containers with secrets namely a create, update and delete container. Create Container when started MUST no have a secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.



## [Projected Volume, ConfigMap, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L411)

Part 2/3 - ConfigMaps

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with default permission mode. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw-r—-r—-.



## [Projected Volume, ConfigMap, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L420)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with permission mode set to 0400. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -r——-——-—-.



## [Projected Volume, ConfigMap, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L435)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap as non-root user with uid 1000. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw—r——r—-.



## [Projected Volume, ConfigMap, mapped](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L448)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with default permission mode. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -rw—r——r—-.



## [Projected Volume, ConfigMap, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L457)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with permission mode set to 0400. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r-—r——r—-.



## [Projected Volume, ConfigMap, mapped, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L467)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap as non-root user with uid 1000. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r-—r——r—-.



## [Projected Volume, ConfigMap, update](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L480)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap and performs a create and update to new value. Pod MUST be able to create the configMap with value-1. Pod MUST be able to update the value in the confgiMap to value-2.



## [Projected Volume, ConfigMap, create, update and delete](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L568)

Release : v1.9
Create a Pod with three containers with ConfigMaps namely a create, update and delete container. Create Container when started MUST not have configMap, update and delete containers MUST be created with a ConfigMap value as ‘value-1’. Create a configMap in the create container, the Pod MUST be able to read the configMap from the create container. Update the configMap in the update container, Pod MUST be able to read the updated configMap value. Delete the configMap in the delete container. Pod MUST fail to read the configMap from the delete container.



## [Projected Volume, ConfigMap, multiple volume paths](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L769)

Release : v1.9
A Pod is created with a projected volume source ‘ConfigMap’ to store a configMap. The configMap is mapped to two different volume mounts. Pod MUST be able to read the content of the configMap successfully from the two volume mounts.



## [Projected Volume, DownwardAPI, pod name](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L867)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L881)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r—-—————.



## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L896)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r—-—————.



## [Projected Volume, DownwardAPI, update labels](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L940)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and label items. Pod MUST be able to read the labels from the mounted DownwardAPIVolumeFiles. Labels are then updated. Pod MUST be able to read the updated values for the Labels.



## [Projected Volume, DownwardAPI, update annotation](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L972)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and annotation items. Pod MUST be able to read the annotations from the mounted DownwardAPIVolumeFiles. Annotations are then updated. Pod MUST be able to read the updated values for the Annotations.



## [Projected Volume, DownwardAPI, CPU limits](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L1006)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory limits](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L1020)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, CPU request](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L1034)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu request from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory request](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L1048)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory request from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, CPU limit, node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L1062)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default cpu limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory limit, node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L1074)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default memory limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, multiple projections](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/projected.go#L1087)

Test multiple projections

Release : v1.9
A Pod is created with a projected volume source for secrets, configMap and downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the secrets, configMap values and the cpu and memory limits as well as cpu and memory requests from the mounted DownwardAPIVolumeFiles.



## [Secrets, pod environment field](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets.go#L39)

Release : v1.9
Create a secret. Create a Pod with Container that declares a environment variable which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.



## [Secrets, pod environment from source](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets.go#L88)

Release : v1.9
Create a secret. Create a Pod with Container that declares a environment variable using ‘EnvFrom’ which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.



## [Secrets Volume, default](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L42)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -rw-r--r-- by default.



## [Secrets Volume, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L51)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r——--—-—- by default.



## [Secrets Volume, volume mode 0440, fsGroup 1001 and uid 1000](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L61)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x440 as a non-root user with uid 1000 and fsGroup id 1001. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r——r-—-—- by default.



## [Secrets Volume, mapping](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L73)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with a custom path. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -rw—r-—r—- by default.



## [Secrets Volume, mapping, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L82)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with a custom path and file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -r-—r-—r—-.



## [Secrets Volume, volume mode default, secret with same name in different namespace](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L92)

Release : v1.12
Create a secret with same name in two namespaces. Create a Pod with secret volume source configured into the container. Pod MUST be able to read the secrets from the mounted volume from the container runtime and only secrets which are associated with namespace where pod is created. The file mode of the secret MUST be -rw-r--r-- by default.



## [Secrets Volume, mapping multiple volume paths](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L118)

Release : v1.9
Create a secret. Create a Pod with two secret volume sources configured into the container in to two different custom paths. Pod MUST be able to read the secret from the both the mounted volumes from the two specified custom paths.



## [Secrets Volume, create, update and delete](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/common/secrets_volume.go#L196)

Release : v1.9
Create a Pod with three containers with secrets volume sources namely a create, update and delete container. Create Container when started MUST not have secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.



## [Kubectl, replication controller](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L303)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2.



## [Kubectl, scale replication controller](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L316)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Update the replicaset to 1. Number of running instances of the Pod MUST be 1. Update the replicaset to 2. Number of running instances of the Pod MUST be 2.



## [Kubectl, rolling update replication controller](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L337)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Run a rolling update to run a different version of the container. All running instances SHOULD now be running the newer version of the container as part of the rolling update.



## [Kubectl, guestbook application](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L370)

Release : v1.9
Create Guestbook application that contains redis server, 2 instances of redis slave, frontend application, frontend service and redis master service and redis slave service. Using frontend service, the test will write an entry into the guestbook application which will store the entry into the backend redis database. Application flow MUST work as expected and the data written MUST be available to read.



## [Kubectl, check version v1](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L737)

Release : v1.9
Run kubectl to get api versions, output MUST contain returned versions with ‘v1’ listed.



## [Kubectl, cluster info](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L834)

Release : v1.9
Call kubectl to get cluster-info, output MUST contain cluster-info returned and Kubernetes Master SHOULD be running.



## [Kubectl, describe pod or rc](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L853)

Release : v1.9
Deploy a redis controller and a redis service. Kubectl describe pods SHOULD return the name, namespace, labels, state and other information as expected. Kubectl describe on rc, service, node and namespace SHOULD also return proper information.



## [Kubectl, create service, replication controller](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L961)

Release : v1.9
Create a Pod running redis master listening to port 6379. Using kubectl expose the redis master  replication controllers at port 1234. Validate that the replication controller is listening on port 1234 and the target port is set to 6379, port that redis master is listening. Using kubectl expose the redis master as a service at port 2345. The service MUST be listening on port 2345 and the target port is set to 6379, port that redis master is listening.



## [Kubectl, label update](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1057)

Release : v1.9
When a Pod is running, update a Label using ‘kubectl label’ command. The label MUST be created in the Pod. A ‘kubectl get pod’ with -l option on the container MUST verify that the label can be read back. Use ‘kubectl label label-’ to remove the label. Kubetctl get pod’ with -l option SHOULD no list the deleted label as the label is removed.



## [Kubectl, logs](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1103)

Release : v1.9
When a Pod is running then it MUST generate logs.
Starting a Pod should have a log line indicating the the server is running and ready to accept connections. 			   Also log command options MUST work as expected and described below.
‘kubectl log -tail=1’ should generate a output of one line, the last line in the log.
‘kubectl --limit-bytes=1’ should generate a single byte output.
‘kubectl --tail=1 --timestamp should genrate one line with timestamp in RFC3339 format
‘kubectl --since=1s’ should output logs that are only 1 second older from now
‘kubectl --since=24h’ should output logs that are only 1 day older from now



## [Kubectl, patch to annotate](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1159)

Release : v1.9
Start running a redis master and a replication controller. When the pod is running, using ‘kubectl patch’ command add annotations. The annotation MUST be added to running pods and SHOULD be able to read added annotations from each of the Pods running under the replication controller.



## [Kubectl, version](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1193)

Release : v1.9
The command ‘kubectl version’ MUST return the major, minor versions,  GitCommit, etc of the the Client and the Server that the kubectl is configured to connect to.



## [Kubectl, run default](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1225)

Release : v1.9
Command ‘kubectl run’ MUST create a running pod with possible replicas given a image using the option --image=’nginx’. The running Pod SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command.



## [Kubectl, run rc](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1260)

Release : v1.9
Command ‘kubectl run’ MUST create a running rc with default one replicas given a image using the option --image=’nginx’. The running replication controller SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command. Also there MUST be 1 pod controlled by this replica set running 1 container with the image specified. A ‘kubetctl logs’ command MUST return the logs from the container in the replication controller.



## [Kubectl, rolling update](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1321)

Release : v1.9
Command ‘kubectl rolling-update’ MUST replace the specified replication controller with a new replication controller by updating one pod at a time to use the new Pod spec.



## [Kubectl, run deployment](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1371)

Release : v1.9
Command ‘kubectl run’ MUST create a job, with --generator=deployment, when a image name is specified in the run command. After the run command there SHOULD be a deployment that should exist with one container running the specified image. Also there SHOULD be a Pod that is controlled by this deployment, with a container running the specified image.



## [Kubectl, run job](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1416)

Release : v1.9
Command ‘kubectl run’ MUST create a deployment, with --generator=job, when a image name is specified in the run command. After the run command there SHOULD be a job that should exist with one container running the specified image. Also there SHOULD be a restart policy on the job spec that SHOULD match the command line.



## [Kubectl, run pod](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1489)

Release : v1.9
Command ‘kubectl run’ MUST create a pod, with --generator=run-pod, when a image name is specified in the run command. After the run command there SHOULD be a pod that should exist with one container running the specified image.



## [Kubectl, replace](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1525)

Release : v1.9
Command ‘kubectl replace’ on a existing Pod with a new spec MUST update the image of the container running in the Pod. A -f option to ‘kubectl replace’ SHOULD force to re-create the resource. The new Pod SHOULD have the container with new change to the image.



## [Kubectl, run job with --rm](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1566)

Release : v1.9
Start a job with a Pod using ‘kubectl run’ but specify --rm=true. Wait for the Pod to start running by verifying that there is output as expected. Now verify that the job has exited and cannot be found. With --rm=true option the job MUST start by running the image specified and then get deleted itself.



## [Kubectl, proxy port zero](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1596)

TODO: test proxy options (static, prefix, etc)

Release : v1.9
Start a proxy server on port zero by running ‘kubectl proxy’ with --port=0. Call the proxy server by requesting api versions from unix socket. The proxy server MUST provide at least one version string.



## [Kubectl, proxy socket](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/kubectl/kubectl.go#L1621)

Release : v1.9
Start a proxy server on by running ‘kubectl proxy’ with --unix-socket=<some path>. Call the proxy server by requesting api versions from  http://locahost:0/api. The proxy server MUST provide atleast one version string



## [DNS, cluster](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/dns.go#L44)

Release : v1.9
When a Pod is created, the pod MUST be able to resolve cluster dns entries such as kubernetes.default via DNS and /etc/hosts.



## [DNS, services](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/dns.go#L75)

Release : v1.9
When a headless service is created, the service MUST be able to resolve all the required service endpoints. When the service is created, any pod in the same namespace must be able to resolve the service by all of the expected DNS names.



## [Proxy, logs port endpoint](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/proxy.go#L68)

Release : v1.9
Select any node in the cluster to invoke /proxy/nodes/<nodeip>:10250/logs endpoint. This endpoint MUST be reachable.



## [Proxy, logs endpoint](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/proxy.go#L75)

Release : v1.9
Select any node in the cluster to invoke /proxy/nodes/<nodeip>//logs endpoint. This endpoint MUST be reachable.



## [Proxy, logs service endpoint](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/proxy.go#L84)

using the porter image to serve content, access the content
(of multiple pods?) from multiple (endpoints/services?)

Release : v1.9
Select any node in the cluster to invoke  /logs endpoint  using the /nodes/proxy subresource from the kubelet port. This endpoint MUST be reachable.



## [Kubernetes Service](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/service.go#L107)

Release : v1.9
By default when a kubernetes cluster is running there MUST be a ‘kubernetes’ service running in the cluster.



## [Service, endpoints](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/service.go#L117)

Release : v1.9
Create a service with a endpoint without any Pods, the service MUST run and show empty endpoints. Add a pod to the service and the service MUST validate to show all the endpoints for the ports exposed by the Pod. Add another Pod then the list of all Ports exposed by both the Pods MUST be valid and have corresponding service endpoint. Once the second Pod is deleted then set of endpoint MUST be validated to show only ports from the first container that are exposed. Once both pods are deleted the endpoints from the service MUST be empty.



## [Service, endpoints with multiple ports](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/service.go#L174)

Release : v1.9
Create a service with two ports but no Pods are added to the service yet.  The service MUST run and show empty set of endpoints. Add a Pod to the first port, service MUST list one endpoint for the Pod on that port. Add another Pod to the second port, service MUST list both the endpoints. Delete the first Pod and the service MUST list only the endpoint to the second Pod. Delete the second Pod and the service must now have empty set of endpoints.



## [Service endpoint latency, thresholds](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/network/service_latency.go#L54)

Release : v1.9
Run 100 iterations of create service with the Pod running the pause image, measure the time it takes for creating the service and the endpoint with the service name is available. These durations are captured for 100 iterations, then the durations are sorted to compue 50th, 90th and 99th percentile. The single server latency MUST not exceed liberally set thresholds of 20s for 50th percentile and 50s for the 90th percentile.



## [Pod events, verify event from Scheduler and Kubelet](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/node/events.go#L43)

Release : v1.9
Create a Pod, make sure that the Pod can be queried. Create a event selector for the kind=Pod and the source is the Scheduler. List of the events MUST be at least one. Create a event selector for kind=Pod and the source is the Kubelet. List of the events MUST be at least one. Both Scheduler and Kubelet MUST send events when scheduling and running a Pod.



## [Pods, delete grace period](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/node/pods.go#L55)

Flaky issue #36821.

Release : v1.9
Create a pod, make sure it is running, create a watch to observe Pod creation. Create a 'kubectl local proxy', capture the port the proxy is listening. Using the http client send a ‘delete’ with gracePeriodSeconds=30. Pod SHOULD get deleted within 30 seconds.



## [Pods, QOS](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/node/pods.go#L212)

Release : v1.9
Create a Pod with CPU and Memory request and limits. Pos status MUST have QOSClass set to PodQOSGuaranteed.



## [Pods, prestop hook](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/node/pre_stop.go#L169)

Release : v1.9
Create a server pod with a rest endpoint '/write' that changes state.Received field. Create a Pod with a pre-stop handle that posts to the /write endpoint on the server Pod. Verify that the Pod with pre-stop hook is running. Delete the Pod with the pre-stop hook. Before the Pod is deleted, pre-stop handler MUST be called when configured. Verify that the Pod is deleted and a call to prestop hook is verified by checking the status received on the server Pod.



## [Scheduler, resource limits](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/scheduling/predicates.go#L226)

This test verifies we don't allow scheduling of pods in a way that sum of
limits of pods is greater than machines capacity.
It assumes that cluster add-on pods stay stable and cannot be run in parallel
with any other test that touches Nodes or Pods.
It is so because we need to have precise control on what's running in the cluster.
Test scenario:
1. Find the amount CPU resources on each node.
2. Create one pod with affinity to each node that uses 70% of the node CPU.
3. Wait for the pods to be scheduled.
4. Create another pod with no affinity to any node that need 50% of the largest node CPU.
5. Make sure this additional pod is not scheduled.

Release : v1.9
Scheduling Pods MUST fail if the resource limits exceed Machine capacity.



## [Scheduler, node selector not matching](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/scheduling/predicates.go#L332)

Test Nodes does not have any label, hence it should be impossible to schedule Pod with
nonempty Selector set.

Release : v1.9
Create a Pod with a NodeSelector set to a value that does not match a node in the cluster. Since there are no nodes matching the criteria the Pod MUST not be scheduled.



## [Scheduler, node selector matching](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/scheduling/predicates.go#L355)

Release : v1.9
Create a label on the node {k: v}. Then create a Pod with a NodeSelector set to {k: v}. Check to see if the Pod is scheduled. When the NodeSelector matches then Pod MUST be scheduled on that node.



## [SubPath: Reading content from a secret volume.](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/storage/subpath.go#L59)

Release : v1.12
Containers in a pod can read content from a secret mounted volume which was configured with a subpath.



## [SubPath: Reading content from a configmap volume.](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/storage/subpath.go#L69)

Release : v1.12
Containers in a pod can read content from a configmap mounted volume which was configured with a subpath.



## [SubPath: Reading content from a configmap volume.](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/storage/subpath.go#L79)

Release : v1.12
Containers in a pod can read content from a configmap mounted volume which was configured with a subpath and also using a mountpath that is a specific file.



## [SubPath: Reading content from a downwardAPI volume.](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/storage/subpath.go#L91)

Release : v1.12
Containers in a pod can read content from a downwardAPI mounted volume which was configured with a subpath.



## [SubPath: Reading content from a projected volume.](https://github.com/kubernetes/kubernetes/tree/v1.12.2/test/e2e/storage/subpath.go#L105)

Release : v1.12
Containers in a pod can read content from a projected mounted volume which was configured with a subpath.




## **Summary**

Total Conformance Tests: 189, total legacy tests that need conversion: 0, while total tests that need comment sections: 0

