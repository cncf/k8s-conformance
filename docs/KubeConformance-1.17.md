# Kubernetes Conformance Test Suite -  v1.17

## **Summary**
This document provides a summary of the tests included in the Kubernetes conformance test suite.
Each test lists a set of formal requirements that a platform that meets conformance requirements must adhere to.

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
  Release: v1.9
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

### Release v1.9
By default the stdout and stderr from the process
being executed in a pod MUST be sent to the pod's logs.
Note this test needs to be fixed to also test for stderr

Notational Conventions when documenting the tests with the key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

Note: Please see the Summary at the end of this document to find the number of tests documented for conformance.

## **List of Tests**
## [aggregator-supports-the-sample-apiserver](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/aggregator.go#L97)

### Release 
Ensure that the sample-apiserver code from 1.10 and compiled against 1.10
will work on the current Aggregator/API-Server.



## [Custom Resource Definition Conversion Webhook, conversion custom resource](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_conversion_webhook.go#L146)

### Release v1.16
Register a conversion webhook and a custom resource definition. Create a v1 custom
resource. Attempts to read it at v2 MUST succeed.



## [Custom Resource Definition Conversion Webhook, convert mixed version list](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_conversion_webhook.go#L181)

### Release v1.16
Register a conversion webhook and a custom resource definition. Create a custom resource stored at
v1. Change the custom resource definition storage to v2. Create a custom resource stored at v2. Attempt to list
the custom resources at v2; the list result MUST contain both custom resources at v2.



## [Custom Resource OpenAPI Publish, with validation schema](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L64)

### Release v1.16
Register a custom resource definition with a validating schema consisting of objects, arrays and
primitives. Attempt to create and apply a change a custom resource using valid properties, via kubectl;
client-side validation MUST pass. Attempt both operations with unknown properties and without required
properties; client-side validation MUST reject the operations. Attempt kubectl explain; the output MUST
explain the custom resource properties. Attempt kubectl explain on custom resource properties; the output MUST
explain the nested custom resource properties.



## [Custom Resource OpenAPI Publish, with x-preserve-unknown-fields in object](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L139)

### Release v1.16
Register a custom resource definition with x-preserve-unknown-fields in the top level object.
Attempt to create and apply a change a custom resource, via kubectl; client-side validation MUST accept unknown
properties. Attempt kubectl explain; the output MUST contain a valid DESCRIPTION stanza.



## [Custom Resource OpenAPI Publish, with x-preserve-unknown-fields at root](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L180)

### Release v1.16
Register a custom resource definition with x-preserve-unknown-fields in the schema root.
Attempt to create and apply a change a custom resource, via kubectl; client-side validation MUST accept unknown
properties. Attempt kubectl explain; the output MUST show the custom resource KIND.



## [Custom Resource OpenAPI Publish, with x-preserve-unknown-fields in embedded object](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L222)

### Release v1.16
Register a custom resource definition with x-preserve-unknown-fields in an embedded object.
Attempt to create and apply a change a custom resource, via kubectl; client-side validation MUST accept unknown
properties. Attempt kubectl explain; the output MUST show that x-preserve-unknown-properties is used on the
nested field.



## [Custom Resource OpenAPI Publish, varying groups](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L262)

### Release v1.16
Register multiple custom resource definitions spanning different groups and versions;
OpenAPI definitions MUST be published for custom resource definitions.



## [Custom Resource OpenAPI Publish, varying versions](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L295)

### Release v1.16
Register a custom resource definition with multiple versions; OpenAPI definitions MUST be published
for custom resource definitions.



## [Custom Resource OpenAPI Publish, varying kinds](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L343)

### Release v1.16
Register multiple custom resource definitions in the same group and version but spanning different kinds;
OpenAPI definitions MUST be published for custom resource definitions.



## [Custom Resource OpenAPI Publish, version rename](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L377)

### Release v1.16
Register a custom resource definition with multiple versions; OpenAPI definitions MUST be published
for custom resource definitions. Rename one of the versions of the custom resource definition via a patch;
OpenAPI definitions MUST update to reflect the rename.



## [Custom Resource OpenAPI Publish, stop serving version](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_publish_openapi.go#L428)

### Release v1.16
Register a custom resource definition with multiple versions. OpenAPI definitions MUST be published
for custom resource definitions. Update the custom resource definition to not serve one of the versions. OpenAPI
definitions MUST be updated to not contain the version that is no longer served.



## [Custom Resource Definition, watch](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/crd_watch.go#L48)

### Release v1.16
Create a Custom Resource Definition. Attempt to watch it; the watch MUST observe create,
modify and delete events.



## [Custom Resource Definition, create](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/custom_resource_definition.go#L55)

### Release v1.9
Create a API extension client and define a random custom resource definition.
Create the custom resource definition and then delete it. The creation and deletion MUST
be successful.



## [Custom Resource Definition, list](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/custom_resource_definition.go#L82)

### Release v1.16
Create a API extension client, define 10 labeled custom resource definitions and list them using
a label selector; the list result MUST contain only the labeled custom resource definitions. Delete the labeled
custom resource definitions via delete collection; the delete MUST be successful and MUST delete only the
labeled custom resource definitions.



## [Custom Resource Definition, status sub-resource](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/custom_resource_definition.go#L142)

### Release v1.16
Create a custom resource definition. Attempt to read, update and patch its status sub-resource;
all mutating sub-resource operations MUST be visible to subsequent reads.



## [Custom Resource Definition, discovery](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/custom_resource_definition.go#L196)

### Release v1.16
Fetch /apis, /apis/apiextensions.k8s.io, and /apis/apiextensions.k8s.io/v1 discovery documents,
and ensure they indicate CustomResourceDefinition apiextensions.k8s.io/v1 resources are available.



## [Custom Resource Definition, defaulting](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/custom_resource_definition.go#L267)

### Release v1.17
Create a custom resource definition without default. Create CR. Add default and read CR until
the default is applied. Create another CR. Remove default, add default for another field and read CR until
new field is defaulted, but old default stays.



## [Garbage Collector, delete replication controller, propagation policy background](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/garbage_collector.go#L313)

### Release v1.9
Create a replication controller with 2 Pods. Once RC is created and the first Pod is created, delete RC with deleteOptions.PropagationPolicy set to Background. Deleting the Replication Controller MUST cause pods created by that RC to be deleted.



## [Garbage Collector, delete replication controller, propagation policy orphan](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/garbage_collector.go#L371)

### Release v1.9
Create a replication controller with maximum allocatable Pods between 10 and 100 replicas. Once RC is created and the all Pods are created, delete RC with deleteOptions.PropagationPolicy set to Orphan. Deleting the Replication Controller MUST cause pods created by that RC to be orphaned.



## [Garbage Collector, delete deployment,  propagation policy background](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/garbage_collector.go#L485)

### Release v1.9
Create a deployment with a replicaset. Once replicaset is created , delete the deployment  with deleteOptions.PropagationPolicy set to Background. Deleting the deployment MUST delete the replicaset created by the deployment and also the Pods that belong to the deployments MUST be deleted.



## [Garbage Collector, delete deployment, propagation policy orphan](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/garbage_collector.go#L544)

### Release v1.9
Create a deployment with a replicaset. Once replicaset is created , delete the deployment  with deleteOptions.PropagationPolicy set to Orphan. Deleting the deployment MUST cause the replicaset created by the deployment to be orphaned, also the Pods created by the deployments MUST be orphaned.



## [Garbage Collector, delete replication controller, after owned pods](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/garbage_collector.go#L618)

### Release v1.9
Create a replication controller with maximum allocatable Pods between 10 and 100 replicas. Once RC is created and the all Pods are created, delete RC with deleteOptions.PropagationPolicy set to Foreground. Deleting the Replication Controller MUST cause pods created by that RC to be deleted before the RC is deleted.



## [Garbage Collector, multiple owners](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/garbage_collector.go#L703)

### Release v1.9
TODO: this should be an integration test

Create a replication controller RC1, with maximum allocatable Pods between 10 and 100 replicas. Create second replication controller RC2 and set RC2 as owner for half of those replicas. Once RC1 is created and the all Pods are created, delete RC1 with deleteOptions.PropagationPolicy set to Foreground. Half of the Pods that has RC2 as owner MUST not be deleted but have a deletion timestamp. Deleting the Replication Controller MUST not delete Pods that are owned by multiple replication controllers.



## [Garbage Collector, dependency cycle](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/garbage_collector.go#L814)

### Release v1.9
TODO: should be an integration test

Create three pods, patch them with Owner references such that pod1 has pod3, pod2 has pod1 and pod3 has pod2 as owner references respectively. Delete pod1 MUST delete all pods. The dependency cycle MUST not block the garbage collection.



## [namespace-deletion-removes-pods](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/namespace.go#L232)

### Release 
Ensure that if a namespace is deleted then all pods are removed from that namespace.



## [namespace-deletion-removes-services](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/namespace.go#L239)

### Release 
Ensure that if a namespace is deleted then all services are removed from that namespace.



## [ResourceQuota, object count quota, resourcequotas](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L59)

### Release v1.16
Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.



## [ResourceQuota, object count quota, service](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L84)

