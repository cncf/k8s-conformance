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
- Ubuntu 22.04 (or other OS supported by [minione](https://github.com/OpenNebula/minione#requirements))

#### OpenNebula installation

For our example we will go with **Ubuntu 22.04** and we set the hostname to `opennebula-server` - to distinguish commands run on the opennebula-server from those run inside the appliance VMs.

The installation will be done via an easy-to-use OpenNebula's bash installer called [minione](https://github.com/OpenNebula/minione).

Let's download `minione`:

```
root@opennebula-server:~# curl -fLO https://github.com/OpenNebula/minione/releases/latest/download/minione
```

Now we can install OpenNebula server - this will take a couple of minutes:

```
root@opennebula-server:~# bash minione --version 6.8.0 --yes --password k8s-test --marketapp-name 'Service OneKE 1.29'
```

The installation (if successful) should at the end print out useful report like this:

```
### Report
OpenNebula 6.8.0 was installed
Sunstone is running on:
  http://<IPv4>/
FireEdge is running on:
  http://<IPv4>:2616/
Use following to login:
  user: oneadmin
  password: k8s-test
```

Previous command already downloaded the Kubernetes appliance from the OpenNebula marketplace and configured oneadmin's password (which we can use to login into the web interface called Sunstone). For more information you can take a look at the [documentation](https://docs.opennebula.io/minione/simple/validation.html).

OpenNebula server node should be ready by now and so we can open the URL of the Sunstone in a browser: `http://opennebula-server`

Or verify the host with the `onehost` command:

```
root@opennebula-server:~# onehost list
  ID NAME                                 CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   0 localhost                            default      0      0 / 1600 (0%)    0K / 31.2G (0%) on
```

### Deploy OneKE

The `sonobuoy` conformance test suite requires at least 2-node kubernetes cluster. By default the Kubernetes appliance deploys 4 roles:

- vnf: 1 VM that implement a load-balancer (HAProxy) for the Control-Plane
- master: 1 VM where master node is located (tainted with `CriticalAddonsOnly=true:NoExecute`)
- worker: 1 VM to act as regular worker nodes (can be scaled up if more nodes are required)
- storage: 0 VM dedicated for Longhorn replicas (tainted with `node.longhorn.io/create-default-disk=true:NoSchedule`)

After scaling the **worker** role to 2 nodes and the **storage** role to 1 node, this setup should satisfy the `sonobuoy` requirement, with the caveat that both mentioned taints have to be treated as "non-blocking".

#### Deploy Kubernetes

At this point the `Service OneKE 1.29` appliance has already been downloaded into the OpenNebula instance along with VM templates and images:

```
root@opennebula-server:~# oneflow-template list
  ID USER     GROUP    NAME                                                                 REGTIME
   0 oneadmin oneadmin Service OneKE 1.29                                            05/13 14:53:42
```
```
root@opennebula-server:~# onetemplate list
  ID USER     GROUP    NAME                                                                 REGTIME
   2 oneadmin oneadmin Service OneKE 1.29-storage-2                                  05/13 14:53:42
   1 oneadmin oneadmin Service OneKE 1.29-master-1                                   05/13 14:53:42
   0 oneadmin oneadmin Service OneKE 1.29-vnf-0                                      05/13 14:53:42
```
```
root@opennebula-server:~# oneimage list
  ID USER     GROUP    NAME                                          DATASTORE     SIZE TYPE PER STAT RVMS
   3 oneadmin oneadmin Service OneKE 1.29-storage-2-189df81475-1     default        10G OS    No rdy     0
   2 oneadmin oneadmin Service OneKE 1.29-storage-2-0d4a373747-0     default        25G OS    No rdy     0
   1 oneadmin oneadmin Service OneKE 1.29-master-1-9fe7fc8517-0      default        25G OS    No rdy     0
   0 oneadmin oneadmin Service OneKE 1.29-vnf-0                      default         2G OS    No rdy     0
```

Everything is in place to deploy the Kubernetes cluster based on the new service template `Service OneKE 1.29`:

```
root@opennebula-server:~# oneflow-template instantiate 'Service OneKE 1.29' <<'EOF'
{
    "name": "OneKE/1",
    "networks_values": [
        {"Public": {"id": "0"}},
        {"Private": {"id": "0"}}
    ],
    "custom_attrs_values": {
        "ONEAPP_VROUTER_ETH0_VIP0": "",
        "ONEAPP_VROUTER_ETH1_VIP0": "",

        "ONEAPP_RKE2_SUPERVISOR_EP": "ep0.eth0.vr:9345",
        "ONEAPP_K8S_CONTROL_PLANE_EP": "ep0.eth0.vr:6443",
        "ONEAPP_K8S_EXTRA_SANS": "localhost,127.0.0.1,ep0.eth0.vr,\${vnf.TEMPLATE.CONTEXT.ETH0_IP}",

        "ONEAPP_K8S_MULTUS_ENABLED": "YES",
        "ONEAPP_K8S_MULTUS_CONFIG": "",

        "ONEAPP_K8S_CNI_PLUGIN": "canal",
        "ONEAPP_K8S_CNI_CONFIG": "",
        "ONEAPP_K8S_CILIUM_RANGE": "",

        "ONEAPP_K8S_METALLB_ENABLED": "YES",
        "ONEAPP_K8S_METALLB_CONFIG": "",
        "ONEAPP_K8S_METALLB_RANGE": "",

        "ONEAPP_K8S_LONGHORN_ENABLED": "YES",
        "ONEAPP_STORAGE_DEVICE": "/dev/vdb",
        "ONEAPP_STORAGE_FILESYSTEM": "xfs",

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
  ID USER     GROUP    NAME                                  STARTTIME STAT
   1 oneadmin oneadmin OneKE/1                          05/13 15:00:03 RUNNING
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
NAME                    STATUS   ROLES                       AGE     VERSION          INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
oneke-ip-172-16-100-4   Ready    control-plane,etcd,master   19m     v1.29.4+rke2r1   172.16.100.4   <none>        Ubuntu 22.04.4 LTS   5.15.0-105-generic   containerd://1.7.11-k3s2
oneke-ip-172-16-100-5   Ready    <none>                      18m     v1.29.4+rke2r1   172.16.100.5   <none>        Ubuntu 22.04.4 LTS   5.15.0-105-generic   containerd://1.7.11-k3s2
oneke-ip-172-16-100-6   Ready    <none>                      13m     v1.29.4+rke2r1   172.16.100.6   <none>        Ubuntu 22.04.4 LTS   5.15.0-105-generic   containerd://1.7.11-k3s2
oneke-ip-172-16-100-7   Ready    <none>                      8m44s   v1.29.4+rke2r1   172.16.100.7   <none>        Ubuntu 22.04.4 LTS   5.15.0-105-generic   containerd://1.7.11-k3s2
```

The rest of this document follows instructions from the `sonobuoy` test suite (found here: [instructions.md](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)).

1. Download and extract **sonobuoy**:

    ```
    root@opennebula-server:~# curl -fsSL https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz | tar -xzf- sonobuoy
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
            e2e   complete                1
   systemd-logs   complete                4

Sonobuoy plugins have completed. Preparing results for download.
```

We will do as is hinted:

```
root@opennebula-server:~# outfile=$(./sonobuoy retrieve)
root@opennebula-server:~# cp -a "$outfile" sonobuoy.tar.gz
```

Files `e2e.log` and `junit_01.xml` have been included.
