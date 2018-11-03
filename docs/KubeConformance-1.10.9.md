# Kubernetes Conformance Test Suite - v1.10.9

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


## [crd-creation-test](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/custom_resource_definition.go#L41)

Create a random Custom Resource Definition and make sure
the API returns success.



## [garbage-collector-delete-rc--propagation-background](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/garbage_collector.go#L335)

Ensure that if deleteOptions.PropagationPolicy is set to Background,
then deleting a ReplicationController should cause pods created
by that RC to also be deleted.



## [garbage-collector-delete-rc--propagation-orphan](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/garbage_collector.go#L394)

Ensure that if deleteOptions.PropagationPolicy is set to Orphan,
then deleting a ReplicationController should cause pods created
by that RC to be orphaned.



## [garbage-collector-delete-deployment-propagation-background](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/garbage_collector.go#L518)

Ensure that if deleteOptions.PropagationPolicy is set to Background,
then deleting a Deployment should cause ReplicaSets created
by that Deployment to also be deleted.



## [garbage-collector-delete-deployment-propagation-true](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/garbage_collector.go#L575)

Ensure that if deleteOptions.PropagationPolicy is set to Orphan,
then deleting a Deployment should cause ReplicaSets created
by that Deployment to be orphaned.



## [garbage-collector-delete-rc-after-owned-pods](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/garbage_collector.go#L645)

Ensure that if deleteOptions.PropagationPolicy is set to Foreground,
then a ReplicationController should not be deleted until all its dependent pods are deleted.



## [garbage-collector-multiple-owners](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/garbage_collector.go#L734)

TODO: this should be an integration test

Ensure that if a Pod has multiple valid owners, it will not be deleted
when one of of those owners gets deleted.



## [garbage-collector-dependency-cycle](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apimachinery/garbage_collector.go#L850)

TODO: should be an integration test

Ensure that a dependency cycle will
not block the garbage collector.



## [DaemonSet-Creation](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/daemon_set.go#L116)

A conformant Kubernetes distribution MUST support the creation of DaemonSets. When a DaemonSet
Pod is deleted, the DaemonSet controller MUST create a replacement Pod.



## [DaemonSet-NodeSelection](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/daemon_set.go#L143)

A conformant Kubernetes distribution MUST support DaemonSet Pod node selection via label
selectors.



## [DaemonSet-FailedPodCreation](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/daemon_set.go#L242)

A conformant Kubernetes distribution MUST create new DaemonSet Pods when they fail.



## [DaemonSet-RollingUpdate](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/daemon_set.go#L321)

A conformant Kubernetes distribution MUST support DaemonSet RollingUpdates.



## [DaemonSet-Rollback](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/daemon_set.go#L371)

A conformant Kubernetes distribution MUST support automated, minimally disruptive
rollback of updates to a DaemonSet.



## [ReplicationController should serve a basic image on each replica with a public image ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/rc.go#L41)




## [ReplicaSet should serve a basic image on each replica with a public image ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/replica_set.go#L81)




## [StatefulSet-RollingUpdate](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/statefulset.go#L259)

