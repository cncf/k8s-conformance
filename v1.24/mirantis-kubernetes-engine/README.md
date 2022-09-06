# Mirantis Kubernetes Engine 3.6.0

The Mirantis Kubernetes Engine 3.6.0 platform is made up of a number of
components. Kubernetes is included within MKE component.

## Installing Mirantis Kubernetes Engine 3.6.0 to reproduce the results

You will need to deploy a cluster of 1 or more machines with Mirantis Mirantis Container Runtime (MCR) 22.06-beta5 or newer installed. Mirantis recommends using [Launchpad](https://github.com/Mirantis/launchpad/) tool to provision and install a cluster.

### Provision Cluster via Launchpad + Terraform
1. Download Launchpad.  More details at [Launchpad Documentation Page](https://docs.mirantis.com/mke/3.5/launchpad.html)

    For M1 platform, download command should look like this:
    ``` bash
    > wget https://github.com/Mirantis/launchpad/releases/download/1.4.1/launchpad-darwin-arm64
    ```

2. Rename the downloaded binary to launchpad, move it to a directory in the PATH variable, and give it permission to run (execute permission).

    **If macOS is in use it may be necessary to give Launchpad permissions in the Security & Privacy section in System Preferences.*

3. Verify the installation by checking the installed tool version with the launchpad version command.
    ``` bash
    $ launchpad version
    version: 1.4.1
    commit: 7e9e8d6
    ```

4. Create a Launchpad configuration file

    The cluster is configured using a yaml file.

    In the example provided, a simple two-node MKE cluster is set up using Kubernetes: one node for MKE and one for a worker node. In your editor, create a new file and copy-paste the following text as-is:

    ``` yaml
    apiVersion: launchpad.mirantis.com/mke/v1.3
    kind: mke
    metadata:
    name: mke-kube
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
        keyPath: ~/.ssh/my_key
    - role: worker
        ssh:
        address: 172.16.33.101
        keyPath: ~/.ssh/my_key
    ```

5. Add additional parameter to `launchpad.yaml` so Sonobuoy can reach MKE using default ports.
    ``` yaml
        --nodeport-range=30000-32768
    ```

6. Specify the version of MKE to be `3.6.0-tp2`
    ``` yaml
        version: 3.6.0-tp2
    ```

    Resulting `launchpad.yaml` file should look like this.
    ``` yaml
    apiVersion: launchpad.mirantis.com/mke/v1.3
    kind: mke
    metadata:
    name: mke-kube
    spec:
    mke:
        imageRepo: docker.io/mirantiseng
        installFlags:
        - --admin-username=admin
        - --admin-password=your_password_here
        - --default-node-orchestrator=kubernetes
        - --nodeport-range=30000-32768
        upgradeFlags:
        - --force-recent-backup
        - --force-minimums
        version: "3.6.0-tp2"
    hosts:
    - role: manager
        ssh:
        address: 172.16.33.100
        keyPath: ~/.ssh/my_key
    - role: worker
        ssh:
        address: 172.16.33.101
        keyPath: ~/.ssh/my_key
    mcr:
        version: "22.06.0-beta5"
        channel: test
        repoURL: https://repos.mirantis.com
        installURLLinux: https://get.mirantis.com/
        installURLWindows: https://get.mirantis.com/install.ps1
    ```

7. Bootstrap your cluster

    You can start the cluster once the cluster configuration file is fully set up. In the same directory where you created the launchpad.yaml file, run:
    ```
    $ launchpad apply
    ```

8. At the end of the `launchpad apply` process, Admin UI connection information will be shown like this.
    ``` bash
    INFO[0021] ==> Running phase: MKE cluster info
    INFO[0021] Cluster is now configured.  You can access your admin UIs at:
    INFO[0021] MKE cluster admin UI: https://test-mke-cluster-master-lb-895b79a08e57c67b.elb.eu-north-1.example.com
    ```

### Setting up your test environment
**When installed without a license, MKE will run as trial mode so you can try out MKE.  For production use, you are required to have a Mirantis Kubernetes Engine subscription.*

1. Create an environment variable with the user security token:
    ``` bash
    AUTHTOKEN=$(curl -sk -d \
    '{"username":"<username>","password":"<password>"}' \
    https://<mke-ip>/auth/login | jq -r .auth_token)
    ```
2. Download the client certificate bundle:
    ```
    curl -k -H "Authorization: Bearer $AUTHTOKEN" \
    https://<mke-ip>/api/clientbundle -o bundle.zip
    ```


## Run Conformance Test

1. Download Sonobuoy CLI at [https://github.com/vmware-tanzu/sonobuoy](https://github.com/vmware-tanzu/sonobuoy)
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.10/sonobuoy_0.56.10_darwin_arm64.tar.gz
```

2. Launch the conformance tests

```
$ ./sonobuoy run --wait --mode=certified-conformance --kube-conformance-image-version=v1.21 --plugin-env='e2e.E2E_EXTRA_ARGS=--non-blocking-taints=com.docker.ucp.manager'
```

3. Retrieve the results

```
$ sonobuoy retrieve ./results
```

4. Optionally it is possible to clean up the Kubernetes objects created by Sonobuoy

```
./sonobuoy delete
```
