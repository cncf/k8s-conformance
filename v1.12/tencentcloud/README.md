To reproduce:
- Follow the instructions to create a [Tencent Cloud Account](https://cloud.tencent.com/register)
- Go to  [Console of Tencent Kubernetes Engine ](https://console.qcloud.com/tke/cluster) 
- Follow the instructions to create a [Create Cluster](https://cloud.tencent.com/document/product/457/9091?lang=en)
- The cluster region need choose out of China( e.g. Singapore)
- The cluster Kubernetes version need choose 1.12.4
- The cluster kubernetes master's typs need choose self-managed
- After the creation completed, ssh to any node of cluster
- Run command as below

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.