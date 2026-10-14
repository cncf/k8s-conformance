# Conformance testing VEXXHOST Kubernetes

VEXXHOST uses [magnum-cluster-api](https://github.com/vexxhost/magnum-cluster-api),
a Cluster API driver for OpenStack Magnum, to provision and manage Kubernetes
clusters on OpenStack infrastructure.

## Setup the cluster

### 1. Upload the image

```bash
export KUBE_TAG=v1.35.1
IMAGE_URL="https://github.com/vexxhost/capo-image-elements/releases/latest/download/ubuntu-22.04-${KUBE_TAG}.qcow2"
IMAGE_NAME="ubuntu-22.04-${KUBE_TAG}"

wget -q "${IMAGE_URL}" -O "${IMAGE_NAME}.qcow2"
openstack image create "${IMAGE_NAME}" \
  --disk-format qcow2 \
  --container-format bare \
  --file "${IMAGE_NAME}.qcow2"
```

### 2. Create the cluster template

```bash
openstack coe cluster template create \
  --image $(openstack image show ${IMAGE_NAME} -c id -f value) \
  --external-network public \
  --dns-nameserver 1.1.1.1 \
  --master-lb-enabled \
  --master-flavor m1.large \
  --flavor m1.large \
  --network-driver cilium \
  --docker-storage-driver overlay2 \
  --coe kubernetes \
  --label kube_tag=${KUBE_TAG} \
  --label fixed_subnet_cidr=192.168.24.0/24 \
  --label octavia_provider=ovn \
  k8s-${KUBE_TAG}
```

### 3. Create the cluster

```bash
openstack coe cluster create \
  --cluster-template $(openstack coe cluster template show -c uuid -f value k8s-${KUBE_TAG}) \
  --master-count 1 \
  --node-count 2 \
  --merge-labels \
  --label audit_log_enabled=true \
  k8s-cluster
```

Wait for the cluster to reach `CREATE_COMPLETE`:

```bash
watch openstack coe cluster show k8s-cluster -c status -f value
```

### 4. Get the kubeconfig

```bash
eval $(openstack coe cluster config k8s-cluster)
```

## Run conformance tests using Hydrophone

Download [Hydrophone](https://github.com/kubernetes-sigs/hydrophone) and run the conformance tests:

```bash
HYDROPHONE_VERSION=v0.7.0

curl -LO "https://github.com/kubernetes-sigs/hydrophone/releases/download/${HYDROPHONE_VERSION}/hydrophone_Linux_x86_64.tar.gz"
tar -xzf hydrophone_Linux_x86_64.tar.gz

./hydrophone --conformance --output-dir=./hydrophone-results --parallel $(nproc)
```