StatefulSet MUST support the RollingUpdate strategy to automatically replace Pods
one at a time when the Pod template changes. The StatefulSet's status MUST indicate the
CurrentRevision and UpdateRevision. If the template is changed to match a prior revision,
StatefulSet MUST detect this as a rollback instead of creating a new revision.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-RollingUpdatePartition](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/statefulset.go#L381)

StatefulSet's RollingUpdate strategy MUST support the Partition parameter for
canaries and phased rollouts. If a Pod is deleted while a rolling update is in progress,
StatefulSet MUST restore the Pod without violating the Partition.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-Scaling](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/statefulset.go#L679)

StatefulSet MUST create Pods in ascending order by ordinal index when scaling up,
and delete Pods in descending order when scaling down. Scaling up or down MUST pause if any
Pods belonging to the StatefulSet are unhealthy.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-BurstScaling](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/statefulset.go#L760)

StatefulSet MUST support the Parallel PodManagementPolicy for burst scaling.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-RecreateFailedPod](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/apps/statefulset.go#L804)

StatefulSet MUST delete and recreate Pods it owns that go into a Failed state,
such as when they are rejected or evicted by a Node.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [ServiceAccounts should mount an API token into pods ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/auth/service_accounts.go#L156)




## [ServiceAccounts should allow opting out of API token automount ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/auth/service_accounts.go#L238)




## [configmap-in-env-field](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap.go#L37)

Make sure config map value can be used as an environment
variable in the container (on container.env field)



## [configmap-envfrom-field](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap.go#L85)

Make sure config map value can be used as an source for
environment variables in the container (on container.envFrom field)



## [configmap-nomap-simple](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L40)

Make sure config map without mappings works by mounting it
to a volume with a custom path (mapping) on the pod with no other settings.



## [configmap-nomap-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L49)

Make sure config map without mappings works by mounting it
to a volume with a custom path (mapping) on the pod with defaultMode set



## [configmap-nomap-user](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L64)

Make sure config map without mappings works by mounting it
to a volume with a custom path (mapping) on the pod as non-root.



## [configmap-simple-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L78)

Make sure config map works by mounting it to a volume with
a custom path (mapping) on the pod with no other settings and make sure
the pod actually consumes it.



## [configmap-with-item-mode-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L87)

Make sure config map works with an item mode (e.g. 0400)
for the config map item.



## [configmap-simple-user-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L96)

Make sure config map works when it is mounted as non-root.



## [configmap-update-test](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L109)

Make sure update operation is working on config map and
the result is observed on volumes mounted in containers.



## [configmap-CUD-test](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L283)

Make sure Create, Update, Delete operations are all working
on config map and the result is observed on volumes mounted in containers.



## [configmap-multiple-volumes](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/configmap_volume.go#L466)

Make sure config map works when it mounted as two different
volumes on the same node.



## [pods-readiness-probe-initial-delay](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L57)

Make sure that pod with readiness probe should not be
ready before initial delay and never restart.



## [pods-readiness-probe-failure](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L89)

Make sure that pod with readiness probe that fails should
never be ready and never restart.



## [pods-cat-liveness-probe-restarted](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L114)

Make sure the pod is restarted with a cat /tmp/health
liveness probe.



## [pods-cat-liveness-probe-not-restarted](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L146)

Make sure the pod is not restarted with a cat /tmp/health
liveness probe.



## [pods-http-liveness-probe-restarted](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L178)

Make sure when http liveness probe fails, the pod should
be restarted.



## [pods-restart-count](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L212)

Slow by design (5 min)

Make sure when a pod gets restarted, its start count
should increase.



## [pods-http-liveness-probe-not-restarted](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L245)

Make sure when http liveness probe succeeds, the pod
should not be restarted.



## [pods-docker-liveness-probe-timeout](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/container_probe.go#L279)

Make sure that the pod is restarted with a docker exec
liveness probe with timeout.



## [container-without-command-args](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/docker_containers.go#L36)

When a Pod is created neither 'command' nor 'args' are
provided for a Container, ensure that the docker image's default
command and args are used.



## [container-with-args](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/docker_containers.go#L48)

When a Pod is created and 'args' are provided for a
Container, ensure that they take precedent to the docker image's
default arguments, but that the default command is used.



## [container-with-command](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/docker_containers.go#L65)

Note: when you override the entrypoint, the image's arguments (docker cmd)
are ignored.

When a Pod is created and 'command' is provided for a
Container, ensure that it takes precedent to the docker image's default
command.



## [container-with-command-args](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/docker_containers.go#L80)

When a Pod is created and 'command' and 'args' are
provided for a Container, ensure that they take precedent to the docker
image's default command and arguments.



## [downwardapi-env-name-namespace-podip](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downward_api.go#L45)

Ensure that downward API can provide pod's name, namespace
and IP address as environment variables.



## [downwardapi-env-host-ip](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downward_api.go#L91)

Ensure that downward API can provide an IP address for
host node as an environment variable.



## [downwardapi-env-limits-requests](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downward_api.go#L118)

Ensure that downward API can provide CPU/memory limit
and CPU/memory request as environment variables.



## [downwardapi-env-default-allocatable](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downward_api.go#L170)

Ensure that downward API can provide default node
allocatable values for CPU and memory as environment variables if CPU
and memory limits are not specified for a container.



## [downwardapi-env-pod-uid](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downward_api.go#L220)

Ensure that downward API can provide pod UID as an
environment variable.



## [downwardapi-volume-podname](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L47)

Ensure that downward API can provide pod's name through
DownwardAPIVolumeFiles.



## [downwardapi-volume-set-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L61)

Ensure that downward API can set default file permission
mode for DownwardAPIVolumeFiles if no mode is specified.



## [downwardapi-volume-set-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L76)

Ensure that downward API can set file permission mode for
DownwardAPIVolumeFiles.



## [downwardapi-volume-update-label](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L120)

Ensure that downward API updates labels in
DownwardAPIVolumeFiles when pod's labels get modified.



## [downwardapi-volume-update-annotation](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L152)

Ensure that downward API updates annotations in
DownwardAPIVolumeFiles when pod's annotations get modified.



## [downwardapi-volume-cpu-limit](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L186)

Ensure that downward API can provide container's CPU limit
through DownwardAPIVolumeFiles.



## [downwardapi-volume-memory-limit](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L200)

Ensure that downward API can provide container's memory
limit through DownwardAPIVolumeFiles.



## [downwardapi-volume-cpu-request](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L214)

Ensure that downward API can provide container's CPU
request through DownwardAPIVolumeFiles.



## [downwardapi-volume-memory-request](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L228)

Ensure that downward API can provide container's memory
request through DownwardAPIVolumeFiles.



## [downwardapi-volume-default-cpu](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L243)

Ensure that downward API can provide default node
allocatable value for CPU through DownwardAPIVolumeFiles if CPU
limit is not specified for a container.



## [downwardapi-volume-default-memory](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/downwardapi_volume.go#L256)

Ensure that downward API can provide default node
allocatable value for memory through DownwardAPIVolumeFiles if memory
limit is not specified for a container.



## [volume-emptydir-mode-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L76)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure the volume has 0777 unix file permissions and tmpfs
mount type.



## [volume-emptydir-root-0644-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L86)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a root owned file with 0644 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-root-0666-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L96)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a root owned file with 0666 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-root-0777-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L106)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a root owned file with 0777 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-user-0644-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L116)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a user owned file with 0644 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-user-0666-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L126)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a user owned file with 0666 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-user-0777-tmpfs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L136)

For a Pod created with an 'emptyDir' Volume with 'medium'
of 'Memory', ensure a user owned file with 0777 unix file permissions
is created correctly, has tmpfs mount type, and enforces the permissions.



## [volume-emptydir-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L145)

For a Pod created with an 'emptyDir' Volume, ensure the
volume has 0777 unix file permissions.



## [volume-emptydir-root-0644](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L155)

For a Pod created with an 'emptyDir' Volume, ensure a
root owned file with 0644 unix file permissions is created and enforced
correctly.



## [volume-emptydir-root-0666](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L165)

For a Pod created with an 'emptyDir' Volume, ensure a
root owned file with 0666 unix file permissions is created and enforced
correctly.



## [volume-emptydir-root-0777](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L175)

For a Pod created with an 'emptyDir' Volume, ensure a
root owned file with 0777 unix file permissions is created and enforced
correctly.



## [volume-emptydir-user-0644](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L185)

For a Pod created with an 'emptyDir' Volume, ensure a
user owned file with 0644 unix file permissions is created and enforced
correctly.



## [volume-emptydir-user-0666](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L195)

For a Pod created with an 'emptyDir' Volume, ensure a
user owned file with 0666 unix file permissions is created and enforced
correctly.



## [volume-emptydir-user-0777](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/empty_dir.go#L205)

For a Pod created with an 'emptyDir' Volume, ensure a
user owned file with 0777 unix file permissions is created and enforced
correctly.



## [var-expansion-env](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/expansion.go#L37)

Make sure environment variables can be set using an
expansion of previously defined environment variables



## [var-expansion-command](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/expansion.go#L82)

Make sure a container's commands can be set using an
expansion of environment variables.



## [var-expansion-arg](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/expansion.go#L117)

Make sure a container's args can be set using an
expansion of environment variables.



## [volume-hostpath-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/host_path.go#L49)

For a Pod created with a 'HostPath' Volume, ensure the
volume is a directory with 0777 unix file permissions and that is has
the sticky bit (mode flag t) set.



## [kubelet-managed-etc-hosts](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/kubelet_etc_hosts.go#L58)

Make sure Kubelet correctly manages /etc/hosts and mounts
it into the container.



## [networking-intra-pod-http](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/networking.go#L38)

Try to hit all endpoints through a test container, retry 5 times,
expect exactly one unique hostname. Each of these endpoints reports
its own hostname.

Try to hit test endpoints from a test container and make
sure each of them can report a unique hostname.



## [networking-intra-pod-udp](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/networking.go#L50)

Try to hit test endpoints from a test container using udp
and make sure each of them can report a unique hostname.



## [networking-node-pod-http](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/networking.go#L62)

Try to hit test endpoints from the pod and make sure each
of them can report a unique hostname.



## [networking-node-pod-udp](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/networking.go#L74)

Try to hit test endpoints from the pod using udp and make sure
each of them can report a unique hostname.



## [pods-created-pod-assigned-hostip](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/pods.go#L136)

Make sure when a pod is created that it is assigned a host IP
Address.



## [pods-submitted-removed](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/pods.go#L158)

Makes sure a pod is created, a watch can be setup for the pod,
pod creation was observed, pod is deleted, and pod deletion is observed.



## [pods-updated-successfully](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/pods.go#L283)

Make sure it is possible to successfully update a pod's labels.



## [pods-update-active-deadline-seconds](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/pods.go#L338)

Make sure it is possible to create a pod, update its
activeDeadlineSecondsValue, and then waits for the deadline to pass
and verifies the pod is terminated.



## [pods-contain-services-environment-variables](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/pods.go#L384)

Make sure that when a pod is created it contains environment
variables for each active service.



## [projected-secret-no-defaultMode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L42)

Simple projected Secret test with no defaultMode set.



## [projected-secret-with-defaultMode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L50)

Simple projected Secret test with defaultMode set.



## [projected-secret-with-nonroot-defaultMode-fsGroup](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L60)

Simple projected Secret test as non-root with
defaultMode and fsGroup set.



## [projected-secret-simple-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L73)

Simple projected Secret test, by setting a secret and
mounting it to a volume with a custom path (mapping) on the pod with
no other settings and make sure the pod actually consumes it.



## [projected-secret-with-item-mode-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L82)

Repeat the projected-secret-simple-mapped but this time
with an item mode (e.g. 0400) for the secret map item.



## [projected-secret-multiple-volumes](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L113)

Make sure secrets works when mounted as two different
volumes on the same node.



## [projected-secret-simple-optional](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L206)

Make sure secrets works when optional updates included.



## [projected-volume-configMap-nomappings-succeeds](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L408)

Part 2/3 - ConfigMaps

Make sure that a projected volume with a configMap with
no mappings succeeds properly.



## [projected-volume-configMap-consumable-defaultMode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L417)

Make sure that a projected volume configMap is consumable
with defaultMode set.



## [projected-volume-configMap-consumable-nonroot](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L432)

Make sure that a projected volume configMap is consumable
by a non-root userID.



## [projected-configmap-simple-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L446)

Simplest projected ConfigMap test, by setting a config
map and mounting it to a volume with a custom path (mapping) on the
pod with no other settings and make sure the pod actually consumes it.



## [projected-secret-with-item-mode-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L455)

Repeat the projected-secret-simple-mapped but this time
with an item mode (e.g. 0400) for the secret map item



## [projected-configmap-simpler-user-mapped](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L465)

Repeat the projected-config-map-simple-mapped but this
time with a user other than root.



## [projected-volume-configMaps-updated-successfully](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L479)

Make sure that if a projected volume has configMaps,
that the values in these configMaps can be updated, deleted,
and created.



## [projected-volume-optional-configMaps-updated-successfully](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L568)

Make sure that if a projected volume has optional
configMaps, that the values in these configMaps can be updated,
deleted, and created.



## [projected-configmap-multiple-volumes](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L769)

Make sure config map works when it mounted as two
different volumes on the same node.



## [projected-downwardapi-volume-podname](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L867)

Ensure that downward API can provide pod's name through
DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-set-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L882)

Ensure that downward API can set default file permission
mode for DownwardAPIVolumeFiles if no mode is specified in a projected
volume.



## [projected-downwardapi-volume-set-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L897)

Ensure that downward API can set file permission mode for
DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-update-label](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L942)

