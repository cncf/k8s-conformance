# MetalK8s
Official documentation: https://metal-k8s.readthedocs.io/en/development/2.5

## Prerequisites
- An OpenStack cluster
- The official CentOS 7.8 2003 image pre-loaded in Glance
- Three VMs with 8 vCPUs, 16 GB of RAM, 40GB of local storage

## Provisioning
- Create one private network in the OpenStack cluster with port security
  disabled, and a subnet in it:

  * Control-plane network: 10.10.0.0/16

- Create VM instances using the CentOS 7.8 image, and attach each of them to a
  public network (for internet access) and the two private networks.

- Configure the interface for private network (make sure to fill in the
  appropriate MAC address):

  ```
  $ cat > /etc/sysconfig/network-scripts/ifcfg-eth1 << EOF
  BOOTPROTO=dhcp
  DEVICE=eth1
  HWADDR=...
  ONBOOT=yes
  TYPE=Ethernet
  USERCTL=no
  PEERDNS=no
  EOF
  $ systemctl restart network
  ```

### Provisioning the Bootstrap Node
On one of the VMs, which will act as the *bootstrap* node, perform the following
steps:

- Set up the Salt Minion ID:

  ```
  $ mkdir /etc/salt; chmod 0700 /etc/salt
  $ echo metalk8s-bootstrap > /etc/salt/minion_id
  ```

- Download MetalK8s ISO to `/home/centos/metalk8s-2.6.iso`

- Create `/etc/metalk8s/bootstrap.yaml`:

  ```
  $ mkdir /etc/metalk8s
  $ cat > /etc/metalk8s/bootstrap.yaml << EOF
  apiVersion:  metalk8s.scality.com/v1alpha2
  kind: BootstrapConfiguration
  networks:
    controlPlane: "10.10.0.0/16"
    workloadPlane: "10.10.0.0/16"
  ca:
    minion: metalk8s-bootstrap
  archives:
    - /home/centos/metalk8s-2.6.iso
  EOF
  ```

- Bootstrap the cluster

  ```
  $ mkdir /mnt/metalk8s-2.6
  $ mount /home/centos/metalk8s-2.6.iso /mnt/metalk8s-2.6
  $ cd /mnt/metalk8s-2.6
  $ ./bootstrap.sh
  ```

### Provisioning the Cluster Nodes
Add the 2 other nodes to the cluster according to the procedure outlined in the
MetalK8s documentation. The easiest way to achieve this is through the MetalK8s
UI.

## Preparing the Cluster to Run Sonobuoy
On the *bootstrap* node:

- Configure access to the Kubernetes API server

  ```
  $ export KUBECONFIG=/etc/kubernetes/admin.conf
  ```

- Remove taints from the node, which would prevent the Sonobuoy *Pod*s from
  being scheduled:

  ```
  $ kubectl taint node metalk8s-bootstrap node-role.kubernetes.io/bootstrap-
  node/metalk8s-bootstrap untainted
  $ kubectl taint node metalk8s-bootstrap node-role.kubernetes.io/infra-
  node/metalk8s-bootstrap untainted
  ```

## Running Sonobuoy and Collecting Results
Follow the
[instructions](https://github.com/cncf/k8s-conformance/blob/95e904c99d6a0777db2e99a4787247118db8ed4e/instructions.md)
as found in the [CNCF K8s Conformance repository](https://github.com/cncf/k8s-conformance).
