# OpenNebula Kubernetes Engine (OneKE) CE/EE

**NOTE**:
> At the time of preparing this document there are no functional differences between CE and EE versions other than preloaded docker images used for airgapped installation purposes.

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
root@opennebula-server:~# bash minione --version 6.6.0 --yes --password k8s-test --marketapp-name 'Service OneKE 1.27 CE'
```

The installation (if successful) should at the end print out useful report like this:

```
### Report
OpenNebula 6.6.0 was installed
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
- storage: 1 VM dedicated for Longhorn replicas (tainted with `node.longhorn.io/create-default-disk=true:NoSchedule`)

After scaling the worker role to 2 nodes this setup should satisfy the `sonobuoy` requirement, with the caveat that both mentioned taints have to be treated as "non-blocking".

#### Deploy Kubernetes

At this point the `Service OneKE 1.27 CE` appliance has already been downloaded into the OpenNebula instance along with VM templates and images:

```
root@opennebula-server:~# oneflow-template list
  ID USER     GROUP    NAME                                                                 REGTIME
   0 oneadmin oneadmin Service OneKE 1.27 CE                                         05/12 10:11:47
```
```
root@opennebula-server:~# onetemplate list
  ID USER     GROUP    NAME                                                                 REGTIME
   2 oneadmin oneadmin Service OneKE 1.27 CE-storage-2                               05/12 10:11:47
   1 oneadmin oneadmin Service OneKE 1.27 CE-master-1                                05/12 10:11:47
   0 oneadmin oneadmin Service OneKE 1.27 CE-vnf-0                                   05/12 10:11:47
```
```
root@opennebula-server:~# oneimage list
  ID USER     GROUP    NAME                                          DATASTORE     SIZE TYPE PER STAT RVMS
   3 oneadmin oneadmin Service OneKE 1.27 CE-storage-2-b0d01b0dd4-1  default        10G OS    No rdy     0
   2 oneadmin oneadmin Service OneKE 1.27 CE-storage-2-eae8ed83cd-0  default        20G OS    No rdy     0
   1 oneadmin oneadmin Service OneKE 1.27 CE-master-1-27193ce849-0   default        20G OS    No rdy     0
   0 oneadmin oneadmin Service OneKE 1.27 CE-vnf-0                   default         2G OS    No rdy     0
```

Everything is in place to deploy the Kubernetes cluster based on the new service template `Service OneKE 1.27 CE`:

```
root@opennebula-server:~# cat >/tmp/OneKE-instantiate <<'EOF'
{
    "name": "OneKE/1",
    "networks_values": [
        {"Public": {"id": "0"}},
        {"Private": {"id": "0"}}
    ],
    "custom_attrs_values": {
        "ONEAPP_VROUTER_ETH0_VIP0": "172.16.100.254",
        "ONEAPP_VROUTER_ETH1_VIP0": "",
        "ONEAPP_K8S_EXTRA_SANS": "localhost,127.0.0.1",
        "ONEAPP_K8S_LOADBALANCER_RANGE": "",
        "ONEAPP_K8S_LOADBALANCER_CONFIG": "",
        "ONEAPP_STORAGE_DEVICE": "/dev/vdb",
        "ONEAPP_STORAGE_FILESYSTEM": "xfs",
        "ONEAPP_VNF_NAT4_ENABLED": "NO",
        "ONEAPP_VNF_NAT4_INTERFACES_OUT": "eth0",
        "ONEAPP_VNF_ROUTER4_ENABLED": "YES",
        "ONEAPP_VNF_ROUTER4_INTERFACES": "eth0,eth1",
        "ONEAPP_VNF_HAPROXY_INTERFACES": "eth0",
        "ONEAPP_VNF_HAPROXY_REFRESH_RATE": "30",
        "ONEAPP_VNF_HAPROXY_CONFIG": "",
        "ONEAPP_VNF_HAPROXY_LB2_PORT": "443",
        "ONEAPP_VNF_HAPROXY_LB3_PORT": "80",
        "ONEAPP_VNF_KEEPALIVED_VRID": "1"
    }
}
EOF
root@opennebula-server:~# oneflow-template instantiate 'Service OneKE 1.27 CE' /tmp/OneKE-instantiate
ID: 1
```

