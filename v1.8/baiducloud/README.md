### How To Reproduce:

#### Create Account
Create a Baidu Cloud Account by following this [instruction](https://login.bce.baidu.com/reg.html?tpl=bceplat&from=portal).

#### Login to Account
Login to Baidu Cloud Account from [here](https://login.bce.baidu.com/). 

#### Login to Console
After login to the account, login to Console of Baidu Cloud Container Engine from [here](https://console.bce.baidu.com/cce/#/cce/cluster/list).

#### Create Cluster
Create a Cluster by following this [instruction](https://cloud.baidu.com/doc/CCE/GettingStarted.html#.E5.88.9B.E5.BB.BA.E9.9B.86.E7.BE.A4), the cluster Kubernetes version by default is v1.8.6.

#### Access to Cluster
The cluster will be setup in about 5 minutes, you can ssh to any node of cluster by following this [instruction](https://cloud.baidu.com/doc/CCE/GettingStarted.html#.E6.89.A9.E5.AE.B9.E9.9B.86.E7.BE.A4).


#### Run Conformance Test
On one of the node, run command as below:


```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

kubectl logs -f -n sonobuoy sonobuoy
```

Wait for around 50 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
cd results
tar zxvf *_sonobuoy_*.tar.gz
```

Retrieve `e2e.log` and `junit_01.xml` file out of the tar file.

### NOTICE:

Some of the docker images from gcr.io cannot be pulled in China, so before run the test suite, you should run the following command to pre-download all the required docker images for the test, and cordon all the other nodes:

```
curl -L  https://raw.githubusercontent.com/tizhou86/dockerhub-ci/master/import_images.sh | sh -
```

And then update the `sonobuoy-conformance.yaml` file, replace three `ImagePullPolicy` fields from "Always" to be "IfNotPresent" before the test.

We disabled v1alpha1 apis in kube-apiserver, so the resource type `PodPreset` cannot be accessed in the conformance test, will enable the v1alpa1 apis in next release.
