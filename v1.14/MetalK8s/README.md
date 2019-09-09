# MetalK8s
Official documentation: https://metal-k8s.readthedocs.io

## Prerequisites
- An OpenStack cluster
- The official CentOS 7.6 1809 image pre-loaded in Glance
- A VM with 8 vCPUs, 16 GB of RAM, 40GB of local storage

## Provisioning
- Create two private networks in the OpenStack cluster with port security
  disabled, and a subnet in each of them:

  * Control-plane network: 10.10.0.0/16
  * Workload-plane network: 10.20.0.0/16

- Create a VM instance using the CentOS 7.6 image, and attach it to a public
  network (for internet access) and the two private networks.

- Configure all interfaces in (make sure to fill in the appropriate MAC
  addresses):

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

  $ cat > /etc/sysconfig/network-scripts/ifcfg-eth2 << EOF
  BOOTPROTO=dhcp
  DEVICE=eth2
  HWADDR=...
  ONBOOT=yes
  TYPE=Ethernet
  USERCTL=no
  PEERDNS=no
  EOF

  $ systemctl restart network
  ```

- Set up the Salt Minion ID:

  ```
  $ mkdir /etc/salt; chmod 0700 /etc/salt
  $ echo metalk8s-23 > /etc/salt/minion_id
  ```

- Download MetalK8s ISO to `/home/centos/metalk8s-2.3.iso`

- Create `/etc/metalk8s/bootstrap.yaml`:

  ```
  $ mkdir /etc/metalk8s
  $ cat > /etc/metalk8s/bootstrap.yaml << EOF
  apiVersion: metalk8s.scality.com/v1alpha2
  kind: BootstrapConfiguration
  networks:
    controlPlane: 10.10.0.0/16
    workloadPlane: 10.20.0.0/16
  ca:
    minion: metalk8s-23
  apiServer:
    host: metalk8s-23
  products:
    metalk8s:
      - /home/centos/metalk8s-2.3.iso
  EOF
  ```

- Bootstrap the cluster

  ```
  $ mkdir /mnt/metalk8s-2.3
  $ mount /home/centos/metalk8s-2.3.iso /mnt/metalk8s-2.3
  $ cd /mnt/metalk8s-2.3
  $ ./bootstrap.sh
  ```

## Preparing the Cluster to Run Sonobuoy

- Configure access to the Kubernetes API server

  ```
  $ export KUBECONFIG=/etc/kubernetes/admin.conf
  ```

- Remove taints from the node, which would prevent the Sonobuoy *Pod*s to be
  scheduled:

  ```
  $ kubectl taint node metalk8s-23 node-role.kubernetes.io/bootstrap-
  node/metalk8s-23 untainted
  $ kubectl taint node metalk8s-23 node-role.kubernetes.io/infra-
  node/metalk8s-23 untainted
  ```

## Running Sonobuoy and Collecting Results

Follow the
[instructions](https://github.com/cncf/k8s-conformance/blob/83d687c5aaf65a6fa462a5476553e92774730d3a/instructions.md)
as found in the [CNCF K8s Conformance repository](https://github.com/cncf/k8s-conformance).
