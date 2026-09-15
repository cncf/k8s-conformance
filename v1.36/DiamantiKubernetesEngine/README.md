# Conformance tests for Diamanti Kubernetes Engine

## Install Diamanti Ultima v4.6.x (based on Kubernetes v1.36.x) and create a cluster

Use regular dctl command to create a cluster (consult Exploring the Diamanti CLI Guide for details) and then create a default network for that cluster.  If you are using Diamanti Ultima Accelerator hardware, for your default network set host-network flag as enabled.

Diamanti 3 nodes cluster:

```
$ dctl cluster status
Name                    : autotb4
UUID                    : 4e0e15a4-aaa1-11f1-987a-a4bf01069b8a
State                   : Created
Version                 : 4.6.0 (8)
Etcd State              : NoFaultTolerance
Virtual IP              : 172.16.19.57
Storage VLAN            : 451
Pod DNS Domain          : cluster.local

NAME        NODE      K8S       ROLE      MILLICORES   MEMORY           STORAGE    IOPS      VNICS     BANDWIDTH      SCTRLS
            STATUS    STATUS                                                                           NET, STORAGE   LOCAL, REMOTE
appserv64   Good      Good      master*   4300/40000   5.26GiB/64GiB    0/3.05TB   0/500K    1/63      0/9G, 0/9G     0/64, 0/64
appserv65   Good      Good      worker    1850/40000   2.75GiB/128GiB   0/3.05TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64
appserv66   Good      Good      worker    1850/40000   2.75GiB/128GiB   0/3.05TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64

$ dctl network list
NAME      TYPE      START ADDRESS   TOTAL     USED      GATEWAY        VLAN      NETWORK-GROUP   ZONE      PORT-GROUP
blue      public    172.16.154.4    250       3         172.16.154.1   154                                 data
default   public    172.16.153.4    250       0         172.16.153.1   153                                 data

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

$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.5/sonobuoy_0.57.5_linux_amd64.tar.gz

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


