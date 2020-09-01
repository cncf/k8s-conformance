## To reproduce:
#### Setup KubeSphere container management platform
* Deploy KubeSphere according to the [Kubesphere](https://github.com/kubesphere/kubekey) documentation.

Step 1:Download Installer v3.0.0 and add permission.
```
curl -O -k https://kubernetes.pek3b.qingstor.com/tools/kubekey/kk
chmod +x kk
```

Step 2:Create configuration file Kubernetes and KubeSphere
```
./kk create config --with-kubesphere
```

Step 3:Modify config-sample.yaml include hosts and kubernetes.version
```
apiVersion: kubekey.kubesphere.io/v1alpha1
kind: Cluster
metadata:
  name: config-sample
spec:
  hosts:
  - {name: node1, address: 192.168.0.2, internalAddress: 192.168.0.2, user: root, password: ****}
  - {name: node2, address: 192.168.0.3, internalAddress: 192.168.0.3, user: root, password: ****}
  roleGroups:
    etcd:
    - node1
    master: 
    - node1
    worker:
    - node1
    - node2
  controlPlaneEndpoint:
    domain: lb.kubesphere.local
    address: ""
    port: "6443"
  kubernetes:
    version: v1.18.3
```

Step 4:Get Started With Installation
It's recommended to install using root user, then create a cluster using the configuration file:
```
./kk create cluster -f config-sample.yaml
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+
| name  | sudo | curl | openssl | ebtables | socat | ipset | conntrack | docker | nfs client | ceph client | glusterfs client | time         |
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+
| node1 | y    | y    | y       | y        | y     | y     | y         | y      |            |             |                  | CST 10:08:08 |
| node2 | y    | y    | y       | y        | y     | y     | y         | y      |            |             |                  | CST 10:08:08 |
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+

This is a simple check of your environment.
Before installation, you should ensure that your machines meet all requirements specified at
https://github.com/kubesphere/kubekey#requirements-and-recommendations

Continue this installation? [yes/no]:
```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.