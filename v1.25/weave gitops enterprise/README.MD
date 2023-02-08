# Conformance testing Weave GitOps Enterprise
Guide to run the conformance test with a Weave GitOps Enterprise cluster.

## Install Weave GitOps Enterprise

Install Weave GitOps Enterprise according to the [Weave GitOps Enterprise](https://docs.gitops.weave.works/docs/installation/weave-gitops-enterprise).

## Configure Cluster management 

Configure the cluster management component according to the [Cluster management](https://docs.gitops.weave.works/docs/cluster-management/getting-started).

## Create a workload cluster
Create a Kubernetes cluster through a template.

Example template

   ```yaml
   apiVersion: capi.weave.works/v1alpha1
    kind: CAPITemplate
    metadata:
    name: conformance-testing-template
    namespace: default
    spec:
    description: Azure Cluster
    params:
        - name: CLUSTER_NAME
        description: The name for this cluster.
        - name: KUBERNETES_VERSION
        description: Kubernetes version to use
        options: ["v1.19.13", "v1.20.9", "v1.21.2", "v1.25.0"]
        - name: AZURE_CONTROL_PLANE_MACHINE_TYPE
        description: Machine Type for Control Plane Nodes
        options: ["Standard_D2s_v3"]
        - name: CONTROL_PLANE_MACHINE_COUNT
        description: Number of Control plane machines
        options: ["1", "3"]
        - name: AZURE_WORKER_MACHINE_TYPE
        description: Machine Type for Worker Plane Nodes
        options: ["Standard_D2s_v3", "Standard_D4_v4"]
        - name: WORKER_MACHINE_COUNT
        description: Number of worker nodes to create.
    resourcetemplates:
        - apiVersion: cluster.x-k8s.io/v1alpha4
        kind: Cluster
        metadata:
            name: ${CLUSTER_NAME}
            namespace: default
            labels:
            weave.works/capi: azure
        spec:
            clusterNetwork:
            services:
                cidrBlocks:
                - 192.168.0.0/16
            controlPlaneRef:
            apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
            kind: AzureManagedControlPlane
            name: ${CLUSTER_NAME}
            infrastructureRef:
            apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
            kind: AzureManagedCluster
            name: ${CLUSTER_NAME}

        - apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
        kind: AzureManagedControlPlane
        metadata:
            annotations:
            kustomize.toolkit.fluxcd.io/prune: disabled
            name: ${CLUSTER_NAME}
            namespace: default
        spec:
            identityRef:
            apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
            kind: AzureClusterIdentity
            name: cluster-identity
            location: centralus
            resourceGroupName: ${CLUSTER_NAME}
            subscriptionID: 6bf943cd-75d6-4e1c-b2bf-b8691841d4ae
            version: ${KUBERNETES_VERSION}

        - apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
        kind: AzureManagedCluster
        metadata:
            annotations:
            kustomize.toolkit.fluxcd.io/prune: disabled
            name: ${CLUSTER_NAME}
            namespace: default

        - apiVersion: cluster.x-k8s.io/v1alpha4
        kind: MachinePool
        metadata:
            annotations:
            kustomize.toolkit.fluxcd.io/prune: disabled
            name: agentpool0
            namespace: default
        spec:
            clusterName: ${CLUSTER_NAME}
            replicas: ${CONTROL_PLANE_MACHINE_COUNT}
            template:
            metadata: {}
            spec:
                bootstrap:
                dataSecretName: ""
                clusterName: ${CLUSTER_NAME}
                infrastructureRef:
                apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
                kind: AzureManagedMachinePool
                name: agentpool0
                version: ${KUBERNETES_VERSION}

        - apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
        kind: AzureManagedMachinePool
        metadata:
            annotations:
            kustomize.toolkit.fluxcd.io/prune: disabled
            name: agentpool0
            namespace: default
        spec:
            mode: System
            osDiskSizeGB: 512
            sku: ${AZURE_CONTROL_PLANE_MACHINE_TYPE}

        - apiVersion: cluster.x-k8s.io/v1alpha4
        kind: MachinePool
        metadata:
            annotations:
            kustomize.toolkit.fluxcd.io/prune: disabled
            name: agentpool1
            namespace: default
        spec:
            clusterName: ${CLUSTER_NAME}
            replicas: ${WORKER_MACHINE_COUNT}
            template:
            metadata: {}
            spec:
                bootstrap:
                dataSecretName: ""
                clusterName: ${CLUSTER_NAME}
                infrastructureRef:
                apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
                kind: AzureManagedMachinePool
                name: agentpool1
                version: ${KUBERNETES_VERSION}

        - apiVersion: infrastructure.cluster.x-k8s.io/v1alpha4
        kind: AzureManagedMachinePool
        metadata:
            annotations:
            kustomize.toolkit.fluxcd.io/prune: disabled
            name: agentpool1
            namespace: default
        spec:
            mode: User
            osDiskSizeGB: 1024
            sku: ${AZURE_WORKER_MACHINE_TYPE}
   ```
   

   
1. Populate the template
2. Select the cluster credentials 
3. Create a PR
4. Merge the Cluster PR
  

## Run Sonobuoy e2e
```
./sonobuoy run --mode=certified-conformance 
results=$(./sonobuoy retrieve)
mkdir ./results
tar xzf $results -C ./results
./sonobuoy e2e ${results}
mv results/plugins/e2e/results/global/* .
```
