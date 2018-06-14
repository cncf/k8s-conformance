To reproduce:
- Follow the instructions to create a [Tencent Cloud Account](https://cloud.tencent.com/register?lang=en)
- Go to  [Console of Tencent Kubernetes Engine ](https://console.cloud.tencent.com/ccs/cluster?language=en) 
- Follow the instructions to create a [Create Cluster](https://cloud.tencent.com/document/product/457/9091?lang=en)
- The cluster region need choose out of China( e.g. Singapore)
- The cluster Kubernetes version need choose 1.10.3
- After the creation completed, ssh to any node of cluster
- Run command as below

```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
kubectl logs -f -n sonobuoy sonobuoy

# wait for completion, signified by:
# no-exit was specified, sonobuoy is now blocking

kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
cd results
tar -zxvf *_sonobuoy_*.tar.gz
retain plugins/e2e/results/{e2e.log,junit.xml}
```