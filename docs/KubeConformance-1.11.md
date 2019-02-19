# Kubernetes Conformance Test Suite - v1.11

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


## [crd-creation-test](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/custom_resource_definition.go#L41)

Create a random Custom Resource Definition and make sure
the API returns success.



## [garbage-collector-delete-rc--propagation-background](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/garbage_collector.go#L344)

Ensure that if deleteOptions.PropagationPolicy is set to Background,
then deleting a ReplicationController should cause pods created
by that RC to also be deleted.



## [garbage-collector-delete-rc--propagation-orphan](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/garbage_collector.go#L402)

Ensure that if deleteOptions.PropagationPolicy is set to Orphan,
then deleting a ReplicationController should cause pods created
by that RC to be orphaned.



## [garbage-collector-delete-deployment-propagation-background](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/garbage_collector.go#L516)

Ensure that if deleteOptions.PropagationPolicy is set to Background,
then deleting a Deployment should cause ReplicaSets created
by that Deployment to also be deleted.



## [garbage-collector-delete-deployment-propagation-true](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/garbage_collector.go#L575)

Ensure that if deleteOptions.PropagationPolicy is set to Orphan,
then deleting a Deployment should cause ReplicaSets created
by that Deployment to be orphaned.



## [garbage-collector-delete-rc-after-owned-pods](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/garbage_collector.go#L648)

Ensure that if deleteOptions.PropagationPolicy is set to Foreground,
then a ReplicationController should not be deleted until all its dependent pods are deleted.



## [garbage-collector-multiple-owners](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/garbage_collector.go#L736)

TODO: this should be an integration test

Ensure that if a Pod has multiple valid owners, it will not be deleted
when one of of those owners gets deleted.



## [garbage-collector-dependency-cycle](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/garbage_collector.go#L850)

TODO: should be an integration test

Ensure that a dependency cycle will
not block the garbage collector.



## [watch-configmaps-with-multiple-watchers](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/watch.go#L52)

Ensure that multiple watchers are able to receive all add,
update, and delete notifications on configmaps that match a label selector and do
not receive notifications for configmaps which do not match that label selector.



## [watch-configmaps-from-resource-version](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/watch.go#L137)

Ensure that a watch can be opened from a particular resource version
in the past and only notifications happening after that resource version are observed.



## [watch-configmaps-closed-and-restarted](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/watch.go#L185)

Ensure that a watch can be reopened from the last resource version
observed by the previous watch, and it will continue delivering notifications from
that point in time.



## [watch-configmaps-label-changed](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apimachinery/watch.go#L249)

Ensure that a watched object stops meeting the requirements of
a watch's selector, the watch will observe a delete, and will not observe
notifications for that object until it meets the selector's requirements again.



## [DaemonSet-Creation](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/daemon_set.go#L112)

A conformant Kubernetes distribution MUST support the creation of DaemonSets. When a DaemonSet
Pod is deleted, the DaemonSet controller MUST create a replacement Pod.



## [DaemonSet-NodeSelection](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/daemon_set.go#L139)

A conformant Kubernetes distribution MUST support DaemonSet Pod node selection via label
selectors.



## [DaemonSet-FailedPodCreation](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/daemon_set.go#L238)

A conformant Kubernetes distribution MUST create new DaemonSet Pods when they fail.



## [DaemonSet-RollingUpdate](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/daemon_set.go#L317)

A conformant Kubernetes distribution MUST support DaemonSet RollingUpdates.



## [DaemonSet-Rollback](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/daemon_set.go#L367)

A conformant Kubernetes distribution MUST support automated, minimally disruptive
rollback of updates to a DaemonSet.



## [Replication Controller, run basic image](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/rc.go#L47)

Release : v1.9
Replication Controller MUST create a Pod with Basic Image and MUST run the service with the provided image. Image MUST be tested by dialing into the service listening through TCP, UDP and HTTP.



## [Replica Set, run basic image](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/replica_set.go#L90)

Release : v1.9
Create a ReplicaSet with a Pod and a single Container. Make sure that the Pod is running. Pod SHOULD send a valid response when queried.



## [StatefulSet, Rolling Update](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/statefulset.go#L256)

