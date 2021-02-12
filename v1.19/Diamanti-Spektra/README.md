# Conformance tests for Diamanti Spektra

## Install Diamanti Spektra v3.2 (based on Kubernetes v1.19.5) and create a cluster

Use regular dctl command to create a cluster (consult Diamanti D-Series CLI Guide for details) and then create a default network for that cluster.  If you are using D-Series hardware, for your default network set host-network flag as enabled.

Diamanti 3 nodes cluster:

```
[root@softserv93 conformance]# dctl cluster status

Name           	: softtb2
UUID           	: 39f3f322-60d7-11eb-b470-000c29632696
State          	: Created
Version        	: 3.2.0 (0)
Etcd State     	: Healthy
Virtual IP     	: 172.16.19.174
Pod DNS Domain	: cluster.local

NAME         NODE-STATUS   K8S-STATUS   ROLE      MILLICORES   MEMORY          STORAGE   IOPS      VNICS     BANDWIDTH   SCTRLS
                                                                                                                         LOCAL, REMOTE   
softserv24   Good          Good         master*   100/3000     1.07GiB/16GiB   0/0       0/0       0/0       0/0         0/64, 0/64
softserv25   Good          Good         master    350/3000     1.32GiB/16GiB   0/0       0/0       0/0       0/0         0/64, 0/64
softserv26   Good          Good         master    100/3000     1.07GiB/16GiB   0/0       0/0       0/0       0/0         0/64, 0/64
```

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes, and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.19.0/sonobuoy_0.19.0_linux_amd64.tar.gz
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run
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

