# Kubernetes Conformance Test Suite - v1.10

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
## [Kubelet-OutputToLogs](https://github.com/kubernetes/kubernetes/kubernetes/blob/release-1.9/test/e2e_node/kubelet_test.go#L42)

By default the stdout and stderr from the process
being executed in a pod MUST be sent to the pod's logs.
Note this test needs to be fixed to also test for stderr

Notational Conventions when documenting the tests with the key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

Note: Please see the Summary at the end of this document to find the number of tests documented for conformance.

## **List of Tests**


## [Customer Resource Definition, create](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/custom_resource_definition.go#L41)

Release : v1.9
Create a API extension client, define a random custom resource definition, create the custom resource. API server MUST be able to create the customer resource.



## [garbage-collector-delete-rc--propagation-background](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/garbage_collector.go#L335)

Ensure that if deleteOptions.PropagationPolicy is set to Background,
then deleting a ReplicationController should cause pods created
by that RC to also be deleted.



## [garbage-collector-delete-rc--propagation-orphan](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/garbage_collector.go#L394)

Ensure that if deleteOptions.PropagationPolicy is set to Orphan,
then deleting a ReplicationController should cause pods created
by that RC to be orphaned.



## [garbage-collector-delete-deployment-propagation-background](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/garbage_collector.go#L518)

Ensure that if deleteOptions.PropagationPolicy is set to Background,
then deleting a Deployment should cause ReplicaSets created
by that Deployment to also be deleted.



## [garbage-collector-delete-deployment-propagation-true](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/garbage_collector.go#L575)

Ensure that if deleteOptions.PropagationPolicy is set to Orphan,
then deleting a Deployment should cause ReplicaSets created
by that Deployment to be orphaned.



## [garbage-collector-delete-rc-after-owned-pods](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/garbage_collector.go#L645)

Ensure that if deleteOptions.PropagationPolicy is set to Foreground,
then a ReplicationController should not be deleted until all its dependent pods are deleted.



## [garbage-collector-multiple-owners](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/garbage_collector.go#L734)

TODO: this should be an integration test

Ensure that if a Pod has multiple valid owners, it will not be deleted
when one of of those owners gets deleted.



## [garbage-collector-dependency-cycle](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apimachinery/garbage_collector.go#L850)

TODO: should be an integration test

Ensure that a dependency cycle will
not block the garbage collector.



## [Replication Controller, run basic image](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apps/rc.go#L46)

Release : v1.9
Replication Controller MUST create a Pod with Basic Image and MUST run the service with the provided image. Image MUST be tested by dialing into the service listening through TCP, UDP and HTTP.



## [Replica Set, run basic image](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apps/replica_set.go#L86)

Release : v1.9
Create a ReplicaSet with a Pod and a single Container. Make sure that the Pod is running. Pod SHOULD send a valid response when queried.



## [StatefulSet-RollingUpdate](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apps/statefulset.go#L259)

StatefulSet MUST support the RollingUpdate strategy to automatically replace Pods
one at a time when the Pod template changes. The StatefulSet's status MUST indicate the
CurrentRevision and UpdateRevision. If the template is changed to match a prior revision,
StatefulSet MUST detect this as a rollback instead of creating a new revision.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-RollingUpdatePartition](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apps/statefulset.go#L381)

StatefulSet's RollingUpdate strategy MUST support the Partition parameter for
canaries and phased rollouts. If a Pod is deleted while a rolling update is in progress,
StatefulSet MUST restore the Pod without violating the Partition.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-Scaling](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apps/statefulset.go#L679)

StatefulSet MUST create Pods in ascending order by ordinal index when scaling up,
and delete Pods in descending order when scaling down. Scaling up or down MUST pause if any
Pods belonging to the StatefulSet are unhealthy.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-BurstScaling](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apps/statefulset.go#L760)

StatefulSet MUST support the Parallel PodManagementPolicy for burst scaling.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet-RecreateFailedPod](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/apps/statefulset.go#L804)

StatefulSet MUST delete and recreate Pods it owns that go into a Failed state,
such as when they are rejected or evicted by a Node.
This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [Service Account Tokens Must AutoMount](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/auth/service_accounts.go#L156)

Release : v1.9
Ensure that Service Account keys are  mounted into the Pod. Pod contains three containers each will read Service Account Key, root CA Key and Namespace Key respectively from the default API Token Mount path. All these three files MUST exist and the Service Account mount path MUST be auto mounted to the Pod.



## [Service account tokens auto mount optionally](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/auth/service_accounts.go#L238)

Release : v1.9
Ensure that Service Account keys are  mounted into the Pod only when AutoMountServiceToken is not set to false. We test the following scenarios here.
1. Create Pod,  Pod Spec has  AutomountServiceAccountToken  set to nil
a) Service Account is default,
b) Service Account is an object with AutomountServiceAccountToken set to true,
c) Service Account is an object with  AutomountServiceAccountToken  set to false
2. Create Pod,  Pod Spec has  AutomountServiceAccountToken  set to true
a) Service Account is default,
b) Service Account is an object with AutomountServiceAccountToken set to true,
c) Service Account is an object with  AutomountServiceAccountToken  set to false
3. Create Pod,  Pod Spec has  AutomountServiceAccountToken  set to false
a) Service Account is default,
b) Service Account is an object with AutomountServiceAccountToken set to true,
c) Service Account is an object with  AutomountServiceAccountToken  set to false

