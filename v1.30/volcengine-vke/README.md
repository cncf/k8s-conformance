# How to Reproduce

### Prerequisites
- Account
- VPC

### Login Volcengine Kubernetes Engine Console
- Go to  [VKE](https://console.volcengine.com/vke) Console

### Create VKE Cluster
- Create a VKE Cluster
- The cluster Kubernetes version need choose v1.30.x
- The cluster container network mode: Flannel
- The cluster public access: On
- The cluster api server public access: On
![](CreateVKECluster.png)

### Prepare Test Environment
- Get KubeConfig save to ~/.kube/config
- Download binary release of the CLI
- Prepare custom image repo ```sonobuoy gen default-image-config > custom-repo-config.yaml```
- Push image to custom image repo ```sonobuoy images  --kubernetes-version v1.30.0 push --e2e-repo-config custom-repo-config.yaml --custom-registry cr-helm2-cn-beijing.cr.volces.com/sonobuoy```

### Deploy sonobuoy Conformance test
- Run command as below

Download a binary release of the CLI, Refer to the following command to run：

```shell
sonobuoy run \
--mode=certified-conformance \
--sonobuoy-image=cr-helm2-cn-beijing.cr.volces.com/sonobuoy/sonobuoy:v0.56.16 \
--kubernetes-version=v1.30.0 \
--systemd-logs-image=cr-helm2-cn-beijing.cr.volces.com/sonobuoy/systemd-logs:v0.4 \
--e2e-repo-config=custom-repo-config.yaml \
--progress-report-url=http://localhost:8099/progress \
--kube-conformance-image=cr-helm2-cn-beijing.cr.volces.com/sonobuoy/conformance:v1.30.0
```

See more in conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.