Release : v1.9
StatefulSet MUST support the RollingUpdate strategy to automatically replace Pods one at a time when the Pod template changes. The StatefulSet's status MUST indicate the CurrentRevision and UpdateRevision. If the template is changed to match a prior revision, StatefulSet MUST detect this as a rollback instead of creating a new revision. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Rolling Update with Partition](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/statefulset.go#L376)

Release : v1.9
StatefulSet's RollingUpdate strategy MUST support the Partition parameter for canaries and phased rollouts. If a Pod is deleted while a rolling update is in progress, StatefulSet MUST restore the Pod without violating the Partition. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Scaling](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/statefulset.go#L672)

Release : v1.9
StatefulSet MUST create Pods in ascending order by ordinal index when scaling up, and delete Pods in descending order when scaling down. Scaling up or down MUST pause if any Pods belonging to the StatefulSet are unhealthy. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Burst Scaling](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/statefulset.go#L753)

Release : v1.9
StatefulSet MUST support the Parallel PodManagementPolicy for burst scaling. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Recreate Failed Pod](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/apps/statefulset.go#L796)

Release : v1.9
StatefulSet MUST delete and recreate Pods it owns that go into a Failed state, such as when they are rejected or evicted by a Node. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [ServiceAccounts should mount an API token into pods](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/auth/service_accounts.go#L156)




## [ServiceAccounts should allow opting out of API token automount](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/auth/service_accounts.go#L238)




## [configmap-in-env-field](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap.go#L37)

Make sure config map value can be used as an environment
variable in the container (on container.env field)



## [configmap-envfrom-field](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap.go#L85)

Make sure config map value can be used as an source for
environment variables in the container (on container.envFrom field)



## [configmap-nomap-simple](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L40)

Make sure config map without mappings works by mounting it
to a volume with a custom path (mapping) on the pod with no other settings.



## [configmap-nomap-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L49)

Make sure config map without mappings works by mounting it
to a volume with a custom path (mapping) on the pod with defaultMode set



## [configmap-nomap-user](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L64)

Make sure config map without mappings works by mounting it
to a volume with a custom path (mapping) on the pod as non-root.



## [configmap-simple-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L78)

Make sure config map works by mounting it to a volume with
a custom path (mapping) on the pod with no other settings and make sure
the pod actually consumes it.



## [configmap-with-item-mode-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L87)

Make sure config map works with an item mode (e.g. 0400)
for the config map item.



## [configmap-simple-user-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L96)

Make sure config map works when it is mounted as non-root.



## [configmap-update-test](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L109)

Make sure update operation is working on config map and
the result is observed on volumes mounted in containers.



## [configmap-CUD-test](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L283)

Make sure Create, Update, Delete operations are all working
on config map and the result is observed on volumes mounted in containers.



## [configmap-multiple-volumes](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/configmap_volume.go#L466)

Make sure config map works when it mounted as two different
volumes on the same node.



## [pods-readiness-probe-initial-delay](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/container_probe.go#L57)

Make sure that pod with readiness probe should not be
ready before initial delay and never restart.



## [pods-readiness-probe-failure](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/container_probe.go#L89)

Make sure that pod with readiness probe that fails should
never be ready and never restart.



## [pods-cat-liveness-probe-restarted](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/container_probe.go#L114)

Make sure the pod is restarted with a cat /tmp/health
liveness probe.



## [pods-cat-liveness-probe-not-restarted](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/container_probe.go#L146)

Make sure the pod is not restarted with a cat /tmp/health
liveness probe.



## [pods-http-liveness-probe-restarted](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/container_probe.go#L178)

Make sure when http liveness probe fails, the pod should
be restarted.



## [pods-restart-count](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/container_probe.go#L212)

Slow by design (5 min)

Make sure when a pod gets restarted, its start count
should increase.



## [pods-http-liveness-probe-not-restarted](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/container_probe.go#L245)

Make sure when http liveness probe succeeds, the pod
should not be restarted.



## [container-without-command-args](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/docker_containers.go#L36)

When a Pod is created neither 'command' nor 'args' are
provided for a Container, ensure that the docker image's default
command and args are used.



## [container-with-args](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/docker_containers.go#L48)

When a Pod is created and 'args' are provided for a
Container, ensure that they take precedent to the docker image's
default arguments, but that the default command is used.



## [container-with-command](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/docker_containers.go#L65)

Note: when you override the entrypoint, the image's arguments (docker cmd)
are ignored.

When a Pod is created and 'command' is provided for a
Container, ensure that it takes precedent to the docker image's default
command.



## [container-with-command-args](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/docker_containers.go#L80)

When a Pod is created and 'command' and 'args' are
provided for a Container, ensure that they take precedent to the docker
image's default command and arguments.



## [downwardapi-env-name-namespace-podip](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downward_api.go#L45)

Ensure that downward API can provide pod's name, namespace
and IP address as environment variables.



## [downwardapi-env-host-ip](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downward_api.go#L91)

Ensure that downward API can provide an IP address for
host node as an environment variable.



## [downwardapi-env-limits-requests](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downward_api.go#L118)

Ensure that downward API can provide CPU/memory limit
and CPU/memory request as environment variables.



## [downwardapi-env-default-allocatable](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downward_api.go#L170)

Ensure that downward API can provide default node
allocatable values for CPU and memory as environment variables if CPU
and memory limits are not specified for a container.



## [downwardapi-env-pod-uid](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downward_api.go#L220)

Ensure that downward API can provide pod UID as an
environment variable.



## [downwardapi-volume-podname](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L47)

Ensure that downward API can provide pod's name through
DownwardAPIVolumeFiles.



## [downwardapi-volume-set-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L61)

Ensure that downward API can set default file permission
mode for DownwardAPIVolumeFiles if no mode is specified.



## [downwardapi-volume-set-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L76)

Ensure that downward API can set file permission mode for
DownwardAPIVolumeFiles.



## [downwardapi-volume-update-label](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L120)

Ensure that downward API updates labels in
DownwardAPIVolumeFiles when pod's labels get modified.



## [downwardapi-volume-update-annotation](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L152)

Ensure that downward API updates annotations in
DownwardAPIVolumeFiles when pod's annotations get modified.



## [downwardapi-volume-cpu-limit](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L186)

Ensure that downward API can provide container's CPU limit
through DownwardAPIVolumeFiles.



## [downwardapi-volume-memory-limit](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L200)

Ensure that downward API can provide container's memory
limit through DownwardAPIVolumeFiles.



## [downwardapi-volume-cpu-request](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L214)

Ensure that downward API can provide container's CPU
request through DownwardAPIVolumeFiles.



## [downwardapi-volume-memory-request](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L228)

Ensure that downward API can provide container's memory
request through DownwardAPIVolumeFiles.



## [downwardapi-volume-default-cpu](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L243)

Ensure that downward API can provide default node
allocatable value for CPU through DownwardAPIVolumeFiles if CPU
limit is not specified for a container.



## [downwardapi-volume-default-memory](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/downwardapi_volume.go#L256)

Ensure that downward API can provide default node
allocatable value for memory through DownwardAPIVolumeFiles if memory
limit is not specified for a container.



## [volume-emptydir-mode-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L75)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure the volume has 0777 unix file permissions and tmpfs
mount type.



## [volume-emptydir-root-0644-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L85)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a root owned file with 0644 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-root-0666-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L95)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a root owned file with 0666 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-root-0777-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L105)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a root owned file with 0777 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-user-0644-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L115)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a user owned file with 0644 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-user-0666-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L125)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a user owned file with 0666 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-user-0777-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L135)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a user owned file with 0777 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L144)

For a Pod created with an 'emptyDir' Volume, ensure the
volume has 0777 unix file permissions.



## [volume-emptydir-root-0644](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L154)

For a Pod created with an 'emptyDir' Volume, ensure a
root owned file with 0644 unix file permissions is created and enforced
correctly.



## [volume-emptydir-root-0666](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L164)

For a Pod created with an 'emptyDir' Volume, ensure a
root owned file with 0666 unix file permissions is created and enforced
correctly.



## [volume-emptydir-root-0777](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L174)

For a Pod created with an 'emptyDir' Volume, ensure a
root owned file with 0777 unix file permissions is created and enforced
correctly.



## [volume-emptydir-user-0644](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L184)

For a Pod created with an 'emptyDir' Volume, ensure a
user owned file with 0644 unix file permissions is created and enforced
correctly.



## [volume-emptydir-user-0666](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L194)

For a Pod created with an 'emptyDir' Volume, ensure a
user owned file with 0666 unix file permissions is created and enforced
correctly.



## [volume-emptydir-user-0777](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/empty_dir.go#L204)

For a Pod created with an 'emptyDir' Volume, ensure a
user owned file with 0777 unix file permissions is created and enforced
correctly.



## [var-expansion-env](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/expansion.go#L40)

Make sure environment variables can be set using an
expansion of previously defined environment variables



## [var-expansion-command](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/expansion.go#L85)

Make sure a container's commands can be set using an
expansion of environment variables.



## [var-expansion-arg](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/expansion.go#L120)

Make sure a container's args can be set using an
expansion of environment variables.



## [volume-hostpath-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/host_path.go#L48)

For a Pod created with a 'HostPath' Volume, ensure the
volume is a directory with 0777 unix file permissions and that is has
the sticky bit (mode flag t) set.



## [kubelet-managed-etc-hosts](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/kubelet_etc_hosts.go#L58)

Make sure Kubelet correctly manages /etc/hosts and mounts
it into the container.



## [networking-intra-pod-http](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/networking.go#L38)

Try to hit all endpoints through a test container, retry 5 times,
expect exactly one unique hostname. Each of these endpoints reports
its own hostname.

Try to hit test endpoints from a test container and make
sure each of them can report a unique hostname.



## [networking-intra-pod-udp](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/networking.go#L50)

Try to hit test endpoints from a test container using udp
and make sure each of them can report a unique hostname.



## [networking-node-pod-http](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/networking.go#L62)

Try to hit test endpoints from the pod and make sure each
of them can report a unique hostname.



## [networking-node-pod-udp](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/networking.go#L74)

Try to hit test endpoints from the pod using udp and make sure
each of them can report a unique hostname.



## [pods-created-pod-assigned-hostip](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/pods.go#L136)

Make sure when a pod is created that it is assigned a host IP
Address.



## [pods-submitted-removed](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/pods.go#L158)

Makes sure a pod is created, a watch can be setup for the pod,
pod creation was observed, pod is deleted, and pod deletion is observed.



## [pods-updated-successfully](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/pods.go#L283)

Make sure it is possible to successfully update a pod's labels.



## [pods-update-active-deadline-seconds](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/pods.go#L338)

Make sure it is possible to create a pod, update its
activeDeadlineSecondsValue, and then waits for the deadline to pass
and verifies the pod is terminated.



## [pods-contain-services-environment-variables](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/pods.go#L384)

Make sure that when a pod is created it contains environment
variables for each active service.



## [projected-secret-no-defaultMode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L42)

Simple projected Secret test with no defaultMode set.



## [projected-secret-with-defaultMode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L50)

Simple projected Secret test with defaultMode set.



## [projected-secret-with-nonroot-defaultMode-fsGroup](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L60)

Simple projected Secret test as non-root with
defaultMode and fsGroup set.



## [projected-secret-simple-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L73)

Simple projected Secret test, by setting a secret and
mounting it to a volume with a custom path (mapping) on the pod with
no other settings and make sure the pod actually consumes it.



## [projected-secret-with-item-mode-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L82)

Repeat the projected-secret-simple-mapped but this time
with an item mode (e.g. 0400) for the secret map item.



## [projected-secret-multiple-volumes](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L113)

Make sure secrets works when mounted as two different
volumes on the same node.



## [projected-secret-simple-optional](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L206)

Make sure secrets works when optional updates included.



## [projected-volume-configMap-nomappings-succeeds](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L408)

Part 2/3 - ConfigMaps

Make sure that a projected volume with a configMap with
no mappings succeeds properly.



## [projected-volume-configMap-consumable-defaultMode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L417)

Make sure that a projected volume configMap is consumable
with defaultMode set.



## [projected-volume-configMap-consumable-nonroot](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L432)

Make sure that a projected volume configMap is consumable
by a non-root userID.



## [projected-configmap-simple-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L446)

Simplest projected ConfigMap test, by setting a config
map and mounting it to a volume with a custom path (mapping) on the
pod with no other settings and make sure the pod actually consumes it.



## [projected-secret-with-item-mode-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L455)

Repeat the projected-secret-simple-mapped but this time
with an item mode (e.g. 0400) for the secret map item



## [projected-configmap-simpler-user-mapped](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L465)

Repeat the projected-config-map-simple-mapped but this
time with a user other than root.



## [projected-volume-configMaps-updated-successfully](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L479)

Make sure that if a projected volume has configMaps,
that the values in these configMaps can be updated, deleted,
and created.



## [projected-volume-optional-configMaps-updated-successfully](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L568)

Make sure that if a projected volume has optional
configMaps, that the values in these configMaps can be updated,
deleted, and created.



## [projected-configmap-multiple-volumes](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L769)

Make sure config map works when it mounted as two
different volumes on the same node.



## [projected-downwardapi-volume-podname](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L867)

Ensure that downward API can provide pod's name through
DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-set-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L882)

Ensure that downward API can set default file permission
mode for DownwardAPIVolumeFiles if no mode is specified in a projected
volume.



## [projected-downwardapi-volume-set-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L897)

Ensure that downward API can set file permission mode for
DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-update-label](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L942)

