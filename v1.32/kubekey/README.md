## To reproduce:
#### Creating a cluster with kubekey

Step 1:Download KubeKey v3.1.11 and add permission.
```shell
curl -sfL https://get-kk.kubesphere.io | VERSION=v3.1.11 sh -
chmod +x kk
```

Step 2:Create configuration file for cluster
```shell
./kk create config
```

Step 3:Modify config-sample.yaml include hosts and kubernetes.version
```yaml
apiVersion: kubekey.kubesphere.io/v1alpha2
kind: Cluster
metadata:
  name: sample
spec:
  hosts:
  - {name: node1, address: 172.16.66.5, internalAddress: 172.16.66.5, user: ubuntu, password: "Qcloud@123"}
  - {name: node2, address: 172.16.66.6, internalAddress: 172.16.66.6, user: ubuntu, password: "Qcloud@123"}
  roleGroups:
    etcd:
    - node1
    control-plane: 
    - node1
    worker:
    - node1
    - node2
  controlPlaneEndpoint:
    ## Internal loadbalancer for apiservers 
    # internalLoadbalancer: haproxy

    domain: lb.kubesphere.local
    address: ""
    port: 6443
  kubernetes:
    version: v1.32.8
    clusterName: cluster.local
    autoRenewCerts: true
    containerManager: docker
  etcd:
    type: kubekey
  network:
    plugin: calico
    kubePodsCIDR: 10.233.64.0/18
    kubeServiceCIDR: 10.233.0.0/18
    ## multus support. https://github.com/k8snetworkplumbingwg/multus-cni
    multusCNI:
      enabled: false
  registry:
    privateRegistry: ""
    namespaceOverride: ""
    registryMirrors: []
    insecureRegistries: []
  addons: []
```

Step 4:Get Started With Installation
It's recommended to install using root user, then create a cluster using the configuration file:
```shell
# Kubernetes essential packages can be installed using the following commands (optional):
# ./kk init os -f config-sample.yaml
# create cluster
ubuntu@i-at8xkkid:~$ ./kk create cluster -f config-sample.yaml


 _   __      _          _   __           
| | / /     | |        | | / /           
| |/ / _   _| |__   ___| |/ /  ___ _   _ 
|    \| | | | '_ \ / _ \    \ / _ \ | | |
| |\  \ |_| | |_) |  __/ |\  \  __/ |_| |
\_| \_/\__,_|_.__/ \___\_| \_/\___|\__, |
                                    __/ |
                                   |___/

10:30:36 CST [GreetingsModule] Greetings
10:30:36 CST message: [node2]
Greetings, KubeKey!
10:30:37 CST message: [node1]
Greetings, KubeKey!
10:30:37 CST success: [node2]
10:30:37 CST success: [node1]
10:30:37 CST [NodePreCheckModule] A pre-check on nodes
10:30:37 CST success: [node1]
10:30:37 CST success: [node2]
10:30:37 CST [ConfirmModule] Display confirmation form
+-------+------+------+---------+----------+-------+-------+---------+-----------+--------+--------+------------+------------+-------------+------------------+--------------+
| name  | sudo | curl | openssl | ebtables | socat | ipset | ipvsadm | conntrack | chrony | docker | containerd | nfs client | ceph client | glusterfs client | time         |
+-------+------+------+---------+----------+-------+-------+---------+-----------+--------+--------+------------+------------+-------------+------------------+--------------+
| node1 | y    | y    | y       | y        | y     | y     | y       | y         | y      |        | y          |            |             |                  | CST 10:30:37 |
| node2 | y    | y    | y       | y        | y     | y     | y       | y         | y      |        | y          |            |             |                  | CST 10:30:37 |
+-------+------+------+---------+----------+-------+-------+---------+-----------+--------+--------+------------+------------+-------------+------------------+--------------+

This is a simple check of your environment.
Before installation, ensure that your machines meet all requirements specified at
https://github.com/kubesphere/kubekey#requirements-and-recommendations

Install k8s with specify version:  v1.32.8

[Notice]
For Kubernetes v1.24 and later, dockershim has been deprecated.
Current runtime is set to Docker and `cri-dockerd` will be installed to support Kubernetes v1.24 and later.
Yoc can also specify a container runtime other than Docker to install Kubernetes v1.24 or later.
You can set "spec.kubernetes.containerManager" in the configuration file to "containerd" or add "--container-manager containerd" to the "./kk create cluster" command.
For more information, see:
https://github.com/kubesphere/kubekey/blob/master/docs/commands/kk-create-cluster.md
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#container-runtimes
https://kubernetes.io/blog/2022/02/17/dockershim-faq/
https://github.com/Mirantis/cri-dockerd

Continue this installation? [yes/no]: 

```

Installation successful output example:
```shell
ubuntu@i-at8xkkid:~$ kubectl get node -o wide
NAME    STATUS   ROLES                  AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE           KERNEL-VERSION      CONTAINER-RUNTIME
node1   Ready    control-plane,worker   3m48s   v1.32.8   172.16.66.5   <none>        Ubuntu 22.04 LTS   5.15.0-25-generic   docker://24.0.9
node2   Ready    worker                 3m34s   v1.32.8   172.16.66.6   <none>        Ubuntu 22.04 LTS   5.15.0-25-generic   docker://24.0.9

```

#### Deploy sonobuoy Conformance test
* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.