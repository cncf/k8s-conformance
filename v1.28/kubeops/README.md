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
apiVersion: kubeops/kubeopsctl/alpha/v3 # mandatory
imagePullRegistry: "registry1.kubernative.net/lima"
localRegistry: false
clusterName: "cncftest"
kubernetesVersion: "1.28.2"
masterIP: 10.2.10.51
systemCpu: "200m"
systemMemory: "200Mi"
updateRegistry: false
clusterUser: "myuser"

zones:
  - name: zone1
    nodes:
      master: 
        - name: sk4master2
          ipAdress: 10.2.10.52
          user: myuser
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.28.2
      worker:
        - name: sk4worker1
          ipAdress: 10.2.10.71
          user: myuser
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.28.2
        - name: sk4worker2
          ipAdress: 10.2.10.72
          user: myuser
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.28.2
  - name: zone2
    nodes:
      master:
        - name: sk4master3
          ipAdress: 10.2.10.53
          user: myuser
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.28.2
      worker:
        - name: sk4worker3
          ipAdress: 10.2.10.73
          user: myuser
          systemCpu: 200m
          systemMemory: 200Mi 
          status: active
          kubeversion: 1.28.2

# mandatory, set to true if you want to install it into your cluster
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
keycloak: true
velero: true

harborValues: 
  harborpass: "password" # change to your desired password
  databasePassword: "Postgres_Password" # change to your desired password
  redisPassword: "Redis_Password" 
  externalURL: http://10.2.10.51:30002 # change to ip adress of master1

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