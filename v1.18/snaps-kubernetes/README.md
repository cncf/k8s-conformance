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

#### Host Machines

| Hardware Required | Description | Configuration |
| ----------------- | ----------- | ------------- |
| Servers with 64bit Intel AMD architecture | Commodity Hardware | 16GB RAM, 80+ GB Hard disk with 2 network cards. Server should be network boot enabled. |

#### Management Node

| Hardware Required | Description | Configuration |
| ----------------- | ----------- | ------------- |
| Server with 64bit Intel AMD architecture | Commodity Hardware | 16GB RAM, 80+ GB Hard disk with 1 network card. |

### 2.2 Software Requirements

| Category | Software version |
| -------- | ---------------- |
| Operating System | Ubuntu 16.04 and Ubuntu 18.04 |
| Programming Language | Python 2.7.x |
| Framework |  Kubernetes v1.12.0 - Kubernetes v1.18.6 |

### 2.3 Network Requirements

- At least one network interface cards required in all the node machines
- All servers should use the same naming scheme for ethernet ports. If ports on of the servers are named as eno1, eno2 etc. then ports on other servers should be named as eno1, eno2 etc.
- All host machines and the Management node should have access to the same networks where one must be routed to the Internet.
- Management node shall have http/https and ftp proxy if node is behind corporate firewall.

## 3 Deployment View and Configurations

Project SNAPS-Kubernetes is a Python based framework leveraging
Ansible playbooks, Kubespray and a workflow Engine. To provision your
baremetal host, it is recommended but not required to leverage SNAPS-Boot.