This will take another couple of minutes before all the nodes are up and ready - we can check the status with this command:

```
root@opennebula-server:~# oneflow list
  ID USER     GROUP    NAME                                  STARTTIME STAT
   1 oneadmin oneadmin OneKE/1                          05/12 10:22:00 RUNNING
```

When the column `STAT` is showing `RUNNING` we can scale the `worker` role to 2 nodes:

```
root@opennebula-server:~# oneflow scale 'OneKE/1' worker 2
```

Let's wait until:

```
root@opennebula-server:~# oneflow show 'OneKE/1' --json | jq -r '.DOCUMENT.TEMPLATE.BODY.log[-1].message'
New state: RUNNING
```

We can now try to ssh login into the master kubernetes node. To find the name of the first master node we can execute:

```
root@opennebula-server:~# oneflow show 'OneKE/1' --json | jq -r '.DOCUMENT.TEMPLATE.BODY.roles[]|select(.name=="master").nodes[0].vm_info.VM.NAME'
master_0_(service_1)
```

To obtain the IPv4 address of the first master node:

```
root@opennebula-server:~# onevm show 'master_0_(service_1)' --json | jq -r '.VM.TEMPLATE.NIC[0].IP'
172.16.100.4
```

To download the `/etc/rancher/rke2/rke2.yaml` file:

```
root@opennebula-server:~# install -d ~/.kube/ && scp root@172.16.100.4:/etc/rancher/rke2/rke2.yaml ~/.kube/config
Warning: Permanently added '172.16.100.4' (ECDSA) to the list of known hosts.
rke2.yaml                                         100% 2981     2.1MB/s   00:00
```

Finally, let's edit the `server:` endpoint (use the `ONEAPP_VROUTER_ETH0_VIP0` IPv4 address):

```
root@opennebula-server:~# gawk -i inplace -f- ~/.kube/config <<'EOF'
/^    server: / { $0 = "    server: https://172.16.100.254:6443" }
{ print }
EOF
```

#### Run conformance tests

Let's start with checking if `kubectl` works:

```
root@opennebula-server:~# kubectl get nodes -o wide
NAME                      STATUS   ROLES                       AGE     VERSION          INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
onekube-ip-172-16-100-4   Ready    control-plane,etcd,master   17m     v1.27.1+rke2r1   172.16.100.4   <none>        Ubuntu 22.04.2 LTS   5.15.0-71-generic   containerd://1.6.19-k3s1
onekube-ip-172-16-100-5   Ready    <none>                      15m     v1.27.1+rke2r1   172.16.100.5   <none>        Ubuntu 22.04.2 LTS   5.15.0-71-generic   containerd://1.6.19-k3s1
onekube-ip-172-16-100-6   Ready    <none>                      15m     v1.27.1+rke2r1   172.16.100.6   <none>        Ubuntu 22.04.2 LTS   5.15.0-71-generic   containerd://1.6.19-k3s1
onekube-ip-172-16-100-7   Ready    <none>                      8m22s   v1.27.1+rke2r1   172.16.100.7   <none>        Ubuntu 22.04.2 LTS   5.15.0-71-generic   containerd://1.6.19-k3s1
```

The rest of this document follows instructions from the `sonobuoy` test suite (found here: [instructions.md](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)).

1. Download and extract **sonobuoy**:

    ```
    root@opennebula-server:~# curl -fsSL https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.16/sonobuoy_0.56.16_linux_amd64.tar.gz | tar -xzf- sonobuoy
    ```

1. Run tests:

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

Content of the test is in the exported archive `sonobuoy.tar.gz`.
