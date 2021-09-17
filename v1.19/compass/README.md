## To reproduce:

### Create Kubernetes Cluster

* Login into `Container Cloud Management Platform`.
* Select `Clusters` --> `Add` --> Input cluster name --> Select three machine from `Machines resource pool` as master node --> Select several machine as worker node(optional) --> Input pod network CIDR --> Select `Confirm` to start create cluster.

For more detailed tutorial, you can visit `https://Your-Container-Cloud-Management-Platform-Domain/tutorial/user-guide/cluster/create/`

### Deploy sonobuoy Conformance test

Once the configuration files have been created, you should be able to run `kubectl` to interact with the APIs of the Kubernetes cluster. Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.

* Use `ssh` to login into one of `master` machine.
* Download `kubectl`,`sonobuoy` from [kubernetes-client-linux](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.19.md) & [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.20.0).
* Setup cluster config path:

```bash
export KUBECONFIG=/Path/To/kubectl.kubeconfig
```
* Start test:

```bash
sonobuoy run --wait --mode=certified-conformance
# retrieve result archive to current dir
sonobuoy retrieve
# inspect e2e test result
sonobuoy e2e Result_archive.tar.gz
# clean up
sonobuoy delete --all --wait
```