# Conformance testing Bizfly Kubernetes Engine

### Setup Bizfly Kubernetes cluster

The following instructions will help you configure and create a Kubernetes cluster on Bizfly Cloud:

```
$ Navigate to [release page](https://github.com/bizflycloud/bizflyctl/releases). Download the tar.gz file with your platform (Linux, Windows and MacOS).

$ Extract the tar.gz file

$ Copy bizfly binary to `/usr/local/bin` with Linux and MacOS

$ Configure user name and password. Create a file `.bizfly.yaml` in your `$HOME` directory

email: <your email>
password: <your password> 

$ bizfly kubernetes create --name test_cli --version 653b2e72aab4b44bb545b11b --vpc-network-id e84362d6-0632-4950-87ac-e7bc7d74be6d --worker-pool name=testworkerpool,flavor=nix.3c_6g,profile_type=premium,volume_type=PREMIUM-HDD1,volume_size=40,availability_zone=HN1,desired_size=1,min_size=1,max_size=10

$ Result

ID              	NAME    	VPC NETWORK ID                      	WORKER POOLS COUNT	CLUSTER STATUS	TAGS	CREATED AT                	CLUSTER VERSION 
birwbb2sz4gkpc1c	test_cli	e84362d6-0632-4950-87ac-e7bc7d74be6d	1                 	PROVISIONING  	    	2023-11-01T02:52:58.404827	v1.26.9    
```

Once the cluster has been created successfully, get the kubeconfig using

```
$bizfly kubernetes kubeconfig get birwbb2sz4gkpc1c
```

> Further instructions can be found in our [product documentation](https://docs.bizflycloud.vn/kubernetes_engine/howtos/create-and-delete-cluster).

### Download Sonobuoy

Download [Sonobuoy 0.56.16](https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.56.16) tarball for your machine and unpack it:

```shell
tar xvzf sonobuoy_*.tar.gz
```

### Run the conformance tests

Reproduce the conformance run with the following steps:

```shell
./sonobuoy run --mode=certified-conformance --wait
outfile=$(./sonobuoy retrieve)
tar xvzf $outfile
```

Then inspect `plugins/e2e/results/global/{e2e.log,junit_01.xml}`.
