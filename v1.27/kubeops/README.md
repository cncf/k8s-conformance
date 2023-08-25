We created a cluster with our kubeops clustercreate package.  
https://kubeops.net/docs/latest/getting-started/quickstart/  
our uservalues.yaml was the same as the following:

```yaml
kubeOpsUser: demo
kubeOpsUserPassword: Password
kubeOpsUserMail: demo@demo.net
imagePullRegistry: registry1.kubernative.net/lima
localRegistry: false
clusterName: sonobuoy
clusterUser: myuser
kubernetesVersion: 1.27.2
masterIP: 10.2.10.51
firewall: nftables
pluginNetwork: calico
containerRuntime: containerd
limaRoot: "/home/myuser/kubeops/lima"
clusterOS: Red Hat Enterprise Linux
useInsecureRegistry: false
ignoreFirewallError: false
serviceSubnet: 192.168.128.0/17
podSubnet: 192.168.0.0/17
debug: true
logLevel: vvvvv
systemCpu: '1'
systemMemory: 2G
sudo: true
controlPlaneList: # required are at least two additional controlplanes, keep in mind that you need an odd number of controlplanes
  - 10.2.10.52
  - 10.2.10.53
workerList: # required are at least three additional worker
  - 10.2.10.71
  - 10.2.10.72
  - 10.2.10.73
rook-ceph: true
harbor: true
opensearch: true
opensearch-dashboards: true
logstash: true
filebeat: true
prometheus: true
opa: true
headlamp: true
certman: true
ingress: true
nameSpace: kubeops
storageClass: rook-cephfs
rookValues:
  namespace: kubeops
  nodePort: 31931
  cluster:
    spec:
      dataDirHostPath: "/var/lib/rook"
    removeOSDsIfOutAndSafeToRemove: true
    storage:
      useAllNodes: true
      useAllDevices: true
      deviceFilter: "^sd[a-b]"
      nodes:
      - name: "<ip-adress of node_1>"
        devices:
        - name: sdb
      - name: "<ip-adress of node_2>"
        deviceFilter: "^sd[a-b]"
    resources:
      mgr:
        requests:
          cpu: 500m
          memory: 1Gi
      mon:
        requests:
          cpu: '2'
          memory: 4Gi
      osd:
        requests:
          cpu: '2'
          memory: 4Gi
  operator:
    data:
      rookLogLevel: DEBUG
  blockStorageClass:
    parameters:
      fstype: ext4
postgrespass: password
postgres:
  storageClassName: rook-cephfs
  volumeMode: Filesystem
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
redispass: password
redis:
  storageClassName: rook-cephfs
  volumeMode: Filesystem
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
harborValues:
  namespace: kubeops
  harborpass: password
  externalURL: https://10.2.10.13
  nodePort: 30003
  harborPersistence:
    persistentVolumeClaim:
      registry:
        size: 5Gi
        storageClass: rook-cephfs
      chartmuseum:
        size: 5Gi
        storageClass: rook-cephfs
      jobservice:
        jobLog:
          size: 1Gi
          storageClass: rook-cephfs
        scanDataExports:
          size: 1Gi
          storageClass: rook-cephfs
      database:
        size: 1Gi
        storageClass: rook-cephfs
      redis:
        size: 1Gi
        storageClass: rook-cephfs
      trivy:
        size: 5Gi
        storageClass: rook-cephfs
filebeatValues:
  namespace: kubeops
logstashValues:
  namespace: kubeops
  volumeClaimTemplate:
    resources:
      requests:
        storage: 1Gi
    accessModes:
    - ReadWriteMany
    storageClassName: rook-cephfs
openSearchDashboardValues:
  namespace: kubeops
  nodePort: 30050
openSearchValues:
  namespace: kubeops
  opensearchJavaOpts: "-Xmx512M -Xms512M"
  resources:
    requests:
      cpu: 250m
      memory: 1024Mi
    limits:
      cpu: 300m
      memory: 3072Mi
  persistence:
    size: 4Gi
    enabled: 'true'
    enableInitChown: 'false'
    labels:
      enabled: 'false'
    storageClass: rook-cephfs
    accessModes:
    - ReadWriteMany
  securityConfig:
    enabled: false
  replicas: '3'
prometheusValues:
  namespace: kubeops
  privateRegistry: false
  grafanaUsername: user
  grafanaPassword: password
  grafanaResources:
    storageClass: rook-cephfs
    storage: 5Gi
    nodePort: 30211
  prometheusResources:
    storageClass: rook-cephfs
    storage: 25Gi
    retention: 10d
    retentionSize: 24GB
    nodePort: 32090
opaValues:
  namespace: kubeops
headlampValues:
  namespace: kubeops
  service:
    nodePort: 30007
certmanValues:
  namespace: kubeops
  replicaCount: 3
  logLevel: 2
ingressValues:
  namespace: kubeops

```
## Run Conformance Test
1. Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the sonobuoy CLI, or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

2. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

3. Check the status:
```sh
$ sonobuoy status
```

4. Once the `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:
```sh
$ outfile=$(sonobuoy retrieve)
```

5. Extract the contents into `./results` with:
```sh
$ mkdir ./results; tar xzf $outfile -C ./results
```

6. Clean up Kubernetes objects created by Sonobuoy:
```sh
$ sonobuoy delete
```