Ensure that downward API updates labels in
DownwardAPIVolumeFiles when pod's labels get modified in a projected
volume.



## [projected-downwardapi-volume-update-annotation](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L975)

Ensure that downward API updates annotations in
DownwardAPIVolumeFiles when pod's annotations get modified in a
projected volume.



## [projected-downwardapi-volume-cpu-limit](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L1009)

Ensure that downward API can provide container's CPU
limit through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-memory-limit](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L1023)

Ensure that downward API can provide container's memory
limit through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-cpu-request](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L1037)

Ensure that downward API can provide container's CPU
request through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-memory-request](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L1051)

Ensure that downward API can provide container's memory
request through DownwardAPIVolumeFiles in a projected volume.



## [projected-downwardapi-volume-default-cpu](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L1066)

Ensure that downward API can provide default node
allocatable value for CPU through DownwardAPIVolumeFiles if CPU limit
is not specified for a container in a projected volume.



## [projected-downwardapi-volume-default-memory](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L1079)

Ensure that downward API can provide default node
allocatable value for memory through DownwardAPIVolumeFiles if memory
limit is not specified for a container in a projected volume.



## [projected-configmap-secret-same-dir](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/projected.go#L1092)

Test multiple projections

This test projects a secret and configmap into the same
directory to ensure projection is working as intended.



