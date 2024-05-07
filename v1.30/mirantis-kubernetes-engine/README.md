# Mirantis Kubernetes Engine 3.8.0

The Mirantis Kubernetes Engine 3.8.0 platform is made up of a number of
components, including Kubernetes v1.30.

## Installing Mirantis Kubernetes Engine 3.8.0 to reproduce the results

You will need to deploy a cluster of 1 or more nodes with Mirantis Container Runtime (MCR) v23.0.8 or newer installed. Mirantis recommends using [Launchpad](https://github.com/Mirantis/launchpad/) to ease the provisioning and installation of an MKE cluster.

### Provisioning a Cluster with Launchpad

The following section assumes that you have provisioned some instances with the necessary specifications defined in the [Reference Architecture Page](https://docs.mirantis.com/mke/3.7/common/mke-hw-reqs.html)

1. Download Launchpad. More details at [Launchpad Documentation Page](https://docs.mirantis.com/mke/3.8/launchpad.html)

    The latest available Launchpad binaries can be downloaded from here: <https://github.com/Mirantis/launchpad/releases/tag/1.5.6>

2. Rename the downloaded binary to `launchpad` and move it to a directory available in your `PATH` , then set it to executable.

   *On macOS, it may be necessary to give Launchpad permissions in the Security & Privacy section in System Preferences.*

3. Verify the installation by checking the installed tool version with the launchpad version command.

    ```shell
   launchpad version
    ```

   The output should show the version of the installed Launchpad:

   ```shell
   version: 1.5.6
   commit: 25c253f867ca2059b1ee51adb7551ec9947e1db4
   ```

4. Create a Launchpad configuration file

    The MKE cluster is configured using a YAML file. Details of the Launchpad configuration file can be found at [Launchpad Configuration Page](https://docs.mirantis.com/mke/3.7/launchpad/lp-configuration-file.html)

    For this test, the following values need to be provided to the `installFlags` section:
   1. `--nodeport-range=30000-32768` - This is to allow Sonobuoy to reach MKE using default ports.
   2. `--default-node-orchestrator=kubernetes` - This is to specify the default orchestrator as Kubernetes.

    A minimal `launchpad.yaml` file would look like this:

    ```yaml
    apiVersion: launchpad.mirantis.com/mke/v1.3
    kind: mke
    metadata:
      name: my-mke-kube
    spec:
      hosts:
      - role: manager
        ssh:
          address: <manager_ip>
          user: <ssh_user>
          keyPath: <path_to_ssh_key>
      - role: worker
        ssh:
          address: <worker_ip>
          user: <ssh_user>
          keyPath: <path_to_ssh_key>
      mke:
        version: "3.8.0-tp1"
        adminUsername: <admin_username>
        adminPassword: <admin_password>
        imageRepo: msr.ci.mirantis.com/mirantiseng
        installFlags:
        - --default-node-orchestrator=kubernetes
        - --nodeport-range=30000-32768
        upgradeFlags:
        - --force-recent-backup
        - --force-minimums
      mcr:
          version: "23.0.8"
          channel: stable
          repoURL: https://repos.mirantis.com
          installURLLinux: https://get.mirantis.com/
          installURLWindows: https://get.mirantis.com/install.ps1
    ```

5. Bootstrap your cluster

   You can create the cluster once the cluster configuration file is fully set up. In the same directory where you created the launchpad.yaml file, run:

    ```shell
    launchpad apply
    ```

6. Once the above command is completed, you will see the Admin UI connection information, similar to the following example:

   ```shell
   <- snipped for brevity ->
   INFO ==> Running phase: MKE cluster info
   INFO Cluster is now configured.                   
   INFO MKE cluster admin UI: https://35gqgj-mke-lb-1adb29b634c7ff1a.elb.us-west-2.amazonaws.com/
   INFO You can download the admin client bundle with the command 'launchpad client-config' 
   ```

### Setting up your environment

   **When installed without a license, MKE will run in trial mode.  For production use, you are required to have a Mirantis Kubernetes Engine license.*

1. Download the client certificate bundle using launchpad:

   ```shell
   launchpad client-config
   ```

   From the logs of the above command, take note of the directory where the client bundle is stored. It will be something like:

   ```shell
   INFO Successfully wrote client bundle to ${HOME}/.mirantis-launchpad/cluster/<cluster_name>/bundle/admin
   ```

   where `<cluster_name>` will be replaced by `metadata.name` from the `launchpad.yaml` file.

3. Change to that directory and then source the client bundle script, then return to where your `launchpad.yaml` file is:

    ```shell
    pushd ${HOME}/.mirantis-launchpad/cluster/<cluster_name>/bundle/admin && source env.sh && popd
    ```

   Your shell is now ready to run Sonobuoy, as well as other k8s tools such as kubectl.

## Run Conformance Test

1. Install the Sonobuoy CLI at [https://github.com/vmware-tanzu/sonobuoy](https://github.com/vmware-tanzu/sonobuoy).

2. Launch the conformance tests

    ```shell
    sonobuoy run --wait --mode=certified-conformance --kube-conformance-image-version=v1.30 --plugin-env='e2e.E2E_EXTRA_ARGS=--non-blocking-taints=com.docker.ucp.manager'
    ```

3. Once the tests are complete, retrieve the results

    ```shell
    sonobuoy retrieve ./results
    ```

4. (Optional) Clean up the Kubernetes objects created by Sonobuoy

    ```shell
    sonobuoy delete
    ```
