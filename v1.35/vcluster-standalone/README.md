# Run Conformance Tests

You will need a cluster with at least 2 nodes.
The steps below assume that you will use a local minikube cluster.
We executed the test on a minikube instance with docker driver
(default auto-detected by system).

## 1. Create a multinode minikube cluster

```bash
minikube start --kubernetes-version 1.35.0 --nodes=2
```

## 2. Create the vcluster

Create a file called `vcluster.yaml` with the following content:

```yaml
controlPlane:
  distro:
    k8s:
      apiServer:
        extraArgs:
          - --service-account-jwks-uri=https://kubernetes.default.svc.cluster.local/openid/v1/jwks
      enabled: true
      image:
        tag: v1.35.0
        
  standalone:
    dataDir: "/var/lib/vcluster"
    joinNode:
        enabled: true

networking:
  podCIDR: 10.64.0.0/16
  serviceCIDR: 10.128.0.0/16
```

Create a standalone virtual cluster using `vcluster version 0.32.0` (latest) using
the following command:

```bash
# Create the vCluster
sudo curl -sfL https://github.com/loft-sh/vcluster/releases/download/v0.32.0/install-standalone.sh | sh -s -- --vcluster-name standalone --config vcluster.yaml
```

## 3. Add private nodes to virtual cluster

Follow the [private nodes](https://www.vcluster.com/docs/vcluster/deploy/worker-nodes/private-nodes/join) documentation to add 2 private nodes to vcluster.

## 4. Run Tests

Download a binary release of the CLI, or build it yourself by running:

```bash
go install github.com/vmware-tanzu/sonobuoy@latest
```

Deploy a Sonobuoy pod to your cluster with:

```bash
sonobuoy run --mode=certified-conformance --dns-pod-labels=k8s-app=vcluster-kube-dns
```

View actively running pods:

```bash
sonobuoy status
```

To inspect the logs:

```bash
sonobuoy logs
```

Once sonobuoy status shows the run as completed, copy the output directory from
the main Sonobuoy pod to a local directory:

```bash
outfile=$(sonobuoy retrieve)
```

This copies a single .tar.gz snapshot from the Sonobuoy pod into your local .
directory. Extract the contents into ./results with:

```bash
mkdir ./results; tar xzf $outfile -C ./results
```