![Deployment and Configuration Overview](https://raw.githubusercontent.com/wiki/cablelabs/snaps-kubernetes/images/install-deploy-config-overview-1.png?token=Al5dreR4VK2dsb7h6D5beMZmWnkZpNNNks5bTmfhwA%3D%3D)

![Deployment and Configuration Workflow](https://raw.githubusercontent.com/wiki/cablelabs/snaps-kubernetes/images/install-deploy-config-workflow-1.png?token=Al5drVkAVPNQfJcPFNezfl1WIVYoJLbAks5bTme3wA%3D%3D)

SNAPS-Kubernetes executes on a server that is responsible for deploying
the control and compute services on servers running Ubuntu. The
two stage deployment is outlined below.

1. Provision nodes with Ubuntu and configure network (see snaps-boot <https://github.com/cablelabs/snaps-boot>)
1. Build server setup (SNAPS-Kubernetes)
    1. Install prerequisites
        1. Software requirements
            1. Node requirements : SSH keyed to cluster nodes
            1. apt install python
            1. apt install git
            1. apt install python-pip
        1. Clone SNAPS-Kubernetes:
            <https://github.com/cablelabs/snaps-kubernetes.git>
        1. Install requirements-git.txt:
            <https://github.com/cablelabs/snaps-kubernetes/blob/master/requirements-git.txt>
        1. Install SNAPS-Kubernetes
        1. Deploy K8s

## 4 Kubernetes Cluster Deployment

User is required to prepare a configuration file that should look like
<https://github.com/cablelabs/snaps-kubernetes/blob/master/snaps_k8s/k8s-deploy.yaml>
and the file's location will become the -f argument to the Python main
iaas_launch.py. Please see configuration parameters descriptions below.

### 4.1 Project Configuration

*Required:* Yes

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| Project_name | Y | Project name of the project (E.g. My_project). Using different project name user can install multiple cluster with same SNAPS-Kubernetes folder on different host machines.
| kubespray_url | N | The kubespray git repository URL (default: [kubernetes-sigs]('https://github.com/kubernetes-sigs/kubespray.git'). [CableLabs fork]('https://github.com/cablelabs/kubespray.git') is also known to work).
| kubespray_branch | N | The kubespray version or hash.
| version | Y | Kubernetes version (E.g. v1.18.6) |
| enable_metrics_server | N | Flag used to enable or disable Metric server. Value: True/False (Default: False) |
| enable_helm | N | Flag used to install Helm. Value: True/False (Default: False) |
| Exclusive_CPU_alloc_support | N | Should Cluster enforce exclusive CPU allocation. Value: True/False ***Currently not working*** |
| secrets | N | List of credentials for creating Kubernetes secrets used for pulling secure containers.  See attributes below|
| enable_logging | N | Should Cluster enforce logging. Value: True/False |
| log_level | N | Log level(fatal/error/warn/info/debug/trace) |
| logging_port | N | Logging Port (e.g. 30011) |
| node_user | N | The nodes' passwordless sudo user (default: root) |
| api_host | N | The IP of a master host IP value of the last NIC as that is the one where kubespray places it's certificate (Default: first master host node's IP value)|

### 4.2 Basic Authentication

Parameters specified here are used to define access control mechanism for the
cluster, currently only basic http authentication is supported.

*Required:* Yes

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| user_name | N | User name to access the cluster |
| user_password | N | User password to access the host machine |
| user_id | N | User id to access the cluster |

Define this set of parameters for each user, required to access the cluster.

### 4.3 Node Configuration

Parameters defined here specify the cluster nodes, their roles, ssh access
credential and registry access. This will come under tag node_configuration.

*Required:* Yes

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
    <td>User id to access the root user of the host machine</td>
  </tr>
</table>

### 4.4 Docker Repository

Parameters defined here controls the deployment of private docker repository for
the cluster.

*Required:* Yes

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| Ip | N | Severe IP to host private Docker repository |
| Port | N | Define the registry Port. Example: - “4000” |
| password | N | Password of docker machine. Example: - ChangeMe |
| User | N | User id to access the host machine. |

### 4.5 Proxies

Parameters defined here specifies the proxies to be used for internet access.

*Required:* Yes

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| ftp_proxy | Y | Proxy to be used for FTP. (For no proxy: give value as “”) |
| http_proxy | Y | Proxy to be used for HTTP traffic. (For no proxy: give value as “”) |
| https_proxy | Y | Proxy to be used for HTTPS traffic. (For no proxy: give value as “”) |
| no_proxy | N | Comma separated list of IPs of all host machines. Localhost 127.0.0.1 should be included here. |

### 4.6 Kubespray Proxies

Parameters defined here specifies the proxies to be used for internet access
on the nodes being imaged by kubespray which can be different from 4.5 Proxies
above depending on your networking.

Defaults to 4.5 Proxies value if not set

*Required:* No

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| http_proxy | Y | Proxy to be used for HTTP traffic. (For no proxy: give value as “”) |
| https_proxy | Y | Proxy to be used for HTTPS traffic. (For no proxy: give value as “”) |

### 4.7 Persistent Volume

SNAPS-Kubernetes supports 3 approaches to provide storage to container
workloads.

- Ceph
- HostPath
- Rook - A cloud native implementation of Ceph

#### Ceph Volume

***Note: Ceph support is currently broken an may be removed in the near future***

Parameters specified here control the installation of CEPH process on cluster
nodes. These nodes define a CEPH cluster and storage to PODs is provided from
this cluster. SNAPS-Kubernetes creates a PV and PVC for each set of
claims_parameters, which can later be consumed by application pods.

*Required:* No

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

#### Host Volume

Parameters specified here are used to define PVC and PV for HostPath volume
type. SNAPS-Kubernetes creates a PV and PVC for each set of claim_parameters,
which can later be consumed by application pods.

*Required:* Yes

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

#### Rook Volume

Parameters specified here are used to define PV for a Rook volume.
SNAPS-Kubernetes creates a PV for each volume configured
which can later be consumed by application pods.

*Required:* No

<table>
  <tr>
    <th colspan="3">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="4">Rook_Volume</td>
    <td>no</td>
    <td>User can define multiple volumes under this section</td>
  </tr>
</table>

Rook_Volume Dictionary List keys

<table>
  <tr>
    <th colspan="3">Parameter</th>
    <th>Optionality</th>
    <th>Description</th>
  </tr>
  <tr>
    <td colspan="3">name</td>
    <td>no</td>
    <td>PV name (cannot contain '_' or special characters {'-' ok})</td>
  </tr>
  <tr>
    <td colspan="3">size</td>
    <td>no</td>
    <td>The volume size in GB</td>
  </tr>
  <tr>
    <td colspan="3">path</td>
    <td>no</td>
    <td>The host_path value</td>
  </tr>
</table>

### 4.8 Networks

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

#### Default Networks

Parameters defined here specifies the default networking solution for the
cluster.

SNAPS-Kubernetes install the CNI plugin for the network type defined by
parameter `networking_plugin` and creates a network to be consumed by Kubernetes
pods. User can either choose weave, flannel or calico for default networking
solution.

*Required:* Yes

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| networking_plugin | N | Network plugin to be used for default networking. Allowed values are weave, contiv, flannel, calico, cilium (*** does not work***) |
| service_subnet | N | Subnet to be used for Kubernetes service deployments (E.g. 10.241.0.0/18) |
| pod_subnet | N | Subnet for pods networking (E.g. 10.241.64.0/18) |
| network_name | N | Default network to be created by SNAPS-Kubernetes. Note: The name should not contain any Capital letter and “_”. |
| isMaster | N | The default route will point to the primary network. One of the plugin acts as a “Master” plugin and responsible for configuring k8s network with Pod interface “eth0” “isMaster should be True for one plugin.” Value: true/false |

#### Multus Networks

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

#### CNI

List of network providers to be used under Multus. User can define any
combination of weave, flannel, SRIOV, Macvlan and DHCP.

##### CNI Configuration

Parameters defined are specifies the network subnet, gateway, range and other
network intrinsic parameters.

> **Note:** User must provide configuration parameters for each network provider specified under CNI tag (mentioned above).

#### Flannel

***Flannel is currently broken and may comprimise the integrity of your cluster***

Define this section when Flannel is included under Multus.

*Required:* Yes

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

#### Weave

***Weave is currently broken and may comprimise the integrity of your cluster***

Define this section when Weave is included under Multus.

*Required:* Yes

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

#### DHCP

No configuration required. When DHCP CNI is given, SNAPS-Kubernetes configures
DHCP services on each node and facilitate dynamic IP allocation via external
DHCP server.

#### Macvlan

***This CNI option is being exercied and validated in CI***

Define this section when Macvlan is included under Multus.

User should define these set of parameters for each host where Macvlan network is to be created.

*Required:* Yes

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

#### SRIOV

***SRIOV is currently untested and should be used with caution***

Define this section when SRIOV is included under Multus.

*Required:* Yes

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

#### "secrets" list attributes

| Parameter | Required | Description |
| --------- | -------- | ----------- |
| name | Y | The secret name |
| server | N | The server from which to obtain the image (default: https://index.docker.io/v1/) |
| user | Y | The username |
| password | Y | The password |
| email | Y | The email address |

## 5 Installation Steps

### 5.1 Kubernetes Cluster Deployment

#### 5.1.1 Obtain snaps-kubernetes

Clone snaps-kubernetes:
```Shell
git clone https://github.com/cablelabs/snaps-kubernetes
```

#### 5.1.2 Configuration

Go to directory `{git directory}/snaps-kubernetes/snaps_k8s`

Modify file `k8s-deploy.yaml` for provisioning of Kubernetes nodes on cloud
cluster host machines (Master/etcd and minion). Modify this file according to
your set up environment. Refer to section 3.3.

#### 5.1.3 Installation

Ensure build server has python 2.7 and python-pip installed and the user account executing iaas_launch.py must has passwordless sudo access on the build server and must has their ~/.ssh/id_rsa.pub injected into the 'root' user of each host machine.

Setup the python runtime (note: it is recommended to leverage a virtual
python runtime especially if the build server also performs functions
other than simply executing snaps-kubernetes):

```Shell
pip install -r {path_to_repo}/requirements-git.txt
pip install -e {path_to_repo}
```

Ensure all host machines must have python and SSH installed, which should
be already completed if using snaps-boot to perform the initial setup.
(i.e. apt-get install -y python python-pip)

Run `iaas_launch.py` as shown below:

```Shell
python {path_to_repo}/iaas_launch.py -f {absolute or relative path}/k8s-deploy.yaml -k8_d
```

This will install Kubernetes service on host machines. The Kubernetes
installation will start and will get completed in ~60 minutes.

> Note: if installation fails due to Error “FAILED - RETRYING: container_download | Download containers if pull is required or told to always pull (all nodes) (4 retries left).” please check your internet connection.

Kubectl service will also be installed on bootstrap node.

After cluster installation, if user needs to run kubectl command on bootstrap
node, please run:

```Shell
export KUBECONFIG={project artifact dir}/node-kubeconfig.yaml
```

### 5.2 Cleanup Kubernetes Cluster

Use these steps to clean an existing cluster.

Go to directory  `~/snaps-kubernetes`

Clean up previous Kubernetes deployment:

```Shell
python iaas_launch.py -f snaps_k8s/k8s-deploy.yaml -k8_c
```
