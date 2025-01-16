# Kubernetes Conformance Test Suite -  1.31

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
  Release: v1.13
  Testname: Kubelet, log output, default
  Description: By default the stdout and stderr from the process being executed in a pod MUST be sent to the pod's logs.
*/
framework.ConformanceIt("should print the output to logs [NodeConformance]", func(ctx context.Context) {
```

would generate the following documentation for the test. Note that the "TestName" from the Documentation above will
be used to document the test which make it more human readable. The "Description" field will be used as the
documentation for that test.

### **Output:**
## [Kubelet, log output, default](https://github.com/kubernetes/kubernetes/tree/master/test/e2e/common/node/kubelet.go#L49)

- Added to conformance in release v1.13
- Defined in code as: [k8s.io] Kubelet when scheduling a busybox command in a pod should print the output to logs [NodeConformance] [Conformance]

By default the stdout and stderr from the process being executed in a pod MUST be sent to the pod's logs.

Notational Conventions when documenting the tests with the key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" are to be interpreted as described in [RFC 2119](https://tools.ietf.org/html/rfc2119).

Note: Please see the Summary at the end of this document to find the number of tests documented for conformance.

## **List of Tests**
## [Priority and Fairness FlowSchema API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/flowcontrol.go#L270)

- Added to conformance in release v1.29
- Defined in code as: [sig-api-machinery] API priority and fairness should support FlowSchema API operations [Conformance]

 The flowcontrol.apiserver.k8s.io API group MUST exist in the /apis discovery document. The flowcontrol.apiserver.k8s.io/v1 API group/version MUST exist in the /apis/flowcontrol.apiserver.k8s.io discovery document. The flowschemas and flowschemas/status resources MUST exist in the /apis/flowcontrol.apiserver.k8s.io/v1 discovery document. The flowschema resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [Priority and Fairness PriorityLevelConfiguration API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/flowcontrol.go#L514)

- Added to conformance in release v1.29
- Defined in code as: [sig-api-machinery] API priority and fairness should support PriorityLevelConfiguration API operations [Conformance]

 The flowcontrol.apiserver.k8s.io API group MUST exist in the /apis discovery document. The flowcontrol.apiserver.k8s.io/v1 API group/version MUST exist in the /apis/flowcontrol.apiserver.k8s.io discovery document. The prioritylevelconfiguration and prioritylevelconfiguration/status resources MUST exist in the /apis/flowcontrol.apiserver.k8s.io/v1 discovery document. The prioritylevelconfiguration resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [Admission webhook, list mutating webhooks](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L643)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] listing mutating webhooks should work [Conformance]

Create 10 mutating webhook configurations, all with a label. Attempt to list the webhook configurations matching the label; all the created webhook configurations MUST be present. Attempt to create an object; the object MUST be mutated. Attempt to remove the webhook configurations matching the label with deletecollection; all webhook configurations MUST be deleted. Attempt to create an object; the object MUST NOT be mutated.

## [Admission webhook, list validating webhooks](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L569)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] listing validating webhooks should work [Conformance]

Create 10 validating webhook configurations, all with a label. Attempt to list the webhook configurations matching the label; all the created webhook configurations MUST be present. Attempt to create an object; the create MUST be denied. Attempt to remove the webhook configurations matching the label with deletecollection; all webhook configurations MUST be deleted. Attempt to create an object; the create MUST NOT be denied.

## [Admission webhook, update mutating webhook](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L495)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] patching/updating a mutating webhook should work [Conformance]

Register a mutating admission webhook configuration. Update the webhook to not apply to the create operation and attempt to create an object; the webhook MUST NOT mutate the object. Patch the webhook to apply to the create operation again and attempt to create an object; the webhook MUST mutate the object.

## [Admission webhook, update validating webhook](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L400)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] patching/updating a validating webhook should work [Conformance]

Register a validating admission webhook configuration. Update the webhook to not apply to the create operation and attempt to create an object; the webhook MUST NOT deny the create. Patch the webhook to apply to the create operation again and attempt to create an object; the webhook MUST deny the create.

## [Mutating Admission webhook, create and update mutating webhook configuration with matchConditions](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L763)

- Added to conformance in release v1.28
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should be able to create and update mutating webhook configurations with match conditions [Conformance]

Register a mutating webhook configuration. Verify that the match conditions field are properly stored in the api-server.  Update the mutating webhook configuration and retrieve it; the retrieved object must contain the newly update matchConditions fields.

## [Validating Admission webhook, create and update validating webhook configuration with matchConditions](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L712)

- Added to conformance in release v1.28
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should be able to create and update validating webhook configurations with match conditions [Conformance]

Register a validating webhook configuration. Verify that the match conditions field are properly stored in the api-server.  Update the validating webhook configuration and retrieve it; the retrieved object must contain the newly update matchConditions fields.

## [Admission webhook, deny attach](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L207)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should be able to deny attaching pod [Conformance]

Register an admission webhook configuration that denies connecting to a pod's attach sub-resource. Attempts to attach MUST be denied.

## [Admission webhook, deny custom resource create and delete](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L218)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should be able to deny custom resource creation, update and deletion [Conformance]

Register an admission webhook configuration that denies creation, update and deletion of custom resources. Attempts to create, update and delete custom resources MUST be denied.

## [Admission webhook, deny create](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L196)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should be able to deny pod and configmap creation [Conformance]

Register an admission webhook configuration that admits pod and configmap. Attempts to create non-compliant pods and configmaps, or update/patch compliant pods and configmaps to be non-compliant MUST be denied. An attempt to create a pod that causes a webhook to hang MUST result in a webhook timeout error, and the pod creation MUST be denied. An attempt to create a non-compliant configmap in a whitelisted namespace based on the webhook namespace selector MUST be allowed.

## [Admission webhook, deny custom resource definition](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L298)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should deny crd creation [Conformance]

Register a webhook that denies custom resource definition create. Attempt to create a custom resource definition; the create request MUST be denied.

## [Admission webhook, honor timeout](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L368)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should honor timeout [Conformance]

Using a webhook that waits 5 seconds before admitting objects, configure the webhook with combinations of timeouts and failure policy values. Attempt to create a config map with each combination. Requests MUST timeout if the configured webhook timeout is less than 5 seconds and failure policy is fail. Requests must not timeout if the failure policy is ignore. Requests MUST NOT timeout if configured webhook timeout is 10 seconds (much longer than the webhook wait duration).

## [Admission webhook, discovery document](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L116)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should include webhook resources in discovery documents [Conformance]

The admissionregistration.k8s.io API group MUST exists in the /apis discovery document. The admissionregistration.k8s.io/v1 API group/version MUST exists in the /apis discovery document. The mutatingwebhookconfigurations and validatingwebhookconfigurations resources MUST exist in the /apis/admissionregistration.k8s.io/v1 discovery document.

## [Admission webhook, ordered mutation](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L247)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should mutate configmap [Conformance]

Register a mutating webhook configuration with two webhooks that admit configmaps, one that adds a data key if the configmap already has a specific key, and another that adds a key if the key added by the first webhook is present. Attempt to create a config map; both keys MUST be added to the config map.

## [Admission webhook, mutate custom resource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L282)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should mutate custom resource [Conformance]

Register a webhook that mutates a custom resource. Attempt to create custom resource object; the custom resource MUST be mutated.

## [Admission webhook, mutate custom resource with different stored version](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L312)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should mutate custom resource with different stored version [Conformance]

Register a webhook that mutates custom resources on create and update. Register a custom resource definition using v1 as stored version. Create a custom resource. Patch the custom resource definition to use v2 as the stored version. Attempt to patch the custom resource with a new field and value; the patch MUST be applied successfully.

## [Admission webhook, mutate custom resource with pruning](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L329)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should mutate custom resource with pruning [Conformance]

Register mutating webhooks that adds fields to custom objects. Register a custom resource definition with a schema that includes only one of the data keys added by the webhooks. Attempt to a custom resource; the fields included in the schema MUST be present and field not included in the schema MUST NOT be present.

## [Mutating Admission webhook, mutating webhook excluding object with specific name](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L863)

- Added to conformance in release v1.28
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should mutate everything except 'skip-me' configmaps [Conformance]

Create a mutating webhook configuration with matchConditions field that will reject all resources except ones with a specific name 'skip-me'. Create a configMap with the name 'skip-me' and verify that it's mutated. Create a configMap with a different name than 'skip-me' and verify that it's mustated.

## [Admission webhook, mutation with defaulting](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L258)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should mutate pod and apply defaults after mutation [Conformance]

Register a mutating webhook that adds an InitContainer to pods. Attempt to create a pod; the InitContainer MUST be added the TerminationMessagePolicy MUST be defaulted.

## [Admission webhook, admission control not allowed on webhook configuration objects](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L270)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should not be able to mutate or prevent deletion of webhook configuration objects [Conformance]

Register webhooks that mutate and deny deletion of webhook configuration objects. Attempt to create and delete a webhook configuration object; both operations MUST be allowed and the webhook configuration object MUST NOT be mutated the webhooks.

## [Mutating Admission webhook, reject mutating webhook configurations with invalid matchConditions](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L838)

- Added to conformance in release v1.28
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should reject mutating webhook configurations with invalid match conditions [Conformance]

Creates a mutating webhook configuration with an invalid CEL expression in it's matchConditions field. The api-server server should reject the create request with a "compilation failed" error message.

## [Validing Admission webhook, reject validating webhook configurations with invalid matchConditions](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L814)

- Added to conformance in release v1.28
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should reject validating webhook configurations with invalid match conditions [Conformance]

Creates a validating webhook configuration with an invalid CEL expression in it's matchConditions field. The api-server server should reject the create request with a "compilation failed" error message.

## [Admission webhook, fail closed](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/webhook.go#L235)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] AdmissionWebhook [Privileged:ClusterAdmin] should unconditionally reject operations on fail closed webhook [Conformance]

Register a webhook with a fail closed policy and without CA bundle so that it cannot be called. Attempt operations that require the admission webhook; all MUST be denied.

## [Aggregated Discovery Interface](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/aggregated_discovery.go#L259)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] AggregatedDiscovery should support aggregated discovery interface [Conformance]

An apiserver MUST support the Aggregated Discovery client interface. Built-in resources MUST all be present.

## [Aggregated Discovery Interface CRDs](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/aggregated_discovery.go#L303)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] AggregatedDiscovery should support aggregated discovery interface for CRDs [Conformance]

An apiserver MUST support the Aggregated Discovery client interface. Add a CRD to the apiserver. The CRD resource MUST be present in the discovery document.

## [Aggregated Discovery Endpoint Accept Headers](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/aggregated_discovery.go#L151)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] AggregatedDiscovery should support raw aggregated discovery endpoint Accept headers [Conformance]

An apiserver MUST support the Aggregated Discovery endpoint Accept headers. Built-in resources MUST all be present.

## [Aggregated Discovery Endpoint Accept Headers CRDs](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/aggregated_discovery.go#L194)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] AggregatedDiscovery should support raw aggregated discovery request for CRDs [Conformance]

An apiserver MUST support the Aggregated Discovery endpoint Accept headers. Add a CRD to the apiserver. The CRD MUST appear in the discovery document.

## [aggregator-supports-the-sample-apiserver](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/aggregator.go#L98)

- Added to conformance in release v1.17, v1.21, v1.27
- Defined in code as: [sig-api-machinery] Aggregator Should be able to support the 1.17 Sample API Server using the current Aggregator [Conformance]

Ensure that the sample-apiserver code from 1.17 and compiled against 1.17 will work on the current Aggregator/API-Server.

## [Custom Resource Definition Conversion Webhook, convert mixed version list](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_conversion_webhook.go#L174)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourceConversionWebhook [Privileged:ClusterAdmin] should be able to convert a non homogeneous list of CRs [Conformance]

Register a conversion webhook and a custom resource definition. Create a custom resource stored at v1. Change the custom resource definition storage to v2. Create a custom resource stored at v2. Attempt to list the custom resources at v2; the list result MUST contain both custom resources at v2.

## [Custom Resource Definition Conversion Webhook, conversion custom resource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_conversion_webhook.go#L139)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourceConversionWebhook [Privileged:ClusterAdmin] should be able to convert from CR v1 to CR v2 [Conformance]

Register a conversion webhook and a custom resource definition. Create a v1 custom resource. Attempts to read it at v2 MUST succeed.

## [Custom Resource Definition, watch](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_watch.go#L51)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourceDefinition Watch [Privileged:ClusterAdmin] CustomResourceDefinition Watch watch on custom resource definition objects [Conformance]

Create a Custom Resource Definition. Attempt to watch it; the watch MUST observe create, modify and delete events.

## [Custom Resource Definition, create](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/custom_resource_definition.go#L59)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] CustomResourceDefinition resources [Privileged:ClusterAdmin] Simple CustomResourceDefinition creating/deleting custom resource definition objects works [Conformance]

Create a API extension client and define a random custom resource definition. Create the custom resource definition and then delete it. The creation and deletion MUST be successful.

## [Custom Resource Definition, status sub-resource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/custom_resource_definition.go#L146)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourceDefinition resources [Privileged:ClusterAdmin] Simple CustomResourceDefinition getting/updating/patching custom resource definition status sub-resource works [Conformance]

Create a custom resource definition. Attempt to read, update and patch its status sub-resource; all mutating sub-resource operations MUST be visible to subsequent reads.

## [Custom Resource Definition, list](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/custom_resource_definition.go#L86)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourceDefinition resources [Privileged:ClusterAdmin] Simple CustomResourceDefinition listing custom resource definition objects works [Conformance]

Create a API extension client, define 10 labeled custom resource definitions and list them using a label selector; the list result MUST contain only the labeled custom resource definitions. Delete the labeled custom resource definitions via delete collection; the delete MUST be successful and MUST delete only the labeled custom resource definitions.

## [Custom Resource Definition, defaulting](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/custom_resource_definition.go#L270)

- Added to conformance in release v1.17
- Defined in code as: [sig-api-machinery] CustomResourceDefinition resources [Privileged:ClusterAdmin] custom resource defaulting for requests and from storage works [Conformance]

Create a custom resource definition without default. Create CR. Add default and read CR until the default is applied. Create another CR. Remove default, add default for another field and read CR until new field is defaulted, but old default stays.

## [Custom Resource Definition, discovery](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/custom_resource_definition.go#L199)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourceDefinition resources [Privileged:ClusterAdmin] should include custom resource definition resources in discovery documents [Conformance]

Fetch /apis, /apis/apiextensions.k8s.io, and /apis/apiextensions.k8s.io/v1 discovery documents, and ensure they indicate CustomResourceDefinition apiextensions.k8s.io/v1 resources are available.

## [Custom Resource OpenAPI Publish, stop serving version](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L443)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] removes definition from spec when one version gets changed to not be served [Conformance]

Register a custom resource definition with multiple versions. OpenAPI definitions MUST be published for custom resource definitions. Update the custom resource definition to not serve one of the versions. OpenAPI definitions MUST be updated to not contain the version that is no longer served.

## [Custom Resource OpenAPI Publish, version rename](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L392)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] updates the published spec when one version gets renamed [Conformance]

Register a custom resource definition with multiple versions; OpenAPI definitions MUST be published for custom resource definitions. Rename one of the versions of the custom resource definition via a patch; OpenAPI definitions MUST update to reflect the rename.

## [Custom Resource OpenAPI Publish, with x-kubernetes-preserve-unknown-fields at root](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L195)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] works for CRD preserving unknown fields at the schema root [Conformance]

Register a custom resource definition with x-kubernetes-preserve-unknown-fields in the schema root. Attempt to create and apply a change a custom resource, via kubectl; kubectl validation MUST accept unknown properties. Attempt kubectl explain; the output MUST show the custom resource KIND.

## [Custom Resource OpenAPI Publish, with x-kubernetes-preserve-unknown-fields in embedded object](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L237)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] works for CRD preserving unknown fields in an embedded object [Conformance]

Register a custom resource definition with x-kubernetes-preserve-unknown-fields in an embedded object. Attempt to create and apply a change a custom resource, via kubectl; kubectl validation MUST accept unknown properties. Attempt kubectl explain; the output MUST show that x-preserve-unknown-properties is used on the nested field.

## [Custom Resource OpenAPI Publish, with validation schema](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L70)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] works for CRD with validation schema [Conformance]

Register a custom resource definition with a validating schema consisting of objects, arrays and primitives. Attempt to create and apply a change a custom resource using valid properties, via kubectl; kubectl validation MUST pass. Attempt both operations with unknown properties and without required properties; kubectl validation MUST reject the operations. Attempt kubectl explain; the output MUST explain the custom resource properties. Attempt kubectl explain on custom resource properties; the output MUST explain the nested custom resource properties. All validation should be the same.

## [Custom Resource OpenAPI Publish, with x-kubernetes-preserve-unknown-fields in object](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L154)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] works for CRD without validation schema [Conformance]

Register a custom resource definition with x-kubernetes-preserve-unknown-fields in the top level object. Attempt to create and apply a change a custom resource, via kubectl; kubectl validation MUST accept unknown properties. Attempt kubectl explain; the output MUST contain a valid DESCRIPTION stanza.

## [Custom Resource OpenAPI Publish, varying groups](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L277)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] works for multiple CRDs of different groups [Conformance]

Register multiple custom resource definitions spanning different groups and versions; OpenAPI definitions MUST be published for custom resource definitions.

## [Custom Resource OpenAPI Publish, varying kinds](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L358)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] works for multiple CRDs of same group and version but different kinds [Conformance]

Register multiple custom resource definitions in the same group and version but spanning different kinds; OpenAPI definitions MUST be published for custom resource definitions.

## [Custom Resource OpenAPI Publish, varying versions](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/crd_publish_openapi.go#L310)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] CustomResourcePublishOpenAPI [Privileged:ClusterAdmin] works for multiple CRDs of same group but different versions [Conformance]

Register a custom resource definition with multiple versions; OpenAPI definitions MUST be published for custom resource definitions.

## [Discovery, confirm the groupVerion and a resourcefrom each apiGroup](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/discovery.go#L172)

- Added to conformance in release v1.28
- Defined in code as: [sig-api-machinery] Discovery should locate the groupVersion and a resource within each APIGroup [Conformance]

A resourceList MUST be found for each apiGroup that is retrieved. For each apiGroup the groupVersion MUST equal the groupVersion as reported by the schema. From each resourceList a valid resource MUST be found.

## [Discovery, confirm the PreferredVersion for each api group](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/discovery.go#L126)

- Added to conformance in release v1.19
- Defined in code as: [sig-api-machinery] Discovery should validate PreferredVersion for each APIGroup [Conformance]

Ensure that a list of apis is retrieved. Each api group found MUST return a valid PreferredVersion unless the group suffix is example.com.

## [Server side field validation, unknown fields CR no validation schema](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/field_validation.go#L287)

- Added to conformance in release v1.27
- Defined in code as: [sig-api-machinery] FieldValidation should create/apply a CR with unknown fields for CRD with no validation schema [Conformance]

When a CRD does not have a validation schema, it should succeed when a CR with unknown fields is applied.

## [Server side field validation, valid CR with validation schema](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/field_validation.go#L166)

- Added to conformance in release v1.27
- Defined in code as: [sig-api-machinery] FieldValidation should create/apply a valid CR for CRD with validation schema [Conformance]

When a CRD has a validation schema, it should succeed when a valid CR is applied.

## [Server side field validation, unknown fields CR fails validation](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/field_validation.go#L348)

- Added to conformance in release v1.27
- Defined in code as: [sig-api-machinery] FieldValidation should create/apply an invalid CR with extra properties for CRD with validation schema [Conformance]

When a CRD does have a validation schema, it should reject CRs with unknown fields.

## [Server side field validation, CR duplicates](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/field_validation.go#L620)

- Added to conformance in release v1.27
- Defined in code as: [sig-api-machinery] FieldValidation should detect duplicates in a CR when preserving unknown fields [Conformance]

The server should reject CRs with duplicate fields even when preserving unknown fields.

## [Server side field validation, typed object](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/field_validation.go#L62)

- Added to conformance in release v1.27
- Defined in code as: [sig-api-machinery] FieldValidation should detect unknown and duplicate fields of a typed object [Conformance]

It should reject the request if a typed object has unknown or duplicate fields.

## [Server side field validation, unknown metadata](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/field_validation.go#L472)

- Added to conformance in release v1.27
- Defined in code as: [sig-api-machinery] FieldValidation should detect unknown metadata fields in both the root and embedded object of a CR [Conformance]

The server should reject CRs with unknown metadata fields in both the root and embedded objects of a CR.

## [Server side field validation, typed unknown metadata](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/field_validation.go#L115)

- Added to conformance in release v1.27
- Defined in code as: [sig-api-machinery] FieldValidation should detect unknown metadata fields of a typed object [Conformance]

It should reject the request if a typed object has unknown fields in the metadata.

## [Garbage Collector, delete deployment,  propagation policy background](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/garbage_collector.go#L480)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] Garbage collector should delete RS created by deployment when not orphaning [Conformance]

Create a deployment with a replicaset. Once replicaset is created , delete the deployment  with deleteOptions.PropagationPolicy set to Background. Deleting the deployment MUST delete the replicaset created by the deployment and also the Pods that belong to the deployments MUST be deleted.

## [Garbage Collector, delete replication controller, propagation policy background](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/garbage_collector.go#L322)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] Garbage collector should delete pods created by rc when not orphaning [Conformance]

Create a replication controller with 2 Pods. Once RC is created and the first Pod is created, delete RC with deleteOptions.PropagationPolicy set to Background. Deleting the Replication Controller MUST cause pods created by that RC to be deleted.

## [Garbage Collector, delete replication controller, after owned pods](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/garbage_collector.go#L639)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] Garbage collector should keep the rc around until all its pods are deleted if the deleteOptions says so [Conformance]

Create a replication controller with maximum allocatable Pods between 10 and 100 replicas. Once RC is created and the all Pods are created, delete RC with deleteOptions.PropagationPolicy set to Foreground. Deleting the Replication Controller MUST cause pods created by that RC to be deleted before the RC is deleted.

## [Garbage Collector, dependency cycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/garbage_collector.go#L818)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] Garbage collector should not be blocked by dependency circle [Conformance]

Create three pods, patch them with Owner references such that pod1 has pod3, pod2 has pod1 and pod3 has pod2 as owner references respectively. Delete pod1 MUST delete all pods. The dependency cycle MUST not block the garbage collection.

## [Garbage Collector, multiple owners](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/garbage_collector.go#L714)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] Garbage collector should not delete dependents that have both valid owner and owner that's waiting for dependents to be deleted [Conformance]

Create a replication controller RC1, with maximum allocatable Pods between 10 and 100 replicas. Create second replication controller RC2 and set RC2 as owner for half of those replicas. Once RC1 is created and the all Pods are created, delete RC1 with deleteOptions.PropagationPolicy set to Foreground. Half of the Pods that has RC2 as owner MUST not be deleted or have a deletion timestamp. Deleting the Replication Controller MUST not delete Pods that are owned by multiple replication controllers.

## [Garbage Collector, delete deployment, propagation policy orphan](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/garbage_collector.go#L539)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] Garbage collector should orphan RS created by deployment when deleteOptions.PropagationPolicy is Orphan [Conformance]

Create a deployment with a replicaset. Once replicaset is created , delete the deployment  with deleteOptions.PropagationPolicy set to Orphan. Deleting the deployment MUST cause the replicaset created by the deployment to be orphaned, also the Pods created by the deployments MUST be orphaned.

## [Garbage Collector, delete replication controller, propagation policy orphan](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/garbage_collector.go#L380)

- Added to conformance in release v1.9
- Defined in code as: [sig-api-machinery] Garbage collector should orphan pods created by rc if delete options say so [Conformance]

Create a replication controller with maximum allocatable Pods between 10 and 100 replicas. Once RC is created and the all Pods are created, delete RC with deleteOptions.PropagationPolicy set to Orphan. Deleting the Replication Controller MUST cause pods created by that RC to be orphaned.

## [Namespace, apply finalizer to a namespace](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/namespace.go#L400)

- Added to conformance in release v1.26
- Defined in code as: [sig-api-machinery] Namespaces [Serial] should apply a finalizer to a Namespace [Conformance]

Attempt to create a Namespace which MUST be succeed. Updating the namespace with a fake finalizer MUST succeed. The fake finalizer MUST be found. Removing the fake finalizer from the namespace MUST succeed and MUST NOT be found.

## [Namespace, apply update to a namespace](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/namespace.go#L372)

- Added to conformance in release v1.26
- Defined in code as: [sig-api-machinery] Namespaces [Serial] should apply an update to a Namespace [Conformance]

When updating the namespace it MUST succeed and the field MUST equal the new value.

## [Namespace, apply changes to a namespace status](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/namespace.go#L305)

- Added to conformance in release v1.25
- Defined in code as: [sig-api-machinery] Namespaces [Serial] should apply changes to a namespace status [Conformance]

Getting the current namespace status MUST succeed. The reported status phase MUST be active. Given the patching of the namespace status, the fields MUST equal the new values. Given the updating of the namespace status, the fields MUST equal the new values.

## [namespace-deletion-removes-pods](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/namespace.go#L245)

- Added to conformance in release v1.11
- Defined in code as: [sig-api-machinery] Namespaces [Serial] should ensure that all pods are removed when a namespace is deleted [Conformance]

Ensure that if a namespace is deleted then all pods are removed from that namespace.

## [namespace-deletion-removes-services](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/namespace.go#L254)

- Added to conformance in release v1.11
- Defined in code as: [sig-api-machinery] Namespaces [Serial] should ensure that all services are removed when a namespace is deleted [Conformance]

Ensure that if a namespace is deleted then all services are removed from that namespace.

## [Namespace patching](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/namespace.go#L274)

- Added to conformance in release v1.18
- Defined in code as: [sig-api-machinery] Namespaces [Serial] should patch a Namespace [Conformance]

A Namespace is created. The Namespace is patched. The Namespace and MUST now include the new Label.

## [ResourceQuota, apply changes to a ResourceQuota status](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L1066)

- Added to conformance in release v1.26
- Defined in code as: [sig-api-machinery] ResourceQuota should apply changes to a resourcequota status [Conformance]

Attempt to create a ResourceQuota for CPU and Memory quota limits. Creation MUST be successful. Updating the hard status values MUST succeed and the new values MUST be found. The reported hard status values MUST equal the spec hard values. Patching the spec hard values MUST succeed and the new values MUST be found. Patching the hard status values MUST succeed. The reported hard status values MUST equal the new spec hard values. Getting the /status MUST succeed and the reported hard status values MUST equal the spec hard values. Repatching the hard status values MUST succeed. The spec MUST NOT be changed when patching /status.

## [ResourceQuota, update and delete](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L940)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should be able to update and delete ResourceQuota. [Conformance]

Create a ResourceQuota for CPU and Memory quota limits. Creation MUST be successful. When ResourceQuota is updated to modify CPU and Memory quota limits, update MUST succeed with updated values for CPU and Memory limits. When ResourceQuota is deleted, it MUST not be available in the namespace.

## [ResourceQuota, object count quota, configmap](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L331)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should create a ResourceQuota and capture the life of a configMap. [Conformance]

Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a ConfigMap. Its creation MUST be successful and resource usage count against the ConfigMap object MUST be captured in ResourceQuotaStatus of the ResourceQuota. Delete the ConfigMap. Deletion MUST succeed and resource usage count against the ConfigMap object MUST be released from ResourceQuotaStatus of the ResourceQuota.

## [ResourceQuota, object count quota, pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L235)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should create a ResourceQuota and capture the life of a pod. [Conformance]

Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a Pod with resource request count for CPU, Memory, EphemeralStorage and ExtendedResourceName. Pod creation MUST be successful and respective resource usage count MUST be captured in ResourceQuotaStatus of the ResourceQuota. Create another Pod with resource request exceeding remaining quota. Pod creation MUST fail as the request exceeds ResourceQuota limits. Update the successfully created pod's resource requests. Updation MUST fail as a Pod can not dynamically update its resource requirements. Delete the successfully created Pod. Pod Deletion MUST be scuccessful and it MUST release the allocated resource counts from ResourceQuotaStatus of the ResourceQuota.

## [ResourceQuota, object count quota, replicaSet](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L454)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should create a ResourceQuota and capture the life of a replica set. [Conformance]

Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a ReplicaSet. Its creation MUST be successful and resource usage count against the ReplicaSet object MUST be captured in ResourceQuotaStatus of the ResourceQuota. Delete the ReplicaSet. Deletion MUST succeed and resource usage count against the ReplicaSet object MUST be released from ResourceQuotaStatus of the ResourceQuota.

## [ResourceQuota, object count quota, replicationController](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L398)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should create a ResourceQuota and capture the life of a replication controller. [Conformance]

Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a ReplicationController. Its creation MUST be successful and resource usage count against the ReplicationController object MUST be captured in ResourceQuotaStatus of the ResourceQuota. Delete the ReplicationController. Deletion MUST succeed and resource usage count against the ReplicationController object MUST be released from ResourceQuotaStatus of the ResourceQuota.

## [ResourceQuota, object count quota, secret](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L164)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should create a ResourceQuota and capture the life of a secret. [Conformance]

Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a Secret. Its creation MUST be successful and resource usage count against the Secret object and resourceQuota object MUST be captured in ResourceQuotaStatus of the ResourceQuota. Delete the Secret. Deletion MUST succeed and resource usage count against the Secret object MUST be released from ResourceQuotaStatus of the ResourceQuota.

## [ResourceQuota, object count quota, service](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L104)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should create a ResourceQuota and capture the life of a service. [Conformance]

Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a Service. Its creation MUST be successful and resource usage count against the Service object and resourceQuota object MUST be captured in ResourceQuotaStatus of the ResourceQuota. Delete the Service. Deletion MUST succeed and resource usage count against the Service object MUST be released from ResourceQuotaStatus of the ResourceQuota.

## [ResourceQuota, object count quota, resourcequotas](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L79)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should create a ResourceQuota and ensure its status is promptly calculated. [Conformance]

Create a ResourceQuota. Creation MUST be successful and its ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace.

## [ResourceQuota, manage lifecycle of a ResourceQuota](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L999)

- Added to conformance in release v1.25
- Defined in code as: [sig-api-machinery] ResourceQuota should manage the lifecycle of a ResourceQuota [Conformance]

Attempt to create a ResourceQuota for CPU and Memory quota limits. Creation MUST be successful. Attempt to list all namespaces with a label selector which MUST succeed. One list MUST be found. The ResourceQuota when patched MUST succeed. Given the patching of the ResourceQuota, the fields MUST equal the new values. It MUST succeed at deleting a collection of ResourceQuota via a label selector.

## [ResourceQuota, quota scope, BestEffort and NotBestEffort scope](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L859)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should verify ResourceQuota with best effort scope. [Conformance]

Create two ResourceQuotas, one with 'BestEffort' scope and another with 'NotBestEffort' scope. Creation MUST be successful and their ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a 'BestEffort' Pod by not explicitly specifying resource limits and requests. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'BestEffort' scoped ResourceQuota but MUST NOT in 'NotBestEffort' scoped ResourceQuota. Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'BestEffort' scoped ResourceQuota. Create a 'NotBestEffort' Pod by explicitly specifying resource limits and requests. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'NotBestEffort' scoped ResourceQuota but MUST NOT in 'BestEffort' scoped ResourceQuota. Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'NotBestEffort' scoped ResourceQuota.

## [ResourceQuota, quota scope, Terminating and NotTerminating scope](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/resource_quota.go#L746)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] ResourceQuota should verify ResourceQuota with terminating scopes. [Conformance]

Create two ResourceQuotas, one with 'Terminating' scope and another 'NotTerminating' scope. Request and the limit counts for CPU and Memory resources are set for the ResourceQuota. Creation MUST be successful and their ResourceQuotaStatus MUST match to expected used and total allowed resource quota count within namespace. Create a Pod with specified CPU and Memory ResourceRequirements fall within quota limits. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'NotTerminating' scoped ResourceQuota but MUST NOT in 'Terminating' scoped ResourceQuota. Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'NotTerminating' scoped ResourceQuota. Create a pod with specified activeDeadlineSeconds and resourceRequirements for CPU and Memory fall within quota limits. Pod creation MUST be successful and usage count MUST be captured in ResourceQuotaStatus of 'Terminating' scoped ResourceQuota but MUST NOT in 'NotTerminating' scoped ResourceQuota. Delete the Pod. Pod deletion MUST succeed and Pod resource usage count MUST be released from ResourceQuotaStatus of 'Terminating' scoped ResourceQuota.

## [API Chunking, server should return chunks of results for list calls](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/chunking.go#L83)

- Added to conformance in release v1.29
- Defined in code as: [sig-api-machinery] Servers with support for API chunking should return chunks of results for list calls [Conformance]

Create a large number of PodTemplates. Attempt to retrieve the first chunk with limit set; the server MUST return the chunk of the size not exceeding the limit with RemainingItems set in the response. Attempt to retrieve the remaining items by providing the received continuation token and limit; the server MUST return the remaining items in chunks of the size not exceeding the limit, with appropriately set RemainingItems field in the response and with the ResourceVersion returned in the first response. Attempt to list all objects at once without setting the limit; the server MUST return all items in a single response.

## [API Chunking, server should support continue listing from the last key even if the original version has been compacted away](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/chunking.go#L144)

- Added to conformance in release v1.29
- Defined in code as: [sig-api-machinery] Servers with support for API chunking should support continue listing from the last key if the original version has been compacted away, though the list is inconsistent [Slow] [Conformance]

Create a large number of PodTemplates. Attempt to retrieve the first chunk with limit set; the server MUST return the chunk of the size not exceeding the limit with RemainingItems set in the response. Attempt to retrieve the second page until the continuation token expires; the server MUST return a continuation token for inconsistent list continuation. Attempt to retrieve the second page with the received inconsistent list continuation token; the server MUST return the number of items not exceeding the limit, a new continuation token and appropriately set RemainingItems field in the response. Attempt to retrieve the remaining pages by passing the received continuation token; the server MUST return the remaining items in chunks of the size not exceeding the limit, with appropriately set RemainingItems field in the response and with the ResourceVersion returned as part of the inconsistent list.

## [API metadata HTTP return](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/table_conversion.go#L154)

- Added to conformance in release v1.16
- Defined in code as: [sig-api-machinery] Servers with support for Table transformation should return a 406 for a backend which does not implement metadata [Conformance]

Issue a HTTP request to the API. HTTP request MUST return a HTTP status code of 406.

## [ValidatingAdmissionPolicy](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/validatingadmissionpolicy.go#L221)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] ValidatingAdmissionPolicy [Privileged:ClusterAdmin] should allow expressions to refer variables. [Conformance]

 The ValidatingAdmissionPolicy should allow expressions to refer variables.

## [ValidatingAdmissionPolicy API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/validatingadmissionpolicy.go#L406)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] ValidatingAdmissionPolicy [Privileged:ClusterAdmin] should support ValidatingAdmissionPolicy API operations [Conformance]

 The admissionregistration.k8s.io API group MUST exist in the /apis discovery document. The admissionregistration.k8s.io/v1 API group/version MUST exist in the /apis/admissionregistration.k8s.io discovery document. The validatingadmisionpolicy and validatingadmissionpolicy/status resources MUST exist in the /apis/admissionregistration.k8s.io/v1 discovery document. The validatingadmisionpolicy resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [ValidatingadmissionPolicyBinding API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/validatingadmissionpolicy.go#L673)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] ValidatingAdmissionPolicy [Privileged:ClusterAdmin] should support ValidatingAdmissionPolicyBinding API operations [Conformance]

 The admissionregistration.k8s.io API group MUST exist in the /apis discovery document. The admissionregistration.k8s.io/v1 API group/version MUST exist in the /apis/admissionregistration.k8s.io discovery document. The ValidatingadmissionPolicyBinding resources MUST exist in the /apis/admissionregistration.k8s.io/v1 discovery document. The ValidatingadmissionPolicyBinding resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [ValidatingAdmissionPolicy](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/validatingadmissionpolicy.go#L77)

- Added to conformance in release v1.30
- Defined in code as: [sig-api-machinery] ValidatingAdmissionPolicy [Privileged:ClusterAdmin] should validate against a Deployment [Conformance]

 The ValidatingAdmissionPolicy should validate a deployment as the expression defined inside the policy.

## [watch-configmaps-closed-and-restarted](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/watch.go#L191)

- Added to conformance in release v1.11
- Defined in code as: [sig-api-machinery] Watchers should be able to restart watching from the last resource version observed by the previous watch [Conformance]

Ensure that a watch can be reopened from the last resource version observed by the previous watch, and it will continue delivering notifications from that point in time.

## [watch-configmaps-from-resource-version](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/watch.go#L142)

- Added to conformance in release v1.11
- Defined in code as: [sig-api-machinery] Watchers should be able to start watching from a specific resource version [Conformance]

Ensure that a watch can be opened from a particular resource version in the past and only notifications happening after that resource version are observed.

## [watch-configmaps-with-multiple-watchers](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/watch.go#L60)

- Added to conformance in release v1.11
- Defined in code as: [sig-api-machinery] Watchers should observe add, update, and delete watch notifications on configmaps [Conformance]

Ensure that multiple watchers are able to receive all add, update, and delete notifications on configmaps that match a label selector and do not receive notifications for configmaps which do not match that label selector.

## [watch-configmaps-label-changed](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/watch.go#L257)

- Added to conformance in release v1.11
- Defined in code as: [sig-api-machinery] Watchers should observe an object deletion if it stops meeting the requirements of the selector [Conformance]

Ensure that a watched object stops meeting the requirements of a watch's selector, the watch will observe a delete, and will not observe notifications for that object until it meets the selector's requirements again.

## [watch-consistency](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/watch.go#L334)

- Added to conformance in release v1.15
- Defined in code as: [sig-api-machinery] Watchers should receive events on concurrent watches in same order [Conformance]

Ensure that concurrent watches are consistent with each other by initiating an additional watch for events received from the first watch, initiated at the resource version of the event, and checking that all resource versions of all events match. Events are produced from writes on a background goroutine.

## [Confirm a server version](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apimachinery/server_version.go#L41)

- Added to conformance in release v1.19
- Defined in code as: [sig-api-machinery] server version should find the server version [Conformance]

Ensure that an API server version can be retrieved. Both the major and minor versions MUST only be an integer.

## [ControllerRevision, resource lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/controller_revision.go#L126)

- Added to conformance in release v1.25
- Defined in code as: [sig-apps] ControllerRevision [Serial] should manage the lifecycle of a ControllerRevision [Conformance]

Creating a DaemonSet MUST succeed. Listing all ControllerRevisions with a label selector MUST find only one. After patching the ControllerRevision with a new label, the label MUST be found. Creating a new ControllerRevision for the DaemonSet MUST succeed. Listing the ControllerRevisions by label selector MUST find only two. Deleting a ControllerRevision MUST succeed. Listing the ControllerRevisions by label selector MUST find only one. After updating the ControllerRevision with a new label, the label MUST be found. Patching the DaemonSet MUST succeed. Listing the ControllerRevisions by label selector MUST find only two. Deleting a collection of ControllerRevision via a label selector MUST succeed. Listing the ControllerRevisions by label selector MUST find only one. The current ControllerRevision revision MUST be 3.

## [CronJob Suspend](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/cronjob.go#L97)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] CronJob should not schedule jobs when suspended [Slow] [Conformance]

CronJob MUST support suspension, which suppresses creation of new jobs.

## [CronJob ForbidConcurrent](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/cronjob.go#L125)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] CronJob should not schedule new jobs when ForbidConcurrent [Slow] [Conformance]

CronJob MUST support ForbidConcurrent policy, allowing to run single, previous job at the time.

## [CronJob ReplaceConcurrent](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/cronjob.go#L168)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] CronJob should replace jobs when ReplaceConcurrent [Conformance]

CronJob MUST support ReplaceConcurrent policy, allowing to run single, newer job at the time.

## [CronJob AllowConcurrent](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/cronjob.go#L70)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] CronJob should schedule multiple jobs concurrently [Conformance]

CronJob MUST support AllowConcurrent policy, allowing to run multiple jobs at the same time.

## [CronJob API Operations](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/cronjob.go#L341)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] CronJob should support CronJob API operations [Conformance]

 CronJob MUST support create, get, list, watch, update, patch, delete, and deletecollection. CronJob/status MUST support get, update and patch.

## [DaemonSet, list and delete a collection of DaemonSets](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/daemon_set.go#L851)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] Daemon set [Serial] should list and delete a collection of DaemonSets [Conformance]

When a DaemonSet is created it MUST succeed. It MUST succeed when listing DaemonSets via a label selector. It MUST succeed when deleting the DaemonSet via deleteCollection.

## [DaemonSet-FailedPodCreation](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/daemon_set.go#L305)

- Added to conformance in release v1.10
- Defined in code as: [sig-apps] Daemon set [Serial] should retry creating failed daemon pods [Conformance]

A conformant Kubernetes distribution MUST create new DaemonSet Pods when they fail.

## [DaemonSet-Rollback](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/daemon_set.go#L443)

- Added to conformance in release v1.10
- Defined in code as: [sig-apps] Daemon set [Serial] should rollback without unnecessary restarts [Conformance]

A conformant Kubernetes distribution MUST support automated, minimally disruptive rollback of updates to a DaemonSet.

## [DaemonSet-NodeSelection](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/daemon_set.go#L205)

- Added to conformance in release v1.10
- Defined in code as: [sig-apps] Daemon set [Serial] should run and stop complex daemon [Conformance]

A conformant Kubernetes distribution MUST support DaemonSet Pod node selection via label selectors.

## [DaemonSet-Creation](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/daemon_set.go#L177)

- Added to conformance in release v1.10
- Defined in code as: [sig-apps] Daemon set [Serial] should run and stop simple daemon [Conformance]

A conformant Kubernetes distribution MUST support the creation of DaemonSets. When a DaemonSet Pod is deleted, the DaemonSet controller MUST create a replacement Pod.

## [DaemonSet-RollingUpdate](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/daemon_set.go#L385)

- Added to conformance in release v1.10
- Defined in code as: [sig-apps] Daemon set [Serial] should update pod when spec was updated and update strategy is RollingUpdate [Conformance]

A conformant Kubernetes distribution MUST support DaemonSet RollingUpdates.

## [DaemonSet, status sub-resource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/daemon_set.go#L890)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] Daemon set [Serial] should verify changes to a daemon set status [Conformance]

When a DaemonSet is created it MUST succeed. Attempt to read, update and patch its status sub-resource; all mutating sub-resource operations MUST be visible to subsequent reads.

## [Deployment, completes the scaling of a Deployment subresource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L150)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] Deployment Deployment should have a working scale subresource [Conformance]

Create a Deployment with a single Pod. The Pod MUST be verified that it is running. The Deployment MUST get and verify the scale subresource count. The Deployment MUST update and verify the scale subresource. The Deployment MUST patch and verify a scale subresource.

## [Deployment Recreate](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L113)

- Added to conformance in release v1.12
- Defined in code as: [sig-apps] Deployment RecreateDeployment should delete old pods and create new ones [Conformance]

A conformant Kubernetes distribution MUST support the Deployment with Recreate strategy.

## [Deployment RollingUpdate](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L105)

- Added to conformance in release v1.12
- Defined in code as: [sig-apps] Deployment RollingUpdateDeployment should delete old pods and create new ones [Conformance]

A conformant Kubernetes distribution MUST support the Deployment with RollingUpdate strategy.

## [Deployment RevisionHistoryLimit](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L122)

- Added to conformance in release v1.12
- Defined in code as: [sig-apps] Deployment deployment should delete old replica sets [Conformance]

A conformant Kubernetes distribution MUST clean up Deployment's ReplicaSets based on the Deployment's `.spec.revisionHistoryLimit`.

## [Deployment Proportional Scaling](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L160)

- Added to conformance in release v1.12
- Defined in code as: [sig-apps] Deployment deployment should support proportional scaling [Conformance]

A conformant Kubernetes distribution MUST support Deployment proportional scaling, i.e. proportionally scale a Deployment's ReplicaSets when a Deployment is scaled.

## [Deployment Rollover](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L132)

- Added to conformance in release v1.12
- Defined in code as: [sig-apps] Deployment deployment should support rollover [Conformance]

A conformant Kubernetes distribution MUST support Deployment rollover, i.e. allow arbitrary number of changes to desired state during rolling update before the rollout finishes.

## [Deployment, completes the lifecycle of a Deployment](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L185)

- Added to conformance in release v1.20
- Defined in code as: [sig-apps] Deployment should run the lifecycle of a Deployment [Conformance]

When a Deployment is created it MUST succeed with the required number of replicas. It MUST succeed when the Deployment is patched. When scaling the deployment is MUST succeed. When fetching and patching the DeploymentStatus it MUST succeed. It MUST succeed when deleting the Deployment.

## [Deployment, status sub-resource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/deployment.go#L489)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] Deployment should validate Deployment Status endpoints [Conformance]

When a Deployment is created it MUST succeed. Attempt to read, update and patch its status sub-resource; all mutating sub-resource operations MUST be visible to subsequent reads.

## [PodDisruptionBudget: list and delete collection](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/disruption.go#L90)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] DisruptionController Listing PodDisruptionBudgets for all namespaces should list and delete a collection of PodDisruptionBudgets [Conformance]

PodDisruptionBudget API must support list and deletecollection operations.

## [PodDisruptionBudget: block an eviction until the PDB is updated to allow it](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/disruption.go#L351)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] DisruptionController should block an eviction until the PDB is updated to allow it [Conformance]

Eviction API must block an eviction until the PDB is updated to allow it

## [PodDisruptionBudget: create, update, patch, and delete object](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/disruption.go#L111)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] DisruptionController should create a PodDisruptionBudget [Conformance]

PodDisruptionBudget API must support create, update, patch, and delete operations.

## [PodDisruptionBudget: Status updates](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/disruption.go#L144)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] DisruptionController should observe PodDisruptionBudget status updated [Conformance]

Disruption controller MUST update the PDB status with how many disruptions are allowed.

## [PodDisruptionBudget: update and patch status](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/disruption.go#L167)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] DisruptionController should update/patch PodDisruptionBudget status [Conformance]

PodDisruptionBudget API must support update and patch operations on status subresource.

## [Jobs, orphan pods, re-adoption](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/job.go#L907)

- Added to conformance in release v1.16
- Defined in code as: [sig-apps] Job should adopt matching orphans and release non-matching pods [Conformance]

Create a parallel job. The number of Pods MUST equal the level of parallelism. Orphan a Pod by modifying its owner reference. The Job MUST re-adopt the orphan pod. Modify the labels of one of the Job's Pods. The Job MUST release the Pod.

## [Verify Pod Failure policy allows to fail job early on exit code.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/job.go#L107)

- Added to conformance in release v1.31
- Defined in code as: [sig-apps] Job should allow to use the pod failure policy on exit code to fail the job early [Conformance]

Create a job with pod failure policy, and exactly one pod failing. The exit code of the failed pod matches the pod failure policy triggering the Job failure.

## [Jobs, apply changes to status](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/job.go#L1054)

- Added to conformance in release v1.24
- Defined in code as: [sig-apps] Job should apply changes to a job status [Conformance]

Attempt to create a running Job which MUST succeed. Attempt to patch the Job status which MUST succeed. An annotation for the job that was patched MUST be found. Attempt to replace the job status with update which MUST succeed. Attempt to read its status sub-resource which MUST succeed

## [Ensure Pods of an Indexed Job get a unique index.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/job.go#L490)

- Added to conformance in release v1.24
- Defined in code as: [sig-apps] Job should create pods for an Indexed job with completion indexes and specified hostname [Conformance]

Create an Indexed job. Job MUST complete successfully. Ensure that created pods have completion index annotation and environment variable.

## [Jobs, active pods, graceful termination](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/job.go#L878)

- Added to conformance in release v1.15
- Defined in code as: [sig-apps] Job should delete a job [Conformance]

Create a job. Ensure the active pods reflect parallelism in the namespace and delete the job. Job MUST be deleted successfully.

## [Jobs, manage lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/job.go#L1148)

- Added to conformance in release v1.25
- Defined in code as: [sig-apps] Job should manage the lifecycle of a job [Conformance]

Attempt to create a suspended Job which MUST succeed. Attempt to patch the Job to include a new label which MUST succeed. The label MUST be found. Attempt to replace the Job to include a new annotation which MUST succeed. The annotation MUST be found. Attempt to list all namespaces with a label selector which MUST succeed. One list MUST be found. It MUST succeed at deleting a collection of jobs via a label selector.

## [Jobs, completion after task failure](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/job.go#L788)

- Added to conformance in release v1.16
- Defined in code as: [sig-apps] Job should run a job to completion when tasks sometimes fail and are locally restarted [Conformance]

Explicitly cause the tasks to fail once initially. After restarting, the Job MUST execute to completion.

## [ReplicaSet, is created, Replaced and Patched](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/replica_set.go#L155)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] ReplicaSet Replace and Patch tests [Conformance]

Create a ReplicaSet (RS) with a single Pod. The Pod MUST be verified that it is running. The RS MUST scale to two replicas and verify the scale count The RS MUST be patched and verify that patch succeeded.

## [ReplicaSet, completes the scaling of a ReplicaSet subresource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/replica_set.go#L144)

- Added to conformance in release v1.21
- Defined in code as: [sig-apps] ReplicaSet Replicaset should have a working scale subresource [Conformance]

Create a ReplicaSet (RS) with a single Pod. The Pod MUST be verified that it is running. The RS MUST get and verify the scale subresource count. The RS MUST update and verify the scale subresource. The RS MUST patch and verify a scale subresource.

## [Replica Set, adopt matching pods and release non matching pods](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/replica_set.go#L132)

- Added to conformance in release v1.13
- Defined in code as: [sig-apps] ReplicaSet should adopt matching pods on creation and release no longer matching pods [Conformance]

A Pod is created, then a Replica Set (RS) whose label selector will match the Pod. The RS MUST either adopt the Pod or delete and replace it with a new Pod. When the labels on one of the Pods owned by the RS change to no longer match the RS's label selector, the RS MUST release the Pod and update the Pod's owner references

## [ReplicaSet, list and delete a collection of ReplicaSets](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/replica_set.go#L166)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] ReplicaSet should list and delete a collection of ReplicaSets [Conformance]

When a ReplicaSet is created it MUST succeed. It MUST succeed when listing ReplicaSets via a label selector. It MUST succeed when deleting the ReplicaSet via deleteCollection.

## [Replica Set, run basic image](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/replica_set.go#L112)

- Added to conformance in release v1.9
- Defined in code as: [sig-apps] ReplicaSet should serve a basic image on each replica with a public image [Conformance]

Create a ReplicaSet with a Pod and a single Container. Make sure that the Pod is running. Pod SHOULD send a valid response when queried.

## [ReplicaSet, status sub-resource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/replica_set.go#L177)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] ReplicaSet should validate Replicaset Status endpoints [Conformance]

Create a ReplicaSet resource which MUST succeed. Attempt to read, update and patch its status sub-resource; all mutating sub-resource operations MUST be visible to subsequent reads.

## [Replication Controller, adopt matching pods](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/rc.go#L95)

- Added to conformance in release v1.13
- Defined in code as: [sig-apps] ReplicationController should adopt matching pods on creation [Conformance]

An ownerless Pod is created, then a Replication Controller (RC) is created whose label selector will match the Pod. The RC MUST either adopt the Pod or delete and replace it with a new Pod

## [Replication Controller, get and update ReplicationController scale](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/rc.go#L425)

- Added to conformance in release v1.26
- Defined in code as: [sig-apps] ReplicationController should get and update a ReplicationController scale [Conformance]

A ReplicationController is created which MUST succeed. It MUST succeed when reading the ReplicationController scale. When updating the ReplicationController scale it MUST succeed and the field MUST equal the new value.

## [Replication Controller, release pods](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/rc.go#L104)

- Added to conformance in release v1.13
- Defined in code as: [sig-apps] ReplicationController should release no longer matching pods [Conformance]

A Replication Controller (RC) is created, and its Pods are created. When the labels on one of the Pods change to no longer match the RC's label selector, the RC MUST release the Pod and update the Pod's owner references.

## [Replication Controller, run basic image](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/rc.go#L70)

- Added to conformance in release v1.9
- Defined in code as: [sig-apps] ReplicationController should serve a basic image on each replica with a public image [Conformance]

Replication Controller MUST create a Pod with Basic Image and MUST run the service with the provided image. Image MUST be tested by dialing into the service listening through TCP, UDP and HTTP.

## [Replication Controller, check for issues like exceeding allocated quota](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/rc.go#L86)

- Added to conformance in release v1.15
- Defined in code as: [sig-apps] ReplicationController should surface a failure condition on a common issue like exceeded quota [Conformance]

Attempt to create a Replication Controller with pods exceeding the namespace quota. The creation MUST fail

## [Replication Controller, lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/rc.go#L113)

- Added to conformance in release v1.20
- Defined in code as: [sig-apps] ReplicationController should test the lifecycle of a ReplicationController [Conformance]

A Replication Controller (RC) is created, read, patched, and deleted with verification.

## [StatefulSet, Burst Scaling](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L754)

- Added to conformance in release v1.9
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] Burst scaling should run to completion even with unhealthy pods [Slow] [Conformance]

StatefulSet MUST support the Parallel PodManagementPolicy for burst scaling. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.

## [StatefulSet, Scaling](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L644)

- Added to conformance in release v1.9
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] Scaling should happen in predictable order and halt if any stateful pod is unhealthy [Slow] [Conformance]

StatefulSet MUST create Pods in ascending order by ordinal index when scaling up, and delete Pods in descending order when scaling down. Scaling up or down MUST pause if any Pods belonging to the StatefulSet are unhealthy. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.

## [StatefulSet, Recreate Failed Pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L796)

- Added to conformance in release v1.9
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] Should recreate evicted statefulset [Conformance]

StatefulSet MUST delete and recreate Pods it owns that go into a Failed state, such as when they are rejected or evicted by a Node. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.

## [StatefulSet resource Replica scaling](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L905)

- Added to conformance in release v1.16, v1.21
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] should have a working scale subresource [Conformance]

Create a StatefulSet resource. Newly created StatefulSet resource MUST have a scale of one. Bring the scale of the StatefulSet resource up to two. StatefulSet scale MUST be at two replicas.

## [StatefulSet, list, patch and delete a collection of StatefulSets](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L965)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] should list, patch and delete a collection of StatefulSets [Conformance]

When a StatefulSet is created it MUST succeed. It MUST succeed when listing StatefulSets via a label selector. It MUST succeed when patching a StatefulSet. It MUST succeed when deleting the StatefulSet via deleteCollection.

## [StatefulSet, Rolling Update with Partition](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L335)

- Added to conformance in release v1.9
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] should perform canary updates and phased rolling updates of template modifications [Conformance]

StatefulSet's RollingUpdate strategy MUST support the Partition parameter for canaries and phased rollouts. If a Pod is deleted while a rolling update is in progress, StatefulSet MUST restore the Pod without violating the Partition. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.

## [StatefulSet, Rolling Update](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L324)

- Added to conformance in release v1.9
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] should perform rolling updates and roll backs of template modifications [Conformance]

StatefulSet MUST support the RollingUpdate strategy to automatically replace Pods one at a time when the Pod template changes. The StatefulSet's status MUST indicate the CurrentRevision and UpdateRevision. If the template is changed to match a prior revision, StatefulSet MUST detect this as a rollback instead of creating a new revision. This test does not depend on a preexisting default StorageClass or a dynamic provisioner.

## [StatefulSet, status sub-resource](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/apps/statefulset.go#L1034)

- Added to conformance in release v1.22
- Defined in code as: [sig-apps] StatefulSet Basic StatefulSet functionality [StatefulSetBasic] should validate Statefulset Status endpoints [Conformance]

When a StatefulSet is created it MUST succeed. Attempt to read, update and patch its status sub-resource; all mutating sub-resource operations MUST be visible to subsequent reads.

## [Conformance tests minimum number of nodes.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/architecture/conformance.go#L39)

- Added to conformance in release v1.23
- Defined in code as: [sig-architecture] Conformance Tests should have at least two untainted nodes [Conformance]

Conformance tests requires at least two untainted nodes where pods can be scheduled.

## [CertificateSigningRequest API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/certificates.go#L200)

- Added to conformance in release v1.19
- Defined in code as: [sig-auth] Certificates API [Privileged:ClusterAdmin] should support CSR API operations [Conformance]

 The certificates.k8s.io API group MUST exists in the /apis discovery document. The certificates.k8s.io/v1 API group/version MUST exist in the /apis/certificates.k8s.io discovery document. The certificatesigningrequests, certificatesigningrequests/approval, and certificatesigningrequests/status resources MUST exist in the /apis/certificates.k8s.io/v1 discovery document. The certificatesigningrequests resource must support create, get, list, watch, update, patch, delete, and deletecollection. The certificatesigningrequests/approval resource must support get, update, patch. The certificatesigningrequests/status resource must support get, update, patch.

## [OIDC Discovery (ServiceAccountIssuerDiscovery)](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/service_accounts.go#L531)

- Added to conformance in release v1.21
- Defined in code as: [sig-auth] ServiceAccounts ServiceAccountIssuerDiscovery should support OIDC discovery of service account issuer [Conformance]

Ensure kube-apiserver serves correct OIDC discovery endpoints by deploying a Pod that verifies its own token against these endpoints.

## [Service account tokens auto mount optionally](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/service_accounts.go#L163)

- Added to conformance in release v1.9
- Defined in code as: [sig-auth] ServiceAccounts should allow opting out of API token automount [Conformance]

Ensure that Service Account keys are mounted into the Pod only when AutoMountServiceToken is not set to false. We test the following scenarios here. 1. Create Pod, Pod Spec has AutomountServiceAccountToken set to nil a) Service Account with default value, b) Service Account is an configured AutomountServiceAccountToken set to true, c) Service Account is an configured AutomountServiceAccountToken set to false 2. Create Pod, Pod Spec has AutomountServiceAccountToken set to true a) Service Account with default value, b) Service Account is configured with AutomountServiceAccountToken set to true, c) Service Account is configured with AutomountServiceAccountToken set to false 3. Create Pod, Pod Spec has AutomountServiceAccountToken set to false a) Service Account with default value, b) Service Account is configured with AutomountServiceAccountToken set to true, c) Service Account is configured with AutomountServiceAccountToken set to false The Containers running in these pods MUST verify that the ServiceTokenVolume path is auto mounted only when Pod Spec has AutomountServiceAccountToken not set to false and ServiceAccount object has AutomountServiceAccountToken not set to false, this include test cases 1a,1b,2a,2b and 2c. In the test cases 1c,3a,3b and 3c the ServiceTokenVolume MUST not be auto mounted.

## [RootCA ConfigMap test](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/service_accounts.go#L742)

- Added to conformance in release v1.21
- Defined in code as: [sig-auth] ServiceAccounts should guarantee kube-root-ca.crt exist in any namespace [Conformance]

Ensure every namespace exist a ConfigMap for root ca cert. 1. Created automatically 2. Recreated if deleted 3. Reconciled if modified

## [Service Account Tokens Must AutoMount](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/service_accounts.go#L80)

- Added to conformance in release v1.9
- Defined in code as: [sig-auth] ServiceAccounts should mount an API token into pods [Conformance]

Ensure that Service Account keys are mounted into the Container. Pod contains three containers each will read Service Account token, root CA and default namespace respectively from the default API Token Mount path. All these three files MUST exist and the Service Account mount path MUST be auto mounted to the Container.

## [TokenRequestProjection should mount a projected volume with token using TokenRequest API.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/service_accounts.go#L277)

- Added to conformance in release v1.20
- Defined in code as: [sig-auth] ServiceAccounts should mount projected service account token [Conformance]

Ensure that projected service account token is mounted.

## [ServiceAccount lifecycle test](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/service_accounts.go#L649)

- Added to conformance in release v1.19
- Defined in code as: [sig-auth] ServiceAccounts should run through the lifecycle of a ServiceAccount [Conformance]

Creates a ServiceAccount with a static Label MUST be added as shown in watch event. Patching the ServiceAccount MUST return it's new property. Listing the ServiceAccounts MUST return the test ServiceAccount with it's patched values. ServiceAccount will be deleted and MUST find a deleted watch event.

## [ServiceAccount, update a ServiceAccount](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/service_accounts.go#L810)

- Added to conformance in release v1.26
- Defined in code as: [sig-auth] ServiceAccounts should update a ServiceAccount [Conformance]

A ServiceAccount is created which MUST succeed. When updating the ServiceAccount it MUST succeed and the field MUST equal the new value.

## [SubjectReview, API Operations](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/auth/subjectreviews.go#L50)

- Added to conformance in release v1.27
- Defined in code as: [sig-auth] SubjectReview should support SubjectReview API operations [Conformance]

A ServiceAccount is created which MUST succeed. A clientset is created to impersonate the ServiceAccount. A SubjectAccessReview is created for the ServiceAccount which MUST succeed. The allowed status for the SubjectAccessReview MUST match the expected allowed for the impersonated client call. A LocalSubjectAccessReviews is created for the ServiceAccount which MUST succeed. The allowed status for the LocalSubjectAccessReview MUST match the expected allowed for the impersonated client call.

## [Kubectl, guestbook application](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L393)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Guestbook application should create and stop a working application [Conformance]

Create Guestbook application that contains an agnhost primary server, 2 agnhost replicas, frontend application, frontend service and agnhost primary service and agnhost replica service. Using frontend service, the test will write an entry into the guestbook application which will store the entry into the backend agnhost store. Application flow MUST work as expected and the data written MUST be available to read.

## [Kubectl, check version v1](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L878)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl api-versions should check if v1 is in available api versions [Conformance]

Run kubectl to get api versions, output MUST contain returned versions with 'v1' listed.

## [Kubectl, cluster info](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1365)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl cluster-info should check if Kubernetes control plane services is included in cluster-info [Conformance]

Call kubectl to get cluster-info, output MUST contain cluster-info returned and Kubernetes control plane SHOULD be running.

## [Kubectl, describe pod or rc](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1391)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl describe should check if kubectl describe prints relevant information for rc and pods [Conformance]

Deploy an agnhost controller and an agnhost service. Kubectl describe pods SHOULD return the name, namespace, labels, state and other information as expected. Kubectl describe on rc, service, node and namespace SHOULD also return proper information.

## [Kubectl, diff Deployment](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1044)

- Added to conformance in release v1.19
- Defined in code as: [sig-cli] Kubectl client Kubectl diff should check if kubectl diff finds a difference for Deployments [Conformance]

Create a Deployment with httpd image. Declare the same Deployment with a different image, busybox. Diff of live Deployment with declared Deployment MUST include the difference between live and declared image.

## [Kubectl, create service, replication controller](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1530)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl expose should create services for rc [Conformance]

Create a Pod running agnhost listening to port 6379. Using kubectl expose the agnhost primary replication controllers at port 1234. Validate that the replication controller is listening on port 1234 and the target port is set to 6379, port that agnhost primary is listening. Using kubectl expose the agnhost primary as a service at port 2345. The service MUST be listening on port 2345 and the target port is set to 6379, port that agnhost primary is listening.

## [Kubectl, label update](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1624)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl label should update the label on a resource [Conformance]

When a Pod is running, update a Label using 'kubectl label' command. The label MUST be created in the Pod. A 'kubectl get pod' with -l option on the container MUST verify that the label can be read back. Use 'kubectl label label-' to remove the label. 'kubectl get pod' with -l option SHOULD not list the deleted label as the label is removed.

## [Kubectl, patch to annotate](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1690)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl patch should add annotations for pods in rc [Conformance]

Start running agnhost and a replication controller. When the pod is running, using 'kubectl patch' command add annotations. The annotation MUST be added to running pods and SHOULD be able to read added annotations from each of the Pods running under the replication controller.

## [Kubectl, replace](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1791)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl replace should update a single-container pod's image [Conformance]

Command 'kubectl replace' on a existing Pod with a new spec MUST update the image of the container running in the Pod. A -f option to 'kubectl replace' SHOULD force to re-create the resource. The new Pod SHOULD have the container with new change to the image.

## [Kubectl, run pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1756)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl run pod should create a pod from an image when restart is Never [Conformance]

Command 'kubectl run' MUST create a pod, when a image name is specified in the run command. After the run command there SHOULD be a pod that should exist with one container running the specified image.

## [Kubectl, server-side dry-run Pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1075)

- Added to conformance in release v1.19
- Defined in code as: [sig-cli] Kubectl client Kubectl server-side dry-run should check if kubectl can dry-run update Pods [Conformance]

The command 'kubectl run' must create a pod with the specified image name. After, the command 'kubectl patch pod -p {...} --dry-run=server' should update the Pod with the new image name and server-side dry-run enabled. The image name must not change.

## [Kubectl, version](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1723)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Kubectl version should check is all data is printed [Conformance]

The command 'kubectl version' MUST return the major, minor versions,  GitCommit, etc of the Client and the Server that the kubectl is configured to connect to.

## [Kubectl, proxy socket](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1858)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Proxy server should support --unix-socket=/path [Conformance]

Start a proxy server on by running 'kubectl proxy' with --unix-socket=<some path>. Call the proxy server by requesting api versions from  http://locahost:0/api. The proxy server MUST provide at least one version string

## [Kubectl, proxy port zero](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L1833)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Proxy server should support proxy with --port 0 [Conformance]

Start a proxy server on port zero by running 'kubectl proxy' with --port=0. Call the proxy server by requesting api versions from unix socket. The proxy server MUST provide at least one version string.

## [Kubectl, replication controller](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L337)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Update Demo should create and stop a replication controller [Conformance]

Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2.

## [Kubectl, scale replication controller](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/kubectl.go#L350)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl client Update Demo should scale a replication controller [Conformance]

Create a Pod and a container with a given image. Configure replication controller to run 2 replicas. The number of running instances of the Pod MUST equal the number of replicas set on the replication controller which is 2. Update the replicaset to 1. Number of running instances of the Pod MUST be 1. Update the replicaset to 2. Number of running instances of the Pod MUST be 2.

## [Kubectl, logs](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/kubectl/logs.go#L167)

- Added to conformance in release v1.9
- Defined in code as: [sig-cli] Kubectl logs logs should be able to retrieve and filter logs [Conformance]

When a Pod is running then it MUST generate logs. Starting a Pod should have a expected log line. Also log command options MUST work as expected and described below. 'kubectl logs -tail=1' should generate a output of one line, the last line in the log. 'kubectl --limit-bytes=1' should generate a single byte output. 'kubectl --tail=1 --timestamp should generate one line with timestamp in RFC3339 format 'kubectl --since=1s' should output logs that are only 1 second older from now 'kubectl --since=24h' should output logs that are only 1 day older from now

## [New Event resource lifecycle, testing a list of events](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/instrumentation/events.go#L207)

- Added to conformance in release v1.19
- Defined in code as: [sig-instrumentation] Events API should delete a collection of events [Conformance]

Create a list of events, the events MUST exist. The events are deleted and MUST NOT show up when listing all events.

## [New Event resource lifecycle, testing a single event](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/instrumentation/events.go#L98)

- Added to conformance in release v1.19
- Defined in code as: [sig-instrumentation] Events API should ensure that an event can be fetched, patched, deleted, and listed [Conformance]

Create an event, the event MUST exist. The event is patched with a new note, the check MUST have the update note. The event is updated with a new series, the check MUST have the update series. The event is deleted and MUST NOT show up when listing all events.

## [Event, delete a collection](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/instrumentation/core_events.go#L176)

- Added to conformance in release v1.20
- Defined in code as: [sig-instrumentation] Events should delete a collection of events [Conformance]

A set of events is created with a label selector which MUST be found when listed. The set of events is deleted and MUST NOT show up when listed by its label selector.

## [Event, manage lifecycle of an Event](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/instrumentation/core_events.go#L58)

- Added to conformance in release v1.25
- Defined in code as: [sig-instrumentation] Events should manage the lifecycle of an event [Conformance]

Attempt to create an event which MUST succeed. Attempt to list all namespaces with a label selector which MUST succeed. One list MUST be found. The event is patched with a new message, the check MUST have the update message. The event is updated with a new series of events, the check MUST confirm this update. The event is deleted and MUST NOT show up when listing all events.

## [DNS, cluster](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L119)

- Added to conformance in release v1.14
- Defined in code as: [sig-network] DNS should provide /etc/hosts entries for the cluster [Conformance]

When a Pod is created, the pod MUST be able to resolve cluster dns entries such as kubernetes.default via /etc/hosts.

## [DNS, for ExternalName Services](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L331)

- Added to conformance in release v1.15
- Defined in code as: [sig-network] DNS should provide DNS for ExternalName services [Conformance]

Create a service with externalName. Pod MUST be able to resolve the address for this service via CNAME. When externalName of this service is changed, Pod MUST resolve to new DNS entry for the service. Change the service type from externalName to ClusterIP, Pod MUST resolve DNS to the service by serving A records.

## [DNS, resolve the hostname](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L246)

- Added to conformance in release v1.15
- Defined in code as: [sig-network] DNS should provide DNS for pods for Hostname [Conformance]

Create a headless service with label. Create a Pod with label to match service's label, with hostname and a subdomain same as service name. Pod MUST be able to resolve its fully qualified domain name as well as hostname by serving an A record at that name.

## [DNS, resolve the subdomain](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L288)

- Added to conformance in release v1.15
- Defined in code as: [sig-network] DNS should provide DNS for pods for Subdomain [Conformance]

Create a headless service with label. Create a Pod with label to match service's label, with hostname and a subdomain same as service name. Pod MUST be able to resolve its fully qualified domain name as well as subdomain by serving an A record at that name.

## [DNS, services](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L139)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] DNS should provide DNS for services [Conformance]

When a headless service is created, the service MUST be able to resolve all the required service endpoints. When the service is created, any pod in the same namespace must be able to resolve the service by all of the expected DNS names.

## [DNS, cluster](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L52)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] DNS should provide DNS for the cluster [Conformance]

When a Pod is created, the pod MUST be able to resolve cluster dns entries such as kubernetes.default via DNS.

## [DNS, PQDN for services](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L193)

- Added to conformance in release v1.17
- Defined in code as: [sig-network] DNS should resolve DNS of partial qualified names for services [LinuxOnly] [Conformance]

Create a headless service and normal service. Both the services MUST be able to resolve partial qualified DNS entries of their service endpoints by serving A records and SRV records. [LinuxOnly]: As Windows currently does not support resolving PQDNs.

## [DNS, custom dnsConfig](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/dns.go#L409)

- Added to conformance in release v1.17
- Defined in code as: [sig-network] DNS should support configurable pod DNS nameservers [Conformance]

Create a Pod with DNSPolicy as None and custom DNS configuration, specifying nameservers and search path entries. Pod creation MUST be successful and provided DNS configuration MUST be configured in the Pod.

## [EndpointSlice API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/endpointslice.go#L208)

- Added to conformance in release v1.21
- Defined in code as: [sig-network] EndpointSlice should create Endpoints and EndpointSlices for Pods matching a Service [Conformance]

The discovery.k8s.io API group MUST exist in the /apis discovery document. The discovery.k8s.io/v1 API group/version MUST exist in the /apis/discovery.k8s.io discovery document. The endpointslices resource MUST exist in the /apis/discovery.k8s.io/v1 discovery document. The endpointslice controller must create EndpointSlices for Pods mataching a Service.

## [EndpointSlice API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/endpointslice.go#L105)

- Added to conformance in release v1.21
- Defined in code as: [sig-network] EndpointSlice should create and delete Endpoints and EndpointSlices for a Service with a selector specified [Conformance]

The discovery.k8s.io API group MUST exist in the /apis discovery document. The discovery.k8s.io/v1 API group/version MUST exist in the /apis/discovery.k8s.io discovery document. The endpointslices resource MUST exist in the /apis/discovery.k8s.io/v1 discovery document. The endpointslice controller should create and delete EndpointSlices for Pods matching a Service.

## [EndpointSlice API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/endpointslice.go#L69)

- Added to conformance in release v1.21
- Defined in code as: [sig-network] EndpointSlice should have Endpoints and EndpointSlices pointing to API Server [Conformance]

The discovery.k8s.io API group MUST exist in the /apis discovery document. The discovery.k8s.io/v1 API group/version MUST exist in the /apis/discovery.k8s.io discovery document. The endpointslices resource MUST exist in the /apis/discovery.k8s.io/v1 discovery document. The cluster MUST have a service named "kubernetes" on the default namespace referencing the API servers. The "kubernetes.default" service MUST have Endpoints and EndpointSlices pointing to each API server instance.

## [EndpointSlice API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/endpointslice.go#L356)

- Added to conformance in release v1.21
- Defined in code as: [sig-network] EndpointSlice should support creating EndpointSlice API operations [Conformance]

The discovery.k8s.io API group MUST exist in the /apis discovery document. The discovery.k8s.io/v1 API group/version MUST exist in the /apis/discovery.k8s.io discovery document. The endpointslices resource MUST exist in the /apis/discovery.k8s.io/v1 discovery document. The endpointslices resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [EndpointSlice Mirroring](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/endpointslicemirroring.go#L55)

- Added to conformance in release v1.21
- Defined in code as: [sig-network] EndpointSliceMirroring should mirror a custom Endpoints resource through create update and delete [Conformance]

The discovery.k8s.io API group MUST exist in the /apis discovery document. The discovery.k8s.io/v1 API group/version MUST exist in the /apis/discovery.k8s.io discovery document. The endpointslices resource MUST exist in the /apis/discovery.k8s.io/v1 discovery document. The endpointslices mirrorowing must mirror endpoint create, update, and delete actions.

## [Scheduling, HostPort matching and HostIP and Protocol not-matching](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/hostport.go#L63)

- Added to conformance in release v1.16, v1.21
- Defined in code as: [sig-network] HostPort validates that there is no conflict between pods with same hostPort but different hostIP and protocol [LinuxOnly] [Conformance]

Pods with the same HostPort value MUST be able to be scheduled to the same node if the HostIP or Protocol is different. This test is marked LinuxOnly since hostNetwork is not supported on Windows.

## [Ingress API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/ingress.go#L55)

- Added to conformance in release v1.19
- Defined in code as: [sig-network] Ingress API should support creating Ingress API operations [Conformance]

 The networking.k8s.io API group MUST exist in the /apis discovery document. The networking.k8s.io/v1 API group/version MUST exist in the /apis/networking.k8s.io discovery document. The ingresses resources MUST exist in the /apis/networking.k8s.io/v1 discovery document. The ingresses resource must support create, get, list, watch, update, patch, delete, and deletecollection. The ingresses/status resource must support update and patch

## [IngressClass API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/ingressclass.go#L268)

- Added to conformance in release v1.19
- Defined in code as: [sig-network] IngressClass API should support creating IngressClass API operations [Conformance]

 - The networking.k8s.io API group MUST exist in the /apis discovery document. - The networking.k8s.io/v1 API group/version MUST exist in the /apis/networking.k8s.io discovery document. - The ingressclasses resource MUST exist in the /apis/networking.k8s.io/v1 discovery document. - The ingressclass resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [Networking, intra pod http](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/network/networking.go#L85)

- Added to conformance in release v1.9, v1.18
- Defined in code as: [sig-network] Networking Granular Checks: Pods should function for intra-pod communication: http [NodeConformance] [Conformance]

Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes. The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.

## [Networking, intra pod udp](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/network/networking.go#L96)

- Added to conformance in release v1.9, v1.18
- Defined in code as: [sig-network] Networking Granular Checks: Pods should function for intra-pod communication: udp [NodeConformance] [Conformance]

Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes. The kubectl exec on the webserver container MUST reach a udp port on the each of service proxy endpoints in the cluster and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames.

## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/network/networking.go#L108)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] Networking Granular Checks: Pods should function for node-pod communication: http [LinuxOnly] [NodeConformance] [Conformance]

Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes. The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=tcp)  and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames. This test is marked LinuxOnly it breaks when using Overlay networking with Windows.

## [Networking, intra pod http, from node](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/network/networking.go#L125)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] Networking Granular Checks: Pods should function for node-pod communication: udp [LinuxOnly] [NodeConformance] [Conformance]

Create a hostexec pod that is capable of curl to netcat commands. Create a test Pod that will act as a webserver front end exposing ports 8080 for tcp and 8081 for udp. The netserver service proxies are created on specified number of nodes. The kubectl exec on the webserver container MUST reach a http port on the each of service proxy endpoints in the cluster using a http post(protocol=udp)  and the request MUST be successful. Container will execute curl command to reach the service port within specified max retry limit and MUST result in reporting unique hostnames. This test is marked LinuxOnly it breaks when using Overlay networking with Windows.

## [Proxy, validate Proxy responses](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/proxy.go#L380)

- Added to conformance in release v1.24
- Defined in code as: [sig-network] Proxy version v1 A set of valid responses are returned for both pod and service Proxy [Conformance]

Attempt to create a pod and a service. A set of pod and service endpoints MUST be accessed via Proxy using a list of http methods. A valid response MUST be returned for each endpoint.

## [Proxy, validate ProxyWithPath responses](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/proxy.go#L286)

- Added to conformance in release v1.21
- Defined in code as: [sig-network] Proxy version v1 A set of valid responses are returned for both pod and service ProxyWithPath [Conformance]

Attempt to create a pod and a service. A set of pod and service endpoints MUST be accessed via ProxyWithPath using a list of http methods. A valid response MUST be returned for each endpoint.

## [Proxy, logs service endpoint](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/proxy.go#L101)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] Proxy version v1 should proxy through a service and a pod [Conformance]

Select any node in the cluster to invoke  /logs endpoint  using the /nodes/proxy subresource from the kubelet port. This endpoint MUST be reachable.

## [Service endpoint latency, thresholds](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service_latency.go#L59)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] Service endpoints latency should not be very high [Conformance]

Run 100 iterations of create service with the Pod running the pause image, measure the time it takes for creating the service and the endpoint with the service name is available. These durations are captured for 100 iterations, then the durations are sorted to compute 50th, 90th and 99th percentile. The single server latency MUST not exceed liberally set thresholds of 20s for 50th percentile and 50s for the 90th percentile.

## [Service, change type, ClusterIP to ExternalName](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L1473)

- Added to conformance in release v1.16
- Defined in code as: [sig-network] Services should be able to change the type from ClusterIP to ExternalName [Conformance]

Create a service of type ClusterIP. Service creation MUST be successful by assigning ClusterIP to the service. Update service type from ClusterIP to ExternalName by setting CNAME entry as externalName. Service update MUST be successful and service MUST not has associated ClusterIP. Service MUST be able to resolve to IP address by returning A records ensuring service is pointing to provided externalName.

## [Service, change type, ExternalName to ClusterIP](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L1396)

- Added to conformance in release v1.16
- Defined in code as: [sig-network] Services should be able to change the type from ExternalName to ClusterIP [Conformance]

Create a service of type ExternalName, pointing to external DNS. ClusterIP MUST not be assigned to the service. Update the service from ExternalName to ClusterIP by removing ExternalName entry, assigning port 80 as service port and TCP as protocol. Service update MUST be successful by assigning ClusterIP to the service and it MUST be reachable over serviceName and ClusterIP on provided service port.

## [Service, change type, ExternalName to NodePort](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L1435)

- Added to conformance in release v1.16
- Defined in code as: [sig-network] Services should be able to change the type from ExternalName to NodePort [Conformance]

Create a service of type ExternalName, pointing to external DNS. ClusterIP MUST not be assigned to the service. Update the service from ExternalName to NodePort, assigning port 80 as service port and, TCP as protocol. service update MUST be successful by exposing service on every node's IP on dynamically assigned NodePort and, ClusterIP MUST be assigned to route service requests. Service MUST be reachable over serviceName and the ClusterIP on servicePort. Service MUST also be reachable over node's IP on NodePort.

## [Service, change type, NodePort to ExternalName](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L1513)

- Added to conformance in release v1.16
- Defined in code as: [sig-network] Services should be able to change the type from NodePort to ExternalName [Conformance]

Create a service of type NodePort. Service creation MUST be successful by exposing service on every node's IP on dynamically assigned NodePort and, ClusterIP MUST be assigned to route service requests. Update the service type from NodePort to ExternalName by setting CNAME entry as externalName. Service update MUST be successful and, MUST not has ClusterIP associated with the service and, allocated NodePort MUST be released. Service MUST be able to resolve to IP address by returning A records ensuring service is pointing to provided externalName.

## [Service, NodePort Service](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L1260)

- Added to conformance in release v1.16
- Defined in code as: [sig-network] Services should be able to create a functioning NodePort service [Conformance]

Create a TCP NodePort service, and test reachability from a client Pod. The client Pod MUST be able to access the NodePort service by service name and cluster IP on the service port, and on nodes' internal and external IPs on the NodePort.

## [Service, NodePort type, session affinity to None](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L2216)

- Added to conformance in release v1.19
- Defined in code as: [sig-network] Services should be able to switch session affinity for NodePort service [LinuxOnly] [Conformance]

Create a service of type "NodePort" and provide service port and protocol. Service's sessionAffinity is set to "ClientIP". Service creation MUST be successful by assigning a "ClusterIP" to the service and allocating NodePort on all the nodes. Create a Replication Controller to ensure that 3 pods are running and are targeted by the service to serve hostname of the pod when requests are sent to the service. Create another pod to make requests to the service. Update the service's sessionAffinity to "None". Service update MUST be successful. When a requests are made to the service on node's IP and NodePort, service MUST be able serve the hostname from any pod of the replica. When service's sessionAffinily is updated back to "ClientIP", service MUST serve the hostname from the same pod of the replica for all consecutive requests. Service MUST be reachable over serviceName and the ClusterIP on servicePort. Service MUST also be reachable over node's IP on NodePort. [LinuxOnly]: Windows does not support session affinity.

## [Service, ClusterIP type, session affinity to None](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L2179)

- Added to conformance in release v1.19
- Defined in code as: [sig-network] Services should be able to switch session affinity for service with type clusterIP [LinuxOnly] [Conformance]

Create a service of type "ClusterIP". Service's sessionAffinity is set to "ClientIP". Service creation MUST be successful by assigning "ClusterIP" to the service. Create a Replication Controller to ensure that 3 pods are running and are targeted by the service to serve hostname of the pod when requests are sent to the service. Create another pod to make requests to the service. Update the service's sessionAffinity to "None". Service update MUST be successful. When a requests are made to the service, it MUST be able serve the hostname from any pod of the replica. When service's sessionAffinily is updated back to "ClientIP", service MUST serve the hostname from the same pod of the replica for all consecutive requests. Service MUST be reachable over serviceName and the ClusterIP on servicePort. [LinuxOnly]: Windows does not support session affinity.

## [Service, complete ServiceStatus lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L3393)

- Added to conformance in release v1.21
- Defined in code as: [sig-network] Services should complete a service status lifecycle [Conformance]

Create a service, the service MUST exist. When retrieving /status the action MUST be validated. When patching /status the action MUST be validated. When updating /status the action MUST be validated. When patching a service the action MUST be validated.

## [Service, deletes a collection of services](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L3619)

- Added to conformance in release v1.23
- Defined in code as: [sig-network] Services should delete a collection of services [Conformance]

Create three services with the required labels and ports. It MUST locate three services in the test namespace. It MUST succeed at deleting a collection of services via a label selector. It MUST locate only one service after deleting the service collection.

## [Find Kubernetes Service in default Namespace](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L3184)

- Added to conformance in release v1.18
- Defined in code as: [sig-network] Services should find a service from listing all namespaces [Conformance]

List all Services in all Namespaces, response MUST include a Service named Kubernetes with the Namespace of default.

## [Service, NodePort type, session affinity to ClientIP](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L2194)

- Added to conformance in release v1.19
- Defined in code as: [sig-network] Services should have session affinity work for NodePort service [LinuxOnly] [Conformance]

Create a service of type "NodePort" and provide service port and protocol. Service's sessionAffinity is set to "ClientIP". Service creation MUST be successful by assigning a "ClusterIP" to service and allocating NodePort on all nodes. Create a Replication Controller to ensure that 3 pods are running and are targeted by the service to serve hostname of the pod when a requests are sent to the service. Create another pod to make requests to the service on node's IP and NodePort. Service MUST serve the hostname from the same pod of the replica for all consecutive requests. Service MUST be reachable over serviceName and the ClusterIP on servicePort. Service MUST also be reachable over node's IP on NodePort. [LinuxOnly]: Windows does not support session affinity.

## [Service, ClusterIP type, session affinity to ClientIP](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L2157)

- Added to conformance in release v1.19
- Defined in code as: [sig-network] Services should have session affinity work for service with type clusterIP [LinuxOnly] [Conformance]

Create a service of type "ClusterIP". Service's sessionAffinity is set to "ClientIP". Service creation MUST be successful by assigning "ClusterIP" to the service. Create a Replication Controller to ensure that 3 pods are running and are targeted by the service to serve hostname of the pod when requests are sent to the service. Create another pod to make requests to the service. Service MUST serve the hostname from the same pod of the replica for all consecutive requests. Service MUST be reachable over serviceName and the ClusterIP on servicePort. [LinuxOnly]: Windows does not support session affinity.

## [Kubernetes Service](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L750)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] Services should provide secure master service [Conformance]

By default when a kubernetes cluster is running there MUST be a 'kubernetes' service running in the cluster.

## [Service, endpoints](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L760)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] Services should serve a basic endpoint from pods [Conformance]

Create a service with a endpoint without any Pods, the service MUST run and show empty endpoints. Add a pod to the service and the service MUST validate to show all the endpoints for the ports exposed by the Pod. Add another Pod then the list of all Ports exposed by both the Pods MUST be valid and have corresponding service endpoint. Once the second Pod is deleted then set of endpoint MUST be validated to show only ports from the first container that are exposed. Once both pods are deleted the endpoints from the service MUST be empty.

## [Service, should serve endpoints on same port and different protocols.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L3703)

- Added to conformance in release v1.29
- Defined in code as: [sig-network] Services should serve endpoints on same port and different protocols [Conformance]

Create one service with two ports, same port number and different protocol TCP and UDP. It MUST be able to forward traffic to both ports. Update the Service to expose only the TCP port, it MUST succeed to connect to the TCP port and fail to connect to the UDP port. Update the Service to expose only the UDP port, it MUST succeed to connect to the UDP port and fail to connect to the TCP port.

## [Service, endpoints with multiple ports](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L821)

- Added to conformance in release v1.9
- Defined in code as: [sig-network] Services should serve multiport endpoints from pods [Conformance]

Create a service with two ports but no Pods are added to the service yet.  The service MUST run and show empty set of endpoints. Add a Pod to the first port, service MUST list one endpoint for the Pod on that port. Add another Pod to the second port, service MUST list both the endpoints. Delete the first Pod and the service MUST list only the endpoint to the second Pod. Delete the second Pod and the service must now have empty set of endpoints.

## [Endpoint resource lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/network/service.go#L3209)

- Added to conformance in release v1.19
- Defined in code as: [sig-network] Services should test the lifecycle of an Endpoint [Conformance]

Create an endpoint, the endpoint MUST exist. The endpoint is updated with a new label, a check after the update MUST find the changes. The endpoint is then patched with a new IPv4 address and port, a check after the patch MUST the changes. The endpoint is deleted by it's label, a watch listens for the deleted watch event.

## [ConfigMap, from environment field](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/configmap.go#L47)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] ConfigMap should be consumable via environment variable [NodeConformance] [Conformance]

Create a Pod with an environment variable value set using a value from ConfigMap. A ConfigMap value MUST be accessible in the container environment.

## [ConfigMap, from environment variables](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/configmap.go#L95)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] ConfigMap should be consumable via the environment [NodeConformance] [Conformance]

Create a Pod with a environment source from ConfigMap. All ConfigMap values MUST be available as environment variables in the container.

## [ConfigMap, with empty-key](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/configmap.go#L140)

- Added to conformance in release v1.14
- Defined in code as: [sig-node] ConfigMap should fail to create ConfigMap with empty key [Conformance]

Attempt to create a ConfigMap with an empty key. The creation MUST fail.

## [ConfigMap lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/configmap.go#L171)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] ConfigMap should run through a ConfigMap lifecycle [Conformance]

Attempt to create a ConfigMap. Patch the created ConfigMap. Fetching the ConfigMap MUST reflect changes. By fetching all the ConfigMaps via a Label selector it MUST find the ConfigMap by it's static label and updated value. The ConfigMap must be deleted by Collection.

## [Pod Lifecycle, post start exec hook](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/lifecycle_hook.go#L137)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Container Lifecycle Hook when create a pod with lifecycle hook should execute poststart exec hook properly [NodeConformance] [Conformance]

When a post start handler is specified in the container lifecycle using a 'Exec' action, then the handler MUST be invoked after the start of the container. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a post start that invokes the server pod using ExecAction to validate that the post start is executed.

## [Pod Lifecycle, post start http hook](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/lifecycle_hook.go#L170)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Container Lifecycle Hook when create a pod with lifecycle hook should execute poststart http hook properly [NodeConformance] [Conformance]

When a post start handler is specified in the container lifecycle using a HttpGet action, then the handler MUST be invoked after the start of the container. A server pod is created that will serve http requests, create a second pod on the same node with a container lifecycle specifying a post start that invokes the server pod to validate that the post start is executed.

## [Pod Lifecycle, prestop exec hook](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/lifecycle_hook.go#L154)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Container Lifecycle Hook when create a pod with lifecycle hook should execute prestop exec hook properly [NodeConformance] [Conformance]

When a pre-stop handler is specified in the container lifecycle using a 'Exec' action, then the handler MUST be invoked before the container is terminated. A server pod is created that will serve http requests, create a second pod with a container lifecycle specifying a pre-stop that invokes the server pod using ExecAction to validate that the pre-stop is executed.

## [Pod Lifecycle, prestop http hook](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/lifecycle_hook.go#L215)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Container Lifecycle Hook when create a pod with lifecycle hook should execute prestop http hook properly [NodeConformance] [Conformance]

When a pre-stop handler is specified in the container lifecycle using a 'HttpGet' action, then the handler MUST be invoked before the container is terminated. A server pod is created that will serve http requests, create a second pod on the same node with a container lifecycle specifying a pre-stop that invokes the server pod to validate that the pre-stop is executed.

## [Container Runtime, TerminationMessage, from log output of succeeding container](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtime.go#L232)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Container Runtime blackbox test on terminated container should report termination message as empty when pod succeeds and TerminationMessagePolicy FallbackToLogsOnError is set [NodeConformance] [Conformance]

Create a pod with an container. Container's output is recorded in log and container exits successfully without an error. When container is terminated, terminationMessage MUST have no content as container succeed.

## [Container Runtime, TerminationMessage, from file of succeeding container](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtime.go#L248)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Container Runtime blackbox test on terminated container should report termination message from file when pod succeeds and TerminationMessagePolicy FallbackToLogsOnError is set [NodeConformance] [Conformance]

Create a pod with an container. Container's output is recorded in a file and the container exits successfully without an error. When container is terminated, terminationMessage MUST match with the content from file.

## [Container Runtime, TerminationMessage, from container's log output of failing container](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtime.go#L216)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Container Runtime blackbox test on terminated container should report termination message from log output if TerminationMessagePolicy FallbackToLogsOnError is set [NodeConformance] [Conformance]

Create a pod with an container. Container's output is recorded in log and container exits with an error. When container is terminated, termination message MUST match the expected output recorded from container's log.

## [Container Runtime, TerminationMessagePath, non-root user and non-default path](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtime.go#L195)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Container Runtime blackbox test on terminated container should report termination message if TerminationMessagePath is set as non-root user and at a non-default path [NodeConformance] [Conformance]

Create a pod with a container to run it as a non-root user with a custom TerminationMessagePath set. Pod redirects the output to the provided path successfully. When the container is terminated, the termination message MUST match the expected output logged in the provided custom path.

## [Container Runtime, Restart Policy, Pod Phases](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtime.go#L52)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Container Runtime blackbox test when starting a container that exits should run with the expected status [NodeConformance] [Conformance]

If the restart policy is set to 'Always', Pod MUST be restarted when terminated, If restart policy is 'OnFailure', Pod MUST be started only if it is terminated with non-zero exit code. If the restart policy is 'Never', Pod MUST never be restarted. All these three test cases MUST verify the restart counts accordingly.

## [Containers, with arguments](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/containers.go#L61)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Containers should be able to override the image's default arguments (container cmd) [NodeConformance] [Conformance]

Default command and  from the container image entrypoint MUST be used when Pod does not specify the container command but the arguments from Pod spec MUST override when specified.

## [Containers, with command](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/containers.go#L75)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Containers should be able to override the image's default command (container entrypoint) [NodeConformance] [Conformance]

Default command from the container image entrypoint MUST NOT be used when Pod specifies the container command.  Command from Pod spec MUST override the command in the image.

## [Containers, with command and arguments](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/containers.go#L89)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Containers should be able to override the image's default command and arguments [NodeConformance] [Conformance]

Default command and arguments from the container image entrypoint MUST NOT be used when Pod specifies the container command and arguments.  Command and arguments from Pod spec MUST override the command and arguments in the image.

## [Containers, without command and arguments](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/containers.go#L41)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Containers should use the image defaults if command and args are blank [NodeConformance] [Conformance]

Default command and arguments from the container image entrypoint MUST be used when Pod does not specify the container command

## [DownwardAPI, environment for CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/downwardapi.go#L168)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Downward API should provide container's limits.cpu/memory and requests.cpu/memory as env vars [NodeConformance] [Conformance]

Downward API MUST expose CPU request and Memory request set through environment variables at runtime in the container.

## [DownwardAPI, environment for default CPU and memory limits and requests](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/downwardapi.go#L219)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Downward API should provide default limits.cpu/memory from node allocatable [NodeConformance] [Conformance]

Downward API MUST expose CPU request and Memory limits set through environment variables at runtime in the container.

## [DownwardAPI, environment for host ip](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/downwardapi.go#L92)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Downward API should provide host IP as an env var [NodeConformance] [Conformance]

Downward API MUST expose Pod and Container fields as environment variables. Specify host IP as environment variable in the Pod Spec are visible at runtime in the container.

## [DownwardAPI, environment for Pod UID](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/downwardapi.go#L269)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Downward API should provide pod UID as env vars [NodeConformance] [Conformance]

Downward API MUST expose Pod UID set through environment variables at runtime in the container.

## [DownwardAPI, environment for name, namespace and ip](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/downwardapi.go#L46)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Downward API should provide pod name, namespace and IP address as env vars [NodeConformance] [Conformance]

Downward API MUST expose Pod and Container fields as environment variables. Specify Pod Name, namespace and IP as environment variable in the Pod Spec are visible at runtime in the container.

## [Ephemeral Container, update ephemeral containers](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/ephemeral_containers.go#L98)

- Added to conformance in release v1.28
- Defined in code as: [sig-node] Ephemeral Containers [NodeConformance] should update the ephemeral containers in an existing pod [Conformance]

Adding an ephemeral container to pod.spec MUST result in the container running. There MUST now be only one ephermal container found. Updating the pod with another ephemeral container MUST succeed. There MUST now be two ephermal containers found.

## [Ephemeral Container Creation](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/ephemeral_containers.go#L51)

- Added to conformance in release 1.25
- Defined in code as: [sig-node] Ephemeral Containers [NodeConformance] will start an ephemeral container in an existing pod [Conformance]

Adding an ephemeral container to pod.spec MUST result in the container running.

## [init-container-starts-app-restartalways-pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/init_container.go#L256)

- Added to conformance in release v1.12
- Defined in code as: [sig-node] InitContainer [NodeConformance] should invoke init containers on a RestartAlways pod [Conformance]

Ensure that all InitContainers are started and all containers in pod started and at least one container is still running or is in the process of being restarted when Pod has restart policy as RestartAlways.

## [init-container-starts-app-restartnever-pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/init_container.go#L178)

- Added to conformance in release v1.12
- Defined in code as: [sig-node] InitContainer [NodeConformance] should invoke init containers on a RestartNever pod [Conformance]

Ensure that all InitContainers are started and all containers in pod are voluntarily terminated with exit status 0, and the system is not going to restart any of these containers when Pod has restart policy as RestartNever.

## [init-container-fails-stops-app-restartnever-pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/init_container.go#L459)

- Added to conformance in release v1.12
- Defined in code as: [sig-node] InitContainer [NodeConformance] should not start app containers and fail the pod if init containers fail on a RestartNever pod [Conformance]

Ensure that app container is not started when at least one InitContainer fails to start and Pod has restart policy as RestartNever.

## [init-container-fails-stops-app-restartalways-pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/init_container.go#L335)

- Added to conformance in release v1.12
- Defined in code as: [sig-node] InitContainer [NodeConformance] should not start app containers if init containers fail on a RestartAlways pod [Conformance]

Ensure that app container is not started when all InitContainers failed to start and Pod has restarted for few occurrences and pod has restart policy as RestartAlways.

## [Kubelet, log output, default](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/kubelet.go#L52)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Kubelet when scheduling a busybox command in a pod should print the output to logs [NodeConformance] [Conformance]

By default the stdout and stderr from the process being executed in a pod MUST be sent to the pod's logs.

## [Kubelet, failed pod, delete](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/kubelet.go#L135)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Kubelet when scheduling a busybox command that always fails in a pod should be possible to delete [NodeConformance] [Conformance]

Create a Pod with terminated state. This terminated pod MUST be able to be deleted.

## [Kubelet, failed pod, terminated reason](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/kubelet.go#L110)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Kubelet when scheduling a busybox command that always fails in a pod should have an terminated reason [NodeConformance] [Conformance]

Create a Pod with terminated state. Pod MUST have only one container. Container MUST be in terminated state and MUST have an terminated reason.

## [Kubelet, pod with read only root file system](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/kubelet.go#L184)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Kubelet when scheduling a read only busybox container should not write to root filesystem [LinuxOnly] [NodeConformance] [Conformance]

Create a Pod with security context set with ReadOnlyRootFileSystem set to true. The Pod then tries to write to the /file on the root, write operation to the root filesystem MUST fail as expected. This test is marked LinuxOnly since Windows does not support creating containers with read-only access.

## [Kubelet, hostAliases](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/kubelet.go#L148)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Kubelet when scheduling an agnhost Pod with hostAliases should write entries to /etc/hosts [NodeConformance] [Conformance]

Create a Pod with hostAliases and a container with command to output /etc/hosts entries. Pod's logs MUST have matching entries of specified hostAliases to the output of /etc/hosts entries.

## [Kubelet, managed etc hosts](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/kubelet_etc_hosts.go#L64)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] KubeletManagedEtcHosts should test kubelet managed /etc/hosts file [LinuxOnly] [NodeConformance] [Conformance]

Create a Pod with containers with hostNetwork set to false, one of the containers mounts the /etc/hosts file form the host. Create a second Pod with hostNetwork set to true. 1. The Pod with hostNetwork=false MUST have /etc/hosts of containers managed by the Kubelet. 2. The Pod with hostNetwork=false but the container mounts /etc/hosts file from the host. The /etc/hosts file MUST not be managed by the Kubelet. 3. The Pod with hostNetwork=true , /etc/hosts file MUST not be managed by the Kubelet. This test is marked LinuxOnly since Windows cannot mount individual files in Containers.

## [lease API should be available](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/lease.go#L73)

- Added to conformance in release v1.17
- Defined in code as: [sig-node] Lease lease API should be available [Conformance]

Create Lease object, and get it; create and get MUST be successful and Spec of the read Lease MUST match Spec of original Lease. Update the Lease and get it; update and get MUST be successful	and Spec of the read Lease MUST match Spec of updated Lease. Patch the Lease and get it; patch and get MUST be successful and Spec of the read Lease MUST match Spec of patched Lease. Create a second Lease with labels and list Leases; create and list MUST be successful and list MUST return both leases. Delete the labels lease via delete collection; the delete MUST be successful and MUST delete only the labels lease. List leases; list MUST be successful and MUST return just the remaining lease. Delete the lease; delete MUST be successful. Get the lease; get MUST return not found error.

## [Pod Eviction, Toleration limits](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/node/taints.go#L444)

- Added to conformance in release v1.16
- Defined in code as: [sig-node] NoExecuteTaintManager Multiple Pods [Serial] evicts pods with minTolerationSeconds [Disruptive] [Conformance]

In a multi-pods scenario with tolerationSeconds, the pods MUST be evicted as per the toleration time limit.

## [Taint, Pod Eviction on taint removal](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/node/taints.go#L284)

- Added to conformance in release v1.16
- Defined in code as: [sig-node] NoExecuteTaintManager Single Pod [Serial] removing taint cancels eviction [Disruptive] [Conformance]

The Pod with toleration timeout scheduled on a tainted Node MUST not be evicted if the taint is removed before toleration time ends.

## [PodTemplate, delete a collection](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/podtemplates.go#L123)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] PodTemplates should delete a collection of pod templates [Conformance]

A set of Pod Templates is created with a label selector which MUST be found when listed. The set of Pod Templates is deleted and MUST NOT show up when listed by its label selector.

## [PodTemplate, replace](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/podtemplates.go#L177)

- Added to conformance in release v1.24
- Defined in code as: [sig-node] PodTemplates should replace a pod template [Conformance]

Attempt to create a PodTemplate which MUST succeed. Attempt to replace the PodTemplate to include a new annotation which MUST succeed. The annotation MUST be found in the new PodTemplate.

## [PodTemplate lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/podtemplates.go#L54)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] PodTemplates should run the lifecycle of PodTemplates [Conformance]

Attempt to create a PodTemplate. Patch the created PodTemplate. Fetching the PodTemplate MUST reflect changes. By fetching all the PodTemplates via a Label selector it MUST find the PodTemplate by it's static label and updated value. The PodTemplate must be deleted.

## [Pods, QOS](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/node/pods.go#L163)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Pods Extended Pods Set QOS Class should be set on Pods with matching resource requests and limits for memory and cpu [Conformance]

Create a Pod with CPU and Memory request and limits. Pod status MUST have QOSClass set to PodQOSGuaranteed.

## [Pods, ActiveDeadlineSeconds](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L399)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Pods should allow activeDeadlineSeconds to be updated [NodeConformance] [Conformance]

Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. The Pod is updated with ActiveDeadlineSeconds set on the Pod spec. Pod MUST terminate of the specified time elapses.

## [Pods, lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L227)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Pods should be submitted and removed [NodeConformance] [Conformance]

A Pod is created with a unique label. Pod MUST be accessible when queried using the label selector upon creation. Add a watch, check if the Pod is running. Pod then deleted, The pod deletion timestamp is observed. The watch MUST return the pod deleted event. Query with the original selector for the Pod MUST return empty list.

## [Pods, update](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L345)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Pods should be updated [NodeConformance] [Conformance]

Create a Pod with a unique label. Query for the Pod with the label as selector MUST be successful. Update the pod to change the value of the Label. Query for the Pod with the new value for the label MUST be successful.

## [Pods, service environment variables](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L445)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Pods should contain environment variables for services [NodeConformance] [Conformance]

Create a server Pod listening on port 9376. A Service called fooservice is created for the server Pod listening on port 8765 targeting port 8080. If a new Pod is created in the cluster then the Pod MUST have the fooservice environment variables available from this new Pod. The new create Pod MUST have environment variables such as FOOSERVICE_SERVICE_HOST, FOOSERVICE_SERVICE_PORT, FOOSERVICE_PORT, FOOSERVICE_PORT_8765_TCP_PORT, FOOSERVICE_PORT_8765_TCP_PROTO, FOOSERVICE_PORT_8765_TCP and FOOSERVICE_PORT_8765_TCP_ADDR that are populated with proper values.

## [Pods, delete a collection](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L846)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] Pods should delete a collection of pods [Conformance]

A set of pods is created with a label selector which MUST be found when listed. The set of pods is deleted and MUST NOT show up when listed by its label selector.

## [Pods, assigned hostip](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L205)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Pods should get a host IP [NodeConformance] [Conformance]

Create a Pod. Pod status MUST return successfully and contains a valid IP address.

## [Pods, patching status](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L1084)

- Added to conformance in release v1.25
- Defined in code as: [sig-node] Pods should patch a pod status [Conformance]

A pod is created which MUST succeed and be found running. The pod status when patched MUST succeed. Given the patching of the pod status, the fields MUST equal the new values.

## [Pods, completes the lifecycle of a Pod and the PodStatus](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L897)

- Added to conformance in release v1.20
- Defined in code as: [sig-node] Pods should run through the lifecycle of Pods and PodStatus [Conformance]

A Pod is created with a static label which MUST succeed. It MUST succeed when patching the label and the pod data. When checking and replacing the PodStatus it MUST succeed. It MUST succeed when deleting the Pod.

## [Pods, remote command execution over websocket](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L537)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Pods should support remote command execution over websockets [NodeConformance] [Conformance]

A Pod is created. Websocket is created to retrieve exec command output from this pod. Message retrieved form Websocket MUST match with expected exec command output.

## [Pods, logs from websockets](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/pods.go#L619)

- Added to conformance in release v1.13
- Defined in code as: [sig-node] Pods should support retrieving logs from the container over websockets [NodeConformance] [Conformance]

A Pod is created. Websocket is created to retrieve log of a container from this pod. Message retrieved form Websocket MUST match with container's output.

## [Pods, prestop hook](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/node/pre_stop.go#L169)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] PreStop should call prestop when killing a pod [Conformance]

Create a server pod with a rest endpoint '/write' that changes state.Received field. Create a Pod with a pre-stop handle that posts to the /write endpoint on the server Pod. Verify that the Pod with pre-stop hook is running. Delete the Pod with the pre-stop hook. Before the Pod is deleted, pre-stop handler MUST be called when configured. Verify that the Pod is deleted and a call to prestop hook is verified by checking the status received on the server Pod.

## [Pod liveness probe, using http endpoint, failure](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L215)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Probing container should *not* be restarted with a /healthz http liveness probe [NodeConformance] [Conformance]

A Pod is created with liveness probe on http endpoint '/'. Liveness probe on this endpoint will not fail. When liveness probe does not fail then the restart count MUST remain zero.

## [Pod liveness probe, using grpc call, success](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L528)

- Added to conformance in release v1.23
- Defined in code as: [sig-node] Probing container should *not* be restarted with a GRPC liveness probe [NodeConformance] [Conformance]

A Pod is created with liveness probe on grpc service. Liveness probe on this endpoint will not fail. When liveness probe does not fail then the restart count MUST remain zero.

## [Pod liveness probe, using local file, no restart](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L152)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Probing container should *not* be restarted with a exec "cat /tmp/health" liveness probe [NodeConformance] [Conformance]

Pod is created with liveness probe that uses 'exec' command to cat /temp/health file. Liveness probe MUST not fail to check health and the restart count should remain 0.

## [Pod liveness probe, using tcp socket, no restart](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L184)

- Added to conformance in release v1.18
- Defined in code as: [sig-node] Probing container should *not* be restarted with a tcp:8080 liveness probe [NodeConformance] [Conformance]

A Pod is created with liveness probe on tcp socket 8080. The http handler on port 8080 will return http errors after 10 seconds, but the socket will remain open. Liveness probe MUST not fail to check health and the restart count should remain 0.

## [Pod liveness probe, using http endpoint, restart](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L169)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Probing container should be restarted with a /healthz http liveness probe [NodeConformance] [Conformance]

A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod MUST now be killed and restarted incrementing restart count to 1.

## [Pod liveness probe, using grpc call, failure](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L551)

- Added to conformance in release v1.23
- Defined in code as: [sig-node] Probing container should be restarted with a GRPC liveness probe [NodeConformance] [Conformance]

A Pod is created with liveness probe on grpc service. Liveness probe on this endpoint should fail because of wrong probe port. When liveness probe does  fail then the restart count should +1.

## [Pod liveness probe, using local file, restart](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L135)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Probing container should be restarted with a exec "cat /tmp/health" liveness probe [NodeConformance] [Conformance]

Create a Pod with liveness probe that uses ExecAction handler to cat /temp/health file. The Container deletes the file /temp/health after 10 second, triggering liveness probe to fail. The Pod MUST now be killed and restarted incrementing restart count to 1.

## [Pod liveness probe, using http endpoint, multiple restarts (slow)](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L199)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Probing container should have monotonically increasing restart count [NodeConformance] [Conformance]

A Pod is created with liveness probe on http endpoint /healthz. The http handler on the /healthz will return a http error after 10 seconds since the Pod is started. This MUST result in liveness check failure. The Pod MUST now be killed and restarted incrementing restart count to 1. The liveness probe must fail again after restart once the http handler for /healthz enpoind on the Pod returns an http error after 10 seconds from the start. Restart counts MUST increment every time health check fails, measure up to 5 restart.

## [Pod readiness probe, with initial delay](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L72)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Probing container with readiness probe should not be ready before initial delay and never restart [NodeConformance] [Conformance]

Create a Pod that is configured with a initial delay set on the readiness probe. Check the Pod Start time to compare to the initial delay. The Pod MUST be ready only after the specified initial delay.

## [Pod readiness probe, failure](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/container_probe.go#L108)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Probing container with readiness probe that fails should never be ready and never restart [NodeConformance] [Conformance]

Create a Pod with a readiness probe that fails consistently. When this Pod is created, then the Pod MUST never be ready, never be running and restart count MUST be zero.

## [Pod with the deleted RuntimeClass is rejected.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtimeclass.go#L158)

- Added to conformance in release v1.20
- Defined in code as: [sig-node] RuntimeClass should reject a Pod requesting a deleted RuntimeClass [NodeConformance] [Conformance]

Pod requesting the deleted RuntimeClass must be rejected.

## [Pod with the non-existing RuntimeClass is rejected.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtimeclass.go#L57)

- Added to conformance in release v1.20
- Defined in code as: [sig-node] RuntimeClass should reject a Pod requesting a non-existent RuntimeClass [NodeConformance] [Conformance]

The Pod requesting the non-existing RuntimeClass must be rejected.

## [RuntimeClass Overhead field must be respected.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtimeclass.go#L131)

- Added to conformance in release v1.24
- Defined in code as: [sig-node] RuntimeClass should schedule a Pod requesting a RuntimeClass and initialize its Overhead [NodeConformance] [Conformance]

The Pod requesting the existing RuntimeClass must be scheduled. This test doesn't validate that the Pod will actually start because this functionality depends on container runtime and preconfigured handler. Runtime-specific functionality is not being tested here.

## [Can schedule a pod requesting existing RuntimeClass.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtimeclass.go#L106)

- Added to conformance in release v1.20
- Defined in code as: [sig-node] RuntimeClass should schedule a Pod requesting a RuntimeClass without PodOverhead [NodeConformance] [Conformance]

The Pod requesting the existing RuntimeClass must be scheduled. This test doesn't validate that the Pod will actually start because this functionality depends on container runtime and preconfigured handler. Runtime-specific functionality is not being tested here.

## [RuntimeClass API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/runtimeclass.go#L191)

- Added to conformance in release v1.20
- Defined in code as: [sig-node] RuntimeClass should support RuntimeClasses API operations [Conformance]

 The node.k8s.io API group MUST exist in the /apis discovery document. The node.k8s.io/v1 API group/version MUST exist in the /apis/mode.k8s.io discovery document. The runtimeclasses resource MUST exist in the /apis/node.k8s.io/v1 discovery document. The runtimeclasses resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [Secrets, pod environment field](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/secrets.go#L48)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Secrets should be consumable from pods in env vars [NodeConformance] [Conformance]

Create a secret. Create a Pod with Container that declares a environment variable which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.

## [Secrets, pod environment from source](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/secrets.go#L97)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Secrets should be consumable via the environment [NodeConformance] [Conformance]

Create a secret. Create a Pod with Container that declares a environment variable using 'EnvFrom' which references the secret created to extract a key value from the secret. Pod MUST have the environment variable that contains proper value for the key to the secret.

## [Secrets, with empty-key](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/secrets.go#L142)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Secrets should fail to create secret due to empty secret key [Conformance]

Attempt to create a Secret with an empty key. The creation MUST fail.

## [Secret patching](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/secrets.go#L156)

- Added to conformance in release v1.18
- Defined in code as: [sig-node] Secrets should patch a secret [Conformance]

A Secret is created. Listing all Secrets MUST return an empty list. Given the patching and fetching of the Secret, the fields MUST equal the new values. The Secret is deleted by it's static Label. Secrets are listed finally, the list MUST NOT include the originally created Secret.

## [Security Context, runAsUser=65534](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/security_context.go#L350)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Security Context When creating a container with runAsUser should run the container with uid 65534 [LinuxOnly] [NodeConformance] [Conformance]

Container is created with runAsUser option by passing uid 65534 to run as unpriviledged user. Pod MUST be in Succeeded phase. [LinuxOnly]: This test is marked as LinuxOnly since Windows does not support running as UID / GID.

## [Security Context, privileged=false.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/security_context.go#L531)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Security Context When creating a pod with privileged should run the container as unprivileged when false [LinuxOnly] [NodeConformance] [Conformance]

Create a container to run in unprivileged mode by setting pod's SecurityContext Privileged option as false. Pod MUST be in Succeeded phase. [LinuxOnly]: This test is marked as LinuxOnly since it runs a Linux-specific command.

## [Security Context, readOnlyRootFilesystem=false.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/security_context.go#L489)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Security Context When creating a pod with readOnlyRootFilesystem should run the container with writable rootfs when readOnlyRootFilesystem=false [NodeConformance] [Conformance]

Container is configured to run with readOnlyRootFilesystem to false. Write operation MUST be allowed and Pod MUST be in Succeeded state.

## [Security Context, test RunAsGroup at container level](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/node/security_context.go#L337)

- Added to conformance in release v1.21
- Defined in code as: [sig-node] Security Context should support container.SecurityContext.RunAsUser And container.SecurityContext.RunAsGroup [LinuxOnly] [Conformance]

Container is created with runAsUser and runAsGroup option by passing uid 1001 and gid 2002 at containr level. Pod MUST be in Succeeded phase. [LinuxOnly]: This test is marked as LinuxOnly since Windows does not support running as UID / GID.

## [Security Context, test RunAsGroup at pod level](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/node/security_context.go#L302)

- Added to conformance in release v1.21
- Defined in code as: [sig-node] Security Context should support pod.Spec.SecurityContext.RunAsUser And pod.Spec.SecurityContext.RunAsGroup [LinuxOnly] [Conformance]

Container is created with runAsUser and runAsGroup option by passing uid 1001 and gid 2002 at pod level. Pod MUST be in Succeeded phase. [LinuxOnly]: This test is marked as LinuxOnly since Windows does not support running as UID / GID.

## [Security Context, allowPrivilegeEscalation=false.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/security_context.go#L612)

- Added to conformance in release v1.15
- Defined in code as: [sig-node] Security Context when creating containers with AllowPrivilegeEscalation should not allow privilege escalation when false [LinuxOnly] [NodeConformance] [Conformance]

Configuring the allowPrivilegeEscalation to false, does not allow the privilege escalation operation. A container is configured with allowPrivilegeEscalation=false and a given uid (1000) which is not 0. When the container is run, container's output MUST match with expected output verifying container ran with given uid i.e. uid=1000. [LinuxOnly]: This test is marked LinuxOnly since Windows does not support running as UID / GID, or privilege escalation.

## [Sysctls, reject invalid sysctls](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/sysctl.go#L125)

- Added to conformance in release v1.21
- Defined in code as: [sig-node] Sysctls [LinuxOnly] [NodeConformance] should reject invalid sysctls [MinimumKubeletVersion:1.21] [Conformance]

Pod is created with one valid and two invalid sysctls. Pod should not apply invalid sysctls. [LinuxOnly]: This test is marked as LinuxOnly since Windows does not support sysctls

## [Sysctl, test sysctls](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/sysctl.go#L79)

- Added to conformance in release v1.21
- Defined in code as: [sig-node] Sysctls [LinuxOnly] [NodeConformance] should support sysctls [MinimumKubeletVersion:1.21] [Environment:NotInUserNS] [Conformance]

Pod is created with kernel.shm_rmid_forced sysctl. Kernel.shm_rmid_forced must be set to 1 [LinuxOnly]: This test is marked as LinuxOnly since Windows does not support sysctls [Environment:NotInUserNS]: The test fails in UserNS (as expected): `open /proc/sys/kernel/shm_rmid_forced: permission denied`

## [Environment variables, expansion](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L48)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Variable Expansion should allow composing env vars into new env vars [NodeConformance] [Conformance]

Create a Pod with environment variables. Environment variables defined using previously defined environment variables MUST expand to proper values.

## [Environment variables, command argument expansion](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L96)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Variable Expansion should allow substituting values in a container's args [NodeConformance] [Conformance]

Create a Pod with environment variables and container command arguments using them. Container command arguments using the  defined environment variables MUST expand to proper values.

## [Environment variables, command expansion](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L77)

- Added to conformance in release v1.9
- Defined in code as: [sig-node] Variable Expansion should allow substituting values in a container's command [NodeConformance] [Conformance]

Create a Pod with environment variables and container command using them. Container command using the  defined environment variables MUST expand to proper values.

## [VolumeSubpathEnvExpansion, subpath expansion](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L116)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] Variable Expansion should allow substituting values in a volume subpath [Conformance]

Make sure a container's subpath can be set using an expansion of environment variables.

## [VolumeSubpathEnvExpansion, subpath with absolute path](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L190)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] Variable Expansion should fail substituting values in a volume subpath with absolute path [Slow] [Conformance]

Make sure a container's subpath can not be set using an expansion of environment variables when absolute path is supplied.

## [VolumeSubpathEnvExpansion, subpath with backticks](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L156)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] Variable Expansion should fail substituting values in a volume subpath with backticks [Slow] [Conformance]

Make sure a container's subpath can not be set using an expansion of environment variables when backticks are supplied.

## [VolumeSubpathEnvExpansion, subpath test writes](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L301)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] Variable Expansion should succeed in writing subpaths in container [Slow] [Conformance]

Verify that a subpath expansion can be used to write files into subpaths. 1.	valid subpathexpr starts a container running 2.	test for valid subpath writes 3.	successful expansion of the subpathexpr isn't required for volume cleanup

## [VolumeSubpathEnvExpansion, subpath ready from failed state](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/node/expansion.go#L229)

- Added to conformance in release v1.19
- Defined in code as: [sig-node] Variable Expansion should verify that a failing subpath expansion can be modified during the lifecycle of a container [Slow] [Conformance]

Verify that a failing subpath expansion can be modified during the lifecycle of a container.

## [LimitRange, resources](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/limit_range.go#L62)

- Added to conformance in release v1.18
- Defined in code as: [sig-scheduling] LimitRange should create a LimitRange with defaults and ensure pod has those defaults applied. [Conformance]

Creating a Limitrange and verifying the creation of Limitrange, updating the Limitrange and validating the Limitrange. Creating Pods with resources and validate the pod resources are applied to the Limitrange

## [LimitRange, list, patch and delete a LimitRange by collection](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/limit_range.go#L253)

- Added to conformance in release v1.26
- Defined in code as: [sig-scheduling] LimitRange should list, patch and delete a LimitRange by collection [Conformance]

When two limitRanges are created in different namespaces, both MUST succeed. Listing limitRanges across all namespaces with a labelSelector MUST find both limitRanges. When patching the first limitRange it MUST succeed and the fields MUST equal the new values. When deleting the limitRange by collection with a labelSelector it MUST delete only one limitRange.

## [Scheduler, resource limits](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/predicates.go#L332)

- Added to conformance in release v1.9
- Defined in code as: [sig-scheduling] SchedulerPredicates [Serial] validates resource limits of pods that are allowed to run [Conformance]

Scheduling Pods MUST fail if the resource requests exceed Machine capacity.

## [Scheduler, node selector matching](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/predicates.go#L467)

- Added to conformance in release v1.9
- Defined in code as: [sig-scheduling] SchedulerPredicates [Serial] validates that NodeSelector is respected if matching [Conformance]

Create a label on the node {k: v}. Then create a Pod with a NodeSelector set to {k: v}. Check to see if the Pod is scheduled. When the NodeSelector matches then Pod MUST be scheduled on that node.

## [Scheduler, node selector not matching](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/predicates.go#L444)

- Added to conformance in release v1.9
- Defined in code as: [sig-scheduling] SchedulerPredicates [Serial] validates that NodeSelector is respected if not matching [Conformance]

Create a Pod with a NodeSelector set to a value that does not match a node in the cluster. Since there are no nodes matching the criteria the Pod MUST not be scheduled.

## [Scheduling, HostPort and Protocol match, HostIPs different but one is default HostIP (0.0.0.0)](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/predicates.go#L705)

- Added to conformance in release v1.16
- Defined in code as: [sig-scheduling] SchedulerPredicates [Serial] validates that there exists conflict between pods with same hostPort and protocol but one using 0.0.0.0 hostIP [Conformance]

Pods with the same HostPort and Protocol, but different HostIPs, MUST NOT schedule to the same node if one of those IPs is the default HostIP of 0.0.0.0, which represents all IPs on the host.

## [Pod preemption verification](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/preemption.go#L626)

- Added to conformance in release v1.19
- Defined in code as: [sig-scheduling] SchedulerPreemption [Serial] PreemptionExecutionPath runs ReplicaSets to verify preemption running path [Conformance]

Four levels of Pods in ReplicaSets with different levels of Priority, restricted by given CPU limits MUST launch. Priority 1 - 3 Pods MUST spawn first followed by Priority 4 Pod. The ReplicaSets with Replicas MUST contain the expected number of Replicas.

## [Scheduler, Verify PriorityClass endpoints](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/preemption.go#L814)

- Added to conformance in release v1.20
- Defined in code as: [sig-scheduling] SchedulerPreemption [Serial] PriorityClass endpoints verify PriorityClass endpoints can be operated with different HTTP methods [Conformance]

Verify that PriorityClass endpoints can be listed. When any mutable field is either patched or updated it MUST succeed. When any immutable field is either patched or updated it MUST fail.

## [Scheduler, Basic Preemption](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/preemption.go#L127)

- Added to conformance in release v1.19
- Defined in code as: [sig-scheduling] SchedulerPreemption [Serial] validates basic preemption works [Conformance]

When a higher priority pod is created and no node with enough resources is found, the scheduler MUST preempt a lower priority pod and schedule the high priority pod.

## [Scheduler, Preemption for critical pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/preemption.go#L221)

- Added to conformance in release v1.19
- Defined in code as: [sig-scheduling] SchedulerPreemption [Serial] validates lower priority pod preemption by critical pod [Conformance]

When a critical pod is created and no node with enough resources is found, the scheduler MUST preempt a lower priority pod to schedule the critical pod.

## [Verify the DisruptionTarget condition is added to the preempted pod](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/scheduling/preemption.go#L329)

- Added to conformance in release v1.31
- Defined in code as: [sig-scheduling] SchedulerPreemption [Serial] validates pod disruption condition is added to the preempted pod [Conformance]

 1. Run a low priority pod with finalizer which consumes 1/1 of node resources 2. Schedule a higher priority pod which also consumes 1/1 of node resources 3. See if the pod with lower priority is preempted and has the pod disruption condition 4. Remove the finalizer so that the pod can be deleted by GC

## [CSIDriver, lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/csi_inline.go#L157)

- Added to conformance in release v1.28
- Defined in code as: [sig-storage] CSIInlineVolumes should run through the lifecycle of a CSIDriver [Conformance]

Creating two CSIDrivers MUST succeed. Patching a CSIDriver MUST succeed with its new label found. Updating a CSIDriver MUST succeed with its new label found. Two CSIDrivers MUST be found when listed. Deleting the first CSIDriver MUST succeed. Deleting the second CSIDriver via deleteCollection MUST succeed.

## [CSIInlineVolumes should support Pods with inline volumes](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/csi_inline.go#L50)

- Added to conformance in release v1.26
- Defined in code as: [sig-storage] CSIInlineVolumes should support CSIVolumeSource in Pod API [Conformance]

Pod resources with CSIVolumeSource should support create, get, list, patch, and delete operations.

## [CSIStorageCapacity API](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/csistoragecapacity.go#L50)

- Added to conformance in release v1.24
- Defined in code as: [sig-storage] CSIStorageCapacity should support CSIStorageCapacities API operations [Conformance]

 The storage.k8s.io API group MUST exist in the /apis discovery document. The storage.k8s.io/v1 API group/version MUST exist in the /apis/mode.k8s.io discovery document. The csistoragecapacities resource MUST exist in the /apis/storage.k8s.io/v1 discovery document. The csistoragecapacities resource must support create, get, list, watch, update, patch, delete, and deletecollection.

## [ConfigMap Volume, text data, binary data](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L176)

- Added to conformance in release v1.12
- Defined in code as: [sig-storage] ConfigMap binary data should be reflected in volume [NodeConformance] [Conformance]

The ConfigMap that is created with text data and binary data MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. ConfigMap's text data and binary data MUST be verified by reading the content from the mounted files in the Pod.

## [ConfigMap Volume, create, update and delete](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L241)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap optional updates should be reflected in volume [NodeConformance] [Conformance]

The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the config map is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod. Also when the item(file) is deleted from the map that MUST result in a error reading that item(file).

## [ConfigMap Volume, without mapping](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L48)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap should be consumable from pods in volume [NodeConformance] [Conformance]

Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST default to 0x644.

## [ConfigMap Volume, without mapping, non-root user](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L75)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap should be consumable from pods in volume as non-root [NodeConformance] [Conformance]

Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Pod is run as a non-root user with uid=1000. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The file on the volume MUST have file mode set to default value of 0x644.

## [ConfigMap Volume, without mapping, volume mode set](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L58)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap should be consumable from pods in volume with defaultMode set [LinuxOnly] [NodeConformance] [Conformance]

Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. File mode is changed to a custom value of '0x400'. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value of '0x400' This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [ConfigMap Volume, with mapping](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L90)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap should be consumable from pods in volume with mappings [NodeConformance] [Conformance]

Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST default to 0x644.

## [ConfigMap Volume, with mapping, volume mode set](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L100)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap should be consumable from pods in volume with mappings and Item mode set [LinuxOnly] [NodeConformance] [Conformance]

Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. File mode is changed to a custom value of '0x400'. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The data content of the file MUST be readable and verified and file modes MUST be set to the custom value of '0x400' This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [ConfigMap Volume, with mapping, non-root user](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L110)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap should be consumable from pods in volume with mappings as non-root [NodeConformance] [Conformance]

Create a ConfigMap, create a Pod that mounts a volume and populates the volume with data stored in the ConfigMap. Files are mapped to a path in the volume. Pod is run as a non-root user with uid=1000. The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount. The file on the volume MUST have file mode set to default value of 0x644.

## [ConfigMap Volume, multiple volume maps](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L424)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap should be consumable in multiple volumes in the same pod [NodeConformance] [Conformance]

The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to multiple paths in the Pod. The content MUST be accessible from all the mapped volume mounts.

## [ConfigMap Volume, immutability](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L505)

- Added to conformance in release v1.21
- Defined in code as: [sig-storage] ConfigMap should be immutable if `immutable` field is set [Conformance]

Create a ConfigMap. Update it's data field, the update MUST succeed. Mark the ConfigMap as immutable, the update MUST succeed. Try to update its data, the update MUST fail. Try to mark the ConfigMap back as not immutable, the update MUST fail. Try to update the ConfigMap`s metadata (labels), the update must succeed. Try to delete the ConfigMap, the deletion must succeed.

## [ConfigMap Volume, update](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/configmap_volume.go#L125)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] ConfigMap updates should be reflected in volume [NodeConformance] [Conformance]

The ConfigMap that is created MUST be accessible to read from the newly created Pod using the volume mount that is mapped to custom path in the Pod. When the ConfigMap is updated the change to the config map MUST be verified by reading the content from the mounted file in the Pod.

## [DownwardAPI volume, CPU limits](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L195)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should provide container's cpu limit [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the CPU limits. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume.

## [DownwardAPI volume, CPU request](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L223)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should provide container's cpu request [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the CPU request. The container runtime MUST be able to access CPU request from the specified path on the mounted volume.

## [DownwardAPI volume, memory limits](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L209)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should provide container's memory limit [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the memory limits. The container runtime MUST be able to access memory limits from the specified path on the mounted volume.

## [DownwardAPI volume, memory request](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L237)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should provide container's memory request [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the memory request. The container runtime MUST be able to access memory request from the specified path on the mounted volume.

## [DownwardAPI volume, CPU limit, default node allocatable](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L251)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should provide node allocatable (cpu) as default cpu limit if the limit is not set [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the CPU limits. CPU limits is not specified for the container. The container runtime MUST be able to access CPU limits from the specified path on the mounted volume and the value MUST be default node allocatable.

## [DownwardAPI volume, memory limit, default node allocatable](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L263)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should provide node allocatable (memory) as default memory limit if the limit is not set [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the memory limits. memory limits is not specified for the container. The container runtime MUST be able to access memory limits from the specified path on the mounted volume and the value MUST be default node allocatable.

## [DownwardAPI volume, pod name](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L55)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should provide podname only [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume.

## [DownwardAPI volume, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L70)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should set DefaultMode on files [LinuxOnly] [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource with the volumesource mode set to -r-------- and DownwardAPIVolumeFiles contains a item for the Pod name. The container runtime MUST be able to access Pod name from the specified path on the mounted volume. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [DownwardAPI volume, file mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L86)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should set mode on item file [LinuxOnly] [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains a item for the Pod name with the file mode set to -r--------. The container runtime MUST be able to access Pod name from the specified path on the mounted volume. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [DownwardAPI volume, update annotations](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L164)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should update annotations on modification [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains list of items for each of the Pod annotations. The container runtime MUST be able to access Pod annotations from the specified path on the mounted volume. Update the annotations by adding a new annotation to the running Pod. The new annotation MUST be available from the mounted volume.

## [DownwardAPI volume, update label](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/downwardapi_volume.go#L132)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Downward API volume should update labels on modification [NodeConformance] [Conformance]

A Pod is configured with DownwardAPIVolumeSource and DownwardAPIVolumeFiles contains list of items for each of the Pod labels. The container runtime MUST be able to access Pod labels from the specified path on the mounted volume. Update the labels by adding a new label to the running Pod. The new label MUST be available from the mounted volume.

## [EmptyDir, Shared volumes between containers](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L230)

- Added to conformance in release v1.15
- Defined in code as: [sig-storage] EmptyDir volumes pod should support shared volumes between containers [Conformance]

A Pod created with an 'emptyDir' Volume, should share volumes between the containeres in the pod. The two busybox image containers should share the volumes mounted to the pod. The main container should wait until the sub container drops a file, and main container access the shared data.

## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L200)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (non-root,0644,default) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [EmptyDir, medium memory, volume mode 0644, non-root user](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L130)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (non-root,0644,tmpfs) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.

## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L210)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (non-root,0666,default) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [EmptyDir, medium memory, volume mode 0666,, non-root user](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L140)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (non-root,0666,tmpfs) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.

## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L220)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (non-root,0777,default) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume, the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [EmptyDir, medium memory, volume mode 0777, non-root user](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L150)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (non-root,0777,tmpfs) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777. Volume is mounted into the container where container is run as a non-root user. The volume MUST have mode -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.

## [EmptyDir, medium default, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L170)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (root,0644,default) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume, the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [EmptyDir, medium memory, volume mode 0644](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L100)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (root,0644,tmpfs) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0644. The volume MUST have mode -rw-r--r-- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.

## [EmptyDir, medium default, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L180)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (root,0666,default) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume, the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [EmptyDir, medium memory, volume mode 0666](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L110)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (root,0666,tmpfs) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0666. The volume MUST have mode -rw-rw-rw- and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.

## [EmptyDir, medium default, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L190)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (root,0777,default) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume, the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [EmptyDir, medium memory, volume mode 0777](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L120)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes should support (root,0777,tmpfs) [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume mode set to 0777.  The volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs and the contents MUST be readable. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID, or the medium = 'Memory'.

## [EmptyDir, medium default, volume mode default](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L160)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes volume on default medium should have the correct mode [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume, the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [EmptyDir, medium memory, volume mode default](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/empty_dir.go#L90)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] EmptyDir volumes volume on tmpfs should have the correct mode [LinuxOnly] [NodeConformance] [Conformance]

A Pod created with an 'emptyDir' Volume and 'medium' as 'Memory', the volume MUST have mode set as -rwxrwxrwx and mount type set to tmpfs. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or the medium = 'Memory'.

## [EmptyDir Wrapper Volume, ConfigMap volumes, no race](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/empty_dir_wrapper.go#L188)

- Added to conformance in release v1.13
- Defined in code as: [sig-storage] EmptyDir wrapper volumes should not cause race condition when used for configmaps [Serial] [Conformance]

Create 50 ConfigMaps Volumes and 5 replicas of pod with these ConfigMapvolumes mounted. Pod MUST NOT fail waiting for Volumes.

## [EmptyDir Wrapper Volume, Secret and ConfigMap volumes, no conflict](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/empty_dir_wrapper.go#L67)

- Added to conformance in release v1.13
- Defined in code as: [sig-storage] EmptyDir wrapper volumes should not conflict [Conformance]

Secret volume and ConfigMap volume is created with data. Pod MUST be able to start with Secret and ConfigMap volumes mounted into the container.

## [PersistentVolumes(Claims), apply changes to a pv/pvc status](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/persistent_volumes.go#L668)

- Added to conformance in release v1.29
- Defined in code as: [sig-storage] PersistentVolumes CSI Conformance should apply changes to a pv/pvc status [Conformance]

Creating PV and PVC MUST succeed. Listing PVs with a labelSelector MUST succeed. Listing PVCs in a namespace MUST succeed. Reading PVC status MUST succeed with a valid phase found. Reading PV status MUST succeed with a valid phase found. Patching the PVC status MUST succeed with its new condition found. Patching the PV status MUST succeed with the new reason/message found. Updating the PVC status MUST succeed with its new condition found. Updating the PV status MUST succeed with the new reason/message found.

## [PersistentVolumes(Claims), lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/persistent_volumes.go#L429)

- Added to conformance in release v1.29
- Defined in code as: [sig-storage] PersistentVolumes CSI Conformance should run through the lifecycle of a PV and a PVC [Conformance]

Creating PV and PVC MUST succeed. Listing PVs with a labelSelector MUST succeed. Listing PVCs in a namespace MUST succeed. Patching a PV MUST succeed with its new label found. Patching a PVC MUST succeed with its new label found. Reading a PV and PVC MUST succeed with required UID retrieved. Deleting a PVC and PV MUST succeed and it MUST be confirmed. Replacement PV and PVC MUST be created. Updating a PV MUST succeed with its new label found. Updating a PVC MUST succeed with its new label found. Deleting the PVC and PV via deleteCollection MUST succeed and it MUST be confirmed.

## [Projected Volume, multiple projections](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_combined.go#L44)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected combined should project all components that make up the projection API [Projection] [NodeConformance] [Conformance]

A Pod is created with a projected volume source for secrets, configMap and downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the secrets, configMap values and the cpu and memory limits as well as cpu and memory requests from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, ConfigMap, create, update and delete](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L175)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap optional updates should be reflected in volume [NodeConformance] [Conformance]

Create a Pod with three containers with ConfigMaps namely a create, update and delete container. Create Container when started MUST not have configMap, update and delete containers MUST be created with a ConfigMap value as 'value-1'. Create a configMap in the create container, the Pod MUST be able to read the configMap from the create container. Update the configMap in the update container, Pod MUST be able to read the updated configMap value. Delete the configMap in the delete container. Pod MUST fail to read the configMap from the delete container.

## [Projected Volume, ConfigMap, volume mode default](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L48)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap should be consumable from pods in volume [NodeConformance] [Conformance]

A Pod is created with projected volume source 'ConfigMap' to store a configMap with default permission mode. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw-r--r--.

## [Projected Volume, ConfigMap, non-root user](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L75)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap should be consumable from pods in volume as non-root [NodeConformance] [Conformance]

A Pod is created with projected volume source 'ConfigMap' to store a configMap as non-root user with uid 1000. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -rw-r--r--.

## [Projected Volume, ConfigMap, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L58)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap should be consumable from pods in volume with defaultMode set [LinuxOnly] [NodeConformance] [Conformance]

A Pod is created with projected volume source 'ConfigMap' to store a configMap with permission mode set to 0400. Pod MUST be able to read the content of the ConfigMap successfully and the mode on the volume MUST be -r--------. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Projected Volume, ConfigMap, mapped](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L90)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap should be consumable from pods in volume with mappings [NodeConformance] [Conformance]

