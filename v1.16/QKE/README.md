## How to Reproduce

### Login 

Login to [QingCloud Console Platform](https://console.qingcloud.com/) Website with your own qingcloud account.

### Create QKE Cluster

Navigate to QKE cluster, Create a ap2a Region(important) QKE cluster according to [QKE Guide](https://docs.qingcloud.com/product/container/qke/index).

![](cluster.png)

>> Note:
>> pls select ap2a region
>> gcr.io/google-containers website for some certain reason.

### Run conformance tests

- Copy Kubeconfig to your local test host

- Start the conformance tests on your local test host

```shell
sonobuoy run \
  --mode=certified-conformance \
  --kubeconfig=path/to/kubeconfig \
```

You can monitor the conformance tests by tracking the sonobuoy logs. Wait for the line no-exit was specified, sonobuoy is now blocking, which signals the end of the testing.

```shell
sonobuoy logs --kubeconfig=path/to/kubeconfig -f
```

Upon completion of the tests you can obtain the results by copying them off the sonobuoy pod.

```shell
OUTPUT_PATH=$(sonobuoy retrieve --kubeconfig=path/to/kubeconfig)
echo ${OUTPUT_PATH}
mkdir ./results
tar xzf ${OUTPUT_PATH} -C ./results
```
