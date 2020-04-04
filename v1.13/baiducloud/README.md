### How To Reproduce:

#### Create Account
Create a Baidu Cloud Account by following this [instruction](https://login.bce.baidu.com/reg.html?tpl=bceplat&from=portal).

#### Login to Account
Login to Baidu Cloud Account from [here](https://login.bce.baidu.com/).

#### Login to Console
After login to the account, login to Console of Baidu Cloud Container Engine from [here](https://console.bce.baidu.com/cce/#/cce/cluster/list).

#### Create Cluster
Create a Cluster in Hong Kong region by following this [instruction](https://cloud.baidu.com/doc/CCE/GettingStarted.html#.E5.88.9B.E5.BB.BA.E9.9B.86.E7.BE.A4), the cluster Kubernetes version by default is v1.13.4.

#### Access to Cluster
The cluster will be setup in about 5 minutes, you can ssh to any node of cluster by following this [instruction](https://cloud.baidu.com/doc/CCE/GettingStarted.html#.E6.89.A9.E5.AE.B9.E9.9B.86.E7.BE.A4).


#### Run Conformance Test
On one of the worker node, run command as below:

```
go get -u -v github.com/heptio/sonobuoy

sonobuoy run

sonobuoy status

sonobuoy logs

```

Wait for around 50 minutes for the test to be finished, the log will show something like `no-exit was specified, sonobuoy is now blocking` to indicate that the test has been finished, then run the following command to extract the test results.

```
sonobuoy retrieve .

mkdir ./results; tar xzf *.tar.gz -C ./results

```
