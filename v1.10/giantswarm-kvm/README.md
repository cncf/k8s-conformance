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

Wait a bit for the cluster to come up (depending on the underlying infrastructure this might take a few minutes. Then run:

```
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

Watch Sonobuoy's logs with `kubectl logs -f -n sonobuoy sonobuoy` and wait for the line `no-exit was specified, sonobuoy is now blocking`. At this point, use `kubectl cp` to bring the results to your local machine.


### Destroy cluster

```
$ gsctl delete cluster -c <clusterid>
```
