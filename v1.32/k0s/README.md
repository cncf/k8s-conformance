# k0s Conformance

## k0s - Zero Friction Kubernetes

Full instructions on how to set up a k0s cluster can be found in the [Quick
Start Guide].

[Quick Start Guide]: https://docs.k0sproject.io/v1.32.1+k0s.0/install/

## Requirements

k0s runs either as a single node (controller with `--enable-worker`), or as a
controller/worker cluster. These instructions assume you have one or more Linux
machines ready for installation.

Download the k0s v1.32.1+k0s.0 binary from the [GitHub Releases Page] and push
it to all the machines you wish to connect to the cluster.

[GitHub Releases Page]: https://github.com/k0sproject/k0s/releases/tag/v1.32.1+k0s.0

## Cluster Setup

### Single node

```console
k0s controller --enable-worker
```

#### Multiple nodes

##### Controller

```console
k0s controller
```

Once k0s on the controller is up, create a join token:

```console
k0s token create --role=worker
```

##### Joining Workers To The Cluster

```console
k0s worker "long-join-token"
```

## Run the Conformance Test

To run the conformance test, download a [sonobuoy release], or build it yourself
by running:

```console
go install github.com/vmware-tanzu/sonobuoy@latest
```

Deploy a Sonobuoy pod to your cluster with:

```console
export KUBECONFIG=/var/lib/k0s/pki/admin.conf
sonobuoy run --mode=certified-conformance \
  --plugin-env=e2e.E2E_EXTRA_ARGS=--ginkgo.v \
  --kubernetes-version=v1.32.1
```

The test will take more than an hour to complete, but you can follow the logs by running:

```console
sonobuoy logs -f
```

To view actively running pods:

```console
sonobuoy status
```

Example:

```console
root@controller-0:~# sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT
            e2e   complete   passed       1
   systemd-logs   complete   passed       3

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Once the tests complete, retrieve the results file by running:

```console
sonobuoy retrieve
```

[sonobuoy release]: https://github.com/vmware-tanzu/sonobuoy/releases