Ensure that downward API updates labels in
DownwardAPIVolumeFiles when pod's labels get modified in a projected
volume.



## [projected-downwardapi-volume-update-annotation](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L975)

Ensure that downward API updates annotations in
DownwardAPIVolumeFiles when pod's annotations get modified in a
projected volume.



## [projected-downwardapi-volume-cpu-limit](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L1009)

Ensure that downward API can provide container's CPU
limit through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-memory-limit](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L1023)

Ensure that downward API can provide container's memory
limit through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-cpu-request](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L1037)

Ensure that downward API can provide container's CPU
request through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-memory-request](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L1051)

Ensure that downward API can provide container's memory
request through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-default-cpu](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L1066)

Ensure that downward API can provide default node
allocatable value for CPU through DownwardAPIVolumeFiles if CPU limit
is not specified for a container in a projected volume.



## [projected-downwardapi-volume-default-memory](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L1079)

Ensure that downward API can provide default node
allocatable value for memory through DownwardAPIVolumeFiles if memory
limit is not specified for a container in a projected volume.



## [projected-configmap-secret-same-dir](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/projected.go#L1092)

Test multiple projections

This test projects a secret and configmap into the same
directory to ensure projection is working as intended.



## [secret-env-vars](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets.go#L38)

Ensure that secret can be consumed via environment
variables.



