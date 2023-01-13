## To reproduce:
#### Creating a cluster with kubekey

Step 1:Download KubeKey v3.0.6 and add permission.
```
curl -sfL https://get-kk.kubesphere.io | VERSION=v3.0.6 sh -
chmod +x kk
```

Step 2:Create configuration file for cluster
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
  - {name: node1, address: 192.168.100.3, internalAddress: 192.168.100.3, user: ubuntu, password: Qcloud@123}
  - {name: node2, address: 192.168.100.4, internalAddress: 192.168.100.4, user: ubuntu, password: Qcloud@123}
  - {name: node3, address: 192.168.100.5, internalAddress: 192.168.100.5, user: ubuntu, password: Qcloud@123}
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
    port: "6443"
  kubernetes:
    version: v1.24.8
```

Step 4:Get Started With Installation
It's recommended to install using root user, then create a cluster using the configuration file:
```
./kk create cluster -f config-sample.yaml
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+
| name  | sudo | curl | openssl | ebtables | socat | ipset | conntrack | docker | nfs client | ceph client | glusterfs client | time         |
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+
| node3 | y    | y    | y       | y        | y     |       | y         | y      |            |             |                  | CST 14:00:33 |
| node2 | y    | y    | y       | y        | y     |       | y         | y      |            |             |                  | CST 14:00:33 |
| node1 | y    | y    | y       | y        | y     |       | y         | y      |            |             |                  | CST 14:00:33 |
+-------+------+------+---------+----------+-------+-------+-----------+--------+------------+-------------+------------------+--------------+

This is a simple check of your environment.
Before installation, you should ensure that your machines meet all requirements specified at
https://github.com/kubesphere/kubekey#requirements-and-recommendations

Continue this installation? [yes/no]:
```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.