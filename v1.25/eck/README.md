# Chinatelecom Cloud Edge Container Service for Kubernetes

## Create a ECK cluster

Sign in Chinatelecom Cloud and navigate to [container service web console](https://esx.ctyun.cn/eck/#/resource/cluster/create).
Select `Standard Kubernetes` cluster type and `v1.25.6` version, fill other required fields in the form and submit.

## Run the tests
Once the cluster state become `running`, download the kubeconfig file and save to `kubeconfig`.  
Run the test: 
```bash
sonobuoy run --mode=certified-conformance \
    --e2e-repo-config  custom-repos.yaml \
    --kube-conformance-image ehub.ctcdn.cn/eck/sonobuoy/conformance:v1.25.6 \
    --sonobuoy-image ehub.ctcdn.cn/eck/sonobuoy/sonobuoy:v0.56.15 \
    --systemd-logs-image ehub.ctcdn.cn/eck/sonobuoy/systemd-logs:v0.4 \
    --kubeconfig kubeconfig
```

The content of `custom-repos.yaml` is as follows:
```yaml
buildImageRegistry: ehub.ctcdn.cn/eck/sonobuoy
dockerGluster: ehub.ctcdn.cn/eck/sonobuoy
dockerLibraryRegistry: ehub.ctcdn.cn/eck/sonobuoy
e2eRegistry: ehub.ctcdn.cn/eck/sonobuoy
e2eVolumeRegistry: ehub.ctcdn.cn/eck/sonobuoy
gcRegistry: ehub.ctcdn.cn/eck/sonobuoy
gcEtcdRegistry: ehub.ctcdn.cn/eck/sonobuoy
promoterE2eRegistry: ehub.ctcdn.cn/eck/sonobuoy
sigStorageRegistry: ehub.ctcdn.cn/eck/sonobuoy
```