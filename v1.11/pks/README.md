# VMware Tanzu Kubernetes Grid Integrated Edition v1.2

VMware Tanzu Kubernetes Grid Integrated Edition (TKGI) is a production grade Kubernetes-based container solution equipped with advanced networking, a private container registry, and full lifecycle management. TKGI radically simplifies the deployment and operation of Kubernetes clusters so you can run and manage containers at scale on private and public clouds.

## Installing TKGI

To get started, follow the guide [here](https://docs.pivotal.io/runtimes/pks). The guide includes instructions on how to provision and manage the TKGI control plane.

## Creating a Kubernetes Cluster

```
pks create-cluster CLUSTER-NAME -e HOSTNAME -p PLAN_NAME
pks get-credentials CLUSTER-NAME
```

## Running Conformance Tests

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy). Sonobuoy is regularly built and
kept up to date to execute against all currently supported versions of
kubernetes.

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
