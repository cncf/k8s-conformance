## How to Reproduce

### Login 

Login to [QingCloud Console Platform](https://console.qingcloud.com/) Website with your own qingcloud account.

### Create KubeSphere(QKE) Cluster

Navigate to KubeSphere(QKE) cluster, Create a ap2a Region(important) KubeSphere cluster according to [KubeSphere(QKE) Guide](https://docs.qingcloud.com/product/container/qke/index).

![](cluster.png)

>> Note:
>> pls select ap2a region
>> gcr.io/google-containers website for some certain reason.

### Deploy sonobuoy Conformance test

Once the configuration files have been created, you should be able to run `kubectl` to interact with the APIs of the Kubernetes cluster. Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it