## [secret-configmaps-source](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets.go#L87)

Ensure that secret can be consumed via source of a set
of ConfigMaps.



## [secret-volume-mount-without-mapping](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets_volume.go#L41)

Ensure that secret can be mounted without mapping to a
pod volume.



## [secret-volume-mount-without-mapping-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets_volume.go#L50)

Ensure that secret can be mounted without mapping to a
pod volume in default mode.



## [secret-volume-mount-without-mapping-non-root-default-mode-fsgroup](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets_volume.go#L60)

Ensure that secret can be mounted without mapping to a pod
volume as non-root in default mode with fsGroup set.



## [secret-volume-mount-with-mapping](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets_volume.go#L72)

Ensure that secret can be mounted with mapping to a pod
volume.



## [secret-volume-mount-with-mapping-item-mode](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets_volume.go#L81)

Ensure that secret can be mounted with mapping to a pod
volume in item mode.



## [secret-multiple-volume-mounts](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets_volume.go#L111)

Ensure that secret can be mounted to multiple pod volumes.



## [secret-mounted-volume-optional-update-change](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/common/secrets_volume.go#L189)

Ensure that optional update change to secret can be
reflected on a mounted volume.



## [Kubectl, replication controller](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L274)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2.



## [Kubectl, scale replication controller](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L287)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Update the replicaset to 1. Number of running instances of the Pod MUST be 1. Update the replicaset to 2. Number of running instances of the Pod MUST be 2.



