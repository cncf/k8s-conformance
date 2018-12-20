# DaoCloud Enterprise

DaoCloud Enterprise is a platform based on Kubernetes which developed by [DaoCloud](https://www.daocloud.io).

## Setup DCE Cluster

First install DaoCloud Enterprise 3.0.3, which is based on Kubernetes 1.13.1.
To install DaoCloud Enterprise, run the following commands on CentOS 7.4 System:
```
export VERSION=3.0.3
curl -L https://dce.daocloud.io/DaoCloud_Enterprise/$VERSION/os-requirements  > /usr/local/bin/os-requirements
chmod +x /usr/local/bin/os-requirements
/usr/local/bin/os-requirements
bash -c "$(docker run -i --rm daocloud.io/daocloud/dce:$VERSION install)"
```
To add more nodes to the cluster, the user need log into DaoCloud Enterprise control panel and follow instructions under node management section.

After the installation, run ```docker exec -it `docker ps | grep dce-kube-controller | awk '{print$1}'` bash``` to enter the DaoCloud Enterprise Kubernetes controller container.

## Run conformance tests

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy). 

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

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