### Release v1.16
Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a Service. Its creation MUST be successful and resource usage count against the Service object and resourceQuota object MUST be captured in ResourceQuotaStatus of the ResourceQuota.
Delete the Service. Deletion MUST succeed and resource usage count against the Service object MUST be released from ResourceQuotaStatus of the ResourceQuota.



## [ResourceQuota, object count quota, secret](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L130)

### Release v1.16
Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a Secret. Its creation MUST be successful and resource usage count against the Secret object and resourceQuota object MUST be captured in ResourceQuotaStatus of the ResourceQuota.
Delete the Secret. Deletion MUST succeed and resource usage count against the Secret object MUST be released from ResourceQuotaStatus of the ResourceQuota.



## [ResourceQuota, object count quota, pod](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L200)

### Release v1.16
Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a Pod with resource request count for CPU, Memory, EphemeralStorage and ExtendedResourceName. Pod creation MUST be successful and respective resource usage count MUST be captured in ResourceQuotaStatus of the ResourceQuota.
Create another Pod with resource request exceeding remaining quota. Pod creation MUST fail as the request exceeds ResourceQuota limits.
Update the successfully created pod's resource requests. Updation MUST fail as a Pod can not dynamically update its resource requirements.
Delete the successfully created Pod. Pod Deletion MUST be scuccessful and it MUST release the allocated resource counts from ResourceQuotaStatus of the ResourceQuota.



## [ResourceQuota, object count quota, configmap](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L296)

### Release v1.16
Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a ConfigMap. Its creation MUST be successful and resource usage count against the ConfigMap object MUST be captured in ResourceQuotaStatus of the ResourceQuota.
Delete the ConfigMap. Deletion MUST succeed and resource usage count against the ConfigMap object MUST be released from ResourceQuotaStatus of the ResourceQuota.



## [ResourceQuota, object count quota, replicationController](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L364)

### Release v1.16
Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a ReplicationController. Its creation MUST be successful and resource usage count against the ReplicationController object MUST be captured in ResourceQuotaStatus of the ResourceQuota.
Delete the ReplicationController. Deletion MUST succeed and resource usage count against the ReplicationController object MUST be released from ResourceQuotaStatus of the ResourceQuota.



## [ResourceQuota, object count quota, replicaSet](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L410)

### Release v1.16
Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a ReplicaSet. Its creation MUST be successful and resource usage count against the ReplicaSet object MUST be captured in ResourceQuotaStatus of the ResourceQuota.
Delete the ReplicaSet. Deletion MUST succeed and resource usage count against the ReplicaSet object MUST be released from ResourceQuotaStatus of the ResourceQuota.



## [ResourceQuota, quota scope, Terminating and NotTerminating scope](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L652)

### Release v1.16
Create two ResourceQuotas, one with 'Terminating' scope and another 'NotTerminating' scope. Request and the limit counts for CPU and Memory resources are set for the ResourceQuota. Creation MUST be successful and their ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a Pod with specified CPU and Memory ResourceRequirements fall within quota limits. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'NotTerminating' scoped ResourceQuota but MUST NOT in 'Terminating' scoped ResourceQuota.
Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'NotTerminating' scoped ResourceQuota.
Create a pod with specified activeDeadlineSeconds and resourceRequirements for CPU and Memory fall within quota limits. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'Terminating' scoped ResourceQuota but MUST NOT in 'NotTerminating' scoped ResourceQuota.
Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'Terminating' scoped ResourceQuota.



## [ResourceQuota, quota scope, BestEffort and NotBestEffort scope](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L765)

### Release v1.16
Create two ResourceQuotas, one with 'BestEffort' scope and another with 'NotBestEffort' scope. Creation MUST be successful and their ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.
Create a 'BestEffort' Pod by not explicitly specifying resource limits and requests. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'BestEffort' scoped ResourceQuota but MUST NOT in 'NotBestEffort' scoped ResourceQuota.
Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'BestEffort' scoped ResourceQuota.
Create a 'NotBestEffort' Pod by explicitly specifying resource limits and requests. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'NotBestEffort' scoped ResourceQuota but MUST NOT in 'BestEffort' scoped ResourceQuota.
Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'NotBestEffort' scoped ResourceQuota.



## [ResourceQuota, update and delete](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/resource_quota.go#L846)

### Release v1.16
Create a ResourceQuota for CPU and Memory quota limits. Creation MUST be successful.
When ResourceQuota is updated to modify CPU and Memory quota limits, update MUST succeed with updated values for CPU and Memory limits.
When ResourceQuota is deleted, it MUST not be available in the namespace.



## [API metadata HTTP return](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/table_conversion.go#L153)

### Release v1.16
Issue a HTTP request to the API.
HTTP request MUST return a HTTP status code of 406.



## [watch-configmaps-with-multiple-watchers](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/watch.go#L53)

### Release 
Ensure that multiple watchers are able to receive all add,
update, and delete notifications on configmaps that match a label selector and do
not receive notifications for configmaps which do not match that label selector.



## [watch-configmaps-from-resource-version](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/watch.go#L138)

### Release 
Ensure that a watch can be opened from a particular resource version
in the past and only notifications happening after that resource version are observed.



## [watch-configmaps-closed-and-restarted](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/watch.go#L186)

### Release 
Ensure that a watch can be reopened from the last resource version
observed by the previous watch, and it will continue delivering notifications from
that point in time.



## [watch-configmaps-label-changed](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/watch.go#L251)

### Release 
Ensure that a watched object stops meeting the requirements of
a watch's selector, the watch will observe a delete, and will not observe
notifications for that object until it meets the selector's requirements again.



## [watch-consistency](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/watch.go#L328)

### Release v1.15
Ensure that concurrent watches are consistent with each other by initiating an additional watch
for events received from the first watch, initiated at the resource version of the event, and checking that all
resource versions of all events match. Events are produced from writes on a background goroutine.



## [Admission webhook, discovery document](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L114)

### Release v1.16
The admissionregistration.k8s.io API group MUST exists in the /apis discovery document.
The admissionregistration.k8s.io/v1 API group/version MUST exists in the /apis discovery document.
The mutatingwebhookconfigurations and validatingwebhookconfigurations resources MUST exist in the
/apis/admissionregistration.k8s.io/v1 discovery document.



## [Admission webhook, deny create](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L194)

### Release v1.16
Register an admission webhook configuration that admits pod and configmap. Attempts to create
non-compliant pods and configmaps, or update/patch compliant pods and configmaps to be non-compliant MUST
be denied. An attempt to create a pod that causes a webhook to hang MUST result in a webhook timeout error,
and the pod creation MUST be denied. An attempt to create a non-compliant configmap in a whitelisted
namespace based on the webhook namespace selector MUST be allowed.



## [Admission webhook, deny attach](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L206)

### Release v1.16
Register an admission webhook configuration that denies connecting to a pod's attach sub-resource.
Attempts to attach MUST be denied.



## [Admission webhook, deny custom resource create and delete](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L218)

### Release v1.16
Register an admission webhook configuration that denies creation, update and deletion of
custom resources. Attempts to create, update and delete custom resources MUST be denied.



## [Admission webhook, fail closed](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L236)

### Release v1.16
Register a webhook with a fail closed policy and without CA bundle so that it cannot be called.
Attempt operations that require the admission webhook; all MUST be denied.



## [Admission webhook, ordered mutation](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L249)

### Release v1.16
Register a mutating webhook configuration with two webhooks that admit configmaps, one that
adds a data key if the configmap already has a specific key, and another that adds a key if the key added by
the first webhook is present. Attempt to create a config map; both keys MUST be added to the config map.



## [Admission webhook, mutation with defaulting](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L261)

### Release v1.16
Register a mutating webhook that adds an InitContainer to pods. Attempt to create a pod;
the InitContainer MUST be added the TerminationMessagePolicy MUST be defaulted.



## [Admission webhook, admission control not allowed on webhook configuration objects](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L274)

### Release v1.16
Register webhooks that mutate and deny deletion of webhook configuration objects. Attempt to create
and delete a webhook configuration object; both operations MUST be allowed and the webhook configuration object
MUST NOT be mutated the webhooks.



## [Admission webhook, mutate custom resource](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L288)

### Release v1.16
Register a webhook that mutates a custom resource. Attempt to create custom resource object;
the custom resource MUST be mutated.



## [Admission webhook, deny custom resource definition](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L305)

### Release v1.16
Register a webhook that denies custom resource definition create. Attempt to create a
custom resource definition; the create request MUST be denied.



## [Admission webhook, mutate custom resource with different stored version](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L320)

### Release v1.16
Register a webhook that mutates custom resources on create and update. Register a custom resource
definition using v1 as stored version. Create a custom resource. Patch the custom resource definition to use v2 as
the stored version. Attempt to patch the custom resource with a new field and value; the patch MUST be applied
successfully.



## [Admission webhook, mutate custom resource with pruning](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L338)

### Release v1.16
Register mutating webhooks that adds fields to custom objects. Register a custom resource definition
with a schema that includes only one of the data keys added by the webhooks. Attempt to a custom resource;
the fields included in the schema MUST be present and field not included in the schema MUST NOT be present.