The Containers running in these pods MUST verify that the ServiceTokenVolume path is auto mounted only when Pod Spec has AutomountServiceAccountToken not set to false and ServiceAccount object has AutomountServiceAccountToken not set to false, this include test cases 1a,1b,2a,2b and 2c. In the test cases 1c,3a,3b and 3c the ServiceTokenVolume MUST not be auto mounted.



## [ConfigMap to environment field](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap.go#L37)

Release : v1.9
Create a Pod with a environment variable value set using a value from configMap. A config map value MUST be accessible in a  container environment variable.



## [ConfigMap from environment variables](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap.go#L85)

Release: v1.9
Create a Pod with a environment source from configMap. All config map values MUST be available as environment variables in the container.



## [ConfigMap without mapping](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L40)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file SHOULD be readable and verified and file modes MUST default  to 0x644.



## [ConfigMap without mapping, volume mode set](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L49)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value of ‘0x400’



## [ConfigMap without mapping, non-root user](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L64)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount. The Pod SHOULD be run as a specific non root user with uid 1000, and the data content of the file SHOULD be readable and file modes MUST be set to default 0x644.



## [ConfigMap with mapped volume](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L78)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount. The Pod security context for the file system group id SHOULD be set to 1001. The Pod SHOULD be run as a specific non root user with uid=1000, and the data content of the file SHOULD be readable and verified and file modes MUST be set to default 0x644.



## [ConfigMap with mapped volume, volume mode set](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L87)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value set ‘0x400’.



## [ConfigMap with mapped volume, non-root user](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L96)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. The Pod is run as a specific non-root user with uid=1000 and the data content of the file SHOULD be readable and verified and file modes MUST be set to default 0x644.



## [ConfigMap update](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L109)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the config map is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod.



## [ConfigMap create, update and delete](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L283)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the config map is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod. Also when the item(file) is deleted from the map that SHOULD result in a error reading that item(file).



## [ConfigMap multiple volume maps](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/configmap_volume.go#L466)

Release : v1.9
The config map that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to multiple paths in the Pod. The content MUST be accessible from all the mapped volume mounts.



## [Pod readiness probe with initial delay](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L57)

Release : v1.9
Create a Pod that is configured with a initial delay set on the readiness probe. Check the Pod Start time to compare to the initial delay. The Pod MUST be ready only after the specified initial delay.



## [Pod readiness probe failure](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L89)

Release : v1.9
Pod is created with a readiness probe that fails consistently. When this Pod is created,
then the Pod SHOULD never be ready, never be running and restart count SHOULD be zero.



## [Pod liveness probe, cat, restart](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L114)

Release : v1.9
A Pod is created with liveness probe that that uses ‘exec’ command to cat /temp/health file. The Container deletes the file /temp/health after 10 second, triggering liveness probe to fail. The Pod SHOULD now be killed and restarted incrementing restart count to 1.



## [Pod liveness probe, cat, no restart](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L146)

Release : v1.9
Pod is created with liveness probe that uses ‘exec’ command to cat /temp/health file. Liveness probe MUST not fail to check health and the restart count should remain 0.



## [Pod liveness probe, http, restart](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L178)

Release : v1.9
A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod SHOULD now be killed and restarted incrementing restart count to 1.



## [Pod liveness,http,  multiple restarts (slow)](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L212)

Slow by design (5 min)

Release : v1.9
A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod SHOULD now be killed and restarted incrementing restart count to 1. The liveness probe must fail again after restart once the http handler for /healthz enpoind on the Pod returns an http error after 10 seconds from the start. Restart counts MUST increment everytime health check fails, measure upto 5 restart.



## [Pod liveness probe, http, failure](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L245)

Release : v1.9
A Pod is created with liveness probe on http endpoint ‘/’. Liveness probe on this endpoint will not fail. When liveness probe does not fail then the restart count MUST remain zero.



## [Pod liveness probe, docker exec, restart](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/container_probe.go#L279)

