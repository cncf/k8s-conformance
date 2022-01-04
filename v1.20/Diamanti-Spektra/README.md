# Conformance tests for Diamanti Spektra

## Install Diamanti Spektra v3.3 (based on Kubernetes v1.20.11) and create a cluster

Use regular dctl command to create a cluster (consult Diamanti D-Series CLI Guide for details) and then create a default network for that cluster.  If you are using D-Series hardware, for your default network set host-network flag as enabled.

Diamanti 3 nodes cluster:

```
[root@dctl-0 /]# dctl cluster status
Name           	: local
UUID           	: 
State          	: Created
Version        	: 3.3.0 (84)
Etcd State     	: NoFaultTolerance
Virtual IP     	: 

NAME       NODE-STATUS   K8S-STATUS   ROLE      MILLICORES   MEMORY     STORAGE    IOPS      VNICS     BANDWIDTH   SCTRLS
                                                                                                                   LOCAL, REMOTE   
dss5vm01   Good          Good         master*   0/16000      0/200GiB   0/0        0/0       0/0       0/0         0/64, 0/64
dss5vm02   Good          Good         worker    0/16000      0/200GiB   0/1.21TB   0/500K    0/0       0/0         0/64, 0/64
dss5vm03   Good          Good         worker    0/16000      0/200GiB   0/1.21TB   0/500K    0/0       0/0         0/64, 0/64

```

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes, and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.53.2/sonobuoy_0.53.2_linux_amd64.tar.gz

```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy gen --mode=certified-conformance > sono.yaml
$ kubectl create -f sono.yaml
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

