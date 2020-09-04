# Conformance tests for Diamanti Spektra

## Install Diamanti Spektra v3.1 (based on Kubernetes v1.18.8) and create a cluster


Diamanti cluster:

[root@softserv93 conformance]# dctl cluster status
Name           	: mycluster
UUID           	: 83863c6c-ee4a-11ea-93e7-000c29299047
State          	: Created
Version        	: 3.1.0 (0)
Etcd State     	: Healthy
Virtual IP     	: 172.16.19.196
Pod DNS Domain	: cluster.local

NAME         NODE-STATUS   K8S-STATUS   ROLE      MILLICORES   MEMORY          STORAGE   IOPS      VNICS     BANDWIDTH   SCTRLS
                                                                                                                         LOCAL, REMOTE   
softserv93   Good          Good         master    100/3000     1.07GiB/16GiB   0/0       0/0       0/0       0/0         0/64, 0/64
softserv94   Good          Good         master    100/3000     1.07GiB/16GiB   0/0       0/0       0/0       0/0         0/64, 0/64
softserv95   Good          Good         master    350/3000     1.32GiB/16GiB   0/0       0/0       0/0       0/0         0/64, 0/64



## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes, and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.18.0/sonobuoy_0.18.0_linux_amd64.tar.gz
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