A Pod is created with projected volume source 'ConfigMap' to store a configMap with default permission mode. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -rw-r--r--.

## [Projected Volume, ConfigMap, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L100)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap should be consumable from pods in volume with mappings and Item mode set [LinuxOnly] [NodeConformance] [Conformance]

A Pod is created with projected volume source 'ConfigMap' to store a configMap with permission mode set to 0400. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r--r--r--. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Projected Volume, ConfigMap, mapped, non-root user](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L110)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap should be consumable from pods in volume with mappings as non-root [NodeConformance] [Conformance]

A Pod is created with projected volume source 'ConfigMap' to store a configMap as non-root user with uid 1000. The ConfigMap is also mapped to a custom path. Pod MUST be able to read the content of the ConfigMap from the custom location successfully and the mode on the volume MUST be -r--r--r--.

## [Projected Volume, ConfigMap, multiple volume paths](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L376)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap should be consumable in multiple volumes in the same pod [NodeConformance] [Conformance]

A Pod is created with a projected volume source 'ConfigMap' to store a configMap. The configMap is mapped to two different volume mounts. Pod MUST be able to read the content of the configMap successfully from the two volume mounts.

## [Projected Volume, ConfigMap, update](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_configmap.go#L125)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected configMap updates should be reflected in volume [NodeConformance] [Conformance]

