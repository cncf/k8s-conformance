# Conformance testing CloudControl AppZ Platform Kubernetes Cluster

### Setup AppZ Platform Kubernetes Cluster

Install AppZ Platform Kubernetes Cluster from AWS Marketplace https://aws.amazon.com/marketplace/pp/B08L5DQVTB

Further instructions can be found in our [product documentation](https://docs.ecloudcontrol.com/installer-3.0/aws-marketplace/).

### Run the conformance tests

Once you've created a AppZ cluster, downloaded the kubeconfig and configured your kubectl to use it, you reproduce the conformance run with the following steps:

```
$ sudo su - appz
```
Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.20.0/sonobuoy_0.20.0_linux_amd64.tar.gz
```
After getting the sonobuoy tarball, untar it and move the sonobuoy binary to your /usr/bin directory.

```
$ tar -xvf sonobuoy_0.20.0_linux_amd64.tar.gz
$ sudo mv sonobuoy /usr/bin
$ sudo chmod +x /usr/bin/sonobuoy
```
The `--mode=certified-conformance` flag is required for certification runs since Kubernetes v1.16 (and Sonobuoy v0.16). Without this flag, tests which may be disruptive to your other workloads may be skipped. A valid certification run may not skip any conformance tests. 
```
$ sonobuoy run --mode=certified-conformance
```
The successful completion of the Sonobuoy run command indicates initiation of the Sonobuoy tests. Sonobuoy creates a sonobuoy namespace and runs a sonobuoy pod and an e2e job. The e2e job runs end-to-end conformance testing for your cluster. To get the status of sonobuoy test, run the following
To get the status, run
```
$ sonobuoy status
```
To inspect the logs:
```
$ sonobuoy logs
```
Once `sonobuoy status` shows the run as completed, run 
```
$ outfile = $(sonobuoy retrieve)
```
To inspect the results, run by
```
$ sonobuoy results $outfile
```
You can extract the outfile tarball further to investigate the root cause of the test failures and understand what you need to do to fix them.
```
$ mkdir ./results; tar xzf $outfile -C ./results
```

To clean up Kubernetes objects created by Sonobuoy, run:
```
$ sonobuoy delete
```

