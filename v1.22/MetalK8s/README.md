# MetalK8s
Official documentation: https://metal-k8s.readthedocs.io/en/development-2.11/

## Prerequisites
- An OpenStack cluster
- The official CentOS 7.9 2009 image pre-loaded in Glance
- Three VMs with 8 vCPUs, 16 GB of RAM, 40GB of local storage

## Provisioning
Create VM instances using the CentOS 7.9 image, and attach each of them to the
same network.

### Provisioning the Bootstrap Node
On one of the VMs, which will act as the *bootstrap* node, perform the following
steps:

- Set up the Salt Minion ID:

  ```
  $ mkdir /etc/salt; chmod 0700 /etc/salt
  $ echo metalk8s-bootstrap > /etc/salt/minion_id
  ```

- Download MetalK8s ISO to `/home/centos/metalk8s.iso`

- Create `/etc/metalk8s/bootstrap.yaml`:

  ```
  $ mkdir /etc/metalk8s
  $ cat > /etc/metalk8s/bootstrap.yaml << EOF
  apiVersion:  metalk8s.scality.com/v1alpha3
  kind: BootstrapConfiguration
  networks:
    controlPlane: "10.200.0.0/16"
    workloadPlane: "10.200.0.0/16"
  ca:
    minion: metalk8s-bootstrap
  archives:
    - /home/centos/metalk8s.iso
  EOF
  ```

- Bootstrap the cluster

  ```
  $ mkdir /mnt/metalk8s-2.11
  $ mount /home/centos/metalk8s.iso /mnt/metalk8s-2.11
  $ cd /mnt/metalk8s-2.11
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
[instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md)
as found in the [CNCF K8s Conformance repository](https://github.com/cncf/k8s-conformance).