A Pod is created with projected volume source 'ConfigMap' to store a configMap and performs a create and update to new value. Pod MUST be able to create the configMap with value-1. Pod MUST be able to update the value in the confgiMap to value-2.

## [Projected Volume, DownwardAPI, CPU limits](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L195)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should provide container's cpu limit [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu limits from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, DownwardAPI, CPU request](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L223)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should provide container's cpu request [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the cpu request from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, DownwardAPI, memory limits](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L209)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should provide container's memory limit [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory limits from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, DownwardAPI, memory request](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L237)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should provide container's memory request [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the memory request from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, DownwardAPI, CPU limit, node allocatable](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L251)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should provide node allocatable (cpu) as default cpu limit if the limit is not set [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default cpu limits from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, DownwardAPI, memory limit, node allocatable](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L263)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should provide node allocatable (memory) as default memory limit if the limit is not set [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests.  The CPU and memory resources for requests and limits are NOT specified for the container. Pod MUST be able to read the default memory limits from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, DownwardAPI, pod name](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L55)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should provide podname only [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles.

## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L70)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should set DefaultMode on files [LinuxOnly] [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r--------. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Projected Volume, DownwardAPI, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L86)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should set mode on item file [LinuxOnly] [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests. The default mode for the volume mount is set to 0400. Pod MUST be able to read the pod name from the mounted DownwardAPIVolumeFiles and the volume mode must be -r--------. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Projected Volume, DownwardAPI, update annotation](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L164)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should update annotations on modification [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and annotation items. Pod MUST be able to read the annotations from the mounted DownwardAPIVolumeFiles. Annotations are then updated. Pod MUST be able to read the updated values for the Annotations.

