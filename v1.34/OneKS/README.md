[//]: # ( vim: set wrap : )

# OpenNebula Elastic Kubernetes Service (OneKS)

## Instructions for the deployment and verifying the conformance tests

### Setup a server node

We will need just one server node to verify the results. This node should be powerful enough to run OpenNebula and host the virtual machines that compose the Kubernetes cluster.

**NOTE**:
> You can run this node machine as a VM itself if you configure the nested virtualization.

#### Recommended specification

- 9+ (v)CPU
- 12+ GB RAM
- 200+ GB disk space
- 1 NIC with access to the internet and a default route
- Ubuntu 22.04 (or any other [platform supported](https://github.com/OpenNebula/one-deploy/wiki/sys_reqs#platform-notes))

#### OpenNebula installation

For installing OpenNebula, we're going to use our ansible one-deploy scripts. Please, check our [documentation](https://github.com/OpenNebula/one-deploy/wiki/sys_reqs#requirements)
for downloading the `one-deploy` repository and installing all requirements before following the instructions below.
We can install the repo and ansible in our local machine or in the server that we are going to execute the tests.
For our example we will go with **Ubuntu 22.04** and create a server with hostname `opennebula-server`- to distinguish commands run on the opennebula-server
(OpenNebula frontend).

In summary, for installing the requirements and load the virtual environment, you can execute the following commands in Ubuntu 22.04:
```
root@laptop$ git clone https://github.com/OpenNebula/one-deploy.git
root@laptop$ apt install pipx make
root@laptop$ pipx install hatch
root@laptop$ pipx ensurepath
root@laptop$ source ~/.bashrc
root@laptop$ cd ./one-deploy/ && make requirements
root@laptop$ hatch shell
```

Once we have cloned the `one-deploy` repo and installed all the requirements following the instructions above, create an inventory file `one-deploy/inventory/oneks-test.yml` with the following content:

**NOTE**:
> OneKS is a feature of the OpenNebula Enterprise Edition. A valid Enterprise Token is required to access the opennebula-ks packages.

```
---
all:
  vars:
    ansible_user: root
    ensure_keys_for: [root]
    one_pass: Pa$$w0rd
    one_version: '7.2'
    one_token: <EE_TOKEN>
    gate_endpoint: "http://169.254.16.9:5030"
    gate_tproxy:
      - :service_port: 5030
        :remote_addr: 192.168.150.1
        :remote_port: 5030
      - :service_port: 2633
        :remote_addr: 192.168.150.1
        :remote_port: 2633
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
Then, from the `one-deploy` repository root, execute the OpenNebula installation using Ansible with the following command:
```
root@laptop$ ansible-playbook -v -i ./inventory/oneks-test.yml -e public_ipv4=<frontend_public_ip> opennebula.deploy.main
```
where `<frontend_public_ip>` should contain the hostname or address of the host where you want to install OpenNebula frontend (what we reference as `opennebula-server`. **Remember that you must have ssh access to that host with the current user in order to execute ansible**.
If you are installing OpenNebula locally, and want to execute the ansible playbook against localhost, you can use the argument `--connection=local` for installing OpenNebula locally, e.g.:
```
root@laptop$ ansible-playbook -v --connection=local -i ./inventory/oneks-test.yml -e public_ipv4=localhost opennebula.deploy.main
```
Previous command already downloaded and configured the OpenNebula frontend in the `opennebula-server` machine. You should be able to log into Sunstone through the url `http://<opennebula-server>:2616`, logging in as `oneadmin` user and setting the password you set in the inventory file (in the `one_pass` parameter).

You can also verify the host with the `onehost` command:

```
root@opennebula-server:~# onehost list
  ID NAME                                 CLUSTER    TVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   0 localhost                            default      0      0 / 900 (0%)    0K / 23.5G (0%) on
```

For more information about how to fully verify the OpenNebula installation you can take a look at the [documentation](https://github.com/OpenNebula/one-deploy/wiki/sys_verify).

### OneKS Configuration

Install and enable OneKS:
```
root@opennebula-server:~# apt-get update && apt-get install -y opennebula-ks

root@opennebula-server:~# systemctl enable opennebula-ks
root@opennebula-server:~# systemctl start opennebula-ks
```

If the public bridge (br0) does not provide direct internet access, configure NAT to allow outbound connectivity for the virtual machines:
```
root@opennebula-server:~# ip addr add 192.168.150.1/24 dev br0
root@opennebula-server:~# sysctl -w net.ipv4.ip_forward=1
root@opennebula-server:~# iptables -t nat -A POSTROUTING -s 192.168.150.0/24 -o eth0 -j MASQUERADE
```

### Kubernetes Cluster Deployment

OneKS provisions Kubernetes clusters on top of OpenNebula VMs, including a virtual router for load balancing, a control plane, and scalable worker nodes.

- Virtual Router: HAProxy-based load balancer for the control plane
- Control Plane: single-node or highly available (3 nodes)
- Workers: scalable node groups for workload execution


The cluster is created with the following configuration:
- Kubernetes version: v1.34.2
- Flavor: Single Control Plane
- Public network: 0
- Private network: 1

Cluster creation is initiated using the OneKS CLI:
```
root@opennebula-server:~# oneks create cluster
> Cluster name: cert-cluster
> Select a Kubernetes version for the Cluster:
    0: v1.33.7
    1: v1.34.2

    Select an option by number: 1
> Select a flavour for the Cluster:
    0: Single-Node Control Plane
       Single Control Plane node deployment.
       Suitable for development, evaluation, and non-critical workloads.
       1 node | 2 CPU | 2 vCPU | 4 GB RAM | 16 GB Storage

    1: Highly Available Control Plane
       Three-node Control Plane deployment with built-in redundancy.
       Suitable for production and other environments that require higher availability.
       3 nodes | 2 CPU | 2 vCPU | 4 GB RAM | 16 GB Storage

    Select an option by number: 0
> Public network ID: 0
> Private network ID: 1

ID: 1
```

During provisioning, cluster progress can be monitored through logs:
```
root@opennebula-server:~# oneks logs cluster 1 -f
Thu May 14 10:10:55 2026 [I] [CLS]: Starting cluster provisioning
Thu May 14 10:10:55 2026 [I] [CLS]: Cluster 1 changed state from PENDING to PROVISIONING
Thu May 14 10:10:55 2026 [I] [EVT]: Cluster 1 provision started
Thu May 14 10:10:55 2026 [I] [GRP]: ControlPlane (ID=2) changed state from PENDING to BOOTSTRAPPING
Thu May 14 10:10:55 2026 [I] [SVM]: Creating Seed VM for ControlPlane provisioning
Thu May 14 10:10:55 2026 [I] [SVM]: Seed VM (ID=4) deployed successfully
Thu May 14 10:10:55 2026 [I] [EVT]: ControlPlane (ID=2) bootstrap successfully
```

These logs show the transition through provisioning stages, including control plane bootstrap and VM deployment.

Once provisioning completes, the cluster transitions to a running state:
```
root@opennebula-server:~# oneks list cluster
  ID USER     GROUP    NAME           STATE         REGTIME
  1  oneadmin oneadmin cert-cluster   RUNNING       05/14 10:10:55
```

**Add a Worker node**

After the cluster is running, a worker node group can be added:

A worker flavor is selected depending on the workload requirements, followed by the number of nodes to deploy. In this example, a single medium-sized worker node is created.
```
root@opennebula-server:~# oneks create group --cluster-id 1
> Nodegroup name: cert-worker
> Select a flavour for the Nodegroup:
    0: Small Worker Nodes
       Small worker node profile for lightweight workloads.
       2 CPU | 2 vCPU | 4 GB RAM | 16 GB Storage

    1: Medium Worker Nodes
       Medium worker node profile for balanced workloads.
       4 CPU | 4 vCPU | 8 GB RAM | 32 GB Storage

    2: Large Worker Nodes
       Large worker node profile for demanding workloads.
       8 CPU | 8 vCPU | 16 GB RAM | 64 GB Storage

    Select an option by number: 1
There are some parameters that require user input.
  * (count) Number of Worker nodes [type: number]
    Enter a number: 1

ID: 3
```

Once deployed, the worker VM appears alongside the control plane and virtual router in OpenNebula:
```
root@opennebula-server:~# onevm list
  ID USER     GROUP    NAME                    STAT  CPU     MEM HOST          TIME
   8 oneadmin oneadmin cert-worker-jsw8m-rshnx runn    4      8G 172.20.0.11   0d 00h00
   7 oneadmin oneadmin cert-cluster-rfvqf      runn    2      4G 172.20.0.11   0d 00h10
   6 oneadmin oneadmin vr-cert-cluster-cp-0    runn    1    512M 172.20.0.11   0d 00h10

```

Retrieve and configure the kubeconfig file to enable kubectl access to the cluster.

```
root@opennebula-server:~# oneks show cluster 1 --kubeconfig >> kubeconfig
root@opennebula-server:~# export KUBECONFIG=kubeconfig
```

### Run conformance tests

Let's start by checking if `kubectl` works:
```
root@opennebula-server:~# kubectl get nodes -o wide
NAME                      STATUS   ROLES                AGE   VERSION          INTERNAL-IP       EXTERNAL-IP       OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
cert-cluster-rfvqf        Ready    control-plane,etcd   19m   v1.34.2+rke2r1   192.168.200.102   192.168.200.102   Ubuntu 22.04.5 LTS   5.15.0-140-generic   containerd://2.1.5-k3s1
cert-worker-jsw8m-rshnx   Ready    <none>               10m   v1.34.2+rke2r1   192.168.200.103   192.168.200.103   Ubuntu 22.04.5 LTS   5.15.0-140-generic   containerd://2.1.5-k3s1

```

The rest of this document follows instructions from the `sonobuoy` test suite (found here: [instructions.md](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)).

1. Download and extract **sonobuoy**:

    ```
    root@opennebula-server:~# curl -fsSL https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz | tar -xzf- sonobuoy
    ```

2. Run tests:

    ```
    root@opennebula-server:~# ./sonobuoy run --mode=certified-conformance
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
   systemd-logs   complete                2

Sonobuoy is still running. Runs can take 60 minutes or more depending on cluster and plugin configuration.
```

When test suite is finished the former command will give an output similar to this:

```
root@opennebula-server:~# ./sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT   PROGRESS
            e2e   complete   passed       1
   systemd-logs   complete   passed       2

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

We will do as hinted:

```
root@opennebula-server:~# outfile=$(./sonobuoy retrieve)
root@opennebula-server:~# cp -a "$outfile" sonobuoy.tar.gz
```

Finally, we can delete the sonobuoy resources from the cluster with:
```
root@opennebula-server:~# ./sonobuoy delete
```

Files `e2e.log` and `junit_01.xml` have been included.
