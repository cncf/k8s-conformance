# Conformance tests for Diamanti Spektra

## Install Diamanti Spektra v3.4 (based on Kubernetes v1.21.6) and create a cluster

Use regular dctl command to create a cluster (consult Diamanti D-Series CLI Guide for details) and then create a default network for that cluster.  If you are using D-Series hardware, for your default network set host-network flag as enabled.

Diamanti 3 nodes cluster:

```
[diamanti@appserv9 K8S_1_21]$ dctl cluster status
Name           	: devtb6
UUID           	: b4818c72-57c3-11ec-a311-2c600c82ec72
State          	: Created
Version        	: 3.4.0 (10)
Etcd State     	: Healthy
Virtual IP     	: 172.16.19.23
Pod DNS Domain	: cluster.local

NAME        NODE-STATUS   K8S-STATUS   ROLE      MILLICORES   MEMORY    STORAGE   IOPS      VNICS     BANDWIDTH   SCTRLS
                                                                                                                  LOCAL, REMOTE   
appserv10   Good          Good         master    0/32000      0/64GiB   0/0       0/0       0/0       0/0         0/64, 0/64
appserv11   Good          Good         master    0/32000      0/64GiB   0/0       0/0       0/0       0/0         0/64, 0/64
appserv9    Good          Good         master*   0/32000      0/64GiB   0/0       0/0       0/0       0/0         0/64, 0/64

```

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes, and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download and extract the CLI by running:

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.55.1/sonobuoy_0.55.1_linux_amd64.tar.gz

$tar xvf sonobuoy_0.55.1_linux_amd64.tar.gz
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