## [Projected Volume, DownwardAPI, update labels](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_downwardapi.go#L132)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected downwardAPI should update labels on modification [NodeConformance] [Conformance]

A Pod is created with a projected volume source for downwardAPI with pod name, cpu and memory limits and cpu and memory requests and label items. Pod MUST be able to read the labels from the mounted DownwardAPIVolumeFiles. Labels are then updated. Pod MUST be able to read the updated values for the Labels.

## [Projected Volume, Secrets, create, update delete](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_secret.go#L215)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected secret optional updates should be reflected in volume [NodeConformance] [Conformance]

Create a Pod with three containers with secrets namely a create, update and delete container. Create Container when started MUST no have a secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.

## [Projected Volume, Secrets, volume mode default](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_secret.go#L46)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected secret should be consumable from pods in volume [NodeConformance] [Conformance]

A Pod is created with a projected volume source 'secret' to store a secret with a specified key with default permission mode. Pod MUST be able to read the content of the key successfully and the mode MUST be -rw-r--r-- by default.

## [Project Volume, Secrets, non-root, custom fsGroup](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_secret.go#L67)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected secret should be consumable from pods in volume as non-root with defaultMode and fsGroup set [LinuxOnly] [NodeConformance] [Conformance]

A Pod is created with a projected volume source 'secret' to store a secret with a specified key. The volume has permission mode set to 0440, fsgroup set to 1001 and user set to non-root uid of 1000. Pod MUST be able to read the content of the key successfully and the mode MUST be -r--r-----. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [Projected Volume, Secrets, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_secret.go#L56)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected secret should be consumable from pods in volume with defaultMode set [LinuxOnly] [NodeConformance] [Conformance]

A Pod is created with a projected volume source 'secret' to store a secret with a specified key with permission mode set to 0x400 on the Pod. Pod MUST be able to read the content of the key successfully and the mode MUST be -r--------. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Projected Volume, Secrets, mapped](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_secret.go#L78)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected secret should be consumable from pods in volume with mappings [NodeConformance] [Conformance]

A Pod is created with a projected volume source 'secret' to store a secret with a specified key with default permission mode. The secret is also mapped to a custom path. Pod MUST be able to read the content of the key successfully and the mode MUST be -r--------on the mapped volume.

## [Projected Volume, Secrets, mapped, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_secret.go#L88)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected secret should be consumable from pods in volume with mappings and Item Mode set [LinuxOnly] [NodeConformance] [Conformance]

A Pod is created with a projected volume source 'secret' to store a secret with a specified key with permission mode set to 0400. The secret is also mapped to a specific name. Pod MUST be able to read the content of the key successfully and the mode MUST be -r-------- on the mapped volume. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Projected Volume, Secrets, mapped, multiple paths](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/projected_secret.go#L119)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Projected secret should be consumable in multiple volumes in a pod [NodeConformance] [Conformance]

A Pod is created with a projected volume source 'secret' to store a secret with a specified key. The secret is mapped to two different volume mounts. Pod MUST be able to read the content of the key successfully from the two volume mounts and the mode MUST be -r-------- on the mapped volumes.

## [Secrets Volume, create, update and delete](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L205)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Secrets optional updates should be reflected in volume [NodeConformance] [Conformance]

Create a Pod with three containers with secrets volume sources namely a create, update and delete container. Create Container when started MUST not have secret, update and delete containers MUST be created with a secret value. Create a secret in the create container, the Pod MUST be able to read the secret from the create container. Update the secret in the update container, Pod MUST be able to read the updated secret value. Delete the secret in the delete container. Pod MUST fail to read the secret from the delete container.

## [Secrets Volume, volume mode default, secret with same name in different namespace](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L99)

- Added to conformance in release v1.12
- Defined in code as: [sig-storage] Secrets should be able to mount in a volume regardless of a different secret existing with same name in different namespace [NodeConformance] [Conformance]

Create a secret with same name in two namespaces. Create a Pod with secret volume source configured into the container. Pod MUST be able to read the secrets from the mounted volume from the container runtime and only secrets which are associated with namespace where pod is created. The file mode of the secret MUST be -rw-r--r-- by default.

## [Secrets Volume, default](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L47)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Secrets should be consumable from pods in volume [NodeConformance] [Conformance]

Create a secret. Create a Pod with secret volume source configured into the container. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -rw-r--r-- by default.

## [Secrets Volume, volume mode 0440, fsGroup 1001 and uid 1000](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L68)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Secrets should be consumable from pods in volume as non-root with defaultMode and fsGroup set [LinuxOnly] [NodeConformance] [Conformance]

Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x440 as a non-root user with uid 1000 and fsGroup id 1001. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r--r-----by default. This test is marked LinuxOnly since Windows does not support setting specific file permissions, or running as UID / GID.

## [Secrets Volume, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L57)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Secrets should be consumable from pods in volume with defaultMode set [LinuxOnly] [NodeConformance] [Conformance]

Create a secret. Create a Pod with secret volume source configured into the container with file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the container runtime and the file mode of the secret MUST be -r-------- by default. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Secrets Volume, mapping](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L79)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Secrets should be consumable from pods in volume with mappings [NodeConformance] [Conformance]

