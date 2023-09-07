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
apiVersion: gitops.weave.works/v1alpha1
kind: GitopsCluster
metadata:
  labels:
    templates.weave.works/template-name: aws-eks
    templates.weave.works/template-namespace: default
    weave.works/capi: bootstrap
  name: conformance
  namespace: flux-system
spec:
  capiClusterRef:
    name: conformance

---
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  labels:
    templates.weave.works/template-name: aws-eks
    templates.weave.works/template-namespace: default
  name: conformance
  namespace: flux-system
spec:
  clusterNetwork:
    pods:
      cidrBlocks:
        - 10.120.0.0/20
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: AWSManagedControlPlane
    name: conformance-control-plane
  infrastructureRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta1
    kind: AWSManagedControlPlane
    name: conformance-control-plane

---
apiVersion: controlplane.cluster.x-k8s.io/v1beta1
kind: AWSManagedControlPlane
metadata:
  annotations:
    kustomize.toolkit.fluxcd.io/prune: disabled
  labels:
    templates.weave.works/template-name: aws-eks
    templates.weave.works/template-namespace: default
  name: conformance-control-plane
  namespace: flux-system
spec:
  additionalTags:
    creator: eneko@weave.works
  iamAuthenticatorConfig:
    mapRoles:
      - groups:
          - system:masters
        rolearn: arn:aws:iam::894516026745:role/AdministratorAccess
        username: admin
      - groups:
          - system:masters
        rolearn: arn:aws:iam::894516026745:role/WeaveEksEditor
        username: admin
  region: eu-north-1
  sshKeyName: test
  version: v1.27.4

---
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachinePool
metadata:
  annotations:
    kustomize.toolkit.fluxcd.io/prune: disabled
  labels:
    templates.weave.works/template-name: aws-eks
    templates.weave.works/template-namespace: default
  name: conformance-pool-0
  namespace: flux-system
spec:
  clusterName: conformance
  replicas: 3
  template:
    spec:
      bootstrap:
        dataSecretName: ""
      clusterName: conformance
      infrastructureRef:
        apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
        kind: AWSManagedMachinePool
        name: conformance-pool-0

---
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSManagedMachinePool
metadata:
  annotations:
    kustomize.toolkit.fluxcd.io/prune: disabled
  labels:
    templates.weave.works/template-name: aws-eks
    templates.weave.works/template-namespace: default
  name: conformance-pool-0
  namespace: flux-system
spec:
  additionalTags:
    creator: eneko@weave.works
  instanceType: t3.medium

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
