# OpenNebula - Kubernetes appliance

## Instructions for the deployment and verifying the conformance tests

### Setup a server node

We will need just one server node to verify the results. This node should be powerful enough to be able to run up to three small kubernetes nodes as virtual machines.

**NOTE**:
> You can run this node machine as VM itself if you configure the nested virtualization.

#### Recommended specification

- 8 (v)CPU
- 16+ GB RAM
- 60+ GB disk space
- 1 NIC with an access to the internet and a default route
- CentOS 8 (or other OS supported by [minione](https://github.com/OpenNebula/minione#requirements))

#### OpenNebula installation

For our example we will go with **CentOS 8** and we set the hostname to `opennebula-server` - to distinguish commands run on the opennebula server from those run inside the appliance VMs.

The installation will be done via an easy-to-use OpenNebula's bash installer called [minione](https://github.com/OpenNebula/minione).

Firstly we have to install `wget`:

```
[root@opennebula-server ~]# dnf -y install wget
```

and as the next step we download `minione`:

```
[root@opennebula-server ~]# wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
```

Now we can install OpenNebula server - this will take a couple of minutes:

```
[root@opennebula-server ~]# bash minione --yes --password k8s-test --marketapp-name 'Service Kubernetes 1.18 - KVM'
```

The installation (if successful) should at the end print out useful report like this:

```
### Report
OpenNebula 5.12 was installed
Sunstone [the webui] is running on:
  http://10.10.2.130/
Use following to login:
  user: oneadmin
  password: k8s-test
```

The previous command already downloaded the Kubernetes appliance from the OpenNebula marketplace and setup the oneadmin's password via which we can login into the web interface called Sunstone. For more information you can take a look at the [documentation](https://docs.opennebula.io/minione/simple/validation.html).

OpenNebula server node should be ready by now and so we can open the URL of the Sunstone in a browser: `http://opennebula-server`

Or verify the host with the `onehost` command:

```
[root@opennebula-server ~]# onehost list
  ID NAME                                 CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   0 localhost                            default      0       0 / 800 (0%)    0K / 15.7G (0%) on
```

### Deploy the Kubernetes appliance

The `sonobuoy` conformance test suite requires at least two-node kubernetes cluster - so we will firstly deploy a one master node (acting also as a worker node) and after that we will join another worker node.

#### Create new VM template

We could just use and/or modify the already preinstalled Kubernetes appliance's template but instead of navigating in the web interface it will be easier to do everything in the command line.

Create in our opennebula server a file called `kube.tmpl` with this content:

```
[root@opennebula-server ~]# cat > kube.tmpl <<EOF
NAME = "Kube"
CONTEXT = [
  NETWORK = "YES",
  PASSWORD = "k8s-test",
  REPORT_READY = "YES",
  SSH_PUBLIC_KEY = "\$USER[SSH_PUBLIC_KEY]",
  TOKEN = "YES" ]
CPU = "2"
CPU_MODEL = [
  MODEL = "host-passthrough" ]
DISK = [
  DEV_PREFIX = "vd",
  IMAGE_ID = "0",
  SIZE = "20000" ]
GRAPHICS = [
  LISTEN = "0.0.0.0",
  TYPE = "VNC" ]
MEMORY = "4096"
MEMORY_UNIT_COST = "MB"
NIC = [
  NETWORK = "vnet",
  NETWORK_UNAME = "oneadmin",
  SECURITY_GROUPS = "0" ]
NIC_DEFAULT = [
  MODEL = "virtio" ]
OS = [
  ARCH = "x86_64",
  BOOT = "" ]
VCPU = "2"
EOF
```

Import this file as a new `Kube` VM template into the OpenNebula:

```
[root@opennebula-server ~]# onetemplate create kube.tmpl
```

#### Create new OneFlow Service template

This is OpenNebula's feature to deploy VMs in more sophisticated arrangement. We will use in our case a typical master/worker relationship which will enable to create the same two-node (or more) cluster with an ease (repeatably).

We will need the ID of the `Kube` template created from the previous step:

```
[root@opennebula-server ~]# KUBE_ID=$(onetemplate show Kube -x | xmllint --xpath 'number(//VMTEMPLATE/ID)' -)
```

Create a service template file `kube-service.tmpl` (**notice that we are using shell variable expansion for `KUBE_ID`**):

```
[root@opennebula-server ~]# cat > kube-service.tmpl <<EOF
{
  "name": "Kube-service",
  "deployment": "straight",
  "description": "",
  "roles": [
    {
      "name": "master",
      "cardinality": 1,
      "vm_template": ${KUBE_ID} ,
      "vm_template_contents": "ONEGATE_ENABLE=\"YES\"",
      "elasticity_policies": [],
      "scheduled_policies": []
    },
    {
      "name": "worker",
      "cardinality": 1,
      "vm_template": ${KUBE_ID} ,
      "vm_template_contents": "ONEGATE_ENABLE=\"YES\"",
      "parents": [
        "master"
      ],
      "elasticity_policies": [],
      "scheduled_policies": []
    }
  ],
  "ready_status_gate": true
}
EOF
```

Now we can import it as a service template `Kube-service`:

```
[root@opennebula-server ~]# oneflow-template create kube-service.tmpl
```

Finally by doing so we can instantiate the whole Kubernetes cluster with one command (or click in Sunstone).

#### Deploy Kubernetes cluster

Everything is in the place to deploy the Kubernetes cluster based on the new service template `Kube-service`:

```
[root@opennebula-server ~]# oneflow-template instantiate 'Kube-service'
```

This will take another couple of minutes before both of the nodes are up and ready - we can check the status with this command:

```
[root@opennebula-server ~]# oneflow list
  ID USER     GROUP    NAME                                            STAT
   3 oneadmin oneadmin Kube-service                                    RUNNING
```

When the column `STAT` is showing `RUNNING` we can try to ssh login into the master kubernetes node.

**NOTE**:
> The rest of this section can be skipped if the IP of the kubernetes master node is retrieved from Sunstone...
> Also if all here described steps are followed without a change then the IP address of the master node should be the same (`172.16.100.2`).

Let's  find out which VM is the master - we will need the `ID` of the service (number  `3` in our example).

```
[root@opennebula-server ~]# oneflow show 3
SERVICE 3 INFORMATION
ID                  : 3
NAME                : Kube-service
USER                : oneadmin
GROUP               : oneadmin
STRATEGY            : straight
SERVICE STATE       : RUNNING

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

ROLE master
ROLE STATE          : RUNNING
VM TEMPLATE         : 4
CARDINALITY         : 1

NODES INFORMATION
 VM_ID NAME                     USER            GROUP
     2 master_0_(service_3)     oneadmin        oneadmin

ROLE worker
ROLE STATE          : RUNNING
PARENTS             : master
VM TEMPLATE         : 4
CARDINALITY         : 1

NODES INFORMATION
 VM_ID NAME                     USER            GROUP
     3 worker_0_(service_3)     oneadmin        oneadmin

LOG MESSAGES
11/09/20 16:52 [I] New state: DEPLOYING
11/09/20 16:54 [I] New state: RUNNING
```

We are interested in the VM of the `master` role: `master_0_(service_3)` and `ID=2`

```
[root@opennebula-server ~]# KUBE_MASTER=$(onevm show -x 'master_0_(service_3)' | xmllint --xpath 'string(//VM/TEMPLATE/NIC/IP)' -)
```

Our Kubernetes master node has the address: `KUBE_MASTER=172.16.100.2`

#### Run conformance tests

When we know the IP address of the Kubernetes master node:

```
[root@opennebula-server ~]# echo $KUBE_MASTER
172.16.100.2
```

we can login:

```
[root@opennebula-server ~]# ssh $KUBE_MASTER
Warning: Permanently added '172.16.100.2' (ECDSA) to the list of known hosts.

    ___   _ __    ___
   / _ \ | '_ \  / _ \   OpenNebula Service Appliance
  | (_) || | | ||  __/
   \___/ |_| |_| \___|

 All set and ready to serve 8)

[root@onekube-ip-172-16-100-2 ~]#
```

and check the cluster with `kubectl`:

```
[root@onekube-ip-172-16-100-2 ~]# kubectl get nodes -o wide
NAME                                  STATUS   ROLES    AGE     VERSION    INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                CONTAINER-RUNTIME
onekube-ip-172-16-100-2.localdomain   Ready    master   3m56s   v1.18.10   172.16.100.2   <none>        CentOS Linux 7 (Core)   3.10.0-1127.19.1.el7.x86_64   docker://19.3.13
onekube-ip-172-16-100-3.localdomain   Ready    <none>   2m33s   v1.18.10   172.16.100.3   <none>        CentOS Linux 7 (Core)   3.10.0-1127.19.1.el7.x86_64   docker://19.3.13
```

The rest of this document is following the instructions of the `sonobuoy` test suite found here: https://github.com/cncf/k8s-conformance/blob/master/instructions.md

1. Download **sonobuoy**:

    ```
    [root@onekube-ip-172-16-100-2 ~]# curl -L -O 'https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.19.0/sonobuoy_0.19.0_linux_amd64.tar.gz'
    ```

1. Extract `sonobuoy` tool from the archive:

    ```
    [root@onekube-ip-172-16-100-2 ~]# tar -xf sonobuoy_0.19.0_linux_amd64.tar.gz sonobuoy
    ```

1. Run tests:

    ```
    [root@onekube-ip-172-16-100-2 ~]# ./sonobuoy run --mode=certified-conformance
    INFO[0000] created object name=sonobuoy namespace= resource=namespaces
    INFO[0000] created object name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
    INFO[0000] created object name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
    INFO[0000] created object name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
    INFO[0000] created object name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
    INFO[0000] created object name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
    INFO[0000] created object name=sonobuoy namespace=sonobuoy resource=pods
    INFO[0000] created object name=sonobuoy-aggregator namespace=sonobuoy resource=services
    ```

This may take an hour or two to finish - you can monitor the progress with the command:
```
[root@onekube-ip-172-16-100-2 ~]# ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT
            e2e    running                1
   systemd-logs   complete                2

Sonobuoy is still running. Runs can take up to 60 minutes.
```

When test suite is finished the former command will give an output similar to this:

```
[root@onekube-ip-172-16-100-2 ~]# ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT
            e2e   complete   passed       1
   systemd-logs   complete   passed       2

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

We will do as is hinted:

```
[root@onekube-ip-172-16-100-2 ~]# outfile=$(./sonobuoy retrieve)
[root@onekube-ip-172-16-100-2 ~]# cp -a "$outfile" sonobuoy.tar.gz
```

Content of the test is in the exported archive - we can download it to the opennebula server like so:

```
[root@opennebula-server ~]# scp 172.16.100.2:~/sonobuoy.tar.gz ./
```

