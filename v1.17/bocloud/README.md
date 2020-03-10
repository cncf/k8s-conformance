# Conformance tests on BeyondContainer cluster

## Install Bocloud BeyondContainer Platform

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

## Manage cluster

There are two ways to manage clusters

### Manage existing clusters

1. You can [bootstrap clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) first.
2. Use the script `create-token.sh` to generate a token:

    ```sh
    $ cd /opt/paas_auto_deploy_2_3/help
    $ cat create_token.sh
    kubectl create sa management-admin -n kube-system 2>/dev/null
    kubectl create clusterrolebinding management-admin --clusterrole=cluster-admin --serviceaccount=kube-system:management-admin 2>/dev/null
    key=$(kubectl get sa management-admin -o=custom-columns=:.secrets[0].name -n kube-system | grep 'management')
    token=$(kubectl -n kube-system get secret ${key} -o yaml | grep token: | awk '{print $2}' | base64 -d)
    echo $token

    # generate token
    $ ./create_token.sh
    ```

3. Login BeyondContainer Platform and click `add cluster`,then input the token

### Deploy cluster by BeyondContainer

1. Login BeyondContainer Platform,and click `create cluster`
2. Set up cluster,such as `master/node ip`,`access info`,`cni type` etc.
3. You successfully create a cluster

## Run the Kubernetes conformance tests

Before test,you need to login the cluster node terminal.

The standard tool for running these tests is [sonobuoy](https://github.com/heptio/sonobuoy).
Sonobuoy is regularly built and kept up to date to test all currently supported versions of kubernetes,
and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```bash
$ VERSION=0.17.2 OS=linux && \
    curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_${OS}_amd64.tar.gz" --output $HOME/bin/sonobuoy.tar.gz && \
    tar -xzf $HOME/bin/sonobuoy.tar.gz -C $HOME/bin && \
    chmod +x $HOME/bin/sonobuoy && \
    rm $HOME/bin/sonobuoy.tar.gz
```

Deploy a sonobuoy pod to your cluster:

```bash
sonobuoy run
```

View actively running pods:

```bash
sonobuoy status
```

To inspect the logs:

```bash
sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`,
copy the output directory from the main sonobuoy pod to a local directory:

```bash
sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the sonobuoy pod into your local `.` directory.
Extract the contents into `./results` with:

```bash
mkdir ./results; tar xzf *.tar.gz -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**.

To clean up Kubernetes objects created by sonobuoy, run:

```bash
sonobuoy delete
```