Create a secret. Create a Pod with secret volume source configured into the container with a custom path. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -rw-r--r-- by default.

## [Secrets Volume, mapping, volume mode 0400](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L89)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Secrets should be consumable from pods in volume with mappings and Item Mode set [LinuxOnly] [NodeConformance] [Conformance]

Create a secret. Create a Pod with secret volume source configured into the container with a custom path and file mode set to 0x400. Pod MUST be able to read the secret from the mounted volume from the specified custom path. The file mode of the secret MUST be -r--r--r--. This test is marked LinuxOnly since Windows does not support setting specific file permissions.

## [Secrets Volume, mapping multiple volume paths](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L125)

- Added to conformance in release v1.9
- Defined in code as: [sig-storage] Secrets should be consumable in multiple volumes in a pod [NodeConformance] [Conformance]

Create a secret. Create a Pod with two secret volume sources configured into the container in to two different custom paths. Pod MUST be able to read the secret from the both the mounted volumes from the two specified custom paths.

## [Secrets Volume, immutability](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/common/storage/secrets_volume.go#L386)

- Added to conformance in release v1.21
- Defined in code as: [sig-storage] Secrets should be immutable if `immutable` field is set [Conformance]

Create a secret. Update it's data field, the update MUST succeed. Mark the secret as immutable, the update MUST succeed. Try to update its data, the update MUST fail. Try to mark the secret back as not immutable, the update MUST fail. Try to update the secret`s metadata (labels), the update must succeed. Try to delete the secret, the deletion must succeed.

