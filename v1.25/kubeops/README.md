We created a cluster with our kubeops clustercreate package.  
https://kubeops.net/docs/latest/getting-started/quickstart/  
our uservalues.yaml was the same as the following:
```yaml
### General values for registry access ###
kubeOpsUser: "demo" # mandatory
kubeOpsUserPassword: "demo" # mandatory
kubeOpsUserMail: "demo@demo.net" # mandatory
imagePullRegistry: "registry1.kubernative.net/lima" # mandatory, the registry from which the images for the cluster are pulled
### Values for setup configuration ###
clusterName: "Kluster" # mandatory
clusterUser: "demo" # mandatory
kubernetesVersion: "1.24.8" # mandatory, check lima documentation
#masterHost: optional if you have an hostname, default value in "masterIP"
masterIP: 10.2.10.51 # mandatory
firewall: "nftables" # mandatory, default "nftables"
pluginNetwork: "calico" # mandatory, default "calico"
containerRuntime: "containerd" # mandatory
limaRoot: "/home/demo/kubeops/lima" # optional, default: "/var/lima"
clusterOS: "Red Hat Enterprise Linux" # optional, can be "Redhat Enterprise Linux" or "openSUSE Leap", remove this line if you want to use default installed OS on admin machine but it has to be "Redhat Enterprise Linux" or "openSUSE Leap"

localRegistry: false # mandatory, set to true if you use a local registry
# in case of true use the following commands:
# sina pull --hub public kubeops/rook-ceph:1.0.0 -o $LIMAROOT/rookceph.sina -r <local docker registry>
# sina pull --hub public kubeops/harbor:1.0.0 -o $LIMAROOT/harbor.sina -r <local docker registry>
# sina pull --hub public kubeops/sina-kube-prometheus-stack:1.0.0 -o $LIMAROOT/prometheus.sina -r <local docker registry>
# sina pull --hub public kubeops/sina-opensearch-os:1.0.0 -o $LIMAROOT/opensearch.sina -r <local docker registry>
# sina pull --hub public kubeops/sina-opensearch-dashboards:1.0.0 -o $LIMAROOT/opensearch-ds.sina -r <local docker registry>
# sina pull --hub public kubeops/sina-filebeat-os:1.0.0 -o $LIMAROOT/filebeat.sina -r <local docker registry>
# sina pull --hub public kubeops/sina-logstash-os:1.0.0 -o $LIMAROOT/logstash.sina -r <local docker registry>


# additional controlplanes, excludes the masterIP
controlPlaneList: # required are at least two additional controlplanes, keep in mind that you need an odd number of controlplanes
  - 10.2.10.52
  - 10.2.10.53

# additional workers
workerList: # required are at least three additional worker
# - 10.2.10.71
# - 10.2.10.72
# - 10.2.10.73

rook-ceph: false # mandatory, set to true if you want to install it into your cluster
harbor: false # mandatory, set to true if you want to install it into your cluster
opensearch: false # mandatory, set to true if you want to install it into your cluster
opensearch-dashboards: false # mandatory, set to true if you want to install it into your cluster
logstash: false # mandatory, set to true if you want to install it into your cluster
filebeat: false # mandatory, set to true if you want to install it into your cluster
prometheus: false # mandatory, set to true if you want to install it into your cluster
opa: true # mandatory, set to true if you want to install it into your cluster

storageClass: "rook-cephfs" # optional, default value is "rook-cephfs", delete the line if you don't use it
#-------------------------------------------------------------------------------------------------------------------------------
### Values for Rook-Ceph ###
cluster:
  storage:
    useAllNodes: true # default value: true
    useAllDevices: false # default value: true
    # Global filter to only select certain devicesnames. This example matches names starting with sda or sdb.
    # Will only be used if useAllDevices is set to false and will be ignored if individual devices have been specified on a node.
    deviceFilter: "^sd[a-b]"
#-------------------------------------------------------------------------------------------------------------------------------
### Values for Postgres ###
postgrespass: "password" # mandatory, set password for harbor postgres access
postgres:
  resources:
    requests:
      storage: 2Gi # mandatory, depending on storage capacity
#-------------------------------------------------------------------------------------------------------------------------------
### Values for Redis ###
redispass: "password" # mandatory set password for harbor redis access
redis:
  resources:
    requests:
      storage: 2Gi # mandatory depending on storage capacity
#-------------------------------------------------------------------------------------------------------------------------------
### Values for Harbor deployment ###
## For detailed explaination for each key see: https://artifacthub.io/packages/helm/harbor/harbor/1.8.1#configuration ##
harborpass: "password" # mandatory: set password for harbor access
externalURL: https://10.2.10.51:30003 # mandatory, the ip address and port, from which harbor is accessable outside of the cluster
harborPersistence:
  persistentVolumeClaim:
    registry:
      size: 5Gi # mandatory, depending on storage capacity
    chartmuseum:
      size: 5Gi # mandatory, depending on storage capacity
    jobservice:
      size: 1Gi # mandatory, depending on storage capacity
    database:
      size: 1Gi # mandatory, depending on storage capacity
    redis:
      size: 1Gi # mandatory, depending on storage capacity
    trivy:
      size: 5Gi # mandatory, depending on storage capacity


#--------------------------------------------------------------------------------------------------------------------------------
###Values for Logstash deployment###
##For detailed explaination for each key see: https://github.com/elastic/helm-charts/releases/tag/v7.16.3###
volumeClaimTemplate:
  resources:
    requests:
      storage: 1Gi # mandatory, depending on storage capacity


#--------------------------------------------------------------------------------------------------------------------------------
###Values for OpenSearch deployment###
##For detailed explaination for each key see: https://github.com/opensearch-project/helm-charts/tree/main/charts/opensearch###
openSearchPersistence:
  size: 4Gi # mandatory, depending on storage capacity


#--------------------------------------------------------------------------------------------------------------------------------
###Values for Prometheus deployment###
privateRegistry: false # optional, default: false, options: true, false
grafanaUsername: "user"
grafanaPassword: "password"
retentionSize: "24GB"
```