# Conformance tests for RKE Kubernetes cluster

## Node Provisioning
Provision 3 nodes for your cluster. Follow the [OS requirements](https://rancher.com/docs/rke/latest/en/os/).

## Setup Your `cluster.yml` File

A minimal 3-node `cluster.yml` file should look like this:
```yaml
kubernetes_version: v1.16.0-rancher1-1
nodes:
  - address: xx.xx.xx.1
    hostname_override: node-1
    user: root
    role: [controlplane,worker,etcd]
  - address: xx.xx.xx.2
    hostname_override: node-2
    user: root
    role: [controlplane,worker,etcd]
  - address: xx.xx.xx.3
    hostname_override: node-3
    user: root
    role: [controlplane,worker,etcd]
```

## Run RKE
1. Follow the [installation](https://rancher.com/docs/rke/latest/en/installation/) to install the latest RKE release.

2. In the same directory as your `cluster.yml` file, run:
```bash
$ rke up
```
3. Wait until the cluster deployment completes successfully.

## Run Conformance Test

1. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

2. Configure your kubeconfig file by running the following command in the same directory as your `cluster.yml` file:
```sh
$ export KUBECONFIG="kube_config_cluster.yml"
```

4. Run sonobuoy:
```sh
$ sonobuoy run
```

4. Watch the logs:
```sh
$ sonobuoy logs
```

5. Check the status:
```sh
$ sonobuoy status
```

6. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ sonobuoy retrieve
```
