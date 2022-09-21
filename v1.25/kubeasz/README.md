# Conformance tests for kubeasz kubernetes cluster

## Node Provisioning

Provision 3 nodes for your cluster (OS: Ubuntu 20.04)

1 master node (4c16g)

2 worker node (4c16g)

for a High-Availability Kubernetes Cluster, read [more](https://github.com/easzlab/kubeasz/blob/master/docs/setup/00-planning_and_overall_intro.md)

## Install the cluster

(1) Download 'kubeasz' code, the binaries and offline images

```
export release=3.4.0
curl -C- -fLO --retry 3 https://github.com/easzlab/kubeasz/releases/download/${release}/ezdown
chmod +x ./ezdown
./ezdown -D -m standard
```

(2) install an all-in-one cluster

```
./ezdown -S
docker exec -it kubeasz ezctl start-aio
```

(3) Add two worker nodes

```
ssh-copy-id ${worker1_ip}
ssh ${worker1_ip} ln -s /usr/bin/python3 /usr/bin/python
docker exec -it kubeasz ezctl add-node default ${worker1_ip}
ssh-copy-id ${worker2_ip}
ssh ${worker2_ip} ln -s /usr/bin/python3 /usr/bin/python
docker exec -it kubeasz ezctl add-node default ${worker2_ip}
```

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes.

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance
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
