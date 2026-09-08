### How To Reproduce:

#### Create Account and Login

Click this [link](https://login.bce.baidu.com/reg.html?tpl=bceplat&from=portal) to create a Baidu Cloud Account and login to Baidu Cloud Account from [here](https://login.bce.baidu.com/).

#### Login to Console

After login to the account, login to Console of Baidu Cloud Container Engine in English from [here](https://console.bce.baidu.com/cce/?locale=en-us#/cce/cluster/list).

After successful login, select "Product Services > Container Engine CCE" and enter the "Cluster Management > Cluster List" page.

The "Cluster List" page will display all the created CCE cluster name/ID, status, region and other information and users can search the cluster through the cluster name. Please select and switch the region according to the actual needs.

#### Create Cluster

Click "Create cluster" and enter the "Create cluster" page. Fill in cluster name and then fill in relevant configuration information according to your needs. Choose Kubernetes version `v1.35.3`. The cluster used for this submission has 3 master nodes and 3 worker nodes (each `bcc.g4.c8m32`, Ubuntu 22.04, kernel 5.15, containerd 2.1.5). For ssh to the nodes in the cluster, users need to enable EIP binding for the cluster nodes.

#### Access to Cluster

After the CCE cluster is created, you can view the created CCE cluster and cluster details in the cluster list. Click a cluster link in the "cluster name" column of the container list to enter the "cluster details" page to view the status information. The cluster will be setup in about 5 minutes. Download the kubeconfig from the cluster details page, or use VNC/ssh to get access to any node of the cluster.

#### Run Conformance Test

Install `sonobuoy v0.57.3` and run the certified-conformance plugin against the cluster:

```
sonobuoy run \
  --kubeconfig kubeconfig \
  --mode certified-conformance \
  --plugin e2e \
  --kube-conformance-image registry.k8s.io/conformance:v1.35.3 \
  --kubernetes-version v1.35.3 \
  --image-pull-policy Always \
  --force-image-pull-policy \
  --timeout 28800

sonobuoy status --kubeconfig kubeconfig

sonobuoy logs --kubeconfig kubeconfig
```

Wait for around 2 hours for the test to be finished. When `sonobuoy status` reports `STATUS: complete` and `RESULT: passed`, retrieve the result tarball:

```
sonobuoy retrieve --kubeconfig kubeconfig .

mkdir ./results; tar xzf *.tar.gz -C ./results
```

The conformance test produced `e2e.log` and `junit_01.xml` (under `plugins/e2e/results/global/` of the tarball) which are included in this submission.

Final result:

```
Plugin: e2e
Status: passed
Total: 7360
Passed: 446
Failed: 0
Skipped: 6914
```
