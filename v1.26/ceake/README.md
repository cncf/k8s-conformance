# Conformance test for CeaKE

## Create a cluster

1. Prepare The Nodes
- Ceake has three types of nodes: bootstrap nodes, master nodes, and worker nodes. Bootstrap nodes are responsible for cluster deployment and bootstrapping the cluster to start working. Masters serve as the control plane for the cluster, while worker nodes handle the cluster's workload. 
- Once the node role is planned, the next step is to install the operating system. The operating system supported by Ceake, such as Kylin OS, should be installed.

2. Configure the cluster
- After the system installation is completed, SSH into the bootstrap node, and execute tar -zxvf Ceake_install* to unpack the CeaKE deployment package.
- On the bootstrap node, create a CeaKE configuration file config.json, and place it in the cluster-installer/deploy folder. The content of the config.json configuration file is as follows:
```
  { 
    "baseDomain": "ceake.kylin.cn",
    "clusterName": "test0928",
    "apiAddress": "192.168.0.101",
    "ingressAddress": "192.168.0.102",
    "serviceNetworkCIRD": "172.16.0.0/16",
    "clusterNetworkCIRD": "172.17.0.0/16",
    "clusterNode": {
      "rootPassword": "Cestc_1!",
      "masters": [
          "192.168.0.6",
          "192.168.0.7",
          "192.168.0.8"
      ],
      "workers": [
          "192.168.0.9",
          "192.168.0.10"
      ]
    },
    "ntp": [
        "120.25.115.20"
    ]
  }
```

3. Deploy cluster
- After the operating system is installed, the cluster deployment process can begin. To do this, copy the Ceake installation package to the bootstrap node and unzip it. Then, execute script located in the cluster-installer/deploy directory.
```
sh bootstrap_init.sh kylin_v10sp2
```
- Wait for the installation and deployment to complete.

## Run conformance tests

1. Deploy a Sonobuoy pod to CeaKE cluster with:

```
sonobuoy run --mode=certified-conformance --dns-namespace=ccos-kni-infra --dns-pod-labels app=kni-infra-mdns 
```

2. View actively running pods:

```
sonobuoy status
```

3. Once conformance testing is completed, run:

```
sonobuoy retrieve
sonobuoy delete
```