## [Kubectl, rolling update replication controller](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L306)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Run a rolling update to run a different version of the container. All running instances SHOULD now be running the newer version of the container as part of the rolling update.



## [Kubectl, guestbook application](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L338)

Release : v1.9
Create Guestbook application that contains redis server, 2 instances of redis slave, frontend application, frontend service and redis master service and redis slave service. Using frontend service, the test will write an entry into the guestbook application which will store the entry into the backend redis database. Application flow MUST work as expected and the data written MUST be available to read.



## [Kubectl, check version v1](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L705)

Release : v1.9
Run kubectl to get api versions, output MUST contain returned versions with ‘v1’ listed.



## [Kubectl, cluster info](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L801)

Release : v1.9
Call kubectl to get cluster-info, output MUST contain cluster-info returned and Kubernetes Master SHOULD be running.



## [Kubectl, describe pod or rc](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L823)

Release : v1.9
Deploy a redis controller and a redis service. Kubectl describe pods SHOULD return the name, namespace, labels, state and other information as expected. Kubectl describe on rc, service, node and namespace SHOULD also return proper information.



## [Kubectl, create service, replication controller](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L931)

Release : v1.9
Create a Pod running redis master listening to port 6379. Using kubectl expose the redis master  replication controllers at port 1234. Validate that the replication controller is listening on port 1234 and the target port is set to 6379, port that redis master is listening. Using kubectl expose the redis master as a service at port 2345. The service MUST be listening on port 2345 and the target port is set to 6379, port that redis master is listening.



