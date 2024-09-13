# TKS Enterprise Solution

## Create TKS Admin Cluster

### Download TKS install

```shell
$ git clone https://github.com/openinfradev/tks-mgmt-cluster-deploy.git
```

### Configurations

#### Setup 'conf.sh' File

```shell
TKS_RELEASE=main

BOOTSTRAP_CLUSTER_SERVER_IP="xx.xx.xx.xx"
DOWNLOAD_IMAGES=false
INSTALL_NGINX_INGRESS=false

TKS_ADMIN_CLUSTER_INFRA_PROVIDER="byoh"

declare -a CAPI_INFRA_PROVIDERS=("byoh")

AWS_REGION=NA
AWS_ACCESS_KEY_ID=NA
AWS_SECRET_ACCESS_KEYNA
AWS_ACCOUNT_ID=NA
AWS_USER=XXX_MUST_BE_FILLED

GIT_SVC_USERNAME=decapod10
GIT_SVC_TYPE=gitea # or github
GIT_SVC_URL=http://gitea-http.gitea.svc:3000

# DB
DATABASE_HOST=""
DATABASE_PORT=5432
DATABASE_USER=postgres_user
DATABASE_PASSWORD=sEcRetPaSsWoRd

# Gitea
GITEA_ADMIN_USER=gitea_admin
GITEA_ADMIN_PASSWORD=SeCrEtPaSsWoRd
```

Fill in the current node's IP and save it.

#### Setup 'cluster.yaml' File

```yaml
cluster:
  name: tks-admin
  kubernetesVersion: v1.29.8

controlPlaneEndpoint:
  host: xx.xx.xx.xx
  port: xxxx

kubeadmControlPlane:
  replicas: x
  selector:
    matchLabels:
      role: admin-control-plane

machineDeployment:
  - name: tks
    replicas: x
    selector:
      matchLabels:
        role: admin-tks
    labels:
      servicemesh: enabled
      taco-egress-gateway: enabled
      taco-ingress-gateway: enabled
      taco-lma: enabled
```

Save the file by filling in the address and port you want to use as the endpoint for your admin cluster, and the number of cluster nodes you want to configure.

### Install TKS

Run 'tks-install.sh' and follow the on-screen instructions. The kubeconfig file accessible to the admin cluster is located in out/kubeconfig_tks-admin.

```shell
$ ./tks_install.sh cluster.yaml
```

### Install TKS CLI

```shell
$ VERSION=3.2.0
$ wget https://github.com/openinfradev/tks-client/releases/download/v${VERSION}/tks-client_${VERSION}_Linux_amd64.tar.gz
$ tar xvzf tks-client\_${VERSION}\_Linux_amd64.tar.gz
$ sudo cp tks-client /usr/local/bin/tks

## tks cli login
$ tks login http://{Node IP}:{tks-api NodePort}
```

### Create TKS Organization

```shell
$ tks organization create {ORIG NANE} --email {EMAIL}
$ tks organization list
```

## Create workload cluster

### Login Console

Access the following services through a web browser.

```shell
# kubectl  get svc -n tks
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
tks-api       NodePort    10.233.19.94    <none>        9110:32721/TCP   4h57m
```

### Create Stack

Select the stack menu marked with Stack Icon from the top menu bar.
Click the Create button.

1. Environment setting
   After entering management information such as the stack name, select BYOH as the installation environment.
   Click the Next button.

2. Select Stack Template
   Select BYOH standard. BYOH Standard is a basic STACK that deploy Kubenetes cluster and sets the necessary add-ons and monitoring pipeline.
   Click the Next button.

3. Stack properties
   Enter the cluster endpoint and number of nodes in the workload cluster.
   Click the Next button.

4. Node registration
   Run the appropriate install command for each node type on each node and check for registration.
   If the nodes are registered according to the number of nodes you set, move on to the next step.

5. Select Policy Temple
   This is the step of selecting a policy template for Kuberntes Admission control. Don't select it for quick execution.
   Click the Next button.

6. Select Policy
   Select the required policy among the policies included in the Policy Template and change the required attribute values. To speed things up, skip this step.
   Click the Next button.

7. Review & Create
   After viewing and reviewing Sumary, click the Create button to start creating. This operation takes approximately 30 minutes to 1 hour, and this time varies depending on the cluster size and node specifications.

### Login The Stack

TKS uses the oidc-login kubectl plugins. Please install by referring to the link below.
https://github.com/int128/kubelogin

Select the stack menu marked with Stack Icon from the top menu bar.
Click the created STACK Tile.
Click the Downlaod kubeconfig button to download the Kubeconfig file.
When running kubectl cli based on the downloaded Kubeconfig file, follow the prompt that appears and log in using the user account ID/PW created earlier.

## Run conformance tests

```shell
$ curl -LO https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz
$ tar xvfz sonobuoy_0.57.1_linux_amd64.tar.gz
$ ./sonobuoy run --mode=certified-conformance --kubeconfig TKS_CLUSTER_ID-tks-kubeconfig
$ ./sonobuoy status --kubeconfig TKS_CLUSTER_ID-tks-kubeconfig
$ ./sonobuoy retrieve --kubeconfig TKS_CLUSTER_ID-tks-kubeconfig

```
