# To reproduce

## Set up the cluster

1. Login to https://dev.kubermatic.io/
2. Press the "Create Cluster" button
3. Pick Kubernetes version v1.17.x
4. Complete the create cluster wizard with either DigitalOcean or AWS (using a security group that allows all inbound trafic).

When the cluster is up and running,

1. Download the kubeconfig file.
2. Set the KUBECONFIG environment variable `export KUBECONFIG=$PWD/kubeconfig`.

## Run the conformance test

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode certified-conformance --dns-pod-labels "app.kubernetes.io/name=kube-dns,app=coredns"
```

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
