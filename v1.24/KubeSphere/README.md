## To reproduce:
#### Setup KubeSphere container management platform
* Deploy KubeSphere according to the [Kubesphere](https://github.com/kubesphere/kubekey) documentation.

Step 1:Download Installer v3.3.1 and add permission.
```
wget https://github.com/kubesphere/kubekey/releases/download/v3.0.6/kubekey-v3.0.6-linux-amd64.tar.gz
tar zxf kubekey-v3.0.6-linux-amd64.tar.gz
chmod a+x kk
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
    version: v1.24.8
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
```
./kk create cluster -f config-sample.yaml --with-kubesphere v3.3.1
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

Step 5:Waiting for installation to complete
The installation is complete when you see the following information
```
#####################################################
###              Welcome to KubeSphere!           ###
#####################################################

Console: http://192.168.6.5:30880
Account: admin
Password: P@88w0rd

NOTES：
  1. After you log into the console, please check the
     monitoring status of service components in
     "Cluster Management". If any service is not
     ready, please wait patiently until all components 
     are up and running.
  2. Please change the default password after login.

#####################################################
https://kubesphere.io             2022-4-26 15:26:56
#####################################################
INFO[15:26:56 CST] Installation is complete.

Please check the result using the command:

       kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l app=ks-install -o jsonpath='{.items[0].metadata.name}') -f
```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.