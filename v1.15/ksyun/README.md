### How To Reproduce:

#### Create Account
Create a Kingsoft Cloud Account by following this [instruction](https://passport.ksyun.com/en-iam-login.html).

#### Login to Account
Login to Kingsoft Cloud Account from [here](https://passport.ksyun.com/en-login.html).

#### Login to Console
After login to the account, login to Console of Kingsoft Cloud Container Engine from [here](https://kce.console.ksyun.com/#/).

#### Create Cluster
Create a Cluster in Hong Kong region by following this [instruction](https://docs.ksyun.com/documents/2664), the cluster Kubernetes version by default is v1.15.5.

#### Access to Cluster
The cluster will be setup in about 5 minutes, you can ssh to any node of cluster.


#### Run Conformance Test
On one of the worker node, run command as below:

```
go get -u -v github.com/heptio/sonobuoy

sonobuoy run

sonobuoy status

sonobuoy logs

```

Wait for around 1h30 minutes for the test to be finished, once sonobuoy status shows the run as completed to indicate that the test has been finished, then run the following command to extract the test results.

```
sonobuoy retrieve .

mkdir ./results; tar xzf *.tar.gz -C ./results

```
