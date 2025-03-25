# Kubernetes conformance tests on VIOLA
## VIOLA - [ START GUIDE ]
<br>

## **This guide is based on a closed network**
#### CLOUD_DEV3 _ OKESTRO
#
<br>

## **System Information**


| System | Version |
| --- | --- |
| K8S Cluster | v1.32.2 |
| Nexus | 3.63.0-01 |
| System OS | Ubuntu 22.04.3 LTS |

#
<br>

## **Upload Repo To Nexus(Docker Proxy)**
- **cluster docker images list**
    - cilium/cilium:v1.17.2
    - cilium/operator:v1.17.2
    - coredns/coredns:v1.11.3
    - cpa/cluster-proportional-autoscaler:v1.8.8
    - kube-apiserver:v1.32.2
    - kube-controller-manager:v1.32.2
    - kube-proxy:v1.32.2
    - kube-scheduler:v1.32.2
    - nginx 1.25.2-alpine
    - pause:3.9
    - nfs-subdir-external-provisioner:v4.0.2
    - redis:7.4.2
    - vault:1.14.1
    - istio/proxyv2:1.25.0
    - Istio/pilot:1.25.0
    - mariadb:11.3.2
    - maxscale:2.5.28
    - busybox:1.28
    - kafka:0.45.0-kafka-3.9.0
    - kafka-bridge:0.31.1
    - kaniko-executor:0.45.0
    - maven-builder:0.45.0
    - operator:0.45.0
    - keycloak:version-3.0.4
    - mariadb-keycloak:11.3.2
    - oauth2-proxy:7.5.1
    - ingress-nginx/controller:v1.11.2
    - ingress-nginx/kube-webhook-certgen:v1.4.3
    - maestro/cloud-service-api:v3.0.0
    - maestro/cloud-service-collector:v3.0.0
    - maestro/maestro-auth-gateway:v3.0.0
    - maestro/maestro-common-api:v3.0.0
    - maestro/maestro-event-pusher:v3.0.0
    - maestro/maestro-host-app:v3.0.0
    - maestro/maestro-iam-adapter-api:v3.0.0
    - maestro/maestro-remote-app:v3.0.0
    - maestro/notification-adapter-api:v3.0.0
    - maestro/trombone-pipeline-api:v3.0.0
    - maestro/trombone-remote-app:v3.0.0
    - maestro/viola-api:v3.0.0
    - maestro/viola-remote-app:v3.0.0
<br>

## **INSTALL & SETTING ANSIBLE**

* Configuration to install 

```
tar xvf viola-paas-install.tar
cd  viola-paas-install
```

* ansible.cfg

```
[ssh_connection]
pipelining=True
ssh_args = -o ControlMaster=auto -o ControlPersist=30m -o ConnectionAttempts=100 -o UserKnownHostsFile=/dev/null

[defaults]
force_valid_group_names = ignore

host_key_checking=False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp
fact_caching_timeout = 86400
timeout = 300
stdout_callback = default
display_skipped_hosts = no
library = ./library
callbacks_enabled = profile_tasks,ara_default
roles_path = roles:$VIRTUAL_ENV/usr/local/share/kubespray/roles:$VIRTUAL_ENV/usr/local/share/ansible/roles:/usr/share/kubespray/roles
deprecation_warnings=False
inventory_ignore_extensions = ~, .orig, .bak, .ini, .cfg, .retry, .pyc, .pyo, .creds, .gpg
[inventory]
ignore_patterns = artifacts, credentials
```

* 00_deploy_task.sh

```

  _     ___        __   ____ ___    ___    _          _
 | |   / _ \      /_ | |___ \__ \  |__ \  | |        | |
 | | _| (_) |___   | |   __) | ) |    ) | | |__   ___| |_ __   ___ _ __
 | |/ /> _ </ __|  | |  |__ < / /    / /  | '_ \ / _ \ | '_ \ / _ \ '__|
 |   <| (_) \__ \  | |_ ___) / /_ _ / /_  | | | |  __/ | |_) |  __/ |
 |_|\_\\___/|___/  |_(_)____/____(_)____| |_| |_|\___|_| .__/ \___|_|
                                                       | |
                                                       |_|                 
------------------------------------Notification------------------------------------
Before working, please check the hostname of all nodes and modify all list.txt in the deploy_server_script folder before proceeding.

Workflow : [0] -> [1] -> [2] -> [---] -> [6]
------------------------------------------------------------------------------------
[Select_Num.] [Task_Name] [Target Server]
0. OS Install mandatory packages [Deploy Server]
1. SSH key & resolve.conf [Deploy Server]
2. /etc/hosts [Deploy Server]
3. Haproxy.cfg [Deploy Server]
4. Set conatinerd & Configure Nexus [Deploy Server]
5. Kubespray [Deploy Server]
6. istio,ingress-nginx [Deploy Server]

Input the task number you want [0 - 6]:
```



* Node list

```
root@master-1:~# kubectl get nodes
NAME     STATUS   ROLES           AGE     VERSION
cncf-1   Ready    control-plane   5d14h   v1.32.2
cncf-2   Ready    control-plane   5d14h   v1.32.2
cncf-3   Ready    control-plane   5d14h   v1.32.2
```


# Run Conformance Tests

* Download a sonobuoy


```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz

tar -xvf sonobuoy_0.57.3_linux_amd64.tar.gz
```

* sonobuoy run

```
sonobuoy run --mode-certified-conformance --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v"
```

* Check the status

```
sonobuoy status
```

* To inspect the logs

```
sonobuoy logs
```

* Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
```
outfile=$(sonobuoy retrieve)
```

* This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
```
dir_name="./results"; mkdir "$dir_name" && tar xzf "$outfile" -C "$dir_name"
```

* To clean up Kubernetes objects created by Sonobuoy, run:
```
sonobuoy delete --all --wait
```