## [secret-env-vars](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets.go#L38)

Ensure that secret can be consumed via environment
variables.



## [secret-configmaps-source](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets.go#L87)

Ensure that secret can be consumed via source of a set
of ConfigMaps.



## [secret-volume-mount-without-mapping](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets_volume.go#L41)

Ensure that secret can be mounted without mapping to a
pod volume.



## [secret-volume-mount-without-mapping-default-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets_volume.go#L50)

Ensure that secret can be mounted without mapping to a
pod volume in default mode.



## [secret-volume-mount-without-mapping-non-root-default-mode-fsgroup](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets_volume.go#L60)

Ensure that secret can be mounted without mapping to a pod
volume as non-root in default mode with fsGroup set.



## [secret-volume-mount-with-mapping](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets_volume.go#L72)

Ensure that secret can be mounted with mapping to a pod
volume.



## [secret-volume-mount-with-mapping-item-mode](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets_volume.go#L81)

Ensure that secret can be mounted with mapping to a pod
volume in item mode.



## [secret-multiple-volume-mounts](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets_volume.go#L111)

Ensure that secret can be mounted to multiple pod volumes.



## [secret-mounted-volume-optional-update-change](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/common/secrets_volume.go#L189)

Ensure that optional update change to secret can be
reflected on a mounted volume.