## [Admission webhook, honor timeout](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L378)

### Release v1.16
Using a webhook that waits 5 seconds before admitting objects, configure the webhook with combinations
of timeouts and failure policy values. Attempt to create a config map with each combination. Requests MUST
timeout if the configured webhook timeout is less than 5 seconds and failure policy is fail. Requests must not timeout if
the failure policy is ignore. Requests MUST NOT timeout if configured webhook timeout is 10 seconds (much longer
than the webhook wait duration).



## [Admission webhook, update validating webhook](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L410)

### Release v1.16
Register a validating admission webhook configuration. Update the webhook to not apply to the create
operation and attempt to create an object; the webhook MUST NOT deny the create. Patch the webhook to apply to the
create operation again and attempt to create an object; the webhook MUST deny the create.



## [Admission webhook, update mutating webhook](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L506)

### Release v1.16
Register a mutating admission webhook configuration. Update the webhook to not apply to the create
operation and attempt to create an object; the webhook MUST NOT mutate the object. Patch the webhook to apply to the
create operation again and attempt to create an object; the webhook MUST mutate the object.



## [Admission webhook, list validating webhooks](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L581)

### Release v1.16
Create 10 validating webhook configurations, all with a label. Attempt to list the webhook
configurations matching the label; all the created webhook configurations MUST be present. Attempt to create an
object; the create MUST be denied. Attempt to remove the webhook configurations matching the label with deletecollection;
all webhook configurations MUST be deleted. Attempt to create an object; the create MUST NOT be denied.



## [Admission webhook, list mutating webhooks](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apimachinery/webhook.go#L655)

### Release v1.16
Create 10 mutating webhook configurations, all with a label. Attempt to list the webhook
configurations matching the label; all the created webhook configurations MUST be present. Attempt to create an
object; the object MUST be mutated. Attempt to remove the webhook configurations matching the label with deletecollection;
all webhook configurations MUST be deleted. Attempt to create an object; the object MUST NOT be mutated.



## [DaemonSet-Creation](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/daemon_set.go#L152)

### Release 
A conformant Kubernetes distribution MUST support the creation of DaemonSets. When a DaemonSet
Pod is deleted, the DaemonSet controller MUST create a replacement Pod.



## [DaemonSet-NodeSelection](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/daemon_set.go#L179)

### Release 
A conformant Kubernetes distribution MUST support DaemonSet Pod node selection via label
selectors.



## [DaemonSet-FailedPodCreation](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/daemon_set.go#L278)

### Release 
A conformant Kubernetes distribution MUST create new DaemonSet Pods when they fail.



## [DaemonSet-RollingUpdate](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/daemon_set.go#L357)

### Release 
A conformant Kubernetes distribution MUST support DaemonSet RollingUpdates.



## [DaemonSet-Rollback](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/daemon_set.go#L414)

### Release 
A conformant Kubernetes distribution MUST support automated, minimally disruptive
rollback of updates to a DaemonSet.



## [Deployment RollingUpdate](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/deployment.go#L81)

### Release 
A conformant Kubernetes distribution MUST support the Deployment with RollingUpdate strategy.



## [Deployment Recreate](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/deployment.go#L88)

### Release 
A conformant Kubernetes distribution MUST support the Deployment with Recreate strategy.



## [Deployment RevisionHistoryLimit](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/deployment.go#L96)

### Release 
A conformant Kubernetes distribution MUST clean up Deployment's ReplicaSets based on
the Deployment's `.spec.revisionHistoryLimit`.



## [Deployment Rollover](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/deployment.go#L105)

### Release 
A conformant Kubernetes distribution MUST support Deployment rollover,
i.e. allow arbitrary number of changes to desired state during rolling update
before the rollout finishes.



## [Deployment Proportional Scaling](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/deployment.go#L120)

### Release 
A conformant Kubernetes distribution MUST support Deployment
proportional scaling, i.e. proportionally scale a Deployment's ReplicaSets
when a Deployment is scaled.



## [Jobs, completion after task failure](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/job.go#L94)

### Release v1.16
Explicitly cause the tasks to fail once initially. After restarting, the Job MUST
execute to completion.



## [Jobs, active pods, graceful termination](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/job.go#L149)

### Release v1.15
Create a job. Ensure the active pods reflect paralellism in the namespace and delete the job. Job MUST be deleted successfully.



## [Jobs, orphan pods, re-adoption](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/job.go#L175)

### Release v1.16
Create a parallel job. The number of Pods MUST equal the level of parallelism.
Orphan a Pod by modifying its owner reference. The Job MUST re-adopt the orphan pod.
Modify the labels of one of the Job's Pods. The Job MUST release the Pod.



## [Replication Controller, run basic image](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/rc.go#L48)

### Release v1.9
Replication Controller MUST create a Pod with Basic Image and MUST run the service with the provided image. Image MUST be tested by dialing into the service listening through TCP, UDP and HTTP.



## [Replication Controller, check for issues like exceeding allocated quota](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/rc.go#L64)

### Release v1.15
Attempt to create a Replication Controller with pods exceeding the namespace quota. The creation MUST fail



## [Replication Controller, adopt matching pods](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/rc.go#L73)

### Release v1.13
An ownerless Pod is created, then a Replication Controller (RC) is created whose label selector will match the Pod. The RC MUST either adopt the Pod or delete and replace it with a new Pod



## [Replication Controller, release pods](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/rc.go#L82)

### Release v1.13
A Replication Controller (RC) is created, and its Pods are created. When the labels on one of the Pods change to no longer match the RC's label selector, the RC MUST release the Pod and update the Pod's owner references.



## [Replica Set, run basic image](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/replica_set.go#L92)

### Release v1.9
Create a ReplicaSet with a Pod and a single Container. Make sure that the Pod is running. Pod SHOULD send a valid response when queried.



## [Replica Set, adopt matching pods and release non matching pods](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/replica_set.go#L112)

### Release v1.13
A Pod is created, then a Replica Set (RS) whose label selector will match the Pod. The RS MUST either adopt the Pod or delete and replace it with a new Pod. When the labels on one of the Pods owned by the RS change to no longer match the RS's label selector, the RS MUST release the Pod and update the Pod's owner references



## [StatefulSet, Rolling Update](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/statefulset.go#L272)

### Release v1.9
StatefulSet MUST support the RollingUpdate strategy to automatically replace Pods one at a time when the Pod template changes. The StatefulSet's status MUST indicate the CurrentRevision and UpdateRevision. If the template is changed to match a prior revision, StatefulSet MUST detect this as a rollback instead of creating a new revision. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Rolling Update with Partition](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/statefulset.go#L283)

### Release v1.9
StatefulSet's RollingUpdate strategy MUST support the Partition parameter for canaries and phased rollouts. If a Pod is deleted while a rolling update is in progress, StatefulSet MUST restore the Pod without violating the Partition. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Scaling](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/statefulset.go#L553)

