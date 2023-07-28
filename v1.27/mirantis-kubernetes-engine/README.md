# Mirantis Kubernetes Engine 3.7.0

The Mirantis Kubernetes Engine 3.7.0 platform is made up of a number of
components. MKE provides and manages Kubernetes v1.27.

## Installing Mirantis Kubernetes Engine 3.7.0 to reproduce the results

You will need to deploy a cluster of 1 or more nodes with Mirantis Container Runtime (MCR) v23.0.5 or newer installed. Mirantis recommends using [Launchpad](https://github.com/Mirantis/launchpad/) to ease the provisioning and installation of an MKE cluster.

### Provision Cluster via Launchpad + Terraform

1. Download Launchpad.  More details at [Launchpad Documentation Page](https://docs.mirantis.com/mke/3.6/launchpad.html)

    The latest available Launchpad binaries can be downloaded from here: <https://github.com/Mirantis/launchpad/releases/tag/1.5.2>

2. Rename the downloaded binary to `launchpad` and move it to a directory available in your `PATH` , then set it to executable.

    **If macOS is in use it may be necessary to give Launchpad permissions in the Security & Privacy section in System Preferences.*

3. Verify the installation by checking the installed tool version with the launchpad version command.

    ```bash
    $ launchpad version
    version: 1.5.2
    commit: 0780228
    ```

4. Create a Launchpad configuration file

    The cluster is configured using a YAML file.

    In the example provided, a simple two-node MKE cluster is set up using Kubernetes: one node for MKE and one for a worker node. In your editor, create a new file and copy-paste the following text as-is and save to `launchpad.yaml`:

    ```yaml
    apiVersion: launchpad.mirantis.com/mke/v1.3
    kind: mke
    metadata:
      name: my-mke-kube
    spec:
      mke:
        adminUsername: admin
        adminPassword: your_password_here
        installFlags:
        - --default-node-orchestrator=kubernetes
      hosts:
      - role: manager
        ssh:
          address: 172.16.33.100
          user: mylogin
          keyPath: ~/.ssh/my_key
      - role: worker
        ssh:
          address: 172.16.33.101
          user: mylogin
          keyPath: ~/.ssh/my_key
    ```

5. Add additional parameter to `launchpad.yaml` so Sonobuoy can reach MKE using default ports.

    ``` yaml
    --nodeport-range=30000-32768
    ```

6. Specify the version of MKE to be `3.7.0`

    ```yaml
    version: "3.7.0"
    ```

    The resulting `launchpad.yaml` file should look like this:

    ```yaml
    apiVersion: launchpad.mirantis.com/mke/v1.3
    kind: mke
    metadata:
      name: my-mke-kube
    spec:
      hosts:
      - role: manager
        ssh:
          address: 172.16.33.100
          user: mylogin
          keyPath: ~/.ssh/my_key
      - role: worker
        ssh:
          address: 172.16.33.101
          user: mylogin
          keyPath: ~/.ssh/my_key
      mke:
        version: "3.7.0"
        adminUsername: admin
        adminPassword: your_password_here
        imageRepo: docker.io/mirantis
        installFlags:
        - --default-node-orchestrator=kubernetes
        - --nodeport-range=30000-32768
        upgradeFlags:
        - --force-recent-backup
        - --force-minimums
      mcr:
          version: "23.0.5"
          channel: stable
          repoURL: https://repos.mirantis.com
          installURLLinux: https://get.mirantis.com/
          installURLWindows: https://get.mirantis.com/install.ps1
    ```

7. Bootstrap your cluster

    You can start the cluster once the cluster configuration file is fully set up. In the same directory where you created the launchpad.yaml file, run:

    ```bash
    $ launchpad apply
    ```

8. Once the `launchpad apply` has completed, you will see the Admin UI connection information will look similar to the following example:

    ``` bash
    <- snipped for brevity ->
    INFO[0021] ==> Running phase: MKE cluster info
    INFO[0021] Cluster is now configured.  You can access your admin UIs at:
    INFO[0021] MKE cluster admin UI: https://test-mke-cluster-master-lb-895b79a08e57c67b.elb.eu-north-1.example.com
    ```

### Setting up your test environment

**When installed without a license, MKE will run as trial mode so you can try out MKE.  For production use, you are required to have a Mirantis Kubernetes Engine subscription.*

1. Download the client certificate bundle using launchpad:

```bash
launchpad client-config
```

2. Take note of the output of the command, above, which should be about 20 lines long. Towards the end you will see `INFO Successfully wrote client bundle to` followed by a directory path. The path should be in the format of:

    ```bash
    ${HOME}/.mirantis-launchpad/cluster/<cluster_name>/bundle/admin
    ```

    where `<cluster_name>` will be the `metadata.name` from the `launchpad.yaml` file.

3. Change to that directory and then source the client bundle script, then return to where your `launchpad.yaml` file is:

    ```bash
    pushd ${HOME}/.mirantis-launchpad/cluster/<cluster_name>/bundle/admin
    source env.sh
    popd
    ```

Your shell is now ready to run Sonobuoy, as well as other k8s tools such as kubectl.

## Run Conformance Test

1. Download Sonobuoy CLI at [https://github.com/vmware-tanzu/sonobuoy](https://github.com/vmware-tanzu/sonobuoy). For example, on an M1 Mac:

    ```bash
    wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.16/sonobuoy_0.56.16_darwin_arm64.tar.gz
    ```

2. Extract the Sonobuoy binary

    ```bash
    tar xzvf sonobuoy_0.56.16_darwin_arm64.tar.gz
    ```

2. Launch the conformance tests

    ```bash
    $ ./sonobuoy run --wait --mode=certified-conformance --kube-conformance-image-version=v1.27 --plugin-env='e2e.E2E_EXTRA_ARGS=--non-blocking-taints=com.docker.ucp.manager'
    ```

4. Retrieve the results

    ```bash
    $ sonobuoy retrieve ./results
    ```

4. (Optional) Clean up the Kubernetes objects created by Sonobuoy

    ```bash
    ./sonobuoy delete
    ```
