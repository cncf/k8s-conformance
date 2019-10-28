# Conformance tests for KubeOperator 2.1

## Install KubeOperator 2.1

Follow the [installation](https://docs.kubeoperator.io/kubeoperator-v2.1/installation) to install KubeOperator.

#####Requirements
OS requirements: CentOS 7.6 Minimal

#####Download offline package
URL: https://kubeoperator-1256577600.file.myqcloud.com/release/2.0/kubeOperator-v2.1.35-release.tar.gz

#####Intall KubeOperator
```bash
$ tar -zxvf kubeOperator-v2.1.35-release.tar.gz
```
```bash
$ cd kubeOperator-v2.1.35-release
```
```bash
$ ./kubeopsctl install
```
Wait until service running successfully.

## Prepare hosts for deploying Kubernetes

| Name         | Role    | Count  | OS          | Size    | Description  |
| ------------ | ------- | ------ | ----------- | ------ | ---------------------------------------------------------------------- |
| master-1     | Master  | 1      | CentOS 7.6  | 4C 16G | Running etcd、kube-apiserver、kube-scheduler、kube-apiserver.           |
| worker-1     | Worker  | 1      | CentOS 7.6  | 8C 32G | Running kubelet、application workload.                                 |
| nfs-storage  | NFS     | 1      | CentOS 7.6  | 4C 16G | Provide NFS persistent storage, disk recommendations of 500G or more. |

## Deploy Kubernetes

Deploy Kubernetes according to the [documentation](https://docs.kubeoperator.io/kubeoperator-v2.1/userguide-manual).

## Run Conformance Test

1. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```bash
$ go get -u -v github.com/heptio/sonobuoy
```

2. Run sonobuoy:
```bash
$ sonobuoy run
```

3. Watch the logs:
```bash
$ sonobuoy logs
```

4. Check the status:
```bash
$ sonobuoy status
```

5. Once the status shows the run as completed, you can download the results archive by running:
```bash
$ sonobuoy retrieve
```

Please refer to [sonobuoy.tar.gz](sonobuoy.tar.gz) for the result.