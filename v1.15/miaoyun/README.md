# MiaoYun

MiaoYun is a platform based on Docker container, supporting both Docker Swarm and Kubernetes container orchestration.

## Reproduce Conformnace Test Results.

### Preparation

* One node for install MiaoYun management platform and two nodes for Kubernetes cluster. Ubuntu is recommended.
* Install kubectl. Full instruction for kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
```
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
```
* Install Sonobuoy. Full instruction for Sonobuoy: https://github.com/cncf/k8s-conformance/blob/master/instructions.md
```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

### Install MiaoYun

First install MiaoYun v19.12.2. Installation packages can be downloaded at https://miaoyun.net.cn/download.html. The installation package contains three files:
```
$ ls
my
miaoyun-boot.tar.gz
miaoyun-images.tar.gz
```

`my` is the command line tool. Run it with parameters as follows. $DOMAIN is the address for external access and $HOST_IP is the ip address for this host in the internal network.
```
$ my deploy \
    --offline \
    --host-ip $HOST_IP \
    --domain $DOMAIN \
    --boot-tar miaoyun-boot.tar.gz \
    --image-tar miaoyun-images.tar.gz
```

### Setup Kubernetes Cluster

Create a Kubernetes cluster and add nodes. Login to MiaoYun management platform, go to clusters page, create a new Kubernetes cluster, copy the add-node command and execute it on two Kubernetes nodes.
The add node command should look like this.
```
$ sh -c "$(curl -fksNSL https://10.10.1.160/deploy-host.sh)" - --token $TOKEN --host-cidr $HOST_CIDR
```

Setup kubectl. Copy the kubectl setup commands in settings page and execute them.
The kubectl setup command should look like the following.
```
$ kubectl config set-cluster miaoyun-blue --server=https://10.10.1.160/api/kubernetes/blue --insecure-skip-tls-verify=true
$ kubectl config set-credentials miaoyun-admin --token=$TOKEN
$ kubectl config set-context miaoyun --cluster=miaoyun-blue --namespace=default --user=miaoyun-admin
$ kubectl config use-context miaoyun
```

### Run Sonobouy

Run the conformance test:
```
sonobuoy run --mode=certified-conformance
```

Wait for test success message and retrive the test results:
```
sonobuoy retrieve .
```
