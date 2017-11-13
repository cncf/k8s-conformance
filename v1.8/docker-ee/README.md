To reproduce:


Note: This version of the Docker Enterprise Edition product is not yet
generally available at the time this PR was posted.  During the beta
period, sign up for access at http://docker.com/kubernetes


The Docker Enterprise Edition product is made up of a number of
components.  Kubernetes is included within the Universal Control Plane
component.  To install Universal Control Plane 3.0:

1. Deploy a cluster of 1 or more Docker Enterprise Edition 17.06 Engines
2. Perform a `docker swarm init` on one node to create a swarm-mode manager
3. Perform a `docker swarm join ...` on the other nodes in your cluster
4. Install Universal Control Plan 3.0 on the manager node

```
docker run --rm -it --name ucp \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docker/ucp:3.0.0 \
    install [other optional args...]
```

5. Download an admin certificate bundle to access the system remotely
6. Source the `env.sh` to set up your environment for `docker` and `kubectl` CLI access
7. Run `kubectl apply -f sonobuoy-conformance.yaml`