Release : v1.9
A Pod is created with liveness probe with a Exec action on the Pod. If the liveness probe call  does not return within the timeout specified, liveness probe SHOULD restart the Pod.



## [Docker container without command and arguments](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/docker_containers.go#L36)

Release : v1.9
Default command and arguments from the docker image entrypoint SHOULD be used when Pod does not specify the container command



## [Docker container with arguments](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/docker_containers.go#L48)

Release : v1.9
Default command and  from the docker image entrypoint SHOULD be used when Pod does not specify the container command but the arguments from Pod spec SHOULD override when specified.



## [Docker container with command](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/docker_containers.go#L65)

Note: when you override the entrypoint, the image's arguments (docker cmd)
are ignored.

Release : v1.9
Default command from the docker image entrypoint SHOULD NOT be used when Pod specifies the container command.  Command from Pod spec SHOULD override the command in the image.



## [Docker container with command and arguments](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/docker_containers.go#L80)

Release : v1.9
Default command and arguments from the docker image entrypoint SHOULD NOT be used when Pod specifies the container command and arguments.  Command and arguments from Pod spec SHOULD override the command and arguments in the image.



## [DownwardAPI environment for name, namespace and ip](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downward_api.go#L45)

Release : v1.9
Downward API MUST expose Pod and Container fields as environment variables. Specify Pod Name, namespace and IP as environment variable in the Pod Spec are visible at runtime in the container.



## [DownwardAPI environment for host ip](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downward_api.go#L91)

Release : v1.9
Downward API MUST expose Pod and Container fields as environment variables. Specify host IP as environment variable in the Pod Spec are visible at runtime in the container.



## [DownwardAPI environment for CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downward_api.go#L118)

Release : v1.9
Downward API MUST expose CPU request amd Memory request set through environment variables at runtime in the container.



## [DownwardAPI environment for default CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downward_api.go#L170)

Release : v1.9
Downward API MUST expose CPU request amd Memory limits set through environment variables at runtime in the container.



## [DownwardAPI aenvironment for Pod UID](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downward_api.go#L220)

Release : v1.9
Downward API MUST expose Pod UID set through environment variables at runtime in the container.



## [DownwardAPI volume, pod name](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L47)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.



## [DownwardAPI volume, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L61)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource with the volumesource mode set to -r-------- and DownwardAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.



## [DownwardAPI volume, file mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L76)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the Pod name with the file mode set to -r--------. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.



## [DownwardAPI volume, update label](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L120)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains list of items for each of the Pod labels. The container runtime MUST be able to access Pod labels from the specified path on the mounted volume. Update the labels by adding a new label to the running Pod. The new label MUST be available from the mounted volume.



## [DownwardAPI volume, update annotations](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L152)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains list of items for each of the Pod annotations. The container runtime MUST be able to access Pod annotations from the specified path on the mounted volume. Update the annotations by adding a new annotation to the running Pod. The new annotation MUST be available from the mounted volume.



## [DownwardAPI volume, CPU limits](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L186)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the CPU limits. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume.



## [DownwardAPI volume, memory limits](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L200)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the memory limits. The container runtime MUST be able to access memory limits from the specified path on the mounted volume.



## [DownwardAPI volume, CPU request](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L214)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the CPU request. The container runtime MUST be able to access CPU request from the specified path on the mounted volume.



## [DownwardAPI volume, memory request](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L228)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the memory request. The container runtime MUST be able to access memory request from the specified path on the mounted volume.



## [DownwardAPI volume, CPU limit, default node allocatable](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L243)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the CPU limits. CPU limits is not specified for the container. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume and the value MUST be default node allocatable.



## [DownwardAPI volume, memory limit, default node allocatable](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/downwardapi_volume.go#L256)

Release : v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwartAPIVolumeFiles contains a item for the memory limits. memory limits is not specified for the container. The container runtime MUST be able to access memory limits from the specified path on the mounted volume and the value MUST be default node allocatable.



## [EmptyDir, medium memory, volume mode default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L76)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs.



## [EmptyDir, medium memory, volume mode 0644](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L86)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0666](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L96)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0777](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L106)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0644, non-root user](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L116)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0666,, non-root user](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L126)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium memory, volume mode 0777, non-root user](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L136)

Release : v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L145)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs.



## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L155)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L165)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L175)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L185)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L195)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.



## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/empty_dir.go#L205)

Release : v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.



## [Environment variables, expansion](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/expansion.go#L37)

Release : v1.9
Create a Pod with environment variables. Environment variables defined using previously defined environment variables MUST expand to proper values.



## [Environment variables, command expansion](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/expansion.go#L82)

Release : v1.9
Create a Pod with environment variables and container command using them. Container command using the  defined environment variables MUST expand to proper values.



