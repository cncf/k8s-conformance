## To reproduce the test results, follow the steps to create a new Kubernetes cluster from scratch using Taikun:
* Create a new project
* Add 1 control plane node, 2 worker and 1 bastion
* Commit the project
* Wait for the cluster to be created
* Create a kubeconfig with cluster-admin rights and download it
* With the kubeconfig file you can run sonobouy as normal.
    * Replace ~/.kube/config, export KUBECONFIG=/wherever/kubeconfig.yaml, or use --kubeconfig.
    * You will need use a system able to connect to the cluster endpoint.

## Running Conformance Tests
The standard tool for running these tests is
[Sonobuoy](https://github.com/vmware-tanzu/sonobuoy). Sonobuoy is regularly built and
kept up to date to execute against all currently supported versions of
kubernetes.

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance  --wait --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/master"
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
