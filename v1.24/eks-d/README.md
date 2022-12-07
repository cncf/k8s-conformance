# Conformance testing Amazon EKS-D

## Setup EKS-D Cluster

Setup EKS-D cluster according to the [EKS-D documentation](https://distro.eks.amazonaws.com/).

By following these steps, you may reproduce the EKS-D Conformance e2e results using
[kops](https://github.com/kubernetes/kops).

## Requirements
There are several packages you will need to install and configure.

### Kubectl

Install and configure the Kubernetes command-line tool
[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

### AWS CLI

Install and configure the [AWS CLI](https://aws.amazon.com/cli/).

### Sonobuoy

Download a binary release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases/).

If you are on a Mac, you may need to open the Security & Privacy and approve sonobuoy for
execution.

```shell
sonobuoy_version="0.56.2"
if [[ "$(uname)" == "Darwin" ]]
then
  SONOBUOY=https://github.com/vmware-tanzu/sonobuoy/releases/download/v${sonobuoy_version}/sonobuoy_${sonobuoy_version}_darwin_amd64.tar.gz
else
  SONOBUOY=https://github.com/vmware-tanzu/sonobuoy/releases/download/v${sonobuoy_version}/sonobuoy_${sonobuoy_version}_linux_386.tar.gz
fi
wget -qO- ${SONOBUOY} |tar -xz sonobuoy
chmod 755 sonobuoy
```

### kops

Install kops:

```shell
# os_arch="linux-amd64"
os_arch="darwin-amd64"
kops_version="v1.24.1"
wget -qO ./kops "https://github.com/kubernetes/kops/releases/download/${kops_version}/kops-${os_arch}"
chmod +x ./kops
```

Validate `kops` is working correctly:

```shell
./kops version
```

Some macOS systems may prevent the unsigned binary from running. Open macOS Security &
Privacy settings and approve kops for execution.

## Create kops Cluster

Use this shell script to create a cluster:

```shell
#!/usr/bin/env bash

CLUSTER_NAME="${CLUSTER_NAME:-${1?First required argument is cluster name. Cluster name must be an FQDN}}"

RELEASE_BRANCH=1-24
RELEASE=2
KUBERNETES_VERSION=v1.24.6
CNI_VERSION=v1.1.1
METRICS_SERVER_VERSION=v0.6.1
AWS_AUTH_VERSION=v0.5.9
COREDNS_VERSION=v1.8.7

export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}
S3_BUCKET="kops-state-store-${RELEASE_BRANCH}-${RELEASE}"
export KOPS_STATE_STORE=s3://${S3_BUCKET}
export CNI_VERSION_URL=https://distro.eks.amazonaws.com/kubernetes-${RELEASE_BRANCH}/releases/${RELEASE}/artifacts/plugins/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tar.gz
export CNI_ASSET_HASH_STRING=sha256:303c518bba9a79fd7fe401f6bbcd4fbc853044634a774c89121aa585f80639d2

echo "Create bucket if it does not exist..."
aws s3api create-bucket --bucket $S3_BUCKET --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION

cat << EOF > ./values.yaml
kubernetesVersion: https://distro.eks.amazonaws.com/kubernetes-${RELEASE_BRANCH}/releases/${RELEASE}/artifacts/kubernetes/${KUBERNETES_VERSION}
clusterName: $CLUSTER_NAME
configBase: $KOPS_STATE_STORE/$CLUSTER_NAME
awsRegion: $AWS_DEFAULT_REGION
pause:
  repository: public.ecr.aws/eks-distro/kubernetes/pause
  tag: ${KUBERNETES_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
kube_apiserver:
  repository: public.ecr.aws/eks-distro/kubernetes/kube-apiserver
  tag: ${KUBERNETES_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
kube_controller_manager:
  repository: public.ecr.aws/eks-distro/kubernetes/kube-controller-manager
  tag: ${KUBERNETES_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
kube_scheduler:
  repository: public.ecr.aws/eks-distro/kubernetes/kube-scheduler
  tag: ${KUBERNETES_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
kube_proxy:
  repository: public.ecr.aws/eks-distro/kubernetes/kube-proxy
  tag: ${KUBERNETES_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
metrics_server:
  repository: public.ecr.aws/eks-distro/kubernetes-sigs/metrics-server
  tag: ${METRICS_SERVER_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
awsiamauth:
  repository: public.ecr.aws/eks-distro/kubernetes-sigs/aws-iam-authenticator
  tag: ${AWS_AUTH_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
coredns:
  repository: public.ecr.aws/eks-distro/coredns/coredns
  tag: ${COREDNS_VERSION}-eks-${RELEASE_BRANCH}-${RELEASE}
EOF

cat << EOF >./aws-iam-authenticator.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-iam-authenticator
  namespace: kube-system
  labels:
    k8s-app: aws-iam-authenticator
data:
  config.yaml: |
    clusterID: $KOPS_CLUSTER_NAME
EOF

cat << EOF >./eks-d.tpl
apiVersion: kops.k8s.io/v1alpha2
kind: Cluster
metadata:
  name: {{ .clusterName }}
spec:
  api:
    dns: {}
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  configBase: {{ .configBase }}
  containerRuntime: docker
  etcdClusters:
  - cpuRequest: 200m
    etcdMembers:
    - instanceGroup: control-plane-{{.awsRegion}}a
      name: a
    memoryRequest: 100Mi
    name: main
  - cpuRequest: 100m
    etcdMembers:
    - instanceGroup: control-plane-{{.awsRegion}}a
      name: a
    memoryRequest: 100Mi
    name: events
  iam:
    allowContainerRegistry: true
    legacy: false
  kubernetesApiAccess:
  - 0.0.0.0/0
  kubernetesVersion: {{ .kubernetesVersion }}
  masterPublicName: api.{{ .clusterName }}
  networkCIDR: 172.20.0.0/16
  networking:
    kubenet: {}
  nonMasqueradeCIDR: 100.64.0.0/10
  sshAccess:
  - 0.0.0.0/0
  subnets:
  - cidr: 172.20.32.0/19
    name: {{.awsRegion}}a
    type: Public
    zone: {{.awsRegion}}a
  - cidr: 172.20.64.0/19
    name: {{.awsRegion}}b
    type: Public
    zone: {{.awsRegion}}b
  - cidr: 172.20.96.0/19
    name: {{.awsRegion}}c
    type: Public
    zone: {{.awsRegion}}c
  topology:
    dns:
      type: Public
    masters: public
    nodes: public
  kubeAPIServer:
    image: {{ .kube_apiserver.repository }}:{{ .kube_apiserver.tag }}
  kubeControllerManager:
    image: {{ .kube_controller_manager.repository }}:{{ .kube_controller_manager.tag }}
  kubeScheduler:
    image: {{ .kube_scheduler.repository }}:{{ .kube_scheduler.tag }}
  kubeProxy:
    image: {{ .kube_proxy.repository }}:{{ .kube_proxy.tag }}
  metricsServer:
    enabled: true
    insecure: true
    image: {{ .metrics_server.repository }}:{{ .metrics_server.tag }}
  authentication:
    aws:
      image: {{ .awsiamauth.repository }}:{{ .awsiamauth.tag }}
  kubeDNS:
    provider: CoreDNS
    coreDNSImage: {{ .coredns.repository }}:{{ .coredns.tag }}
  masterKubelet:
    podInfraContainerImage: {{ .pause.repository }}:{{ .pause.tag }}
  kubelet:
    podInfraContainerImage: {{ .pause.repository }}:{{ .pause.tag }}
    anonymousAuth: false
    authorizationMode: Webhook
    authenticationTokenWebhook: true

---

apiVersion: kops.k8s.io/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: {{.clusterName}}
  name: control-plane-{{.awsRegion}}a
spec:
  image: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026
  machineType: t3.medium
  maxSize: 1
  minSize: 1
  nodeLabels:
    kops.k8s.io/instancegroup: control-plane-{{.awsRegion}}a
  role: Master
  subnets:
  - {{.awsRegion}}a

---

apiVersion: kops.k8s.io/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: {{.clusterName}}
  name: nodes
spec:
  image: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026
  machineType: t3.medium
  maxSize: 3
  minSize: 3
  nodeLabels:
    kops.k8s.io/instancegroup: nodes
  role: Node
  subnets:
  - {{.awsRegion}}a
  - {{.awsRegion}}b
  - {{.awsRegion}}c
EOF

./kops toolbox template --template ./eks-d.tpl --values ./values.yaml >${CLUSTER_NAME}.yaml
./kops create -f ./${CLUSTER_NAME}.yaml
./kops create secret --name ${CLUSTER_NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub
./kops update cluster --admin --name ${CLUSTER_NAME} --yes

export KOPS_FEATURE_FLAGS=SpecOverrideFlag
./kops set cluster "${KOPS_CLUSTER_NAME}" 'cluster.spec.nodePortAccess=0.0.0.0/0'
./kops update cluster --yes

while ! kubectl --context $CLUSTER_NAME apply -f ./aws-iam-authenticator.yaml
do
    sleep 5
    echo 'Waiting for cluster to come up...'
done

cat << EOF >./core_dns_cluster_role.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:coredns
rules:
  - apiGroups:
    - ""
    resources:
    - endpoints
    - services
    - pods
    - namespaces
    verbs:
    - list
    - watch
  - apiGroups:
    - discovery.k8s.io
    resources:
    - endpointslices
    verbs:
    - list
    - watch
EOF
while ! kubectl --context $KOPS_CLUSTER_NAME apply -f ./core_dns_cluster_role.yaml
do
    sleep 5
    echo 'Waiting for coredns to come up...'
done

./kops validate cluster --wait 15m
```

## Run Sonobuoy e2e
```shell
./sonobuoy run --mode=certified-conformance --wait --kube-conformance-image k8s.gcr.io/conformance:${KUBERNETES_VERSION}
results=$(./sonobuoy retrieve)
mkdir ./results
tar xzf $results -C ./results
./sonobuoy e2e ${results}
mv results/plugins/e2e/results/global/* .
```

## Cleanup
```shell
# Cleanup your cluster:
./kops delete cluster --name ${CLUSTER_NAME} --yes
rm -rf sonobuoy* kops *tar.gz aws-iam-authenticator.yaml core_dns_cluster_role.yaml eks-d.tpl results ${CLUSTER_NAME}.yaml values.yaml
```
