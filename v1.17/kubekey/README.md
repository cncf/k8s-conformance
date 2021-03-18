## To reproduce:
#### Setup KubeSphere container management platform
* Deploy KubeSphere according to the [Kubesphere](https://github.com/kubesphere/kubekey) documentation.

Step 1:Download KubeKey v1.0.1 and add permission.
```
curl -sfL https://get-kk.kubesphere.io | VERSION=v1.0.1 sh -
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
  name: config-sample
spec:
  - {name: node1, address: 192.168.6.8, internalAddress: 192.168.6.8, user: ubuntu, password: Qcloud@123}
  - {name: node2, address: 192.168.6.9, internalAddress: 192.168.6.9, user: ubuntu, password: Qcloud@123}
  - {name: node3, address: 192.168.6.10, internalAddress: 192.168.6.10, user: ubuntu, password: Qcloud@123}
  roleGroups:
    etcd:
    - node1
    master: 
    - node1
    worker:
    - node2
    - node3
  controlPlaneEndpoint:
    domain: lb.kubesphere.local
    address: ""
    port: "6443"
  kubernetes:
    version: v1.17.9
```

Step 4:Get Started With Installation
It's recommended to install using root user, then create a cluster using the configuration file:
```
./kk create cluster -f config-sample.yaml
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+
| name  | sudo | curl | openssl | ebtables | socat | ipset | conntrack | docker | nfs client | ceph client | glusterfs client | time         |
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+
| node3 | y    | y    | y       | y        |       |       | y         | y      |            |             |                  | CST 14:00:33 |
| node2 | y    | y    | y       | y        |       |       | y         | y      |            |             |                  | CST 14:00:33 |
| node1 | y    | y    | y       | y        |       |       | y         | y      |            |             |                  | CST 14:00:33 |
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+

This is a simple check of your environment.
Before installation, you should ensure that your machines meet all requirements specified at
https://github.com/kubesphere/kubekey#requirements-and-recommendations

Continue this installation? [yes/no]:
```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.