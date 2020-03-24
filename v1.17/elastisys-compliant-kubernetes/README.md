To reproduce
======================================

- Contact [Elastisys](https://compliantkubernetes.com/) and receive instructions on how to install the kubernetes clusters.
- We ran the conformance test on an workload cluster consisting of with 1 master and 2 workers.
- Once the clusters are up and running, export the kubeconfig for the workload cluster.



## Run conformance tests

Get Sonobuoy.
```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --wait
```

**NOTE:** The conformance tests can take an hour or more.

Once the tests are completed, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

The two files of interest, **e2e.log**, **junit_01.xml**, are found in **results/plugins/e2e/results/global/**. 

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
