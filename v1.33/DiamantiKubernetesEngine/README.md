# Conformance tests for Diamanti Kubernetes Engine

## Install Diamanti Ultima v4.3.x (based on Kubernetes v1.33.x) and create a cluster

Use regular dctl command to create a cluster (consult Exploring the Diamanti CLI Guide for details) and then create a default network for that cluster.  If you are using Diamanti Ultima Accelerator hardware, for your default network set host-network flag as enabled.

Diamanti 3 nodes cluster:

```
$ dctl cluster status
Name           	: spt2
UUID           	: 6829967a-2a6d-11f0-ac20-a4bf016b8d92
State          	: Created
Version        	: 4.3.0 (0)
Etcd State     	: Healthy
Virtual IP     	: 172.16.52.51
Storage VLAN   	: 76
Pod DNS Domain	: cluster.local

NAME      NODE      K8S       ROLE      MILLICORES   MEMORY           STORAGE         IOPS      VNICS     BANDWIDTH      SCTRLS
          STATUS    STATUS                                                                                NET, STORAGE   LOCAL, REMOTE
spt14     Good      Good      master    4545/40000   6.3GiB/192GiB    1.19TB/3.83TB   0/500K    14/63     0/18G, 0/18G   3/64, 0/64
spt15     Good      Good      master    3120/40000   4.05GiB/192GiB   1.23TB/3.83TB   0/500K    14/63     0/18G, 0/18G   1/64, 0/64
spt16     Good      Good      master*   5225/40000   6.37GiB/192GiB   1.65TB/3.83TB   0/500K    14/63     0/18G, 0/18G   1/64, 0/64

$ dctl network list
NAME                TYPE      START ADDRESS   TOTAL     USED      GATEWAY       VLAN      NETWORK-GROUP   ZONE      PORT-GROUP
green67 (default)   public    172.16.67.10    191       42        172.16.67.1   67                                  data

```

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes, and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```

$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.2/sonobuoy_0.57.2_linux_arm64.tar.gz

```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance
```

View actively running pods:

```
$ sonobuoy status
```


To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```
$ sonobuoy retrieve
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```


