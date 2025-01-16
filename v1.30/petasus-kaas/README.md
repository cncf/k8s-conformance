# Petasus KaaS

Petasus KaaS is an enterprise-grade Kubernetes-as-a-Service (KaaS) solution designed for seamless deployment and management of Kubernetes clusters. Leveraging the power of Petasus Cloud, our on-prem enterprise cloud platform, Petasus KaaS allows organizations to provision fully managed Kubernetes clusters on-demand. This integration ensures that businesses can scale their containerized applications with agility, while maintaining control, security, and compliance across private or hybrid cloud environments. Whether you need rapid deployment or robust orchestration of workloads, Petasus KaaS delivers the flexibility and performance your enterprise requires.

## Install Petasus Cloud
Please refer to the [link](../../v1.29/petasus-cloud/README.md) to install Petasus Cloud first. 

## Provision Petasus KaaS
Once finish installing the Petasus Cloud, you need to follow the following steps to provision Petasus KaaS.

The following command will bootstrap a Kubernetes controlplane.

```shell
$ edgectl create-cluster
? Cluster Name :  conformance-cluster
? Description :  A k8s cluster for running conformance tests.
? OS distro of controlplane :  ubuntu-2004
? Architecture of controlplane :  x86_64
? Kubebernetes Version :  v1.30.0
? Kube Image Name :  ubuntu-2004-v1-30-0-amd64
? Number of replicas of master :  1
? CNI to install :  antrea
? CSI to install :  openebs
? UI to install :  dashboard
? Plugins to be installed :  done
? Do you want to use service network?  Yes
? Select service network type :  external
? External Network :  external-net (0ec627fa-55d3-42a1-9677-bb455a421bb1)
? Do you want to enable external load balancer?  No
? Do you want to pull addon images from private registry?  Yes
? Do you want to use default storage class to provision the cluster?  Yes
? Select the certificate expiration duration (1Y ~ 10Y) :  10
? Do you want to provision a K8S cluster using the input information?  Yes
Cluster conformance-cluster created
Service conformance-cluster-prom created
ConfigMap conformance-cluster-cni-cm created
Cluster Resource Set conformance-cluster-cni-crs created
ConfigMap conformance-cluster-csi-cm created
Cluster Resource Set conformance-cluster-csi-crs created
ConfigMap conformance-cluster-ui-cm created
Cluster Resource Set conformance-cluster-ui-crs created
ConfigMap conformance-cluster-monitoring-cm created
Cluster Resource Set conformance-cluster-monitoring-crs created
Cluster autoscaler conformance-cluster-cluster-autoscaler created
```

Check if the Petasus KaaS cluster is up and running.

```shell
$ edgectl list-clusters 
+---------------------+-------------+-------------+----------+--------+---------+------------+------------+-------------------------+
|         NAME        |    PHASE    |      OS     | KUBE VER |  CNI   |   CSI   |     UI     | AUTOSCALER |           AGE           |
+---------------------+-------------+-------------+----------+--------+---------+------------+------------+-------------------------+
| conformance-cluster | Provisioned | ubuntu-2004 | v1.30.0  | antrea | openebs | dashboard  |  disabled  |      47 minutes ago     |
+---------------------+-------------+-------------+----------+--------+---------+------------+------------+-------------------------+
```

Create a nodepool for adding a set of worker nodes into the cluster.

```shell
$ edgectl create-nodepool
? Cluster Name :  conformance-cluster
? NodePool Name :  default-np
? Description :  A default nodepool for conformance-cluster.
? Flavor of nodepool :  m1.xlarge
? OS distro of nodepool :  ubuntu-2004
? Architecture of nodepool :  x86_64
? Kube version of nodepool :  v1.30.0
? Kube Image Name :  ubuntu-2004-v1-30-0-amd64
? Number of replicas of nodepool :  1
? Do you want to enable nodepool autoscaler?  No
? Do you want to use default storage class to provision a nodepool?  Yes
? Do you want to provision a nodepool using the input information?  Yes
Cluster conformance-cluster updated
```

Check if all the Kubernetes nodes are up and running.

```bash
$ edgectl list-machines
? Cluster Name :  conformance-cluster
? Cluster Name :  conformance-cluster
+--------------------------------------------+---------+-----------+-------+---------+-------------------------------+----------------+
|                    NAME                    |  PHASE  |   FLAVOR  | READY | NODE RD |               IP              |      AGE       |
+--------------------------------------------+---------+-----------+-------+---------+-------------------------------+----------------+
| conformance-cluster-default-np-zclp7-wptxt | Running | m1.xlarge |  True |   True  | k8s-pod-network: 10.233.94.44 | 36 minutes ago |
|                                            |         |           |       |         |  external-net: 172.16.109.76  |                |
+--------------------------------------------+---------+-----------+-------+---------+-------------------------------+----------------+
|         conformance-cluster-5lp9c          | Running | m1.xlarge |  True |   True  | k8s-pod-network: 10.233.94.47 | 48 minutes ago |
|                                            |         |           |       |         |  external-net: 172.16.109.68  |                |
+--------------------------------------------+---------+-----------+-------+---------+-------------------------------+----------------+
```

## Run Conformance Test

```shell
$ curl -LO https://github.com/kubernetes-sigs/hydrophone/releases/download/v0.6.0/hydrophone_Linux_x86_64.tar.gz
$ tar xvfz hydrophone_Linux_x86_64.tar.gz -C ./
$ ./hydrophone --conformance
```