### Release v1.9
StatefulSet MUST create Pods in ascending order by ordinal index when scaling up, and delete Pods in descending order when scaling down. Scaling up or down MUST pause if any Pods belonging to the StatefulSet are unhealthy. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Burst Scaling](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/statefulset.go#L637)

### Release v1.9
StatefulSet MUST support the Parallel PodManagementPolicy for burst scaling. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet, Recreate Failed Pod](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/statefulset.go#L679)

### Release v1.9
StatefulSet MUST delete and recreate Pods it owns that go into a Failed state, such as when they are rejected or evicted by a Node. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.



## [StatefulSet resource Replica scaling](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/apps/statefulset.go#L772)

### Release v1.16
Create a StatefulSet resource.
Newly created StatefulSet resource MUST have a scale of one.
Bring the scale of the StatefulSet resource up to two. StatefulSet scale MUST be at two replicas.



## [Service Account Tokens Must AutoMount](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/auth/service_accounts.go#L170)

### Release v1.9
Ensure that Service Account keys are mounted into the Container. Pod
contains three containers each will read Service Account token,
root CA and default namespace respectively from the default API
Token Mount path. All these three files MUST exist and the Service
Account mount path MUST be auto mounted to the Container.



## [Service account tokens auto mount optionally](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/auth/service_accounts.go#L275)

### Release v1.9
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



## [ConfigMap, from environment field](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap.go#L39)

### Release v1.9
Create a Pod with an environment variable value set using a value from ConfigMap. A ConfigMap value MUST be accessible in the container environment.



## [ConfigMap, from environment variables](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap.go#L87)

### Release v1.9
Create a Pod with a environment source from ConfigMap. All ConfigMap values MUST be available as environment variables in the container.



## [ConfigMap, with empty-key](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap.go#L132)

### Release v1.14
Attempt to create a ConfigMap with an empty key. The creation MUST fail.



## [ConfigMap Volume, without mapping](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L41)

### Release v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST default to 0x644.



## [ConfigMap Volume, without mapping, volume mode set](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L51)

### Release v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. File mode is changed to a custom value of '0x400'. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value of ‘0x400’
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [ConfigMap Volume, without mapping, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L69)

### Release v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Pod is run as a non-root user with uid=1000. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The file on the volume MUST have file mode set to default value of 0x644.
This test is marked LinuxOnly since Windows does not support running as UID / GID.



## [ConfigMap Volume, with mapping](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L85)

### Release v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST default to 0x644.



## [ConfigMap Volume, with mapping, volume mode set](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L95)

### Release v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. File mode is changed to a custom value of '0x400'. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value of ‘0x400’
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [ConfigMap Volume, with mapping, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L106)

### Release v1.9
Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. Pod is run as a non-root user with uid=1000. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The file on the volume MUST have file mode set to default value of 0x644.
This test is marked LinuxOnly since Windows does not support running as UID / GID.



## [ConfigMap Volume, update](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L122)

### Release v1.9
The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the ConfigMap is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod.



## [ConfigMap Volume, text data, binary data](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L205)

### Release v1.12
The ConfigMap that is created with text data and binary data MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. ConfigMap's text data and binary data MUST be verified by reading the content from the mounted files in the Pod.



## [ConfigMap Volume, create, update and delete](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L301)

### Release v1.9
The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the config map is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod. Also when the item(file) is deleted from the map that MUST result in a error reading that item(file).



## [ConfigMap Volume, multiple volume maps](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/configmap_volume.go#L484)

### Release v1.9
The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to multiple paths in the Pod. The content MUST be accessible from all the mapped volume mounts.



## [Pod readiness probe, with initial delay](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/container_probe.go#L60)

### Release v1.9
Create a Pod that is configured with a initial delay set on the readiness probe. Check the Pod Start time to compare to the initial delay. The Pod MUST be ready only after the specified initial delay.



## [Pod readiness probe, failure](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/container_probe.go#L94)

### Release v1.9
Create a Pod with a readiness probe that fails consistently. When this Pod is created,
then the Pod MUST never be ready, never be running and restart count MUST be zero.



## [Pod liveness probe, using local file, restart](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/container_probe.go#L119)

### Release v1.9
Create a Pod with liveness probe that uses ExecAction handler to cat /temp/health file. The Container deletes the file /temp/health after 10 second, triggering liveness probe to fail. The Pod MUST now be killed and restarted incrementing restart count to 1.



## [Pod liveness probe, using local file, no restart](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/container_probe.go#L135)

### Release v1.9
Pod is created with liveness probe that uses ‘exec’ command to cat /temp/health file. Liveness probe MUST not fail to check health and the restart count should remain 0.



## [Pod liveness probe, using http endpoint, restart](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/container_probe.go#L151)

### Release v1.9
A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod MUST now be killed and restarted incrementing restart count to 1.



## [Pod liveness probe, using http endpoint, multiple restarts (slow)](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/container_probe.go#L181)

### Release v1.9
A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod MUST now be killed and restarted incrementing restart count to 1. The liveness probe must fail again after restart once the http handler for /healthz enpoind on the Pod returns an http error after 10 seconds from the start. Restart counts MUST increment everytime health check fails, measure upto 5 restart.



## [Pod liveness probe, using http endpoint, failure](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/container_probe.go#L196)

### Release v1.9
A Pod is created with liveness probe on http endpoint ‘/’. Liveness probe on this endpoint will not fail. When liveness probe does not fail then the restart count MUST remain zero.



## [Docker containers, without command and arguments](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/docker_containers.go#L38)

### Release v1.9
Default command and arguments from the docker image entrypoint MUST be used when Pod does not specify the container command



## [Docker containers, with arguments](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/docker_containers.go#L57)

### Release v1.9
Default command and  from the docker image entrypoint MUST be used when Pod does not specify the container command but the arguments from Pod spec MUST override when specified.



## [Docker containers, with command](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/docker_containers.go#L73)

### Release v1.9
Note: when you override the entrypoint, the image's arguments (docker cmd)
are ignored.

Default command from the docker image entrypoint MUST NOT be used when Pod specifies the container command.  Command from Pod spec MUST override the command in the image.



## [Docker containers, with command and arguments](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/docker_containers.go#L87)

### Release v1.9
Default command and arguments from the docker image entrypoint MUST NOT be used when Pod specifies the container command and arguments.  Command and arguments from Pod spec MUST override the command and arguments in the image.



## [DownwardAPI, environment for name, namespace and ip](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downward_api.go#L41)

### Release v1.9
Downward API MUST expose Pod and Container fields as environment variables. Specify Pod Name, namespace and IP as environment variable in the Pod Spec are visible at runtime in the container.



## [DownwardAPI, environment for host ip](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downward_api.go#L87)

### Release v1.9
Downward API MUST expose Pod and Container fields as environment variables. Specify host IP as environment variable in the Pod Spec are visible at runtime in the container.



## [DownwardAPI, environment for CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downward_api.go#L163)

### Release v1.9
Downward API MUST expose CPU request and Memory request set through environment variables at runtime in the container.



## [DownwardAPI, environment for default CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downward_api.go#L214)

### Release v1.9
Downward API MUST expose CPU request and Memory limits set through environment variables at runtime in the container.



## [DownwardAPI, environment for Pod UID](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downward_api.go#L264)

### Release v1.9
Downward API MUST expose Pod UID set through environment variables at runtime in the container.



## [DownwardAPI volume, pod name](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L49)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.



## [DownwardAPI volume, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L64)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource with the volumesource mode set to -r-------- and DownwardAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [DownwardAPI volume, file mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L80)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the Pod name with the file mode set to -r--------. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [DownwardAPI volume, update label](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L126)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains list of items for each of the Pod labels. The container runtime MUST be able to access Pod labels from the specified path on the mounted volume. Update the labels by adding a new label to the running Pod. The new label MUST be available from the mounted volume.



## [DownwardAPI volume, update annotations](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L158)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains list of items for each of the Pod annotations. The container runtime MUST be able to access Pod annotations from the specified path on the mounted volume. Update the annotations by adding a new annotation to the running Pod. The new annotation MUST be available from the mounted volume.



## [DownwardAPI volume, CPU limits](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L192)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the CPU limits. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume.



## [DownwardAPI volume, memory limits](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L206)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the memory limits. The container runtime MUST be able to access memory limits from the specified path on the mounted volume.



## [DownwardAPI volume, CPU request](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L220)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the CPU request. The container runtime MUST be able to access CPU request from the specified path on the mounted volume.



## [DownwardAPI volume, memory request](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L234)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the memory request. The container runtime MUST be able to access memory request from the specified path on the mounted volume.



## [DownwardAPI volume, CPU limit, default node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L248)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the CPU limits. CPU limits is not specified for the container. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume and the value MUST be default node allocatable.



## [DownwardAPI volume, memory limit, default node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/downwardapi_volume.go#L260)

### Release v1.9
A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the memory limits. memory limits is not specified for the container. The container runtime MUST be able to access memory limits from the specified path on the mounted volume and the value MUST be default node allocatable.



## [EmptyDir, medium memory, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L81)

### Release v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or the medium = 'Memory'.



## [EmptyDir, medium memory, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L91)

### Release v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.



## [EmptyDir, medium memory, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L101)

### Release v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.



## [EmptyDir, medium memory, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L111)

### Release v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.



## [EmptyDir, medium memory, volume mode 0644, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L121)

### Release v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.



## [EmptyDir, medium memory, volume mode 0666,, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L131)

### Release v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.



## [EmptyDir, medium memory, volume mode 0777, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L141)

### Release v1.9
A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.



## [EmptyDir, medium default, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L151)

### Release v1.9
A Pod created with an 'emptyDir' Volume, the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L161)

### Release v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L171)

### Release v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L181)

### Release v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L191)

### Release v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L201)

### Release v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L211)

