# Harmonycloud Container Platform

An Enterprise Platform-as-a-Service based on Kubernetes 

## To Reproduce

First Install Harmonycloud Container Platform v3.0.1. Installation packages can be downloaded at  [here](http://harmonycloud.cn/products/rongqiyun/), the kubernetes version is v1.26.1.

 * install Harmonycloud Container Platform one master and two nodes for Kubernetes cluster. Centos is recommended.

 * Packages: 

   1. k8s-upgrade-deploy.tar.gz

   2. ansible.tar.gz

### Installation process:

1. Distributing installation files via ansible: 

```
$ cd /root/

$ tar -xzvf ansible.tar.gz

$ source ansible_install.sh
```

2. Install Harmonycloud Container Platform 

```
$ cd /root/

$ tar -xzvf k8s-upgrade-deploy.tar.gz

$ cd /k8s-upgrade-deploy/deploy-all/

$ ./install.sh
```

### Run Sonobouy

The standard tool for running these tests is [Sonobuoy](https://github.com/heptio/sonobuoy). Sonobuoy is regularly built and kept up to date to execute against all currently supported versions of kubernetes.

1. Download the CLI by running:

```
$ tar -xzvf sonobuoy_0.56.14_linux_amd64 .tar.gz
$ mv sonobuoy /usr/bin/
```

2. If you can't access [http://www.gcr.io](http://www.gcr.io/), you should download some pre-requisite images from other website. Then change 'imagePullPolicy' from "Always" to "IfNotPresent".

3. Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance --wait
```

4. View actively running pods:

```
$ sonobuoy status 
```

5. To inspect the logs:

```
$ sonobuoy logs
```

6. Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit.xml}**. 

7. To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete --wait
```
