https://kubeops.net/docs/kubeopsctl/getting-started/installation

# Kubeops

1. Prepare Admin Node

install podman and kubeopsctl
```
dnf install -y kubeopsctl*.rpm
dnf install -y podman
```
after that, set the environment variable
```
echo "export KUBEOPSROOT=\"${HOME}/kubeops\"" >> $HOME/.bashrc
echo "export LIMAROOT=\"${HOME}/kubeops/lima\"" >> $HOME/.bashrc
source $HOME/.bashrc
```
2. Prepare Cluster Nodes
set the host name
```
hostnamectl set-hostname <name of node>
```
and remove the firewall
```
systemctl disable --now firewalld
systemctl mask firewalld
dnf remove -y firewalld
reboot
```


3. Create a Kubernetes cluster

we used the following kubeopsctl.yaml file: 

```yaml
apiVersion: kubeops/kubeopsctl/alpha/v5
imagePullRegistry: registry.preprod.kubeops.net/kubeops
localRegistry: false
clusterName: testing4
clusterUser: root
kubernetesVersion: 1.32.0
masterIP: 10.2.10.51
firewall: nftables
pluginNetwork: calico
containerRuntime: containerd
limaRoot: /root/kubeops/lima
kubeOpsRoot: /root/kubeops
dispatcherPath: 
clusterOS: Red Hat Enterprise Linux
ignoreFirewallError: true
serviceSubnet: 192.168.128.0/17
podSubnet: 192.168.0.0/17
debug: true
logLevel: vvvvv
systemCpu: 500m
systemMemory: 1G
sudo: true
tmpCopyDir: /tmp
#rpmServer: https://rpm.kubeops.net/kubeopsRepo/repodata/
createCluster: false
updateRegistry: false
zones:
- name: zone1
  nodes:
    master:
    - name: control-plane01-rhel9
      ipAdress: 10.2.10.51
      user: root
      password: 
      kubeversion: 1.32.0
      status: active
      systemMemory: 1G
      systemCpu: 500m
    worker:
    - name: node01-testing01-rhel9
      ipAdress: 10.2.10.54
      user: root
      password: 
      kubeversion: 1.32.0
      status: active
      systemMemory: 1G
      systemCpu: 500m
- name: zone2
  nodes:
    master:
    - name: control-plane02-rhel9
      ipAdress: 10.2.10.52
      user: root
      password: 
      kubeversion: 1.32.0
      status: active
      systemMemory: 1G
      systemCpu: 500m
    worker:
    - name: node02-testing01-rhel9
      ipAdress: 10.2.10.55
      user: root
      password: 
      kubeversion: 1.32.0
      status: active
      systemMemory: 1G
      systemCpu: 500m
- name: zone3
  nodes:
    master:
    - name: control-plane03-rhel9
      ipAdress: 10.2.10.53
      user: root
      password: 
      kubeversion: 1.32.0
      status: active
      systemMemory: 1G
      systemCpu: 500m
    worker:
    - name: node03-testing01-rhel9
      ipAdress: 10.2.10.56
      user: root
      password: 
      kubeversion: 1.32.0
      status: active
      systemMemory: 1G
      systemCpu: 500m
rook-ceph: false
harbor: true
opensearch: true
opensearch-dashboards: true
logstash: true
filebeat: true
prometheus: true
opa: true
kubeops-dashboard: true
certman: true
ingress: true
keycloak: true
velero: true
namespace: 
storageClass: rook-cephfs
rookValues:
  namespace: rook-ceph
  nodePort: 31000
  hostname: rook-ceph.local
  cluster:
    spec:
      dataDirHostPath: /var/lib/rook
    removeOSDsIfOutAndSafeToRemove: false
    storage:
      useAllNodes: true
      useAllDevices: false
      deviceFilter: sdc
      config: 
      nodes: 
    resources:
      mgr:
        requests:
          cpu: 500m
          memory: 1Gi
      mon:
        requests:
          cpu: 500m
          memory: 1Gi
      osd:
        requests:
          cpu: 500m
          memory: 1Gi
  operator:
    data:
      rookLogLevel: DEBUG
harborValues:
  namespace: harbor
  harborpass: password
  databasePassword: Postgres_Password
  redisPassword: Redis_Password
  externalURL: http://10.2.10.51:30002
  nodePort: 30002
  hostname: 
  harborPersistence:
    persistentVolumeClaim:
      registry:
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
        size: 2Gi
        storageClass: rook-cephfs
      redis:
        size: 2Gi
        storageClass: rook-cephfs
      trivy:
        size: 5Gi
        storageClass: rook-cephfs
filebeatValues:
  namespace: logging
logstashValues:
  namespace: logging
  volumeClaimTemplate:
    resources:
      requests:
        storage: 1Gi
    accessModes:
    - ReadWriteMany
    storageClass: rook-cephfs
    volumeMode: 
openSearchDashboardValues:
  namespace: logging
  nodePort: 30050
  hostname: opensearch.local
openSearchValues:
  namespace: logging
  opensearchJavaOpts: -Xmx512M -Xms512M
  replicas: 3
  resources:
    requests:
      cpu: 250m
      memory: 1024Mi
    limits:
      cpu: 300m
      memory: 3072Mi
  persistence:
    size: 4Gi
    enabled: true
    enableInitChown: false
    labels:
      enabled: false
    storageClass: rook-cephfs
    accessModes:
    - ReadWriteMany
  securityConfig:
    enabled: false
prometheusValues:
  namespace: monitoring
  privateRegistry: false
  grafanaUsername: user
  grafanaPassword: password
  grafanaResources:
    storageClass: rook-cephfs
    storage: 5Gi
    nodePort: 30211
    hostname: grafana.local
  prometheusResources:
    storageClass: rook-cephfs
    storage: 25Gi
    retention: 10d
    retentionSize: 24GB
    nodePort: 32090
    hostname: prometheus.local
opaValues:
  namespace: opa
kubeOpsDashboardValues:
  namespace: kubeops
  hostname: kubeops-dashboard.local
  service:
    nodePort: 30007
certmanValues:
  namespace: certman
  replicaCount: 3
  logLevel: 2
  secretName: 0
ingressValues:
  namespace: ingress
  externalIPs: []
keycloakValues:
  namespace: keycloak
  storageClass: rook-cephfs
  nodePort: 30180
  hostname: keycloak.local
  keycloak:
    auth:
      adminUser: admin
      adminPassword: admin
      existingSecret: ''
  postgresql:
    auth:
      postgresPassword: ''
      username: bn_keycloak
      password: ''
      database: bitnami_keycloak
      existingSecret: ''
veleroValues:
  namespace: velero
  accessKeyId: admin
  secretAccessKey: password
  useNodeAgent: false
  defaultVolumesToFsBackup: false
  provider: aws
  bucket: velero
  useVolumeSnapshots: false
  backupLocationConfig:
    region: minio
    s3ForcePathStyle: true
    s3Url: http://minio.velero.svc:9000
```

3. Run conformance tests

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
go install github.com/vmware-tanzu/sonobuoy@latest
```

Deploy a Sonobuoy pod to your cluster with:

```
sonobuoy run --mode=certified-conformance
```

View actively running pods:

```
sonobuoy status
```

To inspect the logs:

```
sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit_01.xml}**.


4. Clean up

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```