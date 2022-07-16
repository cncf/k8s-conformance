# Conformance tests for WiseCloud v1.13.5 Kubernetes

## Install WiseCloud Server v1.13.5 (base on Kubernetes v1.22.2)

Provision 6+ nodes for your WiseCloud cluster. (RHEL/CentOS 7.4+ and Ubuntu 18/20 are supported)

1 deploy node

1 harbor node

3 wise-controllers nodes

3 loadbalancer nodes (LB services can be deployed on 3 wise-controller nodes or 3 dedicated lb servers for HA purpose)

2+ worker nodes

## Install WiseUp on the deploy node
(1) Install docker and docker-compose

(2) Download the WiesCloud yaml file

(3) execute the command:

    ```    
    docker-compose up -d
    ```

(4) Open the browser to access the WiseUp page

(5) Add nodes and set up WiseCloud components (K8s 1.22.2, wisecloud-core-1.13.5, mysql, nats, redis, prometheus, istio)

(6) Install the cluster

(7) Login to the WiseCloud dashboard and confirm all componentes are running normally

## Run Conformance Test

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is 
regularly built and kept up to date to execute against all 
currently supported versions of kubernetes, and can be obtained [here](https://github.com/heptio/sonobuoy/releases).

Download the CLI by running:

```
$ go get -u -v github.com/heptio/sonobuoy
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

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```
$ sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**. 

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
