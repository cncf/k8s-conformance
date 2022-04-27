## To Reproduce:

Note: to reproduce you need a Giant Swarm account.

### Create cluster

```
$ gsctl create cluster --owner=myorg
```

This will report back a cluster ID that you need for the next step.


### Get Credentials


```
$ gsctl create kubeconfig -c <clusterid> --certificate-organizations=system:masters
```

### Run the tests

Wait a bit for the cluster to come up (depending on the underlying infrastructure this might take a few minutes).

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

### Destroy cluster

```
$ gsctl delete cluster -c <clusterid>
```
