# Conformance test for BXCloud Platform

This document describes steps to run the conformance test for certified Kubernetes.

We use terraform and ansible playbook command to create a cluster.

If you need an authentication information for installation package, please request it by e-mail.

## Prepare environment

Prepare a server to download installation package and to run docker containers that will use ansible and terraform commands.

### Requirements

The workload environment will need:

* 2 vCPU
* 4GB RAM
* 50GB Disk
* Docker 20.x.x
* git


## Set up Kubernetes Cluster

```
$ git clone https://gitlab.bwg.co.kr/cloudfoundry/bxcp-automation.git

$ cd bxcp-automation/

$ ./setup_ansible.sh

$ ./run_public.sh

$ ./install_kc.sh

```

When the shell finishes running, information about connecting to the cluster nodes is printed.
```
    jumpbox_ip : 13.208.72.65     ( [host] / [password] )
    k8s_master_ip : 11.0.7.76   ( [host] / [password] )

```

## Run Conformance Tests

To operate the Kubernetes cluster more securely, we set up a Kubernetes cluster in a private zone.

You need to access the Kubernetes master node via the jumpbox using ssh.

```
ssh bx@13.208.72.65
ssh bx@11.0.7.76

```

Before running the conformance test, you can check the Kubernetes cluster information

```
NAME                                            STATUS   ROLES                  AGE     VERSION
ip-11-0-7-235.ap-northeast-3.compute.internal   Ready    <none>                 3d18h   v1.28.1
ip-11-0-7-63.ap-northeast-3.compute.internal    Ready    <none>                 3d18h   v1.28.1
ip-11-0-7-76.ap-northeast-3.compute.internal    Ready    control-plane,master   3d18h   v1.28.1
```

We installed the latest sonobuoy binary on the master node during installation.

You can run conformance tests using the sonobuoy command.

```
sonobuoy run --mode=certified-conformance

sonobuoy status

outfile=$(sonobuoy retrieve)

mkdir ./results; tar xzf $outfile -C ./results

mv results/plugins/e2e/results/global/* 

```


## Clean up Kubernetes Cluster

Go back to the server in the install container

```
$ ./run_public.sh

$ ./delete_all.sh kc

```