## [Environment variables, command argument expansion](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/expansion.go#L117)

Release : v1.9
Create a Pod with environment variables and container command arguments using them. Container command arguments using the  defined environment variables MUST expand to proper values.



## [Volume Host path, mode default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/host_path.go#L49)

Release : v1.9
Create a Pod with host volume mounted. The volume mounted MUST be a directory with permissions mode -rwxrwxrwx and that is has the sticky bit (mode flag t) set.



## [Kubelet managed etc hosts](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/kubelet_etc_hosts.go#L58)

Release : v1.9
Create a Pod with containers with hostNetwork set to false, one of the containers mounts the /etc/hosts file form the host. Create a second Pod with hostNetwork set to true.
1. The Pod with hostNetwork=false MUST have /etc/hosts of containers managed by the Kubelet.
2. The Pod with hostNetwork=false but the container mounts /etc/hosts file from the host. The /etc/hosts file SHOULD not be managed by the Kubelet.
3. The Pod with hostNetwork=true , /etc/hosts file SHOULD not be manages by the Kubelet.



## [Networking, intra pod http](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/networking.go#L38)

Try to hit all endpoints through a test container, retry 5 times,
expect exactly one unique hostname. Each of these endpoints reports
its own hostname.

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster and the request must be successful. Container will execute curl command to reach the service port within specified max retry limit and should result in reporting unique hostnames.



## [Networking, intra pod udp](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/networking.go#L50)

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a udp port on the each of service proxy endpoints in the cluster and the request must be successful. Container will execute curl command to reach the service port within specified max retry limit and should result in reporting unique hostnames.



## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/networking.go#L62)

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=tcp)  and the request must be successful. Container will execute curl command to reach the service port within specified max retry limit and should result in reporting unique hostnames.



## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/networking.go#L74)

Release : v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=udp)  and the request must be successful. Container will execute curl command to reach the service port within specified max retry limit and should result in reporting unique hostnames.



## [Pods, assigned hostip](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/pods.go#L136)

Release : v1.9
Create a Pod. Pod status MUST return successfully and contains a valid IP address.



## [Pods, lifecycle](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/pods.go#L158)

Release : v1.9
A Pod is created with a unique label. Pod SHOULD be accessible when queries using the label selector upon creation. Add a watch, check if the Pod is running. Pod then deleted, The pod deletion timestamp is observed. The watch MUST return the pod deleted event. Query with the original selector for the Pod MUST return empty list.



## [Pods, update](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/pods.go#L283)

Release : v1.9
Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. Update the pod to change the value of the Label. Query for the Pod with the new value for the label MUST be successful.



## [Pods, ActiveDeadlineSeconds](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/pods.go#L338)

Release : v1.9
Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. The Pod is updated with ActiveDeadlineSeconds set on the Pod spec. Pod MUST terminate of the specified time elapses.



## [Pods, service environment variables](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/pods.go#L384)

Make sure that when a pod is created it contains environment
variables for each active service.

Release : v1.9
Create a server Pod listening on port 9376. A Service called fooservice is created for the server Pod listening on port 8765 targeting port 8080. If a new Pod is created in the cluster then the Pod must have the fooservice environment variables available from this new Pod. The new create Pod MUST have environment variables such as FOOSERVICE_SERVICE_HOST, FOOSERVICE_SERVICE_PORT, FOOSERVICE_PORT, FOOSERVICE_PORT_8765_TCP_PORT, FOOSERVICE_PORT_8765_TCP_PROTO, FOOSERVICE_PORT_8765_TCP and FOOSERVICE_PORT_8765_TCP_ADDR that are populated with proper values.



## [Projected Volume, Secrets, volume mode default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L42)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with default permission mode. Pod MUST be able to read the content of the key successfully and the mode MUST be -rw-r--r-- by default.



## [Projected Volume, Secrets, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L50)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with permission mode set to 0x400 on the Pod. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————.



## [Project Volume, Secrets, non-root, custom fsGroup](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L60)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key. The volume has permission mode set to 0440, fsgroup set to 1001 and user set to non-root uid of 1000. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-r————-.



## [Projected Volume, Secrets, mapped](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L73)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with default permission mode. The secret is also mapped to a custom path. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————— on the mapped volume.



## [Projected Volume, Secrets, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L82)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with permission mode set to 0400. The secret is also mapped to a specific name. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————— on the mapped volume.



## [Projected Volume, Secrets, mapped, multiple paths](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L113)

Release : v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key. The secret is mapped to two different volume mounts. Pod MUST be able to read the content of the key successfully from the two volume mounts and the mode MUST be -r—-—————— on the mapped volumes.



## [Projected Volume, Secrets, create, update delete](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L206)

