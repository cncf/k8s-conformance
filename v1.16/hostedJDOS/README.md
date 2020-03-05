### How To Reproduce:

#### Introduction

Hosted JDOS is Jingdong Datacenter OS for automated management of shared container clusters and containerized applications in a scalable and elastic manner. The key systems include ContainerFS, ContainerDNS and ContainerLB (https://github.com/tiglabs). 

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


