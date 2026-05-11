# Conformance tests for Diamanti Kubernetes Engine

## Install Diamanti Ultima v4.5.x (based on Kubernetes v1.35.x) and create a cluster

Use regular dctl command to create a cluster (consult Exploring the Diamanti CLI Guide for details) and then create a default network for that cluster.  If you are using Diamanti Ultima Accelerator hardware, for your default network set host-network flag as enabled.

Diamanti 3 nodes cluster:

```
$ dctl cluster status
Name             	: autotb14
UUID             	: 537e2922-4d20-11f1-ad77-a4bf01557e6b
State            	: Created
Version          	: 4.5.0 (0)
Etcd State       	: NoFaultTolerance
Virtual IP       	: 172.16.19.24
Storage VLAN     	: 495
Pod DNS Domain  	: cluster.local

NAME        NODE      K8S       ROLE      MILLICORES   MEMORY           STORAGE    IOPS      VNICS     BANDWIDTH      SCTRLS
            STATUS    STATUS                                                                           NET, STORAGE   LOCAL, REMOTE
appserv90   Good      Good      master*   4300/40000   5.26GiB/192GiB   0/7.44TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64
appserv91   Good      Good      worker    1850/40000   2.75GiB/192GiB   0/7.44TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64
appserv92   Good      Good      worker    1850/40000   2.75GiB/192GiB   0/3.83TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64


$ dctl network list
NAME      TYPE      START ADDRESS   TOTAL     USED      GATEWAY        VLAN      NETWORK-GROUP   ZONE      PORT-GROUP
blue      public    172.16.238.4    250       3         172.16.238.1   238                                 data
default   public    172.16.237.4    250       0         172.16.237.1   237                                 data

$ dctl network overlay list
NAME            TYPE      SUBNET          OVERLAY-NW   ISOLATE-NS   NETWORK-GROUP
red (default)   private   172.30.0.0/16   blue         false        
```

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes, and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```

$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_arm64.tar.gz

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


