# TCMS

## Prepare
kubernetes tools
``` 
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.5", GitCommit:"e6503f8d8f769ace2f338794c914a96fc335df0f", GitTreeState:"clean", BuildDate:"2020-06-26T03:47:41Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.5", GitCommit:"e6503f8d8f769ace2f338794c914a96fc335df0f", GitTreeState:"clean", BuildDate:"2020-06-26T03:39:24Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
```

go
```
$ go version
go version go1.14.6 linux/amd64
```

sonobuoy
```
## Install
$ go get github.com/vmware-tanzu/sonobuoy@v0.18.5
Go to GOPATH/bin, copy binaries to /usr/local/bin

$ sonobuoy version
Sonobuoy Version: v0.18.4
MinimumKubeVersion: 1.16.0
MaximumKubeVersion: 1.18.99

```

## Download Docker Images
```
$ sonobuoy images
docker.io/gluster/glusterdynamic-provisioner:v1.0
docker.io/library/busybox:1.29
docker.io/library/httpd:2.4.38-alpine
docker.io/library/httpd:2.4.39-alpine
docker.io/library/nginx:1.14-alpine
docker.io/library/nginx:1.15-alpine
docker.io/library/perl:5.26
docker.io/library/redis:5.0.5-alpine
gcr.io/google-containers/startup-script:v1
gcr.io/kubernetes-e2e-test-images/apparmor-loader:1.0
gcr.io/kubernetes-e2e-test-images/cuda-vector-add:1.0
gcr.io/kubernetes-e2e-test-images/cuda-vector-add:2.0
gcr.io/kubernetes-e2e-test-images/echoserver:2.2
gcr.io/kubernetes-e2e-test-images/ipc-utils:1.0
gcr.io/kubernetes-e2e-test-images/jessie-dnsutils:1.0
gcr.io/kubernetes-e2e-test-images/kitten:1.0
gcr.io/kubernetes-e2e-test-images/metadata-concealment:1.2
gcr.io/kubernetes-e2e-test-images/mounttest-user:1.0
gcr.io/kubernetes-e2e-test-images/mounttest:1.0
gcr.io/kubernetes-e2e-test-images/nautilus:1.0
gcr.io/kubernetes-e2e-test-images/nonewprivs:1.0
gcr.io/kubernetes-e2e-test-images/nonroot:1.0
gcr.io/kubernetes-e2e-test-images/regression-issue-74839-amd64:1.0
gcr.io/kubernetes-e2e-test-images/resource-consumer:1.5
gcr.io/kubernetes-e2e-test-images/sample-apiserver:1.17
gcr.io/kubernetes-e2e-test-images/volume/gluster:1.0
gcr.io/kubernetes-e2e-test-images/volume/iscsi:2.0
gcr.io/kubernetes-e2e-test-images/volume/nfs:1.0
gcr.io/kubernetes-e2e-test-images/volume/rbd:1.0.1
k8s.gcr.io/conformance:v1.18.5
k8s.gcr.io/etcd:3.4.3
k8s.gcr.io/pause:3.2
k8s.gcr.io/prometheus-dummy-exporter:v0.1.0
k8s.gcr.io/prometheus-to-sd:v0.5.0
k8s.gcr.io/sd-dummy-exporter:v0.2.0
quay.io/kubernetes_incubator/nfs-provisioner:v2.2.2
sonobuoy/sonobuoy:v0.18.4
sonobuoy/systemd-logs:v0.3
us.gcr.io/k8s-artifacts-prod/e2e-test-images/agnhost:2.12
gcr.io/authenticated-image-pulling/alpine:3.7
gcr.io/authenticated-image-pulling/windows-nanoserver:v1
gcr.io/k8s-authenticated-test/agnhost:2.6
invalid.com/invalid/alpine:3.1
```

## Install TCMS

### Download the package

[Contact Teamsun](mailto: cloudsystem@vsettan.com.cn) to download the TCMS installation package.

### Run the following command to install the TCMS:

```sh
$ tar xzvf -C /opt TCMS-v2.2-install.tar.gz
$ cd /opt/TCMS-v2.2-install
$ bash prepare.sh
$ bash install.sh
```

## Start Test


```
sonobuoy run --mode=certified-conformance --image-pull-policy=IfNotPresent
```

## Check Status
sonobuoy status

## Test Result
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
