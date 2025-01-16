# Conformance tests for kubeasz kubernetes cluster

## Node Provisioning

Provision 3 nodes for your cluster (OS: Ubuntu 22.04)

1 master node (4c16g)

2 worker node (4c16g)

for a High-Availability Kubernetes Cluster, read [more](https://github.com/easzlab/kubeasz/blob/master/docs/setup/00-planning_and_overall_intro.md)

## Install the cluster

(1) Download 'kubeasz' code, the binaries and offline images

```
export release=3.6.4
curl -C- -fLO --retry 3 https://github.com/easzlab/kubeasz/releases/download/${release}/ezdown
chmod +x ./ezdown
./ezdown -D -m standard
```

(2) install an all-in-one cluster

```
./ezdown -S
source ~/.bashrc
dk ezctl start-aio
```

(3) Add two worker nodes

``` bash
ssh-copy-id ${worker1_ip}
dk ezctl add-node default ${worker1_ip}

ssh-copy-id ${worker2_ip}
dk ezctl add-node default ${worker2_ip}
```

## Run Conformance Test

The standard tool for running these tests is [Sonobuoy](https://github.com/heptio/sonobuoy).  

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v" --mode=certified-conformance
```

**NOTE:** You can run the command synchronously by adding the flag `--wait` but be aware that running the Conformance tests can take an hour or more.

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
