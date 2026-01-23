## To reproduce:

#### Create Kubernetes Cluster

- Login to [Chinaunicom Container Service for Kubernetes](https://console.cucloud.cn/console/cke/cke-list) web console
and create a Kubernetes cluster
    * Select `呼和浩特基地二区` region.
    * In the right pane, click `创建` and then follow the instructions to create a cluster.
      Make sure to select `Version` as `v1.33` and at least six nodes.
    * Wait for the cluster to be in 'ready state'. This might take a while.

- Prepare for Conformance test
    * You can [obtain the kubeconfig file of the cluster and use kubectl to connect to the cluster](https://support.cucloud.cn/document/127/581/900.html?id=900&arcid=2933), and run the kubectl get node command to view the node information of the cluster.
    * We have already pushed sonobuoy image to the repository vpc-nmhhht2-registry.cucloud.cn/e2etest, you just need to point the image configuration to vpc-nmhhht2-registry.cucloud.cn/e2etest, for example: vpc-nmhhht2-registry.cucloud.cn/e2etest/sonobuoy:v0.57.3

#### Deploy sonobuoy Conformance test 

Follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to test it.
