# How to Reproduce

### Create VKE Cluster
- Create a VKE Cluster
- The cluster Kubernetes version need choose v1.24.x

### Prepare Test Environment
- Download binary release of the CLI
- Prepare custom image repo ```sonobuoy gen default-image-config > custom-repo-config.yaml```
- Push image to custom image repo ```sonobuoy images  --kubernetes-version v1.24.0 push --e2e-repo-config custom-repo-config.yaml --custom-registry registry-demo.vecps.com/sonobuoy```

### Deploy sonobuoy Conformance test
- Login any node in cluster
- Download binary release of the CLI
- Run command as below

Download a binary release of the CLI, Refer to the following command to run：

```shell
sonobuoy run \
--mode=certified-conformance \
--sonobuoy-image=registry-demo.vecps.com/sonobuoy/sonobuoy:v0.56.10 \
--kubernetes-version=v1.24.0 \
--systemd-logs-image=registry-demo.vecps.com/sonobuoy/systemd-logs:v0.4 \
--e2e-repo-config=custom-repo-config.yaml \
--kube-conformance-image=registry-demo.vecps.com/sonobuoy/conformance:v1.24.0
```

See more in conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.