### Release v1.9
A Pod created with an 'emptyDir' Volume, the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [EmptyDir, Shared volumes between containers](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/empty_dir.go#L221)

### Release v1.15
A Pod created with an 'emptyDir' Volume, should share volumes between the containeres in the pod. The two busybox image containers shoud share the volumes mounted to the pod.
The main container shoud wait until the sub container drops a file, and main container acess the shared data.



## [Environment variables, expansion](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/expansion.go#L45)

### Release v1.9
Create a Pod with environment variables. Environment variables defined using previously defined environment variables MUST expand to proper values.



## [Environment variables, command expansion](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/expansion.go#L90)

### Release v1.9
Create a Pod with environment variables and container command using them. Container command using the  defined environment variables MUST expand to proper values.



## [Environment variables, command argument expansion](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/expansion.go#L125)

### Release v1.9
Create a Pod with environment variables and container command arguments using them. Container command arguments using the  defined environment variables MUST expand to proper values.



## [Host path, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/host_path.go#L49)

### Release v1.9
Create a Pod with host volume mounted. The volume mounted MUST be a directory with permissions mode -rwxrwxrwx and that is has the sticky bit (mode flag t) set.
This test is marked LinuxOnly since Windows does not support setting the sticky bit (mode flag t).



## [init-container-starts-app-restartnever-pod](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/init_container.go#L165)

### Release v1.12
Ensure that all InitContainers are started
and all containers in pod are voluntarily terminated with exit status 0,
and the system is not going to restart any of these containers
when Pod has restart policy as RestartNever.



## [init-container-starts-app-restartalways-pod](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/init_container.go#L232)

### Release v1.12
Ensure that all InitContainers are started
and all containers in pod started
and at least one container is still running or is in the process of being restarted
when Pod has restart policy as RestartAlways.



## [init-container-fails-stops-app-restartalways-pod](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/init_container.go#L302)

### Release v1.12
Ensure that app container is not started
when all InitContainers failed to start
and Pod has restarted for few occurrences
and pod has restart policy as RestartAlways.



## [init-container-fails-stops-app-restartnever-pod](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/init_container.go#L417)

### Release v1.12
Ensure that app container is not started
when at least one InitContainer fails to start and Pod has restart policy as RestartNever.



## [Kubelet, log output, default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/kubelet.go#L48)

### Release v1.13
By default the stdout and stderr from the process being executed in a pod MUST be sent to the pod's logs.



## [Kubelet, failed pod, terminated reason](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/kubelet.go#L106)

### Release v1.13
Create a Pod with terminated state. Pod MUST have only one container. Container MUST be in terminated state and MUST have an terminated reason.



## [Kubelet, failed pod, delete](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/kubelet.go#L131)

### Release v1.13
Create a Pod with terminated state. This terminated pod MUST be able to be deleted.



## [Kubelet, hostAliases](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/kubelet.go#L145)

### Release v1.13
Create a Pod with hostAliases and a container with command to output /etc/hosts entries. Pod's logs MUST have matching entries of specified hostAliases to the output of /etc/hosts entries.
Kubernetes mounts the /etc/hosts file into its containers, however, mounting individual files is not supported on Windows Containers. For this reason, this test is marked LinuxOnly.



## [Kubelet, pod with read only root file system](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/kubelet.go#L196)

### Release v1.13
Create a Pod with security context set with ReadOnlyRootFileSystem set to true. The Pod then tries to write to the /file on the root, write operation to the root filesystem MUST fail as expected.
This test is marked LinuxOnly since Windows does not support creating containers with read-only access.



## [Kubelet, managed etc hosts](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/kubelet_etc_hosts.go#L62)

### Release v1.9
Create a Pod with containers with hostNetwork set to false, one of the containers mounts the /etc/hosts file form the host. Create a second Pod with hostNetwork set to true.
1. The Pod with hostNetwork=false MUST have /etc/hosts of containers managed by the Kubelet.
2. The Pod with hostNetwork=false but the container mounts /etc/hosts file from the host. The /etc/hosts file MUST not be managed by the Kubelet.
3. The Pod with hostNetwork=true , /etc/hosts file MUST not be managed by the Kubelet.
This test is marked LinuxOnly since Windows cannot mount individual files in Containers.



## [lease API should be available](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/lease.go#L67)

### Release v1.17
Create Lease object, and get it; create and get MUST be successful and Spec of the
read Lease MUST match Spec of original Lease. Update the Lease and get it; update and get MUST
be successful	and Spec of the read Lease MUST match Spec of updated Lease. Patch the Lease and
get it; patch and get MUST be successful and Spec of the read Lease MUST match Spec of patched
Lease. Create a second Lease with labels and list Leases; create and list MUST be successful and
list MUST return both leases. Delete the labels lease via delete collection; the delete MUST be
successful and MUST delete only the labels lease. List leases; list MUST be successful and MUST
return just the remaining lease. Delete the lease; delete MUST be successful. Get the lease; get
MUST return not found error.



## [Pod Lifecycle, post start exec hook](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/lifecycle_hook.go#L99)

### Release v1.9
When a post start handler is specified in the container lifecycle using a ‘Exec’ action, then the handler MUST be invoked after the start of the container. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a post start that invokes the server pod using ExecAction to validate that the post start is executed.



## [Pod Lifecycle, prestop exec hook](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/lifecycle_hook.go#L115)

### Release v1.9
When a pre-stop handler is specified in the container lifecycle using a ‘Exec’ action, then the handler MUST be invoked before the container is terminated. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a pre-stop that invokes the server pod using ExecAction to validate that the pre-stop is executed.



## [Pod Lifecycle, post start http hook](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/lifecycle_hook.go#L131)

### Release v1.9
When a post start handler is specified in the container lifecycle using a HttpGet action, then the handler MUST be invoked after the start of the container. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a post start that invokes the server pod to validate that the post start is executed.



## [Pod Lifecycle, prestop http hook](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/lifecycle_hook.go#L149)

### Release v1.9
When a pre-stop handler is specified in the container lifecycle using a ‘HttpGet’ action, then the handler MUST be invoked before the container is terminated. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a pre-stop that invokes the server pod to validate that the pre-stop is executed.



## [Networking, intra pod http](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/networking.go#L41)

### Release v1.9
Try to hit all endpoints through a test container, retry 5 times,
expect exactly one unique hostname. Each of these endpoints reports
its own hostname.

Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.
This test is marked LinuxOnly since HostNetwork is not supported on other platforms like Windows.



## [Networking, intra pod udp](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/networking.go#L55)

### Release v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a udp port on the each of service proxy endpoints in the cluster and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.
This test is marked LinuxOnly since HostNetwork is not supported on other platforms like Windows.



## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/networking.go#L69)

### Release v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=tcp)  and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.
This test is marked LinuxOnly since HostNetwork is not supported on other platforms like Windows.



## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/networking.go#L83)

### Release v1.9
Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes.
The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=udp)  and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.
This test is marked LinuxOnly since HostNetwork is not supported on other platforms like Windows.



## [Pods, assigned hostip](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/pods.go#L186)

### Release v1.9
Create a Pod. Pod status MUST return successfully and contains a valid IP address.



## [Pods, lifecycle](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/pods.go#L208)

### Release v1.9
A Pod is created with a unique label. Pod MUST be accessible when queried using the label selector upon creation. Add a watch, check if the Pod is running. Pod then deleted, The pod deletion timestamp is observed. The watch MUST return the pod deleted event. Query with the original selector for the Pod MUST return empty list.



## [Pods, update](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/pods.go#L361)

### Release v1.9
Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. Update the pod to change the value of the Label. Query for the Pod with the new value for the label MUST be successful.



## [Pods, ActiveDeadlineSeconds](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/pods.go#L415)

### Release v1.9
Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. The Pod is updated with ActiveDeadlineSeconds set on the Pod spec. Pod MUST terminate of the specified time elapses.



## [Pods, service environment variables](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/pods.go#L461)

### Release v1.9
Create a server Pod listening on port 9376. A Service called fooservice is created for the server Pod listening on port 8765 targeting port 8080. If a new Pod is created in the cluster then the Pod MUST have the fooservice environment variables available from this new Pod. The new create Pod MUST have environment variables such as FOOSERVICE_SERVICE_HOST, FOOSERVICE_SERVICE_PORT, FOOSERVICE_PORT, FOOSERVICE_PORT_8765_TCP_PORT, FOOSERVICE_PORT_8765_TCP_PROTO, FOOSERVICE_PORT_8765_TCP and FOOSERVICE_PORT_8765_TCP_ADDR that are populated with proper values.



## [Pods, remote command execution over websocket](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/pods.go#L553)

### Release v1.13
A Pod is created. Websocket is created to retrieve exec command output from this pod.
Message retrieved form Websocket MUST match with expected exec command output.



## [Pods, logs from websockets](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/pods.go#L635)

### Release v1.13
A Pod is created. Websocket is created to retrieve log of a container from this pod.
Message retrieved form Websocket MUST match with container's output.



## [Projected Volume, multiple projections](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_combined.go#L40)

### Release v1.9
Test multiple projections

A Pod is created with a projected volume source for secrets, configMap and downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the secrets, configMap values and the cpu and memory limits as well as cpu and memory requests from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, ConfigMap, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L42)

### Release v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with default permission mode. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw-r—-r—-.



## [Projected Volume, ConfigMap, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L52)

### Release v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with permission mode set to 0400. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -r——-——-—-.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Projected Volume, ConfigMap, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L69)

### Release v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap as non-root user with uid 1000. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw—r——r—-.



## [Projected Volume, ConfigMap, mapped](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L84)

### Release v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with default permission mode. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -rw—r——r—-.



## [Projected Volume, ConfigMap, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L94)

### Release v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap with permission mode set to 0400. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r-—r——r—-.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Projected Volume, ConfigMap, mapped, non-root user](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L104)

### Release v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap as non-root user with uid 1000. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r-—r——r—-.



## [Projected Volume, ConfigMap, update](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L119)

### Release v1.9
A Pod is created with projected volume source ‘ConfigMap’ to store a configMap and performs a create and update to new value. Pod MUST be able to create the configMap with value-1. Pod MUST be able to update the value in the confgiMap to value-2.



## [Projected Volume, ConfigMap, create, update and delete](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L207)

### Release v1.9
Create a Pod with three containers with ConfigMaps namely a create, update and delete container. Create Container when started MUST not have configMap, update and delete containers MUST be created with a ConfigMap value as ‘value-1’. Create a configMap in the create container, the Pod MUST be able to read the configMap from the create container. Update the configMap in the update container, Pod MUST be able to read the updated configMap value. Delete the configMap in the delete container. Pod MUST fail to read the configMap from the delete container.



## [Projected Volume, ConfigMap, multiple volume paths](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_configmap.go#L408)

