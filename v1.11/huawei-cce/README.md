## To reproduce:

#### Create Kubernetes Cluster

- Login to [HUAWEI CLOUD Cloud Container Engine](https://console.huaweicloud.com/cce2.0) web console
and create a Kubernetes cluster

- Make sure VPN is configured appropriately if the cluster is not in HongKong region(`ap-southeast-1`)

#### Run Conformance Test with kubetest

- ensure you have GNU `sed` installed
- ensure `go` is properly setup
- ensure `kubectl` installed
- `go get k8s.io/test-infra/kubetest`
- `git clone https://github.com/kubernetes/kubernetes.git`


```bash
# in Kubernetes directory

export REPORT_DIR=/path-for-report
export KUBECONFIG=/path-to-your-kubeconfig

export KUBERNETES_CONFORMANCE_TEST=y

kubetest \
    --provider=skeleton \
    --check-version-skew=false \
    --test \
    --test_args="--ginkgo.focus=\\[Conformance\\] \
    --report-dir=${REPORT_DIR} \
    --disable-log-dump" | tee ${REPORT_DIR}/build-log.txt

<${REPORT_DIR}/build-log.txt sed \
    -e 's/\x1b\[[0-9;]*m//g' \
    -e 's/^[IWE][0-9]\{4\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\.[0-9]\{3\}\] //' \
    -e '/^SUCCESS!/q' \
    >${REPORT_DIR}/e2e.log
```
Then grab the following files in the report directory:

- `e2e.log`
- `junit_01.xml`
