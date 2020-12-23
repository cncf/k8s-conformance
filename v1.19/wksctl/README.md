## To Reproduce:

## Install wksctl binary

1. Download the OS specific `wksctl` release package from the [release page](https://github.com/weaveworks/wksctl/releases)
1. Unpack and add the `wksctl` binary to your path

For example:

```console
cd <download dir>
tar xfz wksctl-0.9.0-rc.3-linux-x86_64.tar.gz
chmod +x wksctl
sudo mv wksctl /usr/local/bin/
```

## Install prerequisites

The following steps will create a wksctl cluster on GCE VMs. For other deployment options, please refer to the examples in our [documentation](https://wksctl.readthedocs.io/en/latest)

1. Install:
    - [`gcloud`](https://cloud.google.com/sdk/docs/#install_the_latest_cloud_tools_version_cloudsdk_current_version)
    - [`jk`](https://github.com/jkcfg/jk)
    - [`direnv`](https://direnv.net/)

1. [Configure `gcloud`](https://cloud.google.com/sdk/gcloud/#configurations).

1. If you have never used direnv, you need to [set it up](https://github.com/direnv/direnv#setup).
   It hooks itself into your shell to set/unset environment variables when you
   enter or leave a directory.

   ```console
   eval "$(direnv hook bash)"
   ```

1. Create an `.envrc` file with, for example, the following content (or change to appropriate values where relevant):

    ```console
    export project="wks-tests"
    export zone="europe-west1-b"
    export user="$(whoami)"
    export network="${user}-demo"
    export image_project="centos-cloud"
    export image_family="centos-7"
    export network_interface="eth0"
    ```

    (see also: [GCP images](https://cloud.google.com/compute/docs/images#images_without_shielded_vm_name_support))
    and run:

    ```console
    direnv allow
    ```

## Create the WKS cluster

1. Create the GCE network and instances:

    ```console
    ./create-network.sh && ./create-instances.sh
    ```

    > **Note:** In case cluster capacity for number of instances is reached, try using another zone in `.envrc`.

1. Generate `machines.yaml`:

    ```console
    ./generate-machines-manifest.sh
    ```

1. Create & configure the WKS cluster:

    ```console
    wksctl apply
    ```

1. Generate the kubeconfig file

    ```console
    wksctl kubeconfig
    ```

    This will print a line to the console similar to `$ export KUBECONFIG=/[path to kubeconfig file]`.  Copy that line and paste it into any terminal you are using `kubectl` in.

1. Ensure that everything's working:

    ```console
    kubectl get namespaces
    ```

    should return something like

    ```console
    NAME          STATUS   AGE
    default       Active   1m59s
    kube-public   Active   1m59s
    kube-system   Active   1m59s
    system        Active   1m54s
    ```

## Run sonobuoy conformance tests

Ensure you have installed the sonobuoy binary, steps from the [instructions on github](https://github.com/vmware-tanzu/sonobuoy#installation):

1. Download the latest release of sonobuoy for your client platform.

1. Extract the tarball:

    ```console
    tar -xvf <RELEASE_TARBALL_NAME>.tar.gz
    ```

1. Move the extracted sonobuoy executable to somewhere on your PATH.

1. Run the certified-conformance tests:

    ```console
    sonobuoy run --wait --mode certified-conformance
    ```

1. Once finished, retrieve and inspect the results:

    ```console
    results=$(sonobuoy retrieve)
    sonobuoy results $results
    ```

## Delete the WKS cluster

To delete your WKS cluster, run:

```console
./delete-instances.sh && ./delete-network.sh
```

