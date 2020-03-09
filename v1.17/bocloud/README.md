# To reproduce:

## Install Bocloud BeyondContainer

1. Extract files from the archive:

    ```sh
    tar zxvf paas_auto_deploy_2_3.tar.gz -C /opt
    ```

2. Prepare configuration (modify it if necessary):

    ```sh
    cd /opt/paas_auto_deploy_2_3
    cp paas.conf.example  paas.conf
    ```

3. Install BeyondContainer platform:

    ```sh
    ./INSTALL
    ```

## Run the Kubernetes conformance tests

The standard tool for running these tests is [Sonobuoy](https://github.com/heptio/sonobuoy).
Sonobuoy is regularly built and kept up to date to execute against all currently supported versions of kubernetes,
and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```
$ VERSION=0.17.2 OS=linux && \
    curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_${OS}_amd64.tar.gz" --output $HOME/bin/sonobuoy.tar.gz && \
    tar -xzf $HOME/bin/sonobuoy.tar.gz -C $HOME/bin && \
    chmod +x $HOME/bin/sonobuoy && \
    rm $HOME/bin/sonobuoy.tar.gz
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```sh
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`,
copy the output directory from the main Sonobuoy pod to a local directory:

```
$ sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local `.` directory.
Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
