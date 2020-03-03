To reproduce:
- Follow the instructions to create a [Tencent Cloud Account](https://cloud.tencent.com/register)
- Go to  [Console of Tencent Kubernetes Engine ](https://console.cloud.tencent.com/tke2/cluster) 
- Follow the instructions to create a [Create Cluster](https://intl.cloud.tencent.com/document/product/457/30637)
- The cluster region need choose out of China( e.g. Singapore)
- The cluster Kubernetes version need choose 1.14.3
- After the creation completed, ssh to any node of cluster
- Run command as below

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.