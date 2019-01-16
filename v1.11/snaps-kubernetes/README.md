# Installation

This document serves as a user guide specifying the steps/actions user must
perform to bring up a Kubernetes cluster using SNAPS-Kubernetes. The document
also gives an overview of deployment architecture, hardware and software
requirements that must be fulfilled to bring up a Kubernetes cluster.

This document covers:
- High level overview of the SNAPS-Kubernetes components
- Provisioning of various configuration yaml files
- Deployment of the SNAPS-Kubernetes environment

The intended audience of this document includes the following:
- Users involved in the deployment, maintenance and testing of SNAPS-Kubernetes
- Users interested in deploying a Kubernetes cluster with basic features

## 1 Introduction

### 1.1 Terms and Conventions

The terms and typographical conventions used in this document are listed and
explained in below table.

| Convention | Usage |
| ---------- | ----- |
| Host Machines | Machines in data centers which would be prepared by SNAPS-Kubernetes to serve control plane and data plane services for Kubernetes cluster. SNAPS-Kubernetes will deploy Kubernetes services on these machines. |
| Management node | Machine that will run SNAPS-Kubernetes software. |

### 1.2 Acronyms

The acronyms expanded below are fundamental to the information in this document.

| Acronym | Explanation |
| ------- | ----------- |
| PXE | Preboot Execution Environment |
| IP | Internet Protocol |
| COTS | Commercial Off the Shelf |
| DHCP | Dynamic Host Configuration Protocol |
| TFTP | Trivial FTP |
| VLAN | Virtual Local Area Network |


## 2 Environment Prerequisites

Current release of SNAPS-Kubernetes requires the following Hardware and software
components.

### 2.1 Hardware Requirements

**Host Machines**

| Hardware Required | Description | Configuration |
| ----------------- | ----------- | ------------- |
| Servers with 64bit Intel AMD architecture | Commodity Hardware | 16GB RAM, 80+ GB Hard disk with 2 network cards. Server should be network boot enabled. |

**Management Node**

| Hardware Required | Description | Configuration |
| ----------------- | ----------- | ------------- |
| Server with 64bit Intel AMD architecture | Commodity Hardware | 16GB RAM, 80+ GB Hard disk with 1 network card. |

### 2.2 Software Requirements

| Category | Software version |
| -------- | ---------------- |
| Operating System | Ubuntu 16. |
| Programming Language | Python 2.7.12 |
| Automation | Ansible 2.3.1.0 |
| Framework |  Kubernetes V1.10.0 |
| Containerization | Docker V17-03-CE |

### 2.3 Network Requirements

- Minimum of two network interface cards required in all the host machines
- All servers should use the same naming scheme for ethernet ports. If ports on of the servers are named as eno1, eno2 etc. then ports on other servers should be named as eno1, eno2 etc.
- All host machines and Management node are connected via IPMI network.
- All host machines and the Management node should be on the same network and have Internet access connectivity.
- Management node shall have http/https and ftp proxy if node is behind corporate firewall.
- All the operations for configuration shall be performed as a root user.
- All host machine should be connected to another network/subnet via their 2nd interface. This 2nd network will serve as data network and it should be possible to reach internet via this network as well.



## 3 Deployment View and Configurations

Project SNAPS-Kubernetes is a Python based framework majorly built around
Ansible playbooks, Kubespray and a workflow Engine. SNAPS-Boot is a
pre-requisite and is required to OS provision Baremetal host. It uses a set of
configuration files for environment planning and feature control. These
configuration files are defined as set of yaml files and are required to be
prepared by user for every stage of deployment.