## [StorageClass, lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/storageclass.go#L53)

- Added to conformance in release v1.29
- Defined in code as: [sig-storage] StorageClasses CSI Conformance should run through the lifecycle of a StorageClass [Conformance]

Creating a StorageClass MUST succeed. Reading the StorageClass MUST succeed. Patching the StorageClass MUST succeed with its new label found. Deleting the StorageClass MUST succeed and it MUST be confirmed. Replacement StorageClass MUST be created. Updating the StorageClass MUST succeed with its new label found. Deleting the StorageClass via deleteCollection MUST succeed and it MUST be confirmed.

## [SubPath: Reading content from a configmap volume.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/subpath.go#L69)

- Added to conformance in release v1.12
- Defined in code as: [sig-storage] Subpath Atomic writer volumes should support subpaths with configmap pod [Conformance]

Containers in a pod can read content from a configmap mounted volume which was configured with a subpath.

## [SubPath: Reading content from a configmap volume.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/subpath.go#L79)

- Added to conformance in release v1.12
- Defined in code as: [sig-storage] Subpath Atomic writer volumes should support subpaths with configmap pod with mountPath of existing file [Conformance]

Containers in a pod can read content from a configmap mounted volume which was configured with a subpath and also using a mountpath that is a specific file.

## [SubPath: Reading content from a downwardAPI volume.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/subpath.go#L91)

