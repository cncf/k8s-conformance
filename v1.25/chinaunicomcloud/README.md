
### Login Chinaunicom Kubernetes Engine Console
- Follow the instructions to create a [Chinaunicom Cloud Account](https://console.cucloud.cn/register)
- Go to  [Console of Chinaunicom Kubernetes Engine ](https://console.cucloud.cn/console/cke) 

### Create CKE Cluster
- Create a CKE Cluster
- The cluster region need choose out of China mainland ( e.g. kuiming)
- The cluster Kubernetes version need choose 1.25.0
![](cluster.png)

### Deploy sonobuoy Conformance test
- After the creation completed, ssh to any node of cluster
- Run command as below

Download a binary release of the CLI, Refer to the following command to run：

```shell
sonobuoy run --mode=certified-conformance
```

See more in conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.
