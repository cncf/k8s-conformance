[//]: # ( vim: set wrap : )

# OpenNebula Kubernetes Engine (OneKE)

## Instructions for the deployment and verifying the conformance tests

### Setup a server node

We will need just one server node to verify the results. This node should be powerful enough to be able to run up to 4 Kubernetes nodes as virtual machines.

**NOTE**:
> You can run this node machine as VM itself if you configure the nested virtualization.

#### Recommended specification

- 9+ (v)CPU
- 12+ GB RAM
- 200+ GB disk space
- 1 NIC with an access to the internet and a default route
- Ubuntu 22.04 (or any other [platform supported](https://github.com/OpenNebula/one-deploy/wiki/sys_reqs#platform-notes))

#### OpenNebula installation

For installing OpenNebula, we're going to use our ansible one-deploy scripts. Please, check our [documentation](https://github.com/OpenNebula/one-deploy/wiki/sys_reqs#requirements)
for downloading the `one-deploy` repository and installing all requirements before following the instructions below.
We can install the repo and ansible in our local machine or in the server that we are going to execute the tests.
For our example we will go with **Ubuntu 22.04** and create a server with hostname `opennebula-server`- to distinguish commands run on the opennebula-server
(OpenNebula frontend) from those run inside the appliance VMs.

In summary, for installing the requirements using poetry and load the virtual environment, you can execute the following commands in Ubuntu 22.04:
```
root@laptop$ git clone https://github.com/OpenNebula/one-deploy.git
root@laptop$ apt install pipx make
root@laptop$ pipx install hatch
root@laptop$ pipx ensurepath
root@laptop$ source ~/.bashrc
root@laptop$ cd ./one-deploy/ && make requirements
root@laptop$ hatch shell
```

Once we have cloned the `one-deploy` repo and installed all the requeriments following the instructions above, create an inventory file `one-deploy/inventory/oneke-test.yml` with the following content:
```
---
all:
  vars:
    ansible_user: root
    ensure_keys_for: [root]
    one_pass: Pa$$w0rd
    one_version: '7.0'
    gate_endpoint: "http://192.168.150.1:5030"
    ds: { mode: ssh }
    vn:
      public:
        managed: true
        template:
          VN_MAD: bridge
          BRIDGE: br0
          AR:
            TYPE: IP4
            IP: 192.168.150.100
            SIZE: 100
          NETWORK_ADDRESS: 192.168.150.0
          NETWORK_MASK: 255.255.255.0
          GATEWAY: 192.168.150.1
          DNS: 1.1.1.1
      private:
        managed: true
        template:
          VN_MAD: bridge
          BRIDGE: br1
          AR:
            TYPE: IP4
            IP: 192.168.200.100
            SIZE: 100
          NETWORK_ADDRESS: 192.168.200.0
          NETWORK_MASK: 255.255.255.0
          GATEWAY: 192.168.200.1
          DNS: 1.1.1.1

frontend:
  hosts:
    one: { ansible_host: "{{ public_ipv4 }}" }

node:
  hosts:
    kvm: { ansible_host: "{{ public_ipv4 }}" }
```

Then, from the `one-deploy` repository root, execute the OpenNebula installation through ansible through this command (if you are using poetry, remember to execute `poetry shell` before):
```
root@laptop$ ansible-playbook -v -i ./inventory/oneke-test.yml -e public_ipv4=<frontend_public_ip> opennebula.deploy.main
```
where `<frontend_public_ip>` should contain the hostname or address of the host where you want to install OpenNebula frontend (what we reference as `opennebula-server`. **Remember that you must have ssh access to that host with the current user in order to execute ansible**.
If you are installing OpenNebula locally, and want to execute the ansible playbook against localhost, you can use the argument `--connection=local` for installing OpenNebula locally, e.g.:
```
root@laptop$ ansible-playbook -v --connection=local -i ./inventory/oneke-test.yml -e public_ipv4=localhost opennebula.deploy.main
```

Previous command already downloaded and configured the OpenNebula frontend in the `opennebula-server` machine. You should be able to log into Sunstone through the url `http://<opennebula-server>:2616`, logging in as `oneadmin` user and setting the password you set in the inventory file (in the `one_pass` parameter).

You can also verify the host with the `onehost` command:

```
root@opennebula-server:~# onehost list
  ID NAME                                 CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   0 localhost                            default      0      0 / 1600 (0%)    0K / 31.2G (0%) on
```

For more information about how to fully verify the OpenNebula installation you can take a look at the [documentation](https://github.com/OpenNebula/one-deploy/wiki/sys_verify).

### Deploy OneKE

The `sonobuoy` conformance test suite requires at least 2-node kubernetes cluster. By default the Kubernetes appliance deploys 4 roles:

- vnf: 1 VM that implement a load-balancer (HAProxy) for the Control-Plane
- master: 1 VM where master node is located (tainted with `CriticalAddonsOnly=true:NoExecute`)
- worker: 1 VM to act as regular worker nodes (can be scaled up if more nodes are required)
- storage: 0 VM dedicated for Longhorn replicas (tainted with `node.longhorn.io/create-default-disk=true:NoSchedule`)

After scaling the **worker** role to 2 nodes and the **storage** role to 1 node (we will explain how to do that later), this setup should satisfy the `sonobuoy` requirement, with the caveat that both mentioned taints have to be treated as "non-blocking".

#### Deploy Kubernetes

First of all, we need to download the Kubernetes appliance (OneKE) from the OpenNebula marketplace:
```
root@opennebula-server:~# onemarketapp export 'Service OneKE 1.33' 'Service OneKE 1.33' -d 1
IMAGE
    ID: 0
    ID: 1
    ID: 2
VMTEMPLATE
    ID: 0
    ID: 1
    ID: 2
SERVICE_TEMPLATE
    ID: 0
```

At this point the `Service OneKE 1.33` appliance has already been downloaded into the OpenNebula instance along with VM templates and images:

```
root@opennebula-server:~# oneflow-template list
  ID USER     GROUP    NAME                                                                 REGTIME
   0 oneadmin oneadmin Service OneKE 1.33                                            09/09 20:42:47
```
```
root@opennebula-server:~# onetemplate list
  ID USER     GROUP    NAME                                                                 REGTIME
   2 oneadmin oneadmin Service OneKE 1.33-storage-2                                  09/09 20:42:46
   1 oneadmin oneadmin Service OneKE 1.33-master-1                                   09/09 20:42:46
   0 oneadmin oneadmin Service OneKE 1.33-vnf-0                                      09/09 20:42:46
```
```
root@opennebula-server:~# oneimage list
  ID USER     GROUP    NAME                                               DATASTORE     SIZE TYPE PER STAT RVMS
   3 oneadmin oneadmin Service OneKE 1.33-storage-2-d301e88349-1          default        10G OS    No rdy     0
   2 oneadmin oneadmin Service OneKE 1.33-storage-2-1c8cccfef4-0          default        25G OS    No rdy     0
   1 oneadmin oneadmin Service OneKE 1.33-master-1-a68fb04ee9-0           default        25G OS    No rdy     0
   0 oneadmin oneadmin Service OneKE 1.33-vnf-0                           default         2G OS    No rdy     0
```

Everything is in place to deploy the Kubernetes cluster based on the new service template `Service OneKE 1.33`:

```
root@opennebula-server:~# oneflow-template instantiate 'Service OneKE 1.33' <<EOF
{
    "name": "OneKE/1",
    "networks_values": [
        {"Public": {"id": "0"}},
        {"Private": {"id": "0"}}
    ],
    "user_inputs_values": {
        "ONEAPP_VROUTER_ETH0_VIP0": "",
        "ONEAPP_VROUTER_ETH1_VIP0": "",

        "ONEAPP_RKE2_SUPERVISOR_EP": "ep0.eth0.vr:9345",
        "ONEAPP_K8S_CONTROL_PLANE_EP": "ep0.eth0.vr:6443",
        "ONEAPP_K8S_EXTRA_SANS": "localhost,127.0.0.1,ep0.eth0.vr,\${vnf.TEMPLATE.CONTEXT.ETH0_IP}",

        "ONEAPP_RKE2_CLOUD_CONTROLLER_ENABLED": "YES",

        "ONEAPP_K8S_CLUSTER_CIDR": "",
        "ONEAPP_K8S_SERVICE_CIDR": "",

        "ONEAPP_K8S_HTTP_PROXY": "",
        "ONEAPP_K8S_HTTPS_PROXY": "",
        "ONEAPP_K8S_NO_PROXY": "",

        "ONEAPP_K8S_MULTUS_ENABLED": "YES",
        "ONEAPP_K8S_MULTUS_CONFIG": "",

        "ONEAPP_K8S_CNI_PLUGIN": "canal",
        "ONEAPP_K8S_CNI_CONFIG": "",
        "ONEAPP_K8S_CILIUM_BGP_ENABLED": "",
        "ONEAPP_K8S_CILIUM_RANGE": "",

        "ONEAPP_K8S_METALLB_ENABLED": "YES",
        "ONEAPP_K8S_METALLB_CONFIG": "",
        "ONEAPP_K8S_METALLB_CLASS": "",
        "ONEAPP_K8S_METALLB_RANGE": "",

        "ONEAPP_K8S_LONGHORN_ENABLED": "YES",
        "ONEAPP_K8S_STORAGE_DEVICE": "/dev/vdb",
        "ONEAPP_K8S_STORAGE_FILESYSTEM": "xfs",

        "ONEAPP_K8S_TRAEFIK_ENABLED": "YES",
        "ONEAPP_VNF_HAPROXY_INTERFACES": "eth0",
        "ONEAPP_VNF_HAPROXY_REFRESH_RATE": "30",
        "ONEAPP_VNF_HAPROXY_LB0_PORT": "9345",
        "ONEAPP_VNF_HAPROXY_LB1_PORT": "6443",
        "ONEAPP_VNF_HAPROXY_LB2_PORT": "443",
        "ONEAPP_VNF_HAPROXY_LB3_PORT": "80",

        "ONEAPP_VNF_DNS_ENABLED": "YES",
        "ONEAPP_VNF_DNS_INTERFACES": "eth1",
        "ONEAPP_VNF_DNS_NAMESERVERS": "1.1.1.1,8.8.8.8",
        "ONEAPP_VNF_NAT4_ENABLED": "YES",
        "ONEAPP_VNF_NAT4_INTERFACES_OUT": "eth0",
        "ONEAPP_VNF_ROUTER4_ENABLED": "YES",
        "ONEAPP_VNF_ROUTER4_INTERFACES": "eth0,eth1"
    }
}
EOF
ID: 1
```

This will take another couple of minutes before all the nodes are up and ready - we can check the status with this command:

```
root@opennebula-server:~# oneflow list
  ID USER     GROUP    NAME                                  STARTTIME      STAT
   1 oneadmin oneadmin OneKE/1                               09/09 20:46:36 RUNNING
```

When the column `STAT` is showing `RUNNING` we can scale the **storage** role to at least 1 node:

```
root@opennebula-server:~# oneflow scale 'OneKE/1' storage 1
```
Let's wait until:
```
root@opennebula-server:~# oneflow show 'OneKE/1' --json | jq -r '.DOCUMENT.TEMPLATE.BODY.log[-1].message'
New state: RUNNING
```

When the column `STAT` is showing `RUNNING` we can scale the **worker** role to 2 nodes:

```
root@opennebula-server:~# oneflow scale 'OneKE/1' worker 2
```
Let's wait until:
```
root@opennebula-server:~# oneflow show 'OneKE/1' --json | jq -r '.DOCUMENT.TEMPLATE.BODY.log[-1].message'
New state: RUNNING
```

To find the name of the first master node we can execute:

```
root@opennebula-server:~# oneflow show 'OneKE/1' --json | jq -r '.DOCUMENT.TEMPLATE.BODY.roles[]|select(.name=="master").nodes[0].vm_info.VM.NAME'
master_0_(service_1)
```

To download the kubeconfig file:

```
root@opennebula-server:~# onevm show 'master_0_(service_1)' -j | jq -r '.VM.USER_TEMPLATE.ONEKE_KUBECONFIG|@base64d' | install -m u=rw,go= -D /dev/fd/0 ~/.kube/config
```

#### Run conformance tests

Let's start with checking if `kubectl` works:

```
root@opennebula-server:~# kubectl get nodes -o wide
NAME                       STATUS   ROLES                       AGE     VERSION          INTERNAL-IP       EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
oneke-ip-192-168-150-102   Ready    control-plane,etcd,master   12m     v1.33.4+rke2r1   192.168.150.102   <none>        Ubuntu 22.04.5 LTS   5.15.0-126-generic   containerd://2.0.5-k3s2
oneke-ip-192-168-150-103   Ready    <none>                      11m     v1.33.4+rke2r1   192.168.150.103   <none>        Ubuntu 22.04.5 LTS   5.15.0-126-generic   containerd://2.0.5-k3s2
oneke-ip-192-168-150-104   Ready    <none>                      9m47s   v1.33.4+rke2r1   192.168.150.104   <none>        Ubuntu 22.04.5 LTS   5.15.0-126-generic   containerd://2.0.5-k3s2
oneke-ip-192-168-150-105   Ready    <none>                      4m10s   v1.33.4+rke2r1   192.168.150.105   <none>        Ubuntu 22.04.5 LTS   5.15.0-126-generic   containerd://2.0.5-k3s2
```

The rest of this document follows instructions from the `sonobuoy` test suite (found here: [instructions.md](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)).

1. Download and extract **sonobuoy**:

    ```
    root@opennebula-server:~# curl -fsSL https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz | tar -xzf- sonobuoy
    ```

2. Run tests:

    ```
    root@opennebula-server:~# ./sonobuoy run --mode=certified-conformance --plugin-env=e2e.E2E_EXTRA_ARGS='--non-blocking-taints=CriticalAddonsOnly,node.longhorn.io/create-default-disk --ginkgo.v'
    INFO[0000] create request issued                         name=sonobuoy namespace= resource=namespaces
    INFO[0000] create request issued                         name=sonobuoy-serviceaccount namespace=sonobuoy resource=serviceaccounts
    INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterrolebindings
    INFO[0000] create request issued                         name=sonobuoy-serviceaccount-sonobuoy namespace= resource=clusterroles
    INFO[0000] create request issued                         name=sonobuoy-config-cm namespace=sonobuoy resource=configmaps
    INFO[0000] create request issued                         name=sonobuoy-plugins-cm namespace=sonobuoy resource=configmaps
    INFO[0000] create request issued                         name=sonobuoy namespace=sonobuoy resource=pods
    INFO[0000] create request issued                         name=sonobuoy-aggregator namespace=sonobuoy resource=services
    ```

This may take an hour or two to finish - you can monitor the progress with the command:

```
root@opennebula-server:~# ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT   PROGRESS
            e2e    running                1
   systemd-logs   complete                4

Sonobuoy is still running. Runs can take 60 minutes or more depending on cluster and plugin configuration.
```

When test suite is finished the former command will give an output similar to this:

```
root@opennebula-server:~# ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT   PROGRESS
            e2e   complete   passed       1
   systemd-logs   complete   passed       4

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

We will do as is hinted:

```
root@opennebula-server:~# outfile=$(./sonobuoy retrieve)
root@opennebula-server:~# cp -a "$outfile" sonobuoy.tar.gz
```

Finally, we can delete the sonobuoy resources from the cluster with:
```
root@opennebula-server:~# ./sonobuoy delete
```

Files `e2e.log` and `junit_01.xml` have been included.
