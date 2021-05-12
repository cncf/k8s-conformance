# Conformance tests for kubeasz kubernetes cluster

## Node Provisioning

Provision 2 nodes for your cluster (OS: CentOS 7.9.2009)

1 master node (4c16g)

1 worker node (4c16g)

for a High-Availability Kubernetes Cluster, read [more](https://github.com/easzlab/kubeasz/blob/master/docs/setup/00-planning_and_overall_intro.md)

## Install the cluster

(1) Download 'kubeasz' code, the binaries and offline images

```
export release=3.1.0
curl -C- -fLO --retry 3 https://github.com/easzlab/kubeasz/releases/download/${release}/ezdown
chmod +x ./ezdown
./ezdown -D -m standard
```

(2) install an all-in-one cluster

```
cd /etc/kubeasz
sed -i 's/^CLUSTER_NETWORK=.*$/CLUSTER_NETWORK="calico"/g' example/hosts.allinone
sed -i 's/^PROXY_MODE=.*$/PROXY_MODE="iptables"/g' example/hosts.allinone
./ezdown -S
docker exec -it kubeasz ezctl start-aio
```

(3) Add a worker node

```
ssh-copy-id ${worker_ip}
docker exec -it kubeasz ezctl add-node default ${worker_ip}
```

## Run Conformance Test

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