## [Update Demo should create and stop a replication controller ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L269)




## [Update Demo should scale a replication controller ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L277)




## [Update Demo should do a rolling update of a replication controller ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L291)




## [Guestbook application should create and stop a working application ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L318)




## [Kubectl api-versions should check if v1 is in available api versions ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L682)




## [Kubectl cluster-info should check if Kubernetes master services is included in cluster-info ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L773)




## [Kubectl describe should check if kubectl describe prints relevant information for rc and pods ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L790)




## [Kubectl expose should create services for rc ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L893)




## [Kubectl label should update the label on a resource ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L984)




## [Kubectl logs should be able to retrieve and filter logs ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1019)




## [Kubectl patch should add annotations for pods in rc ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1070)




## [Kubectl version should check is all data is printed ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1099)




## [Kubectl run default should create an rc or deployment from an image ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1126)




## [Kubectl run rc should create an rc from an image ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1156)




## [Kubectl rolling-update should support rolling-update to same image ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1212)




## [Kubectl run deployment should create a deployment from an image ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1256)




## [Kubectl run job should create a job from an image when restart is OnFailure ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1296)




## [Kubectl run pod should create a pod from an image when restart is Never ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1364)




## [Kubectl replace should update a single-container pod's image ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1395)




## [Kubectl run --rm job should create a job from an image, then delete the job ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1431)




