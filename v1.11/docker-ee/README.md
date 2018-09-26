# Docker Enterprise 2.1

The Docker Enterprise 2.1 platform is made up of a number of
components.  Kubernetes is included within the Universal Control Plane (UCP)
component.

## Installing Docker Enterprise 2.1 to reproduce the results

1. Deploy a cluster of 1 or more Docker Engine Enterprise 18.09. [details](https://beta.docs.docker.com/ee/ucp/admin/install/system-requirements/)
2. Perform a `docker swarm init` on one node to create a swarm-mode manager
3. Perform a `docker swarm join ...` on the other nodes in your cluster
4. Install UCP 3.1.0-beta1 or newer on the manager node [details](https://docs.docker.com/ee/ucp/admin/install/)

```
docker run --rm -it --name ucp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  docker/ucp:3.1.0-beta1 install --swarm-port 3376 --interactive
```

5. Download an admin certificate bundle to access the system remotely
6. Source the `env.sh` to set up your environment for `docker` and `kubectl` CLI access


## Run Conformance Test

1. Download Sonobuoy CLI

```
$ go get -u -v github.com/heptio/sonobuoy
```

2. Add a mandatory cluster-admin cluster role binding

```
$ kubectl create clusterrolebinding sonobuoy-serviceaccount-cluster-admin --clusterrole=cluster-admin --serviceaccount=heptio-sonobuoy:sonobuoy-serviceaccount

```

3. Launch the conformance tests

```
$ sonobuoy run
```

Monitor the test running status:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs -f
```

Wait for `sonobuoy status` indicating the run as `completed`, retrieve the Conformance test result archive to a local directory

```
$ sonobuoy retrieve /path/to/report/target/directory
```

This command copies the `.tar.gz` archive to the `/path/to/report/target/directory` directory.

Optionally it is possible to clean up the Kubernetes objects created by Sonobuoy

```
sonobuoy delete
