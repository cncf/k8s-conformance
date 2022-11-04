# Conformance tests for GienTech Kubernetes Platform
GienTech Kubernetes Platform (KubeGien) provides financial level, high availability, and high security container service platform. KubeGien fully follows the conformance with Kubernetes and is flexible to extend more other services with GienTech PAAS products.
## Install KubeGien
Throuth the following steps helps to create a GienTech Kubernetes Platform for running the Kubernetes conformance tests.
- Download KubeGien package to /data/Yuanqi_V1R1.tgz and unzip the package.
- Edit datas.yaml to correspond your kubernetes environment settings, including node、storage、network configurations.
- Execute the installation script.
  
   `sh /data/tools/deploy/deploy_k8s.sh`
## Run Conformance Tests
Download a binary release of the CLI, or build it yourself by running:

`go get -u -v github.com/vmware-tanzu/sonobuoy`

Deploy a Sonobuoy pod to your cluster with:

`sonobuoy run --mode=certified-conformance`

View actively running pods:

`sonobuoy status`

View active job status

`sonobuoy status --json | jq`

To inspect the logs:

`sonobuoy logs`

Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

`outfile=$(sonobuoy retrieve)`

This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

`mkdir ./results; tar xzf $outfile -C ./results`

Delete Sonobuoy

`sonobuoy delete`
