# Conformance testing on Cozystack

[Cozystack](https://cozystack.io/) is a free PaaS platform and framework for building
public and private clouds. It runs on bare metal and provisions tenant Kubernetes clusters
through the `Kubernetes` custom resource, with control planes managed by Kamaji and worker
nodes running as KubeVirt virtual machines on Talos Linux.

The certified artifacts in this directory were produced on a tenant Kubernetes cluster
provisioned by Cozystack v1.6.1.

## Install Cozystack

Follow the [installation guide](https://cozystack.io/docs/getting-started/) to bring up a
management cluster. The steps below assume you have `kubectl` access to it.

## Create a tenant with a dedicated etcd

Conformance requires the tenant to run its own etcd instance. Cozystack tenants share the
root etcd by default, and because etcd compaction is cluster-wide, shared-etcd tenants have
`--etcd-compaction-interval=0` set on their API servers. Setting `etcd: true` on the tenant
gives the cluster its own datastore, which makes compaction safe to enable.

```yaml
apiVersion: apps.cozystack.io/v1alpha1
kind: Tenant
metadata:
  name: conformance
  namespace: tenant-root
spec:
  etcd: true
  monitoring: false
  ingress: false
  seaweedfs: false
  resourceQuotas:
    cpu: 64
    memory: 64Gi
```

```bash
kubectl apply -f tenant.yaml
```

Create the tenant before the cluster. Switching an existing cluster to a different datastore
is not supported.

## Create the Kubernetes cluster

```yaml
apiVersion: apps.cozystack.io/v1alpha1
kind: Kubernetes
metadata:
  name: conformance
  namespace: tenant-conformance
spec:
  version: v1.34
  storageClass: replicated
  controlPlane:
    replicas: 2
    apiServer:
      extraArgs:
        - --etcd-compaction-interval=5m
  nodeGroups:
    md0:
      minReplicas: 2
      maxReplicas: 3
      instanceType: u1.medium
      diskSize: 20Gi
      storageClass: replicated
```

```bash
kubectl apply -f cluster.yaml
kubectl -n tenant-conformance wait --for=condition=Ready \
  kubernetes.apps.cozystack.io/conformance --timeout=30m
```

## Retrieve the kubeconfig

```bash
kubectl -n tenant-conformance get secret kubernetes-conformance-admin-kubeconfig \
  -o jsonpath='{.data.super-admin\.conf}' | base64 -d > conformance.kubeconfig
export KUBECONFIG=$PWD/conformance.kubeconfig
kubectl get nodes
```

## Run the conformance tests

```bash
sonobuoy run --mode=certified-conformance --plugin e2e \
  --kube-conformance-image registry.k8s.io/conformance:v1.34.9
sonobuoy status --wait
outfile=$(sonobuoy retrieve)
sonobuoy results "$outfile"
mkdir results && tar xzf "$outfile" -C results
cp results/plugins/e2e/results/global/e2e.log .
cp results/plugins/e2e/results/global/junit_01.xml .
```

Only the `e2e` plugin is run. The `systemd-logs` plugin is not compatible with Talos Linux,
which does not expose a conventional systemd journal to privileged containers.

## Clean up

```bash
sonobuoy delete --wait
kubectl -n tenant-conformance delete kubernetes.apps.cozystack.io conformance
```
