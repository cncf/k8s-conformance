## To reproduce:
#### Setup KubeSphere container management platform
* Deploy KubeSphere according to the [Kubesphere](https://github.com/kubesphere/kubekey) documentation.

Step 1:Download Installer and add permission.
```
curl -sfL https://get-kk.kubesphere.io | VERSION=v3.1.11 sh -
chmod +x kk
```

Step 2:Create configuration file Kubernetes and KubeSphere
```
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

Step 4:Get started with installation
It's recommended to install using root user, then create a cluster using the configuration file:
```shell
# Kubernetes essential packages can be installed using the following commands (optional):
# ./kk init os -f config-sample.yaml
# create cluster with local storage
./kk create cluster -f config-sample.yaml --with-local-storage


 _   __      _          _   __           
| | / /     | |        | | / /           
| |/ / _   _| |__   ___| |/ /  ___ _   _ 
|    \| | | | '_ \ / _ \    \ / _ \ | | |
| |\  \ |_| | |_) |  __/ |\  \  __/ |_| |
\_| \_/\__,_|_.__/ \___\_| \_/\___|\__, |
                                    __/ |
                                   |___/

16:43:41 CST [GreetingsModule] Greetings
16:43:41 CST message: [node2]
Greetings, KubeKey!
16:43:42 CST message: [node1]
Greetings, KubeKey!
16:43:42 CST success: [node2]
16:43:42 CST success: [node1]
16:43:42 CST [NodePreCheckModule] A pre-check on nodes
16:43:42 CST success: [node1]
16:43:42 CST success: [node2]
16:43:42 CST [ConfirmModule] Display confirmation form
+-------+------+------+---------+----------+-------+-------+---------+-----------+--------+--------+------------+------------+-------------+------------------+--------------+
| name  | sudo | curl | openssl | ebtables | socat | ipset | ipvsadm | conntrack | chrony | docker | containerd | nfs client | ceph client | glusterfs client | time         |
+-------+------+------+---------+----------+-------+-------+---------+-----------+--------+--------+------------+------------+-------------+------------------+--------------+
| node1 | y    | y    | y       | y        | y     | y     | y       | y         | y      |        | y          |            |             |                  | CST 16:43:42 |
| node2 | y    | y    | y       | y        | y     | y     | y       | y         | y      |        | y          |            |             |                  | CST 16:43:42 |
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
```shell
# install kubesphere
chart=oci://hub.kubesphere.com.cn/kse/ks-core
version=1.1.1
helm upgrade --install -n kubesphere-system --create-namespace ks-core $chart --version $version --debug --wait 
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