### Release v1.9
A Pod is created with a projected volume source ‘ConfigMap’ to store a configMap. The configMap is mapped to two different volume mounts. Pod MUST be able to read the content of the configMap successfully from the two volume mounts.



## [Projected Volume, DownwardAPI, pod name](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L49)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L64)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r—-—————.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L80)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r—-—————.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Projected Volume, DownwardAPI, update labels](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L126)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and label items. Pod MUST be able to read the labels from the mounted DownwardAPIVolumeFiles. Labels are then updated. Pod MUST be able to read the updated values for the Labels.



## [Projected Volume, DownwardAPI, update annotation](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L158)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and annotation items. Pod MUST be able to read the annotations from the mounted DownwardAPIVolumeFiles. Annotations are then updated. Pod MUST be able to read the updated values for the Annotations.



## [Projected Volume, DownwardAPI, CPU limits](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L192)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory limits](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L206)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, CPU request](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L220)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu request from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory request](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L234)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory request from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, CPU limit, node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L248)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default cpu limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, DownwardAPI, memory limit, node allocatable](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_downwardapi.go#L260)

### Release v1.9
A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default memory limits from the mounted DownwardAPIVolumeFiles.



## [Projected Volume, Secrets, volume mode default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_secret.go#L42)

### Release v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with default permission mode. Pod MUST be able to read the content of the key successfully and the mode MUST be -rw-r--r-- by default.



## [Projected Volume, Secrets, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_secret.go#L52)

### Release v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with permission mode set to 0x400 on the Pod. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Project Volume, Secrets, non-root, custom fsGroup](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_secret.go#L63)

### Release v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key. The volume has permission mode set to 0440, fsgroup set to 1001 and user set to non-root uid of 1000. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-r————-.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [Projected Volume, Secrets, mapped](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_secret.go#L74)

### Release v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with default permission mode. The secret is also mapped to a custom path. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————— on the mapped volume.



## [Projected Volume, Secrets, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_secret.go#L84)

### Release v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key with permission mode set to 0400. The secret is also mapped to a specific name. Pod MUST be able to read the content of the key successfully and the mode MUST be -r—-—————— on the mapped volume.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Projected Volume, Secrets, mapped, multiple paths](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_secret.go#L115)

### Release v1.9
A Pod is created with a projected volume source ‘secret’ to store a secret with a specified key. The secret is mapped to two different volume mounts. Pod MUST be able to read the content of the key successfully from the two volume mounts and the mode MUST be -r—-—————— on the mapped volumes.



## [Projected Volume, Secrets, create, update delete](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/projected_secret.go#L210)

### Release v1.9
Create a Pod with three containers with secrets namely a create, update and delete container. Create Container when started MUST no have a secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.



## [Container Runtime, Restart Policy, Pod Phases](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/runtime.go#L46)

### Release v1.13
If the restart policy is set to ‘Always’, Pod MUST be restarted when terminated, If restart policy is ‘OnFailure’, Pod MUST be started only if it is terminated with non-zero exit code. If the restart policy is ‘Never’, Pod MUST never be restarted. All these three test cases MUST verify the restart counts accordingly.



## [Container Runtime blackbox test on terminated container should report termination message  if TerminationMessagePath is set as non-root user and at a non-default path](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/runtime.go#L193)

### Release v1.15
Name: Container Runtime, TerminationMessagePath, non-root user and non-default path
Create a pod with a container to run it as a non-root user with a custom TerminationMessagePath set. Pod redirects the output to the provided path successfully. When the container is terminated, the termination message MUST match the expected output logged in the provided custom path.
[LinuxOnly]: Tagged LinuxOnly due to use of 'uid' and unable to mount files in Windows Containers.



## [Container Runtime blackbox test on terminated container should report termination message  from log output if TerminationMessagePolicy FallbackToLogsOnError is set](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/runtime.go#L217)

### Release v1.15
Name: Container Runtime, TerminationMessage, from container's log output of failing container
Create a pod with an container. Container's output is recorded in log and container exits with an error. When container is terminated, termination message MUST match the expected output recorded from container's log.
[LinuxOnly]: Cannot mount files in Windows Containers.



## [Container Runtime blackbox test on terminated container should report termination message  as empty when pod succeeds and TerminationMessagePolicy FallbackToLogsOnError is set](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/runtime.go#L234)

### Release v1.15
Name: Container Runtime, TerminationMessage, from log output of succeeding container
Create a pod with an container. Container's output is recorded in log and container exits successfully without an error. When container is terminated, terminationMessage MUST have no content as container succeed.
[LinuxOnly]: Cannot mount files in Windows Containers.



## [Container Runtime blackbox test on terminated container should report termination message  from file when pod succeeds and TerminationMessagePolicy FallbackToLogsOnError is set](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/runtime.go#L251)

### Release v1.15
Name: Container Runtime, TerminationMessage, from file of succeeding container
Create a pod with an container. Container's output is recorded in a file and the container exits successfully without an error. When container is terminated, terminationMessage MUST match with the content from file.
[LinuxOnly]: Cannot mount files in Windows Containers.



## [Secrets, pod environment field](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets.go#L39)

### Release v1.9
Create a secret. Create a Pod with Container that declares a environment variable which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.



## [Secrets, pod environment from source](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets.go#L88)

### Release v1.9
Create a secret. Create a Pod with Container that declares a environment variable using ‘EnvFrom’ which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.



## [Secrets, with empty-key](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets.go#L133)

### Release v1.15
Attempt to create a Secret with an empty key. The creation MUST fail.



## [Secrets Volume, default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L42)

### Release v1.9
Create a secret. Create a Pod with secret volume source configured into the container. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -rw-r--r-- by default.



## [Secrets Volume, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L52)

### Release v1.9
Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r——--—-—- by default.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Secrets Volume, volume mode 0440, fsGroup 1001 and uid 1000](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L63)

### Release v1.9
Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x440 as a non-root user with uid 1000 and fsGroup id 1001. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r——r-—-—- by default.
This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.



## [Secrets Volume, mapping](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L74)

### Release v1.9
Create a secret. Create a Pod with secret volume source configured into the container with a custom path. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -rw—r-—r—- by default.



## [Secrets Volume, mapping, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L84)

### Release v1.9
Create a secret. Create a Pod with secret volume source configured into the container with a custom path and file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -r-—r-—r—-.
This test is marked LinuxOnly since Windows does not support setting specific file permissions.



## [Secrets Volume, volume mode default, secret with same name in different namespace](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L94)

### Release v1.12
Create a secret with same name in two namespaces. Create a Pod with secret volume source configured into the container. Pod MUST be able to read the secrets from the mounted volume from the container runtime and only secrets which are associated with namespace where pod is created. The file mode of the secret MUST be -rw-r--r-- by default.



## [Secrets Volume, mapping multiple volume paths](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L120)

### Release v1.9
Create a secret. Create a Pod with two secret volume sources configured into the container in to two different custom paths. Pod MUST be able to read the secret from the both the mounted volumes from the two specified custom paths.



## [Secrets Volume, create, update and delete](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/secrets_volume.go#L199)

### Release v1.9
Create a Pod with three containers with secrets volume sources namely a create, update and delete container. Create Container when started MUST not have secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.



## [Security Context, runAsUser=65534](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/security_context.go#L81)

### Release v1.15
Container is created with runAsUser option by passing uid 65534 to run as unpriviledged user. Pod MUST be in Succeeded phase.
[LinuxOnly]: This test is marked as LinuxOnly since Windows does not support running as UID / GID.



## [Security Context, readOnlyRootFilesystem=false.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/security_context.go#L220)

### Release v1.15
Container is configured to run with readOnlyRootFilesystem to false.
Write operation MUST be allowed and Pod MUST be in Succeeded state.



## [Security Context, privileged=false.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/security_context.go#L262)

### Release v1.15
Create a container to run in unprivileged mode by setting pod's SecurityContext Privileged option as false. Pod MUST be in Succeeded phase.
[LinuxOnly]: This test is marked as LinuxOnly since it runs a Linux-specific command.



## [Security Context, allowPrivilegeEscalation=false.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/common/security_context.go#L343)

### Release v1.15
Configuring the allowPrivilegeEscalation to false, does not allow the privilege escalation operation.
A container is configured with allowPrivilegeEscalation=false and a given uid (1000) which is not 0.
When the container is run, container's output MUST match with expected output verifying container ran with given uid i.e. uid=1000.
[LinuxOnly]: This test is marked LinuxOnly since Windows does not support running as UID / GID, or privilege escalation.



## [Kubectl, replication controller](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L339)

### Release v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2.



## [Kubectl, scale replication controller](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L352)

### Release v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Update the replicaset to 1. Number of running instances of the Pod MUST be 1. Update the replicaset to 2. Number of running instances of the Pod MUST be 2.



## [Kubectl, rolling update replication controller](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L373)

### Release v1.9
Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Run a rolling update to run a different version of the container. All running instances SHOULD now be running the newer version of the container as part of the rolling update.



## [Kubectl, guestbook application](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L406)

