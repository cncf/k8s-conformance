# inwinSTACK Kubernetes 
In this section you will deploy a cluster using vagrant.

Prerequisites:
* Ansible version: *v2.5 (or newer)*.
* [Vagrant](https://www.vagrantup.com/downloads.html): >= 2.0.0.
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads): >= 5.0.0.
* Mac OS X need to install `sshpass` tool.

## Deploy Kubernetes
The getting started guide will use Vagrant with VirtualBox to deploy a Kubernetes cluster on virtual machines. You can deploy the cluster with a single command:
```shell
$ git clone https://github.com/inwinstack/kube-ansible.git
$ cd kube-ansible
$ perl -i -pe "s/kube_version:.*/kube_version: 1.12.3/g" inventory/group_vars/all.yml
$ ./hack/setup-vms --memory 2048 --network calico -i eth1 --worker 3 --boss 1 --combine-master 0 --combine-etcd 0
Cluster Size: 1 master, 3 worker.
     VM Size: 1 vCPU, 2048 MB
     VM Info: ubuntu16, virtualbox
         CNI: calico, Binding iface: eth1
Start deploying?(y): y
...
# wait for clustr setup

# SSh into master and follow the next sction to run testing.
$ vagrant ssh k8s-m1
```

## Running Conformance Tests
The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes.

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
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
$ sonobuoy retrieve .
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