Release : v1.9
Create a Pod with three containers with secrets namely a create, update and delete container. Create Container when started MUST no have a secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.



## [Projected Volume, ConfigMap, volume mode default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L408)

Part 2/3 - ConfigMaps

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with default permission mode. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw-r—-r—-.



## [Projected Volume, ConfigMap, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L417)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with permission mode set to 0400. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -r——-——-—-.



## [Projected Volume, ConfigMap, non-root user](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L432)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap as non-root user with uid 1000. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw—r——r—-.



## [Projected Volume, ConfigMap, mapped](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L446)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with default permission mode. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -rw—r——r—-.



## [Projected Volume, ConfigMap, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L455)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with permission mode set to 0400. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r-—r——r—-.



## [Projected Volume, ConfigMap, mapped, non-root user](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L465)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap as non-root user with uid 1000. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r-—r——r—-.



## [Projected Volume, ConfigMap, update](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L479)

Release : v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap and performs a create and update to new value. Pod MUST be able to create the configMap with value-1. Pod MUST be able to update the value in the confgiMap to value-2.



## [Projected Volume, ConfigMap, create, update and delete](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L568)

Release : v1.9
Create a Pod with three containers with ConfigMaps namely a create, update and delete container. Create Container when started MUST not have configMap, update and delete containers MUST be created with a ConfigMap value as ‘value-1’. Create a configMap in the create container, the Pod MUST be able to read the configMap from the create container. Update the configMap in the update container, Pod MUST be able to read the updated configMap value. Delete the configMap in the delete container. Pod MUST fail to read the configMap from the delete container.



## [Projected Volume, ConfigMap, multiple volume paths](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L769)

Release : v1.9
A Pod is created with a projected volume source ‘ConfigMap’ to store a configMap. The configMap is mapped to two different volume mounts. Pod MUST be able to read the content of the configMap successfully from the two volume mounts.



## [Projected Volume, DownwardAPI, pod name](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L867)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L882)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r—-—————.



## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L897)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r—-—————.



## [Projected Volume, DownwardAPI, update labels](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L942)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and label items. Pod MUST be able to read the labels from the mounted DownwardAPIVolumeFiles. Labels are then updated. Pod MUST be able to read the updated values for the Labels.



## [Projected Volume, DownwardAPI, update annotation](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L975)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and annotation items. Pod MUST be able to read the annotations from the mounted DownwardAPIVolumeFiles. Annotations are then updated. Pod MUST be able to read the updated values for the Annotations.



## [Projected Volume, DownwardAPI, CPU limits](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L1009)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory limits](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L1023)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, CPU request](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L1037)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu request from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory request](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L1051)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory request from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, CPU limit, node allocatable](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L1066)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default cpu limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory limit, node allocatable](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L1079)

