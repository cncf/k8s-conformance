# Reproducing the test results:

## Install Gardener on your Kubernetes Landscape
Check out https://github.com/gardener/garden-setup for a more detailed instruction and additional information. To install Gardener in your base cluster, a command line tool [sow](https://github.com/gardener/sow) is used. Use the provided Docker image that already contains `sow` and all required tools. To execute `sow` you call a [wrapper script](https://github.com/gardener/sow/tree/master/docker/bin) which starts `sow` in a Docker container (Docker will download the image from [eu.gcr.io/gardener-project/sow](http://eu.gcr.io/gardener-project/sow) if it is not available locally yet). Docker executes the sow command with the given arguments, and mounts parts of your file system into that container so that `sow` can read configuration files for the installation of Gardener components, and can persist the state of your installation. After `sow`'s execution Docker removes the container again.

1. Clone the `sow` repository and add the path to our [wrapper script](https://github.com/gardener/sow/tree/master/docker/bin) to your `PATH` variable so you can call `sow` on the command line.

    ```bash
    # setup for calling sow via the wrapper
    git clone "https://github.com/gardener/sow"
    cd sow
    export PATH=$PATH:$PWD/docker/bin
    ```

2. Create a directory `landscape` for your Gardener landscape and clone this repository into a subdirectory called `crop`:

    ```bash
    cd ..
    mkdir landscape
    cd landscape
    git clone "https://github.com/gardener/garden-setup" crop
    ```

3. If you don't have your `kubekonfig` stored locally somewhere yet, download it. For example, for GKE you would use the following command:

    ```bash
    gcloud container clusters get-credentials  --zone  --project
    ```

4. Save your `kubeconfig` somewhere in your `landscape` directory. For the remaining steps we will assume that you saved it using file path `landscape/kubeconfig`.

5. In your `landscape` directory, create a configuration file called `acre.yaml`. The structure of the configuration file is described [below](#configuration-file-acreyaml). Note that the relative file path `./kubeconfig` file must be specified in field `landscape.cluster.kubeconfig` in the configuration file. Checkout [configuration file acre](https://github.com/gardener/garden-setup#configuration-file-acreyaml) for configuration details.

    > Do not use file `acre.yaml` in directory `crop`. This file is used internally by the installation tool.

6. If you created the base cluster using GKE convert your `kubeconfig` file to one that uses basic authentication with Google-specific configuration parameters:

    ```bash
    sow convertkubeconfig
    ```
    When asked for credentials, enter the ones that the GKE dashboard shows when clicking on `show credentials`.

    `sow` will replace the file specified in `landscape.cluster.kubeconfig` of your `acre.yaml` file by a kubeconfig file that uses basic authentication.

7. In your first terminal window, use the following command to check in which order the components will be installed. Nothing will be deployed yet and you can test this way if your syntax in `acre.yaml` is correct:

    ```bash
    sow order -A
    ```

8. If there are no error messages, use the following command to deploy Gardener on your base cluster:

    ```bash
    sow deploy -A
    ```

9. `sow` now starts to install Gardener in your base cluster. The installation can take about 30 minutes. `sow` prints out status messages to the terminal window so that you can check the status of the installation. The other terminal window will show the newly created Kubernetes resources after a while and if their deployment was successful. Wait until the last component is deployed and all created Kubernetes resources are in status `Running`.

10. Use the following command to find out the URL of the Gardener dashboard.

    ```bash
    sow url
    ```


## Create Kubernetes Cluster

Login to SAP Gardener Dashboard to create a Kubernetes Clusters on Amazon Web Services, Microsoft Azure, Google Cloud Platform, Alibaba Cloud, or OpenStack cloud provider.

## Launch E2E Conformance Tests
Set the `KUBECONFIG` as path to the kubeconfig file of your newly created cluster (you can find the kubeconfig e.g. in the Gardener dashboard). Follow the instructions below to run the Kubernetes e2e conformance tests. Adjust values for arguments `k8sVersion` and `cloudprovider` respective to your new cluster.

```bash
#first set KUBECONFIG to your cluster
docker run -ti -e --rm -v $KUBECONFIG:/mye2e/shoot.config golang:1.15 bash
# run all commands below within container
go get github.com/gardener/test-infra; cd /go/src/github.com/gardener/test-infra
export GO111MODULE=on; export E2E_EXPORT_PATH=/tmp/export; export KUBECONFIG=/mye2e/shoot.config; export GINKGO_PARALLEL=false
go run -mod=vendor ./integration-tests/e2e --k8sVersion=1.17.1 --cloudprovider=gcp --testcasegroup="conformance"
```