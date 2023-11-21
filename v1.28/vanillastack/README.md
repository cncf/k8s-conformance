# 1. Install from Commandline
## 1.1. Preparations

Make sure, a valuable git client is installed as well as ansible 2.9. Clone the vanillastack project from github:

```
git clone https://github.com/vanillastack/vanillastack.git
cd vanillastack/ansible
git submodule update --init --recursive
```

1.2. Configure Vanillastack

To adapt Vanillastack to your environment, some changes are needed:

$ mv inventory.testing inventory
Edit inventory and add information of your infrastructure to related groups.
mv group_vars.testing group_vars

Adapt your inventory:

vi inventory

[master]
<full-master-master-1> ansible_host=<host-ip> ansible_user=<username>
if ha <full-hostname-master-2> ansible_host=<host-ip> ansible_user=<username>
if ha <full-hostname-master-3> ansible_host=<host-ip> ansible_user=<username>
...

[worker]
<full-hostname-worker-1> ansible_host=<host-ip> ansible_user=<username>
<full-hostname-worker-2> ansible_host=<host-ip> ansible_user=<username>
<full-hostname-worker-3> ansible_host=<host-ip> ansible_user=<username>
 ...

### Ceph Storage Nodes
[storage]
<full-hostname-worker-1> ansible_host=<host-ip> ansible_user=<username>
<full-hostname-worker-2> ansible_host=<host-ip> ansible_user=<username>
 ...

[kube_cluster:children]
master
install_nodes

**This group defines, where the private loadbalancer and virtual IP
hould be installed. That can be changed to other systems as well.**
[haproxy]
master

**This group needs to be empty, as it is used to scale worker nodes**
[install_nodes]
[install_master]
[update_nodes]
[update_master]

To create a basic vanillastack instance, only values inside the "container_vars.yaml" need to be changed. Inside that file, you decide which applications should be deployed, how they could be reached and if you want to configure your commercial account.

Adapt container_vars.yaml:

vi group_vars/all/container_vars.yaml

This installs keepalived and HaProxy on the [haproxy] group defined in the inventory, needs an floating IP defined in 'locadbalancerIP' setting this to true acts like 'install_haproxy' is set to true.

make_ha: false

This installs HaProxy as Loadbalancing service to [haproxy] group defined in the inventory Can be any machine you define in this group, e.g. an external machine

install_haproxy: false

Set your clusterTLDomain:

clusterTLDomain: <mycluster.domain> # needs to have an solveable DNS-record

Offline Install

This will skip all install steps which normally require internet access It requires you to have already prepared Debian or RHEL Machines. See the type_prepare_offline_install.yaml, to prepare machines for the install while still online. Also you have to have a Image Registry and Helm Chart Registry available in the network (in case you’re working in a DMZ) You can set your custom Repositories in the global.yaml

offline_install: false

[…​] #see container_vars.yaml for all values

Be aware that the CIDR of your environment does not overlap with the cluster CIDR.

**For production environment please check all variables in the ansible-script!**

### 2. Run VanillaStack Playbook

First prepare the rollout:

ansible-playbook type_prepare_installnode.yaml

Now we need to execute the Vanillastack Playbook:

ansible-playbook -i inventory type_vanillastack_deploy.yaml

### 3. Kubeconfig

Kubeconfig is located on Master-1 at your ansible_user homedirectory and can be used directly with kubectl On the Node you executed that playbook you can find the configuration under /tmp/ansible/<cluster-uuid>/admin.conf and can be used from any node which reaches kube-api