## [Kubectl, label update](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1027)

Release : v1.9
When a Pod is running, update a Label using ‘kubectl label’ command. The label MUST be created in the Pod. A ‘kubectl get pod’ with -l option on the container MUST verify that the label can be read back. Use ‘kubectl label label-’ to remove the label. Kubetctl get pod’ with -l option SHOULD no list the deleted label as the label is removed.



## [Kubectl, logs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1073)

Release : v1.9
When a Pod is running then it MUST generate logs.
Starting a Pod should have a log line indicating the the server is running and ready to accept connections. 			   Also log command options MUST work as expected and described below.
‘kubectl log -tail=1’ should generate a output of one line, the last line in the log.
‘kubectl --limit-bytes=1’ should generate a single byte output.
‘kubectl --tail=1 --timestamp should genrate one line with timestamp in RFC3339 format
‘kubectl --since=1s’ should output logs that are only 1 second older from now
‘kubectl --since=24h’ should output logs that are only 1 day older from now



## [Kubectl, patch to annotate](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1129)

Release : v1.9
Start running a redis master and a replication controller. When the pod is running, using ‘kubectl patch’ command add annotations. The annotation MUST be added to running pods and SHOULD be able to read added annotations from each of the Pods running under the replication controller.



## [Kubectl, version](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1163)

Release : v1.9
The command ‘kubectl version’ MUST return the major, minor versions,  GitCommit, etc of the the Client and the Server that the kubectl is configured to connect to.



## [Kubectl, run default](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1195)

Release : v1.9
Command ‘kubectl run’ MUST create a running pod with possible replicas given a image using the option --image=’nginx’. The running Pod SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command.



## [Kubectl, run rc](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1230)

Release : v1.9
Command ‘kubectl run’ MUST create a running rc with default one replicas given a image using the option --image=’nginx’. The running replication controller SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command. Also there MUST be 1 pod controlled by this replica set running 1 container with the image specified. A ‘kubetctl logs’ command MUST return the logs from the container in the replication controller.



## [Kubectl, rolling update](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1291)

Release : v1.9
Command ‘kubectl rolling-update’ MUST replace the specified replication controller with a new replication controller by updating one pod at a time to use the new Pod spec.



## [Kubectl, run deployment](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1340)

Release : v1.9
Command ‘kubectl run’ MUST create a job, with --generator=deployment, when a image name is specified in the run command. After the run command there SHOULD be a deployment that should exist with one container running the specified image. Also there SHOULD be a Pod that is controlled by this deployment, with a container running the specified image.



## [Kubectl, run job](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1385)

Release : v1.9
Command ‘kubectl run’ MUST create a deployment, with --generator=job, when a image name is specified in the run command. After the run command there SHOULD be a job that should exist with one container running the specified image. Also there SHOULD be a restart policy on the job spec that SHOULD match the command line.



## [Kubectl, run pod](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1458)

Release : v1.9
Command ‘kubectl run’ MUST create a pod, with --generator=run-pod, when a image name is specified in the run command. After the run command there SHOULD be a pod that should exist with one container running the specified image.



## [Kubectl, replace](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1494)

Release : v1.9
Command ‘kubectl replace’ on a existing Pod with a new spec MUST update the image of the container running in the Pod. A -f option to ‘kubectl replace’ SHOULD force to re-create the resource. The new Pod SHOULD have the container with new change to the image.



## [Kubectl, run job with --rm](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1535)

Release : v1.9
Start a job with a Pod using ‘kubectl run’ but specify --rm=true. Wait for the Pod to start running by verifying that there is output as expected. Now verify that the job has exited and cannot be found. With --rm=true option the job MUST start by running the image specified and then get deleted itself.



