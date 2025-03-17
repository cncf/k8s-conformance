# Conformance tests for GienTech Container Cloud Platform (GTCP)
GienTech Container Cloud Platform (GTCP) provides financial level, high availability, and high security container service platform. GCTP fully follows the conformance with Kubernetes and is flexible to extend more other services with GienTech PAAS products.
## Install GTCP
Throuth the following steps helps to create a GienTech Container Cloud Platform (GTCP) for running the Kubernetes conformance tests.
- Download GTCP package to /data/Yuanqi_V2R2.tgz and unzip the package.
- Edit datas.yaml to correspond your kubernetes environment settings, including node、storage、network configurations.
  ```yaml
  hosts:
  - name: k8s-01
    ansible_host:  192.168.1.1
    ip: 192.168.1.1
    ansible_ssh_port: 22
    ansible_ssh_user: root
    etcd_member_name: etcd_k8s-01
    ansible_ssh_pass: xxxxxxxx
    ansible_sudo_pass: xxxxxxxx
    host_type:
      - master
      - node
      - harbor
      - log
      - monitor
    host_exclusive_pod: 
  - name: k8s-02
    ansible_host: 192.168.1.2
    ip: 192.168.1.2
    ansible_ssh_port: 22
    ansible_ssh_user: root
    etcd_member_name: etcd_k8s-02
    ansible_ssh_pass: xxxxxxxx
    ansible_sudo_pass: xxxxxxxx
    host_type:
      - master
      - node
      - harbor
      - log
      - monitor
    host_exclusive_pod:
   # add more node information
   storage:
    local_path_provisioner_enabled: true
    local_path_dir: /opt/yuanqi-storage
    external_nfs:
      enabled: false
      version: v4  # v4.1, v4, v3
      server_ip: 
      server_path: 
    cinder_csi_enabled: false
    external_ceph_csi_rbd_provisioner:
      enabled: false
      clusterID: "4a2936f1-e9d1-4aca-9903-6340834fa072"
   network:
    network_driver: calico
    subnets:
      kube_pods_subnet: 10.10.0.0/16
      kube_service_addresses: 172.16.0.0/16
    calico:
        # optional: bgp,ipip,ipip_cross_subnet,vxlan,vxlan_cross_subnet
        mode: "ipip_cross_subnet"
        # add this options if mode is bgp
        rr_mode:
          cluster_id: ""
          peer_with_router: false
          global_as_num: ""
   etcd:
   enabled_mount_path: false
   data_dir: /var/lib/etcd
   diskName: 
   fstype: "ext4"  
- Execute the installation script.
  
   `sh /data/tools/deploy/deploy_k8s.sh`
## Run Conformance Tests
Download a binary release of the CLI, or build it yourself by running:

`go get -u -v github.com/vmware-tanzu/sonobuoy`

Deploy a Sonobuoy pod to your cluster with:

`sonobuoy run --mode=certified-conformance`

View actively running pods:

`sonobuoy status`

View active job status

`sonobuoy status --json | jq`

To inspect the logs:

`sonobuoy logs`

Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:

`outfile=$(sonobuoy retrieve)`

This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:

`mkdir ./results; tar xzf $outfile -C ./results`

Delete Sonobuoy

`sonobuoy delete`
