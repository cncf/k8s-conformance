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
apiVersion: kubeops/kubeopsctl/alpha/v4 # mandatory
imagePullRegistry: "registry1.kubernative.net/lima"
localRegistry: false
clusterName: "sonobuoy"
kubernetesVersion: "1.30.1"
masterIP: 10.2.10.11
systemCpu: "200m"
systemMemory: "200Mi"
clusterUser: "root"
rpmServer: https://rpm.kubeops.net/kubeopsRepo/
createCluster: true
updateRegistry: false

zones:
  - name: zone1
    nodes:
      master: 
        - name: sk3master1
          ipAdress: 10.2.10.11
          user: root
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.30.1
        - name: sk3master2
          ipAdress: 10.2.10.12
          user: root
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.30.1
      worker:
        - name: sk3worker1
          ipAdress: 10.2.10.51
          user: root
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.30.1
        - name: sk3worker2
          ipAdress: 10.2.10.52
          user: root
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.30.1
  - name: zone2
    nodes:
      master: 
        - name: sk3master3
          ipAdress: 10.2.10.13
          user: root
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.30.1
      worker:
        - name: sk3worker3
          ipAdress: 10.2.10.53
          user: root
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.30.1

rook-ceph: false
harbor: false
opensearch: false
opensearch-dashboards: false
logstash: false
filebeat: false
prometheus: false
opa: false
kubeops-dashboard: false
certman: false
ingress: false 
keycloak: false
velero: false

harborValues: 
  harborpass: "password" # change to your desired password
  databasePassword: "Postgres_Password" # change to your desired password
  redisPassword: "Redis_Password" 
  externalURL: http://10.2.10.11:30002 # change to ip adress of master1

prometheusValues:
  grafanaUsername: "user"
  grafanaPassword: "password"

ingressValues:
  externalIPs: []

keycloakValues:
  keycloak:
    auth:
      adminUser: admin
      adminPassword: admin
  postgresql:
    auth:
      postgresPassword: ""
      username: bn_keycloak
      password: ""
      database: bitnami_keycloak
      existingSecret: ""

veleroValues:
  accessKeyId: "your_s3_storage_username"
  secretAccessKey: "your_s3_storage_password"
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