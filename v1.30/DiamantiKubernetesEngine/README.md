# Conformance tests for Diamanti Kubernetes Engine

## Install Diamanti Ultima v4.0.x (based on Kubernetes v1.30.x) and create a cluster

Use regular dctl command to create a cluster (consult Exploring the Diamanti CLI Guide for details) and then create a default network for that cluster.  If you are using Diamanti Ultima Accelerator hardware, for your default network set host-network flag as enabled.

Diamanti 3 nodes cluster:

```
[diamanti@appserv76 sono_1.30]$ dctl cluster status
Name           	: autotb11
UUID           	: ae564ec1-7033-11ef-ab11-a4bf0116b570
State          	: Created
Version        	: 4.0.0 (0)
Etcd State     	: Healthy
Virtual IP     	: 172.16.19.61
Storage VLAN   	: 500
Pod DNS Domain	: cluster.local

NAME        NODE      K8S       ROLE      MILLICORES   MEMORY           STORAGE    IOPS      VNICS     BANDWIDTH      SCTRLS
            STATUS    STATUS                                                                           NET, STORAGE   LOCAL, REMOTE
appserv76   Good      Good      master    3450/40000   4.51GiB/128GiB   0/3.05TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64
appserv77   Good      Good      master    2600/40000   3.57GiB/128GiB   0/3.05TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64
appserv78   Good      Good      master*   3600/40000   4.57GiB/128GiB   0/3.05TB   0/500K    1/63      0/18G, 0/18G   0/64, 0/64
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


