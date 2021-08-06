### How To Reproduce:

#### Introduction

Kingsoft Cloud Container Engine (KCE) is developed and adapted based on native Kubernetes. KCE seamlessly integrates with other Kingsoft Cloud products and services and provides you container management services with high reliability, high performance, and high scalability.

#### Deploy A KCE Cluster

* Log in to the KCE console.
* In the left navigation pane, click Cluster.
* Click Create Cluster.
* In the Cluster Configuration step, set cluster parameters and click Next.
* In the Node Configuration step, set node parameters and click Next.
* In the Set Basic Information step, set basic parameters and click Next.
* Click Create to create the cluster. The cluster appears in the cluster list.



#### Run Conformance Test

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
### NOTICE:

Some of the docker images from gcr.io cannot be pulled in China, you need to configure a proxy for your docker deamon.
```

