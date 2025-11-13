# Lenovo xCloud Container Platform Conformance 
Lenovo xCloud Container Platform provides highly available K8S cluster delivery, upgrading and other capabilities, solves the operation and maintenance and security for multiple K8S clusters, and supports the full lifecycle management of enterprise-class containerized applications.

## Requirements

- The operating system is linux
- The linux kernel require 4.0 or higher
- three machines，Each machine CPU 8C memory 16G disk 200G

## Cluster Setup
```shell
[root@master admin]# adminctl earth kubernetes install cluster \
                     -c democluster.yaml  \
                     -i ./democluster_inventory.yaml \
                     -a /etc/kube-admin-agent/app.yml
```


## Sonobuoy

Download a binary release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases/).

If you are on a Mac, you many need to open the Security & Privacy and approve sonobuoy for
execution.

```shell
[root@master admin]# wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
[root@master admin]# tar -zxvf sonobuoy_0.57.3_linux_amd64.tar.gz
```

## Run conformance tests using sonobuoy CLI

k8s version info

```
[root@k8s01]# kubectl version
Client Version: v1.34.1
Kustomize Version: v5.7.1
Server Version: v1.34.1
```

```bash
[root@k8s01]# ./sonobuoy run --mode=certified-conformance --image-pull-policy IfNotPresent --kube-conformance-image conformance:v1.34.1 --sonobuoy-image sonobuoy/sonobuoy:v0.57.3 --e2e-repo-config conformance-image-config.yaml
````

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line `no-exit was specified, sonobuoy is now blocking`, which signals the end of the testing.

```bash
[root@k8s01]# ./sonobuoy logs -f
```
Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```bash
[root@k8s01]# ./sonobuoy retrieve
```