- Added to conformance in release v1.12
- Defined in code as: [sig-storage] Subpath Atomic writer volumes should support subpaths with downward pod [Conformance]

Containers in a pod can read content from a downwardAPI mounted volume which was configured with a subpath.

## [SubPath: Reading content from a projected volume.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/subpath.go#L105)

- Added to conformance in release v1.12
- Defined in code as: [sig-storage] Subpath Atomic writer volumes should support subpaths with projected pod [Conformance]

Containers in a pod can read content from a projected mounted volume which was configured with a subpath.

## [SubPath: Reading content from a secret volume.](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/subpath.go#L59)

- Added to conformance in release v1.12
- Defined in code as: [sig-storage] Subpath Atomic writer volumes should support subpaths with secret pod [Conformance]

Containers in a pod can read content from a secret mounted volume which was configured with a subpath.

## [VolumeAttachment, lifecycle](https://github.com/kubernetes/kubernetes/tree/release-1.31/test/e2e/storage/volume_attachment.go#L57)

- Added to conformance in release v1.30
- Defined in code as: [sig-storage] VolumeAttachment Conformance should run through the lifecycle of a VolumeAttachment [Conformance]

Creating an initial VolumeAttachment MUST succeed. Reading the VolumeAttachment MUST succeed with with required name retrieved. Patching a VolumeAttachment MUST succeed with its new label found. Listing VolumeAttachment with a labelSelector MUST succeed with a single item retrieved. Deleting a VolumeAttachment MUST succeed and it MUST be confirmed. Creating a second VolumeAttachment MUST succeed. Updating the second VolumentAttachment with a new label MUST succeed with its new label found. Creating a third VolumeAttachment MUST succeed. Updating the third VolumentAttachment with a new label MUST succeed with its new label found. Deleting both VolumeAttachments via deleteCollection MUST succeed and it MUST be confirmed.