Release : v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default memory limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, multiple projections](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/projected.go#L1092)

Test multiple projections

Release : v1.9
A Pod is created with a projected volume source for secrets, configMap and downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the secrets, configMap values and the cpu and memory limits as well as cpu and memory requests from the mounted DownwardAPIVolumeFiles.



## [Secrets, pod environment field](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets.go#L38)

Release : v1.9
Create a secret. Create a Pod with Container that declares a environment variable which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.



## [Secrets, pod environment from source](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets.go#L87)

Release : v1.9
Create a secret. Create a Pod with Container that declares a environment variable using ‘EnvFrom’ which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.



## [Secrets Volume, default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets_volume.go#L41)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -rw-r--r-- by default.



## [Secrets Volume, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets_volume.go#L50)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r——--—-—- by default.



## [Secrets Volume, volume mode 0440, fsGroup 1001 and uid 1000](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets_volume.go#L60)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x440 as a non-root user with uid 1000 and fsGroup id 1001. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r——r-—-—- by default.



## [Secrets Volume, mapping](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets_volume.go#L72)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with a custom path. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -rw—r-—r—- by default.



## [Secrets Volume, mapping, volume mode 0400](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets_volume.go#L81)

Release : v1.9
Create a secret. Create a Pod with secret volume source configured into the container with a custom path and file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -r-—r-—r—-.



## [Secrets Volume, mapping multiple volume paths](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets_volume.go#L111)

Release : v1.9
Create a secret. Create a Pod with two secret volume sources configured into the container in to two different custom paths. Pod MUST be able to read the secret from the both the mounted volumes from the two specified custom paths.



## [Secrets Volume, create, update and delete](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/common/secrets_volume.go#L189)

Release : v1.9
Create a Pod with three containers with secrets volume sources namely a create, update and delete container. Create Container when started MUST not have secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.



## [Kubectl, replication controller](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L269)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2.



## [Kubectl, scale replication controller](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L277)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Update the replicaset to 1. Number of running instances of the Pod MUST be 1. Update the replicaset to 2. Number of running instances of the Pod MUST be 2.



## [Kubectl, rolling update replication controller](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L291)

Release : v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Run a rolling update to run a different version of the container. All running instances SHOULD now be running the newer version of the container as part of the rolling update.



## [Kubectl, guestbook application](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L318)

Release : v1.9
Create Guestbook application that contains redis server, 2 instances of redis slave, frontend application, frontend service and redis master service and redis slave service. Using frontend service test will write a entry into the guestbook application which will store the entry into the backend redis database. Applcaition flow MUST work as expects and the data written MUST be available to read.



## [Kubectl, check version v1](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L682)

Release : v1.9
Run kubectl to get api versions, output MUST contain returned versions with ‘v1’ listed.



## [Kubectl, cluster info](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L773)

Release : v1.9
Call kubectl to get cluster-info, output MUST contain cluster-info returned and Kubernetes Master SHOULD be running.



## [Kubectl, describe pod or rc](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L790)

Release : v1.9
Deploy a redis controller and a redis service. Kubectl describe pods SHOULD return the name, namespace, labels, state and other information as expected. Kubectl describe on rc, service, node and namespace SHOULD also return proper information.



## [Kubectl, create service, replication controller](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L893)

Release : v1.9
Create a Pod running redis master listening to port 6379. Using kubectl expose the redis master  replication controllers at port 1234. Validate that the replication controller is listening on port 1234 and the target port is set to 6379, port that redis master is listening. Using kubectl expose the redis master as a service at port 2345. The service MUST be listening on port 2345 and the target port is set to 6379, port that redis master is listening.



## [Kubectl, label update](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L984)

Release : v1.9
When a Pod is running, update a Label using ‘kubectl label’ command. The label MUST be created in the Pod. A ‘kubectl get pod’ with -l option on the container MUST verify that the label can be read back. Use ‘kubectl label label-’ to remove the label. Kubetctl get pod’ with -l option SHOULD no list the deleted label as the label is removed.



## [Kubectl, logs](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1019)

Release : v1.9
When a Pod is running then it MUST generate logs.
Starting a Pod should have a log line indicating the the server is running and ready to accept connections. 			   Also log command options MUST work as expected and described below.
‘kubectl log -tail=1’ should generate a output of one line, the last line in the log.
‘kubectl --limit-bytes=1’ should generate a single byte output.
‘kubectl --tail=1 --timestamp should genrate one line with timestamp in RFC3339 format
‘kubectl --since=1s’ should output logs that are only 1 second older from now
‘kubectl --since=24h’ should output logs that are only 1 day older from now



## [Kubectl, patch to annotate](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1070)

Release : v1.9
Start running a redis master and a replication controller. When the pod is running, using ‘kubectl patch’ command add annotations. The annotation MUST be added to running pods and SHOULD be able to read added annotations from each of the Pods running under the replication controller.



## [Kubectl, version](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1099)

Release : v1.9
The command ‘kubectl version’ MUST return the major, minor versions,  GitCommit, etc of the the Client and the Server that the kubectl is configured to connect to.



## [Kubectl, run default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1126)

Release : v1.9
Command ‘kubectl run’ MUST create a running pod with possible replicas given a image using the option --image=’nginx’. The running Pod SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command.



## [Kubectl, run rc](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1156)

Release : v1.9
Command ‘kubectl run’ MUST create a running rc with default one replicas given a image using the option --image=’nginx’. The running replication controller SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command. Also there MUST be 1 pod controlled by this replica set running 1 container with the image specified. A ‘kubetctl logs’ command MUST return the logs from the container in the replication controller.



## [Kubectl, rolling update](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1212)

Release : v1.9
Command ‘kubectl rolling-update’ MUST replace the specified replication controller with a new replication controller by updating one pod at a time to use the new Pod spec.



## [Kubectl, run deployment](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1256)

Release : v1.9
Command ‘kubectl run’ MUST create a job, with --generator=deployment, when a image name is specified in the run command. After the run command there SHOULD be a deployment that should exist with one container running the specified image. Also there SHOULD be a Pod that is controlled by this deployment, with a container running the specified image.



## [Kubectl, run job](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1296)

Release : v1.9
Command ‘kubectl run’ MUST create a deployment, with --generator=job, when a image name is specified in the run command. After the run command there SHOULD be a job that should exist with one container running the specified image. Also there SHOULD be a restart policy on the job spec that SHOULD match the command line.



## [Kubectl, run pod](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1364)

Release : v1.9
Command ‘kubectl run’ MUST create a pod, with --generator=run-pod, when a image name is specified in the run command. After the run command there SHOULD be a pod that should exist with one container running the specified image.



## [Kubectl, replace](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1395)

Release : v1.9
Command ‘kubectl replace’ on a existing Pod with a new spec MUST update the image of the container running in the Pod. A -f option to ‘kubectl replace’ SHOULD force to re-create the resource. The new Pod SHOULD have the container with new change to the image.



## [Kubectl, run job with --rm](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1431)

Release : v1.9
Start a job with a Pod using ‘kubectl run’ but specify --rm=true. Wait for the Pod to start running by verifying that there is output as expected. Now verify that the job has exited and cannot be found. With --rm=true option the job MUST start by running the image specified and then get deleted itself.



## [Kubectl, proxy port zero](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1459)

TODO: test proxy options (static, prefix, etc)

Release : v1.9
Start a proxy server on port zero by running ‘kubectl proxy’ with --port=0. Call the proxy server by requesting api versions from unix socket. The proxy server MUST provide at least one version string.



## [Kubectl, proxy socket](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/kubectl/kubectl.go#L1479)

Release : v1.9
Start a proxy server on by running ‘kubectl proxy’ with --unix-socket=<some path>. Call the proxy server by requesting api versions from  http://locahost:0/api. The proxy server MUST provide atleast one version string



## [DNS, cluster](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/dns.go#L43)

Release : v1.9
When a Pod is created it MUST be able to resolve cluster dns entries such as kubernetes.default, etc. The Pod MUST validate its hostname entries in the hosts file.



## [DNS, services](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/dns.go#L73)

Release : v1.9
When a headless service is created, it MUST be able to resolve all the required service endpoints. A Pod running in the namespace MUST be able to resolve the service IP.



## [Proxy, logs port endpoint](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/proxy.go#L80)

Release : v1.9
Select any node in the cluster to invoke /proxy/nodes/<nodeip>:10250/logs endpoint. This endpoint MUST be reachable within the max retries(20) specified and within timeout(30s) period.



## [Proxy, logs endpoint](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/proxy.go#L87)

Release : v1.9
Select any node in the cluster to invoke /proxy/nodes/<nodeip>//logs endpoint. This endpoint MUST be reachable within the max retries(20) specified and within timeout(30s) period.



## [Proxy, logs service endpoint](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/proxy.go#L104)

using the porter image to serve content, access the content
(of multiple pods?) from multiple (endpoints/services?)

Release : v1.9
Select any node in the cluster to invoke  /logs endpoint  using the /nodes/proxy subresource from the kubelet port. This endpoint MUST be reachable within the max retries(20) specified and within timeout(30s) period.



## [Kubernetes Service](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/service.go#L76)

Release : v1.9
By default when a kubernetes cluster is running there SHOULD be a ‘kubernetes’ service running in the cluster.



## [Service, endpoints](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/service.go#L86)

Release : v1.9
Create a service with a endpoint without any Pods, the service MUST run and show empty endpoints. Add a pod to the service and the service MUST validate the ports exposed. Add another Pod then the list of all Ports exposed by both the Pods MUST be validated. Once the second Pod is deleted then set of endpoint SHOULD be validate to show only porsts form the first container are exposed. Once both pods are deleted the endpoints SHOULD be empty.



## [Service, endpoints with multiple ports](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/service.go#L151)

Release : v1.9
Create a service with two ports but no Pods are added to the service yet.  The service MUST run and show empty set of endpoints. Add a Pod to the first port, service MUST list one endpoint for the Pod on that port. Add another Pod to the second port, service MUST list both the endpoints. Delete the first Pod and the service MUST list only the endpoint to the second Pod. Delete the second Pod and the service must now have empty set of endpoints.



## [Service endpoint, latency](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/network/service_latency.go#L54)

Release : v1.9
Run 100 iterations of create service with the Pod running the pause image, measure the time it takes for creating the service and the endpoint with the service name is available. These durations are captured for 100 iterations, then the durations are sorted to compue 50th, 90th and 99th percentile. The single server latency MUST not exceed liberally set thresholds of 20s for 50th percentile and 50s for the 90th percentile.



## [Pod, events](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/node/events.go#L39)

Release : v1.9
Create a Pod, make sure that the Pod can be queried. Create a event selector for the kind=Pod and the source is the scheduler. List of the events MUST be at least one.  Create a event selector for kind=Pod and the source is the kubelet. List of the events MUST be at least one. Both Scheduler and Kubelet MUST send events when scheduling and running a Pod.



## [Pods, delete grace period](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/node/pods.go#L50)

Flaky issue #36821.

Release : v1.9
Create a pod, make sure it is running, create a watch to observe Pod creation. Create a kubectl local proxy, capture the port the proxy is listening. Using the http client send a ‘delete’ with gracePeriodSeconds=30. Pod SHOULD get deleted within 30 seconds.



## [Pods, QOS](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/node/pods.go#L202)

Release : v1.9
Create a Pod with CPU and Memory request and limits. Pos status SHOULD have  QOSClass set to PodQOSGuaranteed.



## [Pods, prestop hook](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/node/pre_stop.go#L169)

Release : v1.9
Create a server pod with a rest endpoint /write that changes state.Received. Create a Pod with a pre-stop handle that posts to the /write endpoint on the server Pod. Verify that the Pod with pre-stop hook is running. Delete the Pod with the pre-stop hook. Before the Pod is deleted, pre-stop handler MUST be called when configured. Verify that the Pod is deleted and a call to prestop hook is verified by checking the status received on the server Pod.



## [Scheduler, resource limits](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/scheduling/predicates.go#L244)

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



## [Scheduler, node selector not matching](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/scheduling/predicates.go#L350)

Test Nodes does not have any label, hence it should be impossible to schedule Pod with
nonempty Selector set.

Release : v1.9
Create a Pod with a NodeSelector set to a value that does not match a node in the cluster. Since there are no nodes matching the criteria the Pod SHOULD not be scheduled.



## [Scheduler, node selector matching](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e/scheduling/predicates.go#L373)

Release : v1.9
Create a label on the node {k: v}. Then create a Pod with a NodeSelector set to {k: v}. Check to see if the Pod is scheduled. When the NodeSelector matches then Pod MUST be scheduled on that node.



## [Kubelet, log output, default](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/kubelet_test.go#L42)

Release : v1.9
By default the stdout and stderr from the process being executed in a pod MUST be sent to the pod's logs.



## [Kubelet, Pod with read only root file system](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/kubelet_test.go#L167)

Release : v1.9
Create a Pod with security context set with ReadOnlyRootFileSystem set to true. The Pod then tries to write to the /file on the root, write operation to the root filesystem MUST fail as expected.



## [Pod Lifecycle, post start exec hook](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/lifecycle_hook_test.go#L87)

Release : v1.9
When a post start handler is specified in the container lifecycle using a ‘Exec’ action, then the handler MUST be invoked after the start of the container. A Pod is created that will serve http requests, create a second pod with a container lifecycle specifying a post start that invokes the server to validate that the post start is executed.



## [Pod Lifecycle, prestop exec hook](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/lifecycle_hook_test.go#L98)

Release : v1.9
When a pre-stop handler is specified in the container lifecycle using a ‘Exec’ action, then the handler MUST be invoked before the container is terminated. A Pod is created that will serve http requests, create a second pod with a container lifecycle specifying a pre-stop that invokes the server to validate that the pre-stop is executed.



## [Pod Lifecycle, post start http hook](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/lifecycle_hook_test.go#L109)

Release : v1.9
When a post start handler is specified in the container lifecycle using a HttpGet action, then the handler MUST be invoked after the start of the container. A Pod is created that will serve http requests, create a second pod with a container lifecycle specifying a post start that invokes the server to validate that the post start is executed.



## [Pod Lifecycle, prestop http hook](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/lifecycle_hook_test.go#L122)

Release : v1.9
When a pre-stop handler is specified in the container lifecycle using a ‘HttpGet’ action, then the handler MUST be invoked before the container is terminated. A Pod is created that will serve http requests, create a second pod with a container lifecycle specifying a pre-stop that invokes the server to validate that the pre-stop is executed.



## [Mirror Pod, update](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/mirror_pod_test.go#L60)

Release : v1.9
Updating a static Pod MUST recreate an updated mirror Pod. Create a static pod, verify that a mirror pod is created. Update the static pod by changing the container image,  the mirror pod MUST be re-created and updated with the new image.



## [Mirror Pod, delete](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/mirror_pod_test.go#L82)

Release : v1.9
When a mirror-Pod is deleted then the mirror pod MUST be re-created. Create a static pod, verify that a mirror pod is created. Delete the mirror pod,  the mirror pod MUST be re-created and running.



## [Mirror Pod, force delete](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/mirror_pod_test.go#L97)

Release : v1.9
When a mirror-Pod is deleted, forcibly, then the mirror pod MUST be re-created. Create a static pod, verify that a mirror pod is created. Delete the mirror pod with delete wait time set to zero forcing immediate deletion,  the mirror pod MUST be re-created and running.



## [container runtime conformance blackbox test when starting a container that exits it should run with the expected status](https://github.com/kubernetes/kubernetes/blob/release-1.10/test/e2e_node/runtime_conformance_test.go#L49)





## **Summary**

Total Conformance Tests: 169, total legacy tests that need conversion: 0, while total tests that need comment sections: 1

