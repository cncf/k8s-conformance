# Mirantis Docker Enterprise 3.1

The Mirantis Docker Enterprise 3.1 platform is made up of a number of
components. Kubernetes is included within the Universal Control Plane (UCP)
component.

## Installing Mirantis Docker Enterprise 3.1 to reproduce the results

1. Deploy a cluster of 1 or more machines with Mirantis Docker Engine Enterprise 19.03.8-rc2 or newer installed.
2. Perform a `docker swarm init` on one node to create a swarm-mode manager.
3. Perform a `docker swarm join ...` on the other nodes in your cluster.
4. Install UCP 3.3.0-rc2 or newer on the manager node using the following command:

    ```
    docker run --rm -it --name ucp \
      -v /var/run/docker.sock:/var/run/docker.sock \
      docker/ucp:3.3.0-rc2 install \
      --host-address <node-ip-address> \
      --default-node-orchestrator=kubernetes \
      --interactive
    ```

    This runs the install command in interactive mode, so that you’re prompted for any necessary configuration values.
5. To use UCP, you are required to have a Mirantis Docker Enterprise subscription, or you can test the platform with a free trial license.
    1. Go to [Docker Hub](https://hub.docker.com/editions/enterprise/docker-ee-trial/trial) to get a free trial license.
    2. In your browser, navigate to the UCP web UI, log in with your administrator credentials and upload your license. Navigate to the `Admin Settings` page and in the left pane, click `License`.
    3. Click `Upload License` and navigate to your license (.lic) file. When you’re finished selecting the license, UCP updates with the new settings.
6. Download an admin certificate bundle to access the system remotely.
7. Source the `env.sh` to set up your environment for `docker` and `kubectl` CLI access.


## Run Conformance Test

1. Download Sonobuoy CLI

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.2/sonobuoy_0.17.2_linux_amd64.tar.gz
$ tar -xzf sonobuoy_0.17.2_linux_amd64.tar.gz
```

2. Add a mandatory cluster-admin cluster role binding

```
$ kubectl create clusterrolebinding sonobuoy-serviceaccount-cluster-admin --clusterrole=cluster-admin --serviceaccount=sonobuoy:sonobuoy-serviceaccount

```

3. Launch the conformance tests

```
$ ./sonobuoy run --mode=certified-conformance --kube-conformance-image-version=v1.17.4 --plugin-env='e2e.E2E_EXTRA_ARGS=--non-blocking-taints=com.docker.ucp.manager'
```

Monitor the test running status:

```
$ ./sonobuoy status
```

To inspect the logs:

```
$ ./sonobuoy logs -f
```

Wait for `sonobuoy status` indicating the run as `completed`, retrieve the Conformance test result archive to a local directory

```
$ sonobuoy retrieve ./results
```

Optionally it is possible to clean up the Kubernetes objects created by Sonobuoy

```
./sonobuoy delete
```
