## To reproduce:
#### Setup KubeSphere container management platform
* Deploy KubeSphere according to the [Kubesphere](https://github.com/kubesphere/kubekey) documentation.

Step 1:Download Installer and add permission.
```
wget https://github.com/kubesphere/kubekey/releases/download/v3.1.7/kubekey-v3.1.7-linux-amd64.tar.gz
tar -zxvf kubekey-v3.1.7-linux-amd64.tar.gz
chmod +x kk
```

Step 2:Create configuration file Kubernetes and KubeSphere
```
./kk create config
```

Step 3:Modify config-sample.yaml include hosts and kubernetes.version
```
apiVersion: kubekey.kubesphere.io/v1alpha1
kind: Cluster
metadata:
  name: sample
spec:
  hosts:
  - {name: node1, address: 192.168.6.5, internalAddress: 192.168.6.5, user: root, password: Qcloud@123}
  - {name: node2, address: 192.168.6.6, internalAddress: 192.168.6.6, user: root, password: Qcloud@123}
  - {name: node3, address: 192.168.6.7, internalAddress: 192.168.6.7, user: root, password: Qcloud@123}
  roleGroups:
    etcd:
    - node1
    - node2
    - node3
    master:
    - node1
    - node2
    - node3
    worker:
    - node1
    - node2
    - node3
  controlPlaneEndpoint:
    internalLoadbalancer: haproxy
  
    domain: lb.kubesphere.local
    address: ""
    port: 6443
  kubernetes:
    version: v1.31.2
    imageRepo: kubesphere
    clusterName: cluster.local
  network:
    plugin: calico
    kubePodsCIDR: 10.233.64.0/18
    kubeServiceCIDR: 10.233.0.0/18
  registry:
    registryMirrors: []
    insecureRegistries: []
  addons: []
```

Step 4:Get started with installation
It's recommended to install using root user, then create a cluster using the configuration file:
```shell
./kk create cluster -f config-sample.yaml --with-local-storage
+-------+------+------+---------+----------+-------+-------+-----------+---------+------------+-------------+------------------+--------------+
| name  | sudo | curl | openssl | ebtables | socat | ipset | conntrack | docker  | nfs client | ceph client | glusterfs client | time         |
+-------+------+------+---------+----------+-------+-------+-----------+---------+------------+-------------+------------------+--------------+
| node3 | y    | y    | y       | y        | y     | y     | y         | 20.10.6 |            |             |                  | CST 15:24:17 |
| node1 | y    | y    | y       | y        | y     | y     | y         | 20.10.6 |            |             |                  | CST 15:24:17 |
| node2 | y    | y    | y       | y        | y     | y     | y         | 20.10.6 |            |             |                  | CST 15:24:17 |
+-------+------+------+---------+----------+-------+-------+-----------+---------+------------+-------------+------------------+--------------+

This is a simple check of your environment.
Before installation, you should ensure that your machines meet all requirements specified at
https://github.com/kubesphere/kubekey#requirements-and-recommendations

Continue this installation? [yes/no]:
```
```shell
# install kubesphere
helm upgrade --install -n kubesphere-system --create-namespace ks-core https://charts.kubesphere.io/main/ks-core-1.1.3.tgz --debug --wait
```
Step 5:Waiting for installation to complete
The installation is complete when you see the following information
```
NOTES:
Thank you for choosing KubeSphere Helm Chart.

Please be patient and wait for several seconds for the KubeSphere deployment to complete.

1. Wait for Deployment Completion

    Confirm that all KubeSphere components are running by executing the following command:

    kubectl get pods -n kubesphere-system
2. Access the KubeSphere Console

    Once the deployment is complete, you can access the KubeSphere console using the following URL:

    http://192.168.6.5:30880

3. Login to KubeSphere Console

    Use the following credentials to log in:

    Account: admin
    Password: P@88w0rd

NOTE: It is highly recommended to change the default password immediately after the first login.
For additional information and details, please visit https://kubesphere.io.

```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.
