# Harmonycloud PaaS Container Platform Install 

Harmonycloud PaaS Container Platform Install is an Offline install Platform-as-a-Service platform based on Kubernetes

## To Reproduce

Install Harmonycloud Container Platform v3.0.1. the kubernetes version is v1.26.1.

 * install Harmonycloud Container Platform one master and two nodes for Kubernetes cluster. Centos is recommended.

 * Packages: 

   1. harmonycloud
   
   2. kube1.26.1.tar.gz


### Installation process:

1. Download and Harmonycloud install binary

```
$ wget -c http://harmonycloud.cn/download/cli/latest/harmonycloud && \
    chmod +x harmonycloud && mv harmonycloud /usr/bin
```

2. Download the offline resource pack

```
$ wget -c http://harmonycloud.cn/download/packages/v1.26.1/kube1.26.1.tar.gz
```
3. Install Platform and kubernetes cluster

```
$ harmonycloud init --master 10.10.102.140 \
        --node 10.10.102.141 \
        --node 10.10.103.142
        --user root \
        --passwd Ab123456 \
        --version v1.26.1 \
       --pkg-url /root/kube1.26.1.tar.gz 
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
