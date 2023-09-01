
### Login Tencent Kubernetes Engine Console
- Follow the instructions to create a [Tencent Cloud Account](https://cloud.tencent.com/register)
- Go to  [Console of Tencent Kubernetes Engine ](https://console.cloud.tencent.com/tke2/cluster) 

### Create TKE Cluster
- Create a TKE Cluster
- The cluster region need choose out of China mainland ( e.g. Bangkok)
- The cluster Kubernetes version need choose 1.26.1
![](CreateTkeCluster.png)

### Deploy sonobuoy Conformance test
- After the creation completed, ssh to any node of cluster
- Run command as below

Download a binary release of the CLI, Refer to the following command to run：

```shell
sonobuoy run --mode=certified-conformance
```

See more in conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.
