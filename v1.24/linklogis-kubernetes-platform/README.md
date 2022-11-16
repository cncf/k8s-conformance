# Create the cluster.

1. create config
./bm create config [-f config-demo.yaml]

```
apiVersion: kubekey.kubesphere.io/v1alpha1
kind: Cluster
metadata:
 name: sample
spec:
 hosts:
 - {name: node1, address: x.x.x.x, internalAddress: x.x.x.x, user: root, password: ******, labels: {"node-type": "master"}}
 - {name: node2, address: x.x.x.x, internalAddress: x.x.x.x, user: root, password: ******, labels: {"node-type": "master"}}
 - {name: node3, address: x.x.x.x, internalAddress: x.x.x.x, user: root, password: ******, labels: {"node-type": "master"}}
 - {name: node4, address: x.x.x.x, internalAddress: x.x.x.x, user: root, password: ******, labels: {"node-type": "worker"}}
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
 - node4
 controlPlaneEndpoint:
##Internal loadbalancer for apiservers
#internalLoadbalancer: haproxy
 domain: lb.cluster.local
 address: ""
 networkInterface: "eth0" 
 port: 6443
 kubernetes:
 version: v1.24.3
 clusterName: cluster.local
 containerManager: docker
 etcdDataDir: /var/lib/etcd
 etcdClientPort: 2379
 etcdPeerPort: 2380
 containerEngine:
 dataRoot: /var/lib/docker
 maxSize: 100m
 maxFile: "3"
 limitNOFILE: "1048576"
 limitNPROC: "1048576"
 limitCORE: infinity
 network:
 plugin: calico
 kubePodsCIDR: 10.222.0.0/16
 kubeServiceCIDR: 10.233.0.0/16
 gateway:
 name: traefik
 type: daemonset
 storage:
## plugin now only support cephfs and openebs, when plugin is "", it will not
install storage plugin, default is openebs local pv
 plugin: openebs
 registry:
 registryMirrors: []
 insecureRegistries: []
 privateRegistry: "reg.hrlyit.com"
 namespaceOverride: "kubernetes"
 addons: []

```

2. create kubernetes cluster
./bm create cluster -f config-sample.yaml

Make sure your KUBECONFIG environment variable is set correctly for communicating with your cluster.

Download sonobuoy_<VERSION>_linux_amd64.tar.gz from https://github.com/vmware-tanzu/sonobuoy/releases.

Run:
```
$ sonobuoy run --mode=certified-conformance
```

Wait for sonobuoy status to indicate complete.
```
$ sonobuoy status 
```
Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
```
$ outfile=$(sonobuoy retrieve)
```
This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
```
mkdir ./results; tar xzf $outfile -C ./results
```
NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:
```
sonobuoy delete
```
