# Conformance tests for Breeze Kubernetes cluster

## Node Provisioning
Provision 6+ nodes for your cluster. Follow the [OS requirements](https://github.com/wise2c-devops/breeze).

1 deploy node

1 harbor node

3 master nodes

1+ worker nodes

## Install Breeze on the deploy node
(1) Install docker and docker-compose

(2) Download the [docker-compose.yaml](https://github.com/wise2c-devops/breeze/blob/master/docker-compose.yml) file

(3) execute the command:

    ```    
    docker-compose up -d
    ```

(4) Open the browser to access the installer page

(5) Add nodes and set up K8s components

(6) Install the cluster

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is 
regularly built and kept up to date to execute against all 
currently supported versions of kubernetes.

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run
```

**NOTE:** You can run the command synchronously by adding the flag `--wait` but be aware that running the Conformance tests can take an hour or more.

View actively running pods:

```
$ sonobuoy status 
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**. 

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