### Release v1.9
Create Guestbook application that contains an agnhost master server, 2 agnhost slaves, frontend application, frontend service and agnhost master service and agnhost slave service. Using frontend service, the test will write an entry into the guestbook application which will store the entry into the backend agnhost store. Application flow MUST work as expected and the data written MUST be available to read.



## [Kubectl, check version v1](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L878)

### Release v1.9
Run kubectl to get api versions, output MUST contain returned versions with ‘v1’ listed.



## [Kubectl, cluster info](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1114)

### Release v1.9
Call kubectl to get cluster-info, output MUST contain cluster-info returned and Kubernetes Master SHOULD be running.



## [Kubectl, describe pod or rc](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1140)

### Release v1.9
Deploy an agnhost controller and an agnhost service. Kubectl describe pods SHOULD return the name, namespace, labels, state and other information as expected. Kubectl describe on rc, service, node and namespace SHOULD also return proper information.



## [Kubectl, create service, replication controller](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1281)

### Release v1.9
Create a Pod running agnhost listening to port 6379. Using kubectl expose the agnhost master replication controllers at port 1234. Validate that the replication controller is listening on port 1234 and the target port is set to 6379, port that agnhost master is listening. Using kubectl expose the agnhost master as a service at port 2345. The service MUST be listening on port 2345 and the target port is set to 6379, port that agnhost master is listening.



## [Kubectl, label update](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1378)

### Release v1.9
When a Pod is running, update a Label using ‘kubectl label’ command. The label MUST be created in the Pod. A ‘kubectl get pod’ with -l option on the container MUST verify that the label can be read back. Use ‘kubectl label label-’ to remove the label. ‘kubectl get pod’ with -l option SHOULD not list the deleted label as the label is removed.



## [Kubectl, logs](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1465)

### Release v1.9
When a Pod is running then it MUST generate logs.
Starting a Pod should have a expected log line. Also log command options MUST work as expected and described below.
‘kubectl logs -tail=1’ should generate a output of one line, the last line in the log.
‘kubectl --limit-bytes=1’ should generate a single byte output.
‘kubectl --tail=1 --timestamp should generate one line with timestamp in RFC3339 format
‘kubectl --since=1s’ should output logs that are only 1 second older from now
‘kubectl --since=24h’ should output logs that are only 1 day older from now



## [Kubectl, patch to annotate](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1525)

### Release v1.9
Start running agnhost and a replication controller. When the pod is running, using ‘kubectl patch’ command add annotations. The annotation MUST be added to running pods and SHOULD be able to read added annotations from each of the Pods running under the replication controller.



## [Kubectl, version](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1559)

### Release v1.9
The command ‘kubectl version’ MUST return the major, minor versions,  GitCommit, etc of the Client and the Server that the kubectl is configured to connect to.



## [Kubectl, run default](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1591)

### Release v1.9
Command ‘kubectl run’ MUST create a running pod with possible replicas given a image using the option --image=’httpd’. The running Pod SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command.



## [Kubectl, run rc](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1626)

### Release v1.9
Command ‘kubectl run’ MUST create a running rc with default one replicas given a image using the option --image=’httpd’. The running replication controller SHOULD have one container and the container SHOULD be running the image specified in the ‘run’ command. Also there MUST be 1 pod controlled by this replica set running 1 container with the image specified. A ‘kubetctl logs’ command MUST return the logs from the container in the replication controller.



## [Kubectl, rolling update](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1687)

### Release v1.9
Command ‘kubectl rolling-update’ MUST replace the specified replication controller with a new replication controller by updating one pod at a time to use the new Pod spec.



## [Kubectl, run deployment](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1737)

### Release v1.9
Command ‘kubectl run’ MUST create a deployment, with --generator=deployment, when a image name is specified in the run command. After the run command there SHOULD be a deployment that should exist with one container running the specified image. Also there SHOULD be a Pod that is controlled by this deployment, with a container running the specified image.



## [Kubectl, run job](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1782)

### Release v1.9
Command ‘kubectl run’ MUST create a job, with --generator=job, when a image name is specified in the run command. After the run command there SHOULD be a job that should exist with one container running the specified image. Also there SHOULD be a restart policy on the job spec that SHOULD match the command line.



## [Kubectl, run pod](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1855)

### Release v1.9
Command ‘kubectl run’ MUST create a pod, with --generator=run-pod, when a image name is specified in the run command. After the run command there SHOULD be a pod that should exist with one container running the specified image.



## [Kubectl, replace](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1891)

### Release v1.9
Command ‘kubectl replace’ on a existing Pod with a new spec MUST update the image of the container running in the Pod. A -f option to ‘kubectl replace’ SHOULD force to re-create the resource. The new Pod SHOULD have the container with new change to the image.



## [Kubectl, run job with --rm](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1932)

### Release v1.9
Start a job with a Pod using ‘kubectl run’ but specify --rm=true. Wait for the Pod to start running by verifying that there is output as expected. Now verify that the job has exited and cannot be found. With --rm=true option the job MUST start by running the image specified and then get deleted itself.



## [Kubectl, proxy port zero](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1962)

### Release v1.9
TODO: test proxy options (static, prefix, etc)

Start a proxy server on port zero by running ‘kubectl proxy’ with --port=0. Call the proxy server by requesting api versions from unix socket. The proxy server MUST provide at least one version string.



## [Kubectl, proxy socket](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/kubectl/kubectl.go#L1987)

### Release v1.9
Start a proxy server on by running ‘kubectl proxy’ with --unix-socket=<some path>. Call the proxy server by requesting api versions from  http://locahost:0/api. The proxy server MUST provide at least one version string



## [DNS, cluster](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L44)

### Release v1.9
When a Pod is created, the pod MUST be able to resolve cluster dns entries such as kubernetes.default via DNS.



## [DNS, cluster](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L111)

### Release v1.14
When a Pod is created, the pod MUST be able to resolve cluster dns entries such as kubernetes.default via /etc/hosts.



## [DNS, services](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L131)

### Release v1.9
When a headless service is created, the service MUST be able to resolve all the required service endpoints. When the service is created, any pod in the same namespace must be able to resolve the service by all of the expected DNS names.



## [DNS, PQDN for services](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L187)

### Release v1.17
Create a headless service and normal service. Both the services MUST be able to resolve partial qualified DNS entries of their service endpoints by serving A records and SRV records.
[LinuxOnly]: As Windows currently does not support resolving PQDNs.



## [DNS, resolve the hostname](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L242)

### Release v1.15
Create a headless service with label. Create a Pod with label to match service's label, with hostname and a subdomain same as service name.
Pod MUST be able to resolve its fully qualified domain name as well as hostname by serving an A record at that name.



## [DNS, resolve the subdomain](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L284)

### Release v1.15
Create a headless service with label. Create a Pod with label to match service's label, with hostname and a subdomain same as service name.
Pod MUST be able to resolve its fully qualified domain name as well as subdomain by serving an A record at that name.



## [DNS, for ExternalName Services](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L327)

### Release v1.15
Create a service with externalName. Pod MUST be able to resolve the address for this service via CNAME. When externalName of this service is changed, Pod MUST resolve to new DNS entry for the service.
Change the service type from externalName to ClusterIP, Pod MUST resolve DNS to the service by serving A records.



## [DNS, custom dnsConfig](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/dns.go#L405)

### Release v1.17
Create a Pod with DNSPolicy as None and custom DNS configuration, specifying nameservers and search path entries.
Pod creation MUST be successful and provided DNS configuration MUST be configured in the Pod.



## [Proxy, logs port endpoint](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/proxy.go#L69)

### Release v1.9
Select any node in the cluster to invoke /proxy/nodes/<nodeip>:10250/logs endpoint. This endpoint MUST be reachable.



## [Proxy, logs endpoint](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/proxy.go#L76)

### Release v1.9
Select any node in the cluster to invoke /proxy/nodes/<nodeip>//logs endpoint. This endpoint MUST be reachable.



## [Proxy, logs service endpoint](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/proxy.go#L85)

### Release v1.9
using the porter image to serve content, access the content
(of multiple pods?) from multiple (endpoints/services?)

Select any node in the cluster to invoke  /logs endpoint  using the /nodes/proxy subresource from the kubelet port. This endpoint MUST be reachable.



## [Kubernetes Service](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L162)

### Release v1.9
By default when a kubernetes cluster is running there MUST be a ‘kubernetes’ service running in the cluster.



## [Service, endpoints](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L172)

### Release v1.9
Create a service with a endpoint without any Pods, the service MUST run and show empty endpoints. Add a pod to the service and the service MUST validate to show all the endpoints for the ports exposed by the Pod. Add another Pod then the list of all Ports exposed by both the Pods MUST be valid and have corresponding service endpoint. Once the second Pod is deleted then set of endpoint MUST be validated to show only ports from the first container that are exposed. Once both pods are deleted the endpoints from the service MUST be empty.



## [Service, endpoints with multiple ports](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L225)

### Release v1.9
Create a service with two ports but no Pods are added to the service yet.  The service MUST run and show empty set of endpoints. Add a Pod to the first port, service MUST list one endpoint for the Pod on that port. Add another Pod to the second port, service MUST list both the endpoints. Delete the first Pod and the service MUST list only the endpoint to the second Pod. Delete the second Pod and the service must now have empty set of endpoints.