## [Kubectl, proxy port zero](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1565)

TODO: test proxy options (static, prefix, etc)

Release : v1.9
Start a proxy server on port zero by running ‘kubectl proxy’ with --port=0. Call the proxy server by requesting api versions from unix socket. The proxy server MUST provide at least one version string.



## [Kubectl, proxy socket](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/kubectl/kubectl.go#L1590)

Release : v1.9
Start a proxy server on by running ‘kubectl proxy’ with --unix-socket=<some path>. Call the proxy server by requesting api versions from  http://locahost:0/api. The proxy server MUST provide atleast one version string



## [dns-for-clusters](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/dns.go#L43)

Make sure that DNS can resolve the names of clusters.



## [dns-for-services](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/dns.go#L73)

Make sure that DNS can resolve the names of services.



## [proxy-subresource-node-logs-port](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/proxy.go#L68)

Ensure that proxy on node logs works with node proxy
subresource and explicit kubelet port.



## [proxy-subresource-node-logs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/proxy.go#L75)

Ensure that proxy on node logs works with node proxy
subresource.



## [proxy-service-pod](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/proxy.go#L85)

Ensure that proxy through a service and a pod works with
both generic top level prefix proxy and proxy subresource.



## [service-kubernetes-exists](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/service.go#L106)

Make sure kubernetes service does exist.



## [service-valid-endpoints](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/service.go#L116)

Ensure a service with no pod, one pod or two pods has
valid/accessible endpoints (same port number for service and pods).



## [service-valid-endpoints-multiple-ports](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/service.go#L173)

Ensure a service with no pod, one pod or two pods has
valid/accessible endpoints (different port number for pods).



## [service-endpoint-latency](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/network/service_latency.go#L55)

Ensure service endpoint's latency is not high
(e.g. p50 < 20 seconds and p99 < 50 seconds). If any call to the
service endpoint fails, the test will also fail.



## [Events should be sent by kubelets and the scheduler about pods scheduling and running](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/node/events.go#L39)




## [Delete Grace Period should be submitted and removed](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/node/pods.go#L50)

Flaky issue #36821.



## [Pods Set QOS Class should be submitted and removed](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/node/pods.go#L202)




## [pods-prestop-handler-invoked](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/node/pre_stop.go#L169)

Makes sure a pod's preStop handler is successfully
invoked immediately before a container is terminated.



## [scheduler-resource-limits](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/scheduling/predicates.go#L245)

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

Ensure that scheduler accounts node resources correctly
and respects pods' resource requirements during scheduling.



## [scheduler-node-selector-not-matching](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/scheduling/predicates.go#L351)

Test Nodes does not have any label, hence it should be impossible to schedule Pod with
nonempty Selector set.

Ensure that scheduler respects the NodeSelector field of
PodSpec during scheduling (when it does not match any node).



## [scheduler-node-selector-matching](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e/scheduling/predicates.go#L374)

Ensure that scheduler respects the NodeSelector field
of PodSpec during scheduling (when it matches).



## [Kubelet when scheduling a busybox command in a pod it should print the output to logs](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/kubelet_test.go#L42)




## [Kubelet when scheduling a read only busybox container it should not write to root filesystem](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/kubelet_test.go#L167)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute poststart exec hook properly](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/lifecycle_hook_test.go#L87)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute prestop exec hook properly](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/lifecycle_hook_test.go#L98)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute poststart http hook properly](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/lifecycle_hook_test.go#L109)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute prestop http hook properly](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/lifecycle_hook_test.go#L122)




## [MirrorPod when create a mirror pod  should be updated when static pod updated](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/mirror_pod_test.go#L60)




## [MirrorPod when create a mirror pod  should be recreated when mirror pod gracefully deleted](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/mirror_pod_test.go#L82)




## [MirrorPod when create a mirror pod  should be recreated when mirror pod forcibly deleted](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/mirror_pod_test.go#L97)




## [container runtime conformance blackbox test when starting a container that exits it should run with the expected status](https://github.com/kubernetes/kubernetes/tree/v1.11.0/test/e2e_node/runtime_conformance_test.go#L49)





## **Summary**

Total Conformance Tests: 177, total legacy tests that need conversion: 0, while total tests that need comment sections: 14

