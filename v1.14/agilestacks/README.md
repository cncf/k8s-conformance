# Conformance testing Agile Stacks Kubernetes Stack.

## Setup Agile Stacks Kubernetes Stack

Deploy Agile Stacks Kubernetes Stack as per the Agile Stacks documentation. Use at least 1 master and 1 worker node. We ran our conformance tests on a cluster with 2 r4.large worker instances.

## Run conformance tests

To start the conformance tests on your Agile Stacks Kubernetes Stack download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

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