## [Service, NodePort Service](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L581)

### Release v1.16
Create a TCP NodePort service, and test reachability from a client Pod.
The client Pod MUST be able to access the NodePort service by service name and cluster
IP on the service port, and on nodes' internal and external IPs on the NodePort.



## [Service, change type, ExternalName to ClusterIP](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L1050)

### Release v1.16
Create a service of type ExternalName, pointing to external DNS. ClusterIP MUST not be assigned to the service.
Update the service from ExternalName to ClusterIP by removing ExternalName entry, assigning port 80 as service port and TCP as protocol.
Service update MUST be successful by assigning ClusterIP to the service and it MUST be reachable over serviceName and ClusterIP on provided service port.



## [Service, change type, ExternalName to NodePort](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L1089)

### Release v1.16
Create a service of type ExternalName, pointing to external DNS. ClusterIP MUST not be assigned to the service.
Update the service from ExternalName to NodePort, assigning port 80 as service port and, TCP as protocol.
service update MUST be successful by exposing service on every node's IP on dynamically assigned NodePort and, ClusterIP MUST be assigned to route service requests.
Service MUST be reachable over serviceName and the ClusterIP on servicePort. Service MUST also be reachable over node's IP on NodePort.



## [Service, change type, ClusterIP to ExternalName](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L1127)

### Release v1.16
Create a service of type ClusterIP. Service creation MUST be successful by assigning ClusterIP to the service.
Update service type from ClusterIP to ExternalName by setting CNAME entry as externalName. Service update MUST be successful and service MUST not has associated ClusterIP.
Service MUST be able to resolve to IP address by returning A records ensuring service is pointing to provided externalName.



## [Service, change type, NodePort to ExternalName](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service.go#L1167)

### Release v1.16
Create a service of type NodePort. Service creation MUST be successful by exposing service on every node's IP on dynamically assigned NodePort and, ClusterIP MUST be assigned to route service requests.
Update the service type from NodePort to ExternalName by setting CNAME entry as externalName. Service update MUST be successful and, MUST not has ClusterIP associated with the service and, allocated NodePort MUST be released.
Service MUST be able to resolve to IP address by returning A records ensuring service is pointing to provided externalName.



## [Service endpoint latency, thresholds](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/network/service_latency.go#L54)

### Release v1.9
Run 100 iterations of create service with the Pod running the pause image, measure the time it takes for creating the service and the endpoint with the service name is available. These durations are captured for 100 iterations, then the durations are sorted to compute 50th, 90th and 99th percentile. The single server latency MUST not exceed liberally set thresholds of 20s for 50th percentile and 50s for the 90th percentile.



## [Pod events, verify event from Scheduler and Kubelet](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/node/events.go#L42)

### Release v1.9
Create a Pod, make sure that the Pod can be queried. Create a event selector for the kind=Pod and the source is the Scheduler. List of the events MUST be at least one. Create a event selector for kind=Pod and the source is the Kubelet. List of the events MUST be at least one. Both Scheduler and Kubelet MUST send events when scheduling and running a Pod.



## [Pods, delete grace period](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/node/pods.go#L55)

### Release v1.15
Create a pod, make sure it is running. Create a 'kubectl local proxy', capture the port the proxy is listening. Using the http client send a ‘delete’ with gracePeriodSeconds=30. Pod SHOULD get deleted within 30 seconds.



## [Pods, QOS](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/node/pods.go#L187)

### Release v1.9
Create a Pod with CPU and Memory request and limits. Pod status MUST have QOSClass set to PodQOSGuaranteed.



## [Pods, prestop hook](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/node/pre_stop.go#L181)

### Release v1.9
Create a server pod with a rest endpoint '/write' that changes state.Received field. Create a Pod with a pre-stop handle that posts to the /write endpoint on the server Pod. Verify that the Pod with pre-stop hook is running. Delete the Pod with the pre-stop hook. Before the Pod is deleted, pre-stop handler MUST be called when configured. Verify that the Pod is deleted and a call to prestop hook is verified by checking the status received on the server Pod.



## [Scheduler, resource limits](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/scheduling/predicates.go#L249)

### Release v1.9
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

Scheduling Pods MUST fail if the resource limits exceed Machine capacity.



## [Scheduler, node selector not matching](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/scheduling/predicates.go#L356)

### Release v1.9
Test Nodes does not have any label, hence it should be impossible to schedule Pod with
nonempty Selector set.

Create a Pod with a NodeSelector set to a value that does not match a node in the cluster. Since there are no nodes matching the criteria the Pod MUST not be scheduled.



## [Scheduler, node selector matching](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/scheduling/predicates.go#L379)

### Release v1.9
Create a label on the node {k: v}. Then create a Pod with a NodeSelector set to {k: v}. Check to see if the Pod is scheduled. When the NodeSelector matches then Pod MUST be scheduled on that node.



## [Scheduling, HostPort matching and HostIP and Protocol not-matching](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/scheduling/predicates.go#L584)

### Release v1.16
Pods with the same HostPort value MUST be able to be scheduled to the same node
if the HostIP or Protocol is different.



## [Scheduling, HostPort and Protocol match, HostIPs different but one is default HostIP (0.0.0.0)](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/scheduling/predicates.go#L617)

### Release v1.16
Pods with the same HostPort and Protocol, but different HostIPs, MUST NOT schedule to the
same node if one of those IPs is the default HostIP of 0.0.0.0, which represents all IPs on the host.



## [Taint, Pod Eviction on taint removal](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/scheduling/taints.go#L286)

### Release v1.16
The Pod with toleration timeout scheduled on a tainted Node MUST not be
evicted if the taint is removed before toleration time ends.



## [Pod Eviction, Toleration limits](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/scheduling/taints.go#L416)

### Release v1.16
In a multi-pods scenario with tolerationSeconds, the pods MUST be evicted as per
the toleration time limit.



## [EmptyDir Wrapper Volume, Secret and ConfigMap volumes, no conflict](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/storage/empty_dir_wrapper.go#L63)

### Release v1.13
Secret volume and ConfigMap volume is created with data. Pod MUST be able to start with Secret and ConfigMap volumes mounted into the container.



## [EmptyDir Wrapper Volume, ConfigMap volumes, no race](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/storage/empty_dir_wrapper.go#L184)

### Release v1.13
Create 50 ConfigMaps Volumes and 5 replicas of pod with these ConfigMapvolumes mounted. Pod MUST NOT fail waiting for Volumes.



## [SubPath: Reading content from a secret volume.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/storage/subpath.go#L59)

### Release v1.12
Containers in a pod can read content from a secret mounted volume which was configured with a subpath.
This test is marked LinuxOnly since Windows cannot mount individual files in Containers.



## [SubPath: Reading content from a configmap volume.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/storage/subpath.go#L71)

### Release v1.12
Containers in a pod can read content from a configmap mounted volume which was configured with a subpath.
This test is marked LinuxOnly since Windows cannot mount individual files in Containers.



## [SubPath: Reading content from a configmap volume.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/storage/subpath.go#L83)

### Release v1.12
Containers in a pod can read content from a configmap mounted volume which was configured with a subpath and also using a mountpath that is a specific file.
This test is marked LinuxOnly since Windows cannot mount individual files in Containers.



## [SubPath: Reading content from a downwardAPI volume.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/storage/subpath.go#L97)

### Release v1.12
Containers in a pod can read content from a downwardAPI mounted volume which was configured with a subpath.
This test is marked LinuxOnly since Windows cannot mount individual files in Containers.



## [SubPath: Reading content from a projected volume.](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e/storage/subpath.go#L113)

### Release v1.12
Containers in a pod can read content from a projected mounted volume which was configured with a subpath.
This test is marked LinuxOnly since Windows cannot mount individual files in Containers.



## [Pod startup probe restart](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e_node/startup_probe_test.go#L64)

### Release v1.16
A Pod is created with a failing startup probe. The Pod MUST be killed and restarted incrementing restart count to 1, even if liveness would succeed.



## [Pod liveness probe delayed (long) by startup probe](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e_node/startup_probe_test.go#L93)

### Release v1.16
A Pod is created with failing liveness and startup probes. Liveness probe MUST NOT fail until startup probe expires.



## [Pod liveness probe fails after startup success](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e_node/startup_probe_test.go#L122)

### Release v1.16
A Pod is created with failing liveness probe and delayed startup probe that uses ‘exec’ command to cat /temp/health file. The Container is started by creating /tmp/startup after 10 seconds, triggering liveness probe to fail. The Pod MUST now be killed and restarted incrementing restart count to 1.



## [Pod readiness probe, delayed by startup probe](https://github.com/kubernetes/kubernetes/tree/v1.17.0/test/e2e_node/startup_probe_test.go#L151)

### Release v1.16
A Pod is created with startup and readiness probes. The Container is started by creating /tmp/startup after 45 seconds, delaying the ready state by this amount of time. This is similar to the "Pod readiness probe, with initial delay" test.




## **Summary**

Total Conformance Tests: 284, total legacy tests that need conversion: 0, while total tests that need comment sections: 0

