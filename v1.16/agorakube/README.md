# Agorakube

Official documentation:
 - https://github.com/ilkilab/agorakube
 - https://github.com/ilkilab/agorakube/blob/master/docs/instructions.md

By following these steps you may reproduce the Agorakube Conformance e2e
results.

## Install Agorakube Test Lab

As per [documentation](https://github.com/ilkilab/agorakube/blob/master/LOCAL_ENVIRONMENT.md) install AgoraKube test lab on either a single node or HA mode.

You can also deploy production cluster by following [instructions](https://github.com/ilkilab/agorakube/blob/master/docs/instructions.md)

## Run Conformance Test

1. Once you AgoraKube Kubernetes cluster is active, Fetch it's kubeconfig.yaml file (located in the /root/.kube/config file on the deploy machine) and save it locally.

2. Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

3. Configure your kubeconfig file by running:
```sh
$ export KUBECONFIG="/path/to/your/cluster/kubeconfig.yml"
```

4. Run sonobuoy:
```sh
$ sonobuoy run
```

4. Watch the logs:
```sh
$ sonobuoy logs
```

5. Check the status:
```sh
$ sonobuoy status
```

6. Once the status commands shows the run as completed, you can download the results tar.gz file:
```sh
$ sonobuoy retrieve
```