![Deployment and Configuration Overview](https://raw.githubusercontent.com/wiki/cablelabs/snaps-kubernetes/images/install-deploy-config-overview-1.png?token=Al5dreR4VK2dsb7h6D5beMZmWnkZpNNNks5bTmfhwA%3D%3D)

![Deployment and Configuration Workflow](https://raw.githubusercontent.com/wiki/cablelabs/snaps-kubernetes/images/install-deploy-config-workflow-1.png?token=Al5drVkAVPNQfJcPFNezfl1WIVYoJLbAks5bTme3wA%3D%3D)

In current architecture SNAPS-Kubernetes runs on a separate a server (Management
node) and deploys control and user plane services on host machines. The complete
workflow happens in 3 stages specified below.

1. Bootstrap node provisioning
2. Bare metal OS provisioning
3. Kubernetes cluster deployment

User is required to prepare configuration files for each stage. The section
below explains the configuration files required at various stages of deployment.

### 3.1 Management Node Provisioning

Management node provisioning is the 1st step of cluster deployment and requires
user to prepare a node for running SNAPS-Kubernetes.

Management node runs 2 component software’s SNAPS-Kubernetes and SNAPS-Boot.
SNAPS-Boot is a pre-requisite and is required to net boot all host machines with
Ubuntu 16.04.

User are required to download both software to Management node from GitHub.

SNAPS-Boot package can be downloaded from GitHub
https://github.com/cablelabs/snaps-boot.

SNAPS-Kubernetes package can be downloaded from GitHub
https://github.com/cablelabs/snaps-kubernetes.

Users are further required to prepare a configuration file hosts.yaml as defined
at https://github.com/cablelabs/snaps-boot. This configuration is used by
SNAPS-Boot to discover and net boot host machines, allocate IP addresses, set
proxies and install operating system on these machines.

### 3.2 Bare Metal OS Provisioning

This is the 2nd stage of cluster deployment and primarily involves working with
SNAPS-Boot. Users are not required to prepare any configuration for this stage.

### 3.3 Kubernetes Cluster Deployment

This the 3rd stage of cluster deployment and involves installation of core
Kubernetes services on host machines and enabling storage and networking
features.

User is required to prepare a configuration file `k8s-deploy.yaml`
giving details of the environment, networking and storage features, node
configurations, access and security features. The sections below provide
description of the parameters defined in the configuration file.

>NOTE: The filename of the configuration file can be anything the User wants, but this install guide uses `k8s-deploy.yaml`.

#### 3.3.1 Project Configuration

*Optionality: No*

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| Project_name | N | Project name of the project (E.g. My_project). Using different project name user can install multiple cluster with same SNAPS-Kubernetes folder on different host machines.
| Git_branch | N | Branch to checkout for Kubespray (E.g. master) |
| Version | N | Kubernetes version (Value: 1.10.0) |
| enable_metrics_server | N | Flag used to enable or disable Metric server. Mandatory to set either True or False. Value: True/False |
| Exclusive_CPU_alloc_support | Y | Should Cluster enforce exclusive CPU allocation. Value: True/False |
| enable_logging | N | Should Cluster enforce logging. Value: True/False |
| log_level | N | Log level(fatal/error/warn/info/debug/trace) |
| logging_port | N | Logging Port (e.g. 30011) |

#### 3.3.3 Basic Authentication

Parameters specified here are used to define access control mechanism for the
cluster, currently only basic http authentication is supported.

*Optionality: No*

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| user_name | N | User name to access the cluster |
| user_password | N | User password to access the host machine |
| user_id | N | User id to access the cluster |

Define this set of parameters for each user, required to access the cluster.

#### 3.3.4 Node Configuration

Parameters defined here specify the cluster nodes, their roles, ssh access
credential and registry access. This will come under tag node_configuration.

*Optionality: No*

<table>
  <tr>
    <th colspan="2">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="3">Host</td>
    <td>Define this set of parameters for each host machine (a separate host section should be defined for each host machine).</td>
  </tr>
  <tr>
    <td/>
    <td>Hostname</td>
    <td>N</td>
    <td>Hostname to be used for the machine. (It should be unique across the cluster)</td>
  </tr>
  <tr>
    <td/>
    <td>ip</td>
    <td>N</td>
    <td>IP of the primary interface (Management Interface, allocated after OS provisioning).</td>
  </tr>
  <tr>
    <td/>
    <td>registry_port</td>
    <td>N</td>
    <td>Registry port of the host/master. Example: “2376 / 4386”</td>
  </tr>
  <tr>
    <td/>
    <td>node_type</td>
    <td>N</td>
    <td>Node type (master, minion).</td>
  </tr>
  <tr>
    <td/>
    <td>label_key</td>
    <td>N</td>
    <td>Define the name for label key. Example: zone</td>
  </tr>
  <tr>
    <td/>
    <td>label_value</td>
    <td>N</td>
    <td>Define the name for label value. Example: master</td>
  </tr>
  <tr>
    <td/>
    <td>Password</td>
    <td>N</td>
    <td>Password of host machine</td>
  </tr>
  <tr>
    <td/>
    <td>User</td>
    <td>N</td>
    <td>User id to access the host machine (must be root user)</td>
  </tr>
</table>

#### 3.3.5 Docker Repository

Parameters defined here controls the deployment of private docker repository for
the cluster.

*Optionality: No*

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| Ip | N | Severe IP to host private Docker repository |
| Port | N | Define the registry Port. Example: - “4000” |
| password | N | Password of docker machine. Example: - ChangeMe |
| User | N | User id to access the host machine (must be root user). |

#### 3.3.6 Proxies

Parameters defined here specifies the proxies to be used for internet access.

*Optionality: No*

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| ftp_proxy | Y | Proxy to be used for FTP. (For no proxy: give value as “”) |
| http_proxy | Y | Proxy to be used for HTTP traffic. (For no proxy: give value as “”) |
| https_proxy | Y | Proxy to be used for HTTPS traffic. (For no proxy: give value as “”) |
| no_proxy | N | Comma separated list of IPs of all host machines. Localhost 127.0.0.1 should be included here. |

#### 3.3.7 Persistent Volume

SNAPS-Kubernetes supports 2 approaches to provide storage to container
workloads.
- Ceph.
- HostPath

**Ceph Volume**

Parameters specified here control the installation of CEPH process on cluster
nodes. These nodes define a CEPH cluster and storage to PODs is provided from
this cluster. SNAPS-Kubernetes creates a PV and PVC for each set of
claims_parameters, which can later be consumed by application pods.

*Optionality: No*

<table>
  <tr>
    <th colspan="4">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="5">host</td>
    <td>Define this set of parameters for each host machine.</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">hostname</td>
    <td>Y</td>
    <td>Hostname to be used for the machine. (It should be unique across the cluster)</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">ip</td>
    <td>Y</td>
    <td>IP of the primary interface</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">node_type</td>
    <td>Y</td>
    <td>Node type (ceph_controller/ceph_osd).</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">password</td>
    <td>Y</td>
    <td>Password of host machine</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">user</td>
    <td>Y</td>
    <td>User id to access the host machine</td>
  </tr>
  <tr>
    <td/>
    <td colspan="4">Ceph_claims</td>
    <td>Define this set only for ceph_controller nodes</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td colspan="3">claim_parameteres</td>
    <td>User can define multiple claim parameters under a host</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td/>
    <td>claim_name</td>
    <td>Y</td>
    <td>Define name of persistent volume claim. For Ex. "claim2"</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td/>
    <td>storage</td>
    <td>Y</td>
    <td>Defines storage capacity of persistent volume claim. For Ex. "4Gi"</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">second_storage</td>
    <td>Y</td>
    <td>List of OSD storage device. This field should be defined only if Node_type is ceph_osd</td>
  </tr>
</table>

**Host Volume**

Parameters specified here are used to define PVC and PV for HostPath volume
type. SNAPS-Kubernetes creates a PV and PVC for each set of claim_parameters,
which can later be consumed by application pods.

*Optionality: No*

<table>
  <tr>
    <th colspan="3">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="4">Host_Volume</td>
    <td>User can define multiple claims under this section</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">claim_parameteres</td>
    <td>A tag in yaml file</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>Claim_name</td>
    <td>Y</td>
    <td>Define name of persistent volume claim. For Ex. "claim4"</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>storage</td>
    <td>Y</td>
    <td>Defines storage capacity of Host volume claim. For Ex. "4Gi"</td>
  </tr>
</table>

#### 3.3.8 Networks

SNAPS-Kubernetes supports following 6 solutions for cluster wide networking:
- Weave
- Flannel
- Calico
- MacVlan
- SRIOV
- DHCP

Weave, Calico and Flannel provide cluster wide networking and can be used as
default networking solution for the cluster. MacVlan and SRIOV on the other hand
are specific to individual nodes and are installed only on specified nodes.

SNAPS-Kubernetes uses CNI plug-ins to orchestrate these networking solutions.

**Default Networks**

Parameters defined here specifies the default networking solution for the
cluster.

SNAPS-Kubernetes install the CNI plugin for the network type defined by
parameter `networking_plugin` and creates a network to be consumed by Kubernetes
pods. User can either choose weave, flannel or calico for default networking
solution.

*Optionality: No*

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| networking_plugin | N | Network plugin to be used for default networking. Allowed values are weave, flannel and Calico |
| service_subnet | N | Subnet to be used for Kubernetes service deployments (E.g. 10.241.0.0/18) |
| pod_subnet | N | Subnet for pods networking (E.g. 10.241.64.0/18) |
| network_name | N | Default network to be created by SNAPS-Kubernetes. Note: The name should not contain any Capital letter and “_”. |
| isMaster | N | The default route will point to the primary network. One of the plugin acts as a “Master” plugin and responsible for configuring k8s network with Pod interface “eth0” “isMaster should be True for one plugin.” Value: true/false |

**Multus Networks**

Multus networking solution is required to support application pods with more
than one network interface. It provides a way to group multiple networking
solution and invoke them as required by the pods.

SNAPS-Kubernetes supports Multus as a CNI plugin with following networking
providers:
- Weave
- Flannel
- SRIOV
- MacVlan
- DHCP

##### CNI

List of network providers to be used under Multus. User can define any
combination of weave, flannel, SRIOV, Macvlan and DHCP.

*CNI Configuration*

Parameters defined are specifies the network subnet, gateway, range and other
network intrinsic parameters.

> **Note:** User must provide configuration parameters for each network provider specified under CNI tag (mentioned above).

##### Flannel

Define this section when Flannel is included under Multus.

*Optionality: No*

<table>
  <tr>
    <th colspan="2">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="3">flannel_networks</td>
    <td></td>
  </tr>
  <tr>
    <td/>
    <td>network_name</td>
    <td>N</td>
    <td>Name of the network. SNAPS-Kubernetes creates a Flannel network for the cluster with this name. Note: The name should not contain any Capital letter and “_”.</td>
  </tr>
  <tr>
    <td/>
    <td>network</td>
    <td>N</td>
    <td>Network range in CIDR format to be used for the entire flannel network.</td>
  </tr>
  <tr>
    <td/>
    <td>subnet</td>
    <td>N</td>
    <td>Subnet range for each node of the cluster.</td>
  </tr>
  <tr>
    <td/>
    <td>isMaster</td>
    <td>N</td>
    <td>The "masterplugin" is the only net conf option of multus cni, it identifies the primary network. The default route will point to the primary network One of the plugin acts as a “Master” plugin and responsible for configuring k8s network with Pod interface “eth0”. Value: true/false</td>
  </tr>
</table>

##### Weave

Define this section when Weave is included under Multus.

*Optionality: No*

<table>
  <tr>
    <th colspan="2">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="3">weave_networks</td>
    <td></td>
  </tr>
  <tr>
    <td/>
    <td>network_name</td>
    <td>N</td>
    <td>Name of the network. SNAPS-Kubernetes creates a Weave network for the cluster with this name. Note: The name should not contain any Capital letter and “_”.</td>
  </tr>
  <tr>
    <td/>
    <td>subnet</td>
    <td>N</td>
    <td>Define the Subnet for network.</td>
  </tr>
  <tr>
    <td/>
    <td>isMaster</td>
    <td>N</td>
    <td>The "masterplugin" is the only net conf option of multus cni, it identifies the primary network. The default route will point to the primary network One of the plugin acts as a “Master” plugin and responsible for configuring k8s network with Pod interface “eth0”. Value: true/false</td>
  </tr>
</table>

##### DHCP

No configuration required. When DHCP CNI is given, SNAPS-Kubernetes configures
DHCP services on each node and facilitate dynamic IP allocation via external
DHCP server.

##### Macvlan

Define this section when Macvlan is included under Multus.

User should define these set of parameters for each host where Macvlan network is to be created.

*Optionality: No*

<table>
  <tr>
    <th colspan="2">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="3">macvlan_networks</td>
    <td>Define this section for each node where Macvlan network is to be deployed</td>
  </tr>
  <tr>
    <td/>
    <td>hostname</td>
    <td>N</td>
    <td>Hostname of the node where Macvlan network is to be created</td>
  </tr>
  <tr>
    <td/>
    <td>parent_interface</td>
    <td>N</td>
    <td>Kubernetes creates a Vlan tagged interface for the Macvlan network. The tagged interface is created from the interface name defined here.</td>
  </tr>
  <tr>
    <td/>
    <td>vlanid</td>
    <td>N</td>
    <td>VLAN id of the network</td>
  </tr>
  <tr>
    <td/>
    <td>ip</td>
    <td>N</td>
    <td>IP to be assigned to vlan tagged interface. SNAPS-Kubernetes creates a separate Vlan tagged interface to be used as primary interface for Macvlan network.</td>
  </tr>
  <tr>
    <td/>
    <td>network_name</td>
    <td>N</td>
    <td>This field defines the macvlan network name. Note: The name should not contain any Capital letter and "_"</td>
  </tr>
  <tr>
    <td/>
    <td>master</td>
    <td>N</td>
    <td>Use field parent_interface followed by vlan_id with a dot in between (parent_interface.vlanid).</td>
  </tr>
  <tr>
    <td/>
    <td>type</td>
    <td>N</td>
    <td>host-local or dhcp. If dhcp used, SNAPS-Kubernetes configures this network to ask IPs from external DHCP server. If host-local used, SNAPS-Kubernetes configures
    this network to ask IPs from IPAM.</td>
  </tr>
  <tr>
    <td/>
    <td>rangeStart</td>
    <td>N</td>
    <td>First IP of the network range to be used for Macvlan network (Not required in case type is dhcp).</td>
  </tr>
  <tr>
    <td/>
    <td>rangeEnd</td>
    <td>N</td>
    <td>Last IP of the network range to be used for Macvlan network (Not required in case type is dhcp).</td>
  </tr>
  <tr>
    <td/>
    <td>gateway</td>
    <td>N</td>
    <td>Define the Gateway</td>
  </tr>
  <tr>
    <td/>
    <td>routes_dst</td>
    <td>N</td>
    <td>Use value 0.0.0.0/ (Not required in case type is dhcp).</td>
  </tr>
  <tr>
    <td/>
    <td>subnet</td>
    <td>N</td>
    <td>Define the Subnet for Network in CIDR format (Not required in case type is dhcp).</td>
  </tr>
  <tr>
    <td/>
    <td>isMaster</td>
    <td>N</td>
    <td>The "masterplugin" is the only net conf option of multus cni, it identifies the primary network. The default route will point to the primary network One of the plugin acts as a “Master” plugin and responsible for configuring k8s network with Pod interface “eth0”. Value: true/false</td>
  </tr>
</table>

##### SRIOV

Define this section when SRIOV is included under Multus.

*Optionality: No*

<table>
  <tr>
    <th colspan="3">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="4">host</td>
    <td>Define these set of parameters for each node where SRIOV network is to be deployed</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">hostname</td>
    <td>Hostname of the node</td>
  </tr>
  <tr>
    <td/>
    <td colspan="3">networks</td>
    <td>Define these set of parameters for each SRIOV network be deployed on the host. User can create multiple network on the same host.</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>network_name</td>
    <td>N</td>
    <td>Name of the SRIOV network.</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>sriov_intf</td>
    <td>N</td>
    <td>Name of the physical interface to be used for SRIOV network (the network adaptor should be SRIOV capable).</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>type</td>
    <td>N</td>
    <td>host-local or dhcp. If dhcp used, SNAPS-Kubernetes configures this network to ask IPs from external DHCP server. If local-host used, SNAPS-Kubernetes configures this network to ask IPs from IPAM.</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>rangeStart</td>
    <td>N</td>
    <td>First IP of the network range to be used for Macvlan network (Not required in case type is dhcp).</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>rangeEnd</td>
    <td>N</td>
    <td>Last IP of the network range to be used for Macvlan network (Not required in case type is dhcp).</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>sriov_gateway</td>
    <td>N</td>
    <td>Define the Gateway</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>sriov_subnet</td>
    <td>N</td>
    <td>Define the IP subnet for the SRIOV network.</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>isMaster</td>
    <td>N</td>
    <td>The "masterplugin" is the only net conf option of multus cni, it identifies the primary network. The default route will point to the primary network One of the plugin acts as a “Master” plugin and responsible for configuring k8s network with Pod interface “eth0”. Value: true/false</td>
  </tr>
  <tr>
    <td/>
    <td/>
    <td>dpdk_enable</td>
    <td>Y</td>
    <td>Enable or disable the dpdk.</td>
  </tr>
</table>

## 4 Installation Steps

### 4.1 Kubernetes Cluster Deployment

#### 4.1.1 Kubernetes provisioning package

Clone/FTP Kubernetes_Provisioning package on configuration node. All operations
of configuration server expect the user should be explicitly switched (using `su
root`) to the root user.

#### 4.1.2 Configuration file

Go to directory `~/snaps-kubernetes/snaps_k8s`

Modify file `k8s-deploy.yaml` for provisioning of Kubernetes nodes on cloud
cluster host machines (Master/etcd and minion). Modify this file according to
your set up environment. Refer to section 3.3.

#### 4.1.3 Installation

Ensure Bootstrap node must have python, pathlib, git, SSH and ansible installed.(i.e. apt-get install -y python, apt-get install -y pathlib*, apt-get install -y git, apt-get install -y ssh, apt-get install -y ansible)

Setup the python runtime:

```
python setup.py dev
```

or

```
pip install {path_to_repo}
```

Ensure all host machines must have python and SSH installed.(i.e. apt-get install -y python and apt-get install -y ssh)

Go to directory `~/snaps-kubernetes`

Run `iaas_launch.py` as shown below:

```
sudo python iaas_launch.py -f snaps_k8s/k8s-deploy.yaml -k8_d
```

This will install Kubernetes service on host machines. The Kubernetes
installation will start and will get completed in ~60 minutes.

> Note: if installation fails due to Error “FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (4 retries left).” please check your internet connection.

Kubectl service will also be installed on bootstrap node.

After cluster installation, if user needs to run kubectl command on bootstrap
node, please run:

```
export KUBECONFIG=/etc/kubelet/node-kubeconfig.yaml
```
### 4.2 Cleanup Kubernetes Cluster

Use these steps to clean an existing cluster.

Go to directory  `~/snaps-kubernetes`

Clean up previous Kubernetes deployment:

```
sudo python iaas_launch.py -f snaps_k8s/k8s-deploy.yaml -k8_c
```
