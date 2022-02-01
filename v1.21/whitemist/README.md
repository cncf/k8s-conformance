# Whitemist

## Prepare your installer environment

1. Ensure port security is disabled among the nodes. Also ensure the right security groups are specified (for instance two SG's might be in conflict).
2. Create the directory where WhiteMist configuration will reside, usually /etc/whitemist.
```
sudo mkdir /etc/whitemist
```
3. Prepare the following environment variables to customize your deployment, make sure you persist them on your .bashrc file. Basically, you need to define the “/etc/whitemist” folder as the target for WhiteMist.
```
export WHITEMIST_CONFIG_DIR=/etc/whitemist
```

4. Gather the IP addresses of your you K8s hosts and VIP (for WhiteMist Dashboard). The VIP should be a new IP available for assignment. In an Openstack environment, this can be a floating IP or a new "port" within the same network as the host nodes, available for This IP will be used by MetalLB for exposing the Metal LoadBalancer.
5. Create and populate the WhiteMist configuration file in ${WHITEMIST_CONFIG_DIR}/cluster_configuration.yml
```
# Metal Load Balancing
metallb_enabled: true
metallb_ip_range: 
  - "10.0.0.14-10.0.0.17" # VIP IP address range, this can also be a list of individual IPs
metallb_protocol: layer2
metallb_limits_cpu: "100m"
metallb_limits_memory: "100Mi"
metallb_port: "7472"

# Kubernetes ingress controller
ingress_nginx_enabled: true

# VIP address for your ingress controller
vip_ingress: 10.0.0.14 # Virtual IP for your WhiteMist ingress controller

# Install Prometheus Exporters to monitor this cluster
install_kubeprometheus: true

# Kube-proxy proxyMode configuration.
# Can be ipvs, iptables
kube_proxy_mode: ipvs

# configure arp_ignore and arp_announce to avoid answering ARP queries from kube-ipvs0 interface
# must be set to true for MetalLB to work
kube_proxy_strict_arp: true

# Metrics Server options
metrics_server_enabled: true
metrics_server_kubelet_insecure_tls: true
metrics_server_metric_resolution: 60s
metrics_server_kubelet_preferred_address_types: "InternalIP"

# You can set MTU value here. If left undefined or empty, it will
# not be specified in calico CNI config, so Calico will use built-in
# defaults. The value should be a number, not a string.
# If Whitemist is being deployed in openstack instances
# must be set to 1400, otherwise comment it out
calico_mtu: 1400

# Allows WhiteMist to claim a wide range of ports, useful for SMTP, syslog, etc.
kube_apiserver_node_port_range: "100-32767"
```
6. Select a Storage Provider
To install OpenEBS, which is a fast storage provider for local volumes, you should add the following lines to your cluster_configuration.yml file:
```
install_openebs: true
# If you want to use Jiva, it needs ISCSI tools in order to work
install_iscsi: true
```
If instead you want to install Longhorn, use these settings below:
```
install_longhorn: true
install_iscsi: true # obligatory for LongHorn
longhorn_replicas: 1
```
7. Prepare the following inventory file in ${WHITEMIST_CONFIG_DIR}/inventory.yml

The ansible_host variables refer to the IP addresses of the host nodes (see step 4), each taking up a master or (worker) node role. Here you can also define which nodes will serve as K8S master (must be an odd number!) and which will be plain worker nodes. Master and worker roles can co-live in one physical node.
```
all:
  vars:
    ansible_user: ubuntu
    ansible_python_interpreter: /usr/bin/python3
  hosts:
    whitemist-node1:
      ansible_host: 172.21.7.205
    whitemist-node2:
      ansible_host: 172.21.7.206
    whitemist-node3:
      ansible_host: 172.21.7.207
  children:
    k8s_masters: # 3 primary nodes
      hosts:
        whitemist-node1: {}
        whitemist-node2: {}
        whitemist-node3: {}
    k8s_nodes:  # 3 secondary nodes, co-living in the primary nodes
      hosts:
        whitemist-node1: {}
        whitemist-node2: {}
        whitemist-node3: {}
```
8. To avoid issues with slow sudo commands, it's a good idea to define the hostname (e.g. whitemist-nodeX) in the /etc/hosts files of the nodes.
9. Download the WhiteMist deployer file:
```
wget --no-check-certificate https://storage.whitestack.com/whitemist/whitemist-deployer-eclipse.sh
```
10. Apply executable permissions on the downloaded deployer and run it:
```
wget --no-check-certificate https://storage.whitestack.com/whitemist/whitemist-deployer-eclipse.sh
chmod +x whitemist-deployer-eclipse.sh
./whitemist-deployer-eclipse.sh \
[--configdir ${WHITEMIST_CONFIG_DIR}] [--tag ${TAG}]
```

## Run conformance tests

1. Follow the [test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
   to run the conformance tests. You may need to specify the image available:

```
sonobuoy run --mode=certified-conformance --sonobuoy-image projects.registry.vmware.com/sonobuoy/sonobuoy:v0.53.2
```