## [Proxy server should support proxy with --port 0 ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1459)

TODO: test proxy options (static, prefix, etc)



## [Proxy server should support --unix-socket=/path ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/kubectl/kubectl.go#L1479)




## [dns-for-clusters](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/dns.go#L43)

Make sure that DNS can resolve the names of clusters.



## [dns-for-services](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/dns.go#L73)

Make sure that DNS can resolve the names of services.



## [proxy-subresource-node-logs-port](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/proxy.go#L80)

Ensure that proxy on node logs works with node proxy
subresource and explicit kubelet port.



## [proxy-subresource-node-logs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/proxy.go#L87)

Ensure that proxy on node logs works with node proxy
subresource.



## [proxy-service-pod](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/proxy.go#L104)

Ensure that proxy through a service and a pod works with
both generic top level prefix proxy and proxy subresource.



## [service-kubernetes-exists](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/service.go#L76)

Make sure kubernetes service does exist.



## [service-valid-endpoints](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/service.go#L86)

Ensure a service with no pod, one pod or two pods has
valid/accessible endpoints (same port number for service and pods).



## [service-valid-endpoints-multiple-ports](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/service.go#L151)

Ensure a service with no pod, one pod or two pods has
valid/accessible endpoints (different port number for pods).



## [service-endpoint-latency](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/network/service_latency.go#L54)

Ensure service endpoint's latency is not high
(e.g. p50 < 20 seconds and p99 < 50 seconds). If any call to the
service endpoint fails, the test will also fail.



## [Events should be sent by kubelets and the scheduler about pods scheduling and running ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/node/events.go#L39)




## [Delete Grace Period should be submitted and removed  [Flaky]](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/node/pods.go#L50)

Flaky issue #36821.



## [Pods Set QOS Class should be submitted and removed ](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/node/pods.go#L202)




## [pods-prestop-handler-invoked](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/node/pre_stop.go#L169)

Makes sure a pod's preStop handler is successfully
invoked immediately before a container is terminated.



## [scheduler-resource-limits](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/scheduling/predicates.go#L244)

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



## [scheduler-node-selector-not-matching](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/scheduling/predicates.go#L350)

Test Nodes does not have any label, hence it should be impossible to schedule Pod with
nonempty Selector set.

Ensure that scheduler respects the NodeSelector field of
PodSpec during scheduling (when it does not match any node).



## [scheduler-node-selector-matching](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e/scheduling/predicates.go#L373)

Ensure that scheduler respects the NodeSelector field
of PodSpec during scheduling (when it matches).



## [Kubelet when scheduling a busybox command in a pod it should print the output to logs](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/kubelet_test.go#L42)




## [Kubelet when scheduling a read only busybox container it should not write to root filesystem](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/kubelet_test.go#L167)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute poststart exec hook properly](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/lifecycle_hook_test.go#L87)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute prestop exec hook properly](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/lifecycle_hook_test.go#L98)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute poststart http hook properly](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/lifecycle_hook_test.go#L109)




## [Container Lifecycle Hook when create a pod with lifecycle hook should execute prestop http hook properly](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/lifecycle_hook_test.go#L122)




## [MirrorPod when create a mirror pod  should be updated when static pod updated](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/mirror_pod_test.go#L60)




## [MirrorPod when create a mirror pod  should be recreated when mirror pod gracefully deleted](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/mirror_pod_test.go#L82)




## [MirrorPod when create a mirror pod  should be recreated when mirror pod forcibly deleted](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/mirror_pod_test.go#L97)




## [container runtime conformance blackbox test when starting a container that exits it should run with the expected status](https://github.com/kubernetes/kubernetes/tree/v1.10.9/test/e2e_node/runtime_conformance_test.go#L49)





## **Summary**

Total Conformance Tests: 174, total legacy tests that need conversion: 0, while total tests that need comment sections: 37

