# Reproducing the test results with StarlingX


## Create the StarlingX environment with Kubernetes

The tests were run on a duplex environment.

You can access the StarlingX ISO image from the following mirror: http://mirror.starlingx.cengn.ca/mirror/starlingx/release/4.0.1/

After booting the main controller with the StarlingX image select 'All-in-one Controller Configuration' on the console.

You can select from serial or graphical console to perform the steps based on your environment.

Once the system has booted log in with sysadmin/sysadmin and change your password as prompted.

Configure IP address to be able to connect to the machine via SSH, change the IP address with valid IPs on your setup.

Login via SSH, and create a file called localhost.yml, this file must contain your proxy configuration (if required), it will be used to configure docker/containerd daemon to be able to pull images:

The following is an example of localhost.yml:

++++++++++++++++++++++++
system_mode: duplex

dns_servers:
  - 10.248.2.1

docker_http_proxy: http://proxy.intel.com:PORT
docker_https_proxy:  https://proxy.intel.com:PORT

external_oam_subnet: 10.10.10.0/24
external_oam_gateway_address: 10.10.10.1
external_oam_floating_address: 10.10.10.2
external_oam_node_0_address: 10.10.10.3
external_oam_node_1_address: 10.10.10.4

management_subnet: 192.168.204.0/24
management_start_address: 192.168.204.10
management_end_address: 192.168.204.100

ansible_become_pass: ANSIBLE_PASS
admin_password: ADMIN_PASS
++++++++++++++++++++++++


Replace DNS, proxy and IP address with your lab configuration. Also, replace ANSIBLE_PASS and ADMIN_PASS with actual passwords, first one is sysadmin password, second one is used for horizon on starlingx.

Execute ansible bootstrap and confirm that ansible completes without errors.:

ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

Next, execute the following command to gain access to system commands via keystone:
source /etc/platform/openrc

system host-unlock controller-0

Wait for the host to come back online (takes around 15mins, depends on actual resources), once online, login again.


once it’s back online, execute:
source /etc/platform/openrc

Then wait for a few minutes until the controller is unlocked and available:
system host-show controller-0|grep -w administrative|awk '{print$4}'
locked
unlocked

system host-show controller-0|grep -w availability|awk '{print$4}'
available

You can perform necessary configuration steps and setup the secondary controller similarly.

Once the secondary controller is powered on, grab the mac address of the management interface and add to the system on primary controller
system host-add -n controller-1 -p controller -m 52:54:00:c9:ce:53

Check the status of application platform-integ-apps, it should be “applied”, before moving forward with the next step:

system application-list|grep platform -integ-apps|awk '{print $10}'
applied


Place the helm-chart manifest taken from cengn, and upload it for apply:
system application-upload stx-openstack.tgz. (Name of file will be different, depending of timestamp).

+---------------+----------------------------------+
| Property      | Value                            |
+---------------+----------------------------------+
| active        | False                            |
| app_version   | 1.0-19-centos-stable-versioned   |
| created_at    | 2020-03-19T09:58:13.395028+00:00 |
| manifest_file | stx-openstack.yaml               |
| manifest_name | armada-manifest                  |
| name          | stx-openstack                    |
| progress      | None                             |
| status        | uploading                        |
| updated_at    | None                             |
+---------------+----------------------------------+

Monitor the status:

system application-show stx-openstack
uploading
uploaded

Once uploaded, apply it:
system application-apply stx-openstack
applying

Monitor the status, this can take several minutes depending on your internet connection:

system application-list|grep stx-openstack|awk '{print $10}'
applying
applied

After this step you can move on to the test phase.

### Sample Configuration

You can find instructions on how to check and modify configuration options. Change the interface values according to your environment.

system host-if-modify controller-0 lo -c none

+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | lo                                   |
| iftype          | virtual                              |
| ports           | []                                   |
| imac            | 00:00:00:00:00:00                    |
| imtu            | 1500                                 |
| ifclass         | None                                 |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | f8bb0761-e3d0-425b-9905-7ca9d4c10d4d |
| ihost_uuid      | 91ceae2f-1135-4d12-9bb0-a5b69344e67f |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T08:35:36.938781+00:00     |
| updated_at      | 2020-03-19T08:56:32.535484+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
+-----------------+--------------------------------------+


system interface-network-list controller-0|grep lo|awk '{print $4}'
08893532-bcd4-4cf8-8a98-9c77e062a684


system interface-network-remove 08893532-bcd4-4cf8-8a98-9c77e062a684
Deleted Interface Network: 08893532-bcd4-4cf8-8a98-9c77e062a684

system host-if-modify controller-0 ens3 -c platform

 +-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | ens3                                 |
| iftype          | ethernet                             |
| ports           | [u'ens3']                            |
| imac            | 52:54:00:04:85:22                    |
| imtu            | 1500                                 |
| ifclass         | platform                             |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | 285e8a13-3f23-4bcd-99c2-247334d858ca |
| ihost_uuid      | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T05:33:22.861112+00:00     |
| updated_at      | 2020-03-19T05:55:38.770543+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | None                                 |
| ipv6_mode       | None                                 |
| accelerated     | [False]                              |
+-----------------+--------------------------------------+

system interface-network-assign controller-0 ens3 oam
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| hostname     | controller-0                         |
| uuid         | 4533b176-f167-4372-aa26-f1ce73ba4bc4 |
| ifname       | ens3                                 |
| network_name | oam                                  |
+--------------+--------------------------------------+

system host-if-modify controller-0 ens4 -c platform
+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | ens4                                 |
| iftype          | ethernet                             |
| ports           | [u'ens4']                            |
| imac            | 52:54:00:e4:6e:da                    |
| imtu            | 1500                                 |
| ifclass         | platform                             |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | e6bf34bf-62a6-478b-9968-2e40fe274ef7 |
| ihost_uuid      | 91ceae2f-1135-4d12-9bb0-a5b69344e67f |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T08:33:40.798713+00:00     |
| updated_at      | 2020-03-19T08:56:42.533311+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | None                                 |
| ipv6_mode       | None                                 |
| accelerated     | [False]                              |
+-----------------+--------------------------------------+

system interface-network-assign controller-0 ens4 mgmt
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| hostname     | controller-0                         |
| uuid         | 66cb9f71-2ee2-4fa7-b32d-e02853e84daf |
| ifname       | ens4                                 |
| network_name | mgmt                                 |
+--------------+--------------------------------------+

system interface-network-assign controller-0 ens4 cluster-host
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| hostname     | controller-0                         |
| uuid         | 5c706b17-e5bd-4840-9161-c6fd3a364cd7 |
| ifname       | ens4                                 |
| network_name | cluster-host                         |
+--------------+--------------------------------------+


system storage-backend-add ceph --confirmed
+--------------------------------------+------------+---------+------------+------+----------+--------------------+
| uuid                                 | name       | backend | state      | task | services | capabilities       |
+--------------------------------------+------------+---------+------------+------+----------+--------------------+
| acc55e57-2b82-4ccb-be4b-edbd0d9ef703 | ceph-store | ceph    | configured | None | None     | min_replication: 1 |
|                                      |            |         |            |      |          | replication: 1     |
+--------------------------------------+------------+---------+------------+------+----------+--------------------+

system host-port-list controller-0 --nowrap|grep eth1000|awk '{ print $2,$4,$8}'
66730c4d-2e12-4f0c-9df6-60635f98e3cc eth1000 0000:00:06.0

system host-port-list controller-0 --nowrap|grep eth1001|awk '{ print $2,$4,$8}'
8ab97c40-9a26-4486-840c-097fbc3acaa2 eth1001 0000:00:07.0

system host-if-list -a controller-0|grep eth1000|awk '{print $2}'
649a8ac5-f879-455f-a9d2-1a58a146ee72

system host-if-list -a controller-0|grep eth1001|awk '{print $2}'
10b96edf-e2e8-42be-a222-272055d0de14

system datanetwork-add physnet0 vlan
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| id           | 1                                    |
| uuid         | a8729375-b6f7-48a3-9c8e-a9f2e06a9fb5 |
| name         | physnet0                             |
| network_type | vlan                                 |
| mtu          | 1500                                 |
| description  | None                                 |
+--------------+--------------------------------------+

system datanetwork-add physnet1 vlan
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| id           | 2                                    |
| uuid         | 1a408147-f831-4bac-9e72-6ad3dfe1f257 |
| name         | physnet1                             |
| network_type | vlan                                 |
| mtu          | 1500                                 |
| description  | None                                 |
+--------------+--------------------------------------+

system host-if-modify -m 1500 -n data0 -c data controller-0 649a8ac5-f879-455f-a9d2-1a58a146ee72
+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | data0                                |
| iftype          | ethernet                             |
| ports           | [u'eth1000']                         |
| imac            | 52:54:00:4f:f8:66                    |
| imtu            | 1500                                 |
| ifclass         | data                                 |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | 649a8ac5-f879-455f-a9d2-1a58a146ee72 |
| ihost_uuid      | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T05:33:23.101786+00:00     |
| updated_at      | 2020-03-19T05:55:52.594862+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | disabled                             |
| ipv6_mode       | disabled                             |
| accelerated     | [True]                               |
+-----------------+--------------------------------------+

system interface-datanetwork-assign controller-0 649a8ac5-f879-455f-a9d2-1a58a146ee72 physnet0
+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| hostname         | controller-0                         |
| uuid             | f0e230de-450e-4cbb-993f-b736363dce72 |
| ifname           | data0                                |
| datanetwork_name | physnet0                             |
+------------------+--------------------------------------+

system host-if-modify -m 1500 -n data1 -c data controller-0 10b96edf-e2e8-42be-a222-272055d0de14
+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | data1                                |
| iftype          | ethernet                             |
| ports           | [u'eth1001']                         |
| imac            | 52:54:00:3a:63:41                    |
| imtu            | 1500                                 |
| ifclass         | data                                 |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | 10b96edf-e2e8-42be-a222-272055d0de14 |
| ihost_uuid      | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T05:33:23.289735+00:00     |
| updated_at      | 2020-03-19T05:55:56.294144+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | disabled                             |
| ipv6_mode       | disabled                             |
| accelerated     | [True]                               |
+-----------------+--------------------------------------+


system interface-datanetwork-assign controller-0 10b96edf-e2e8-42be-a222-272055d0de14 physnet1
+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| hostname         | controller-0                         |
| uuid             | 799d331a-09b5-4382-8f89-2d10a270b4a0 |
| ifname           | data1                                |
| datanetwork_name | physnet1                             |
+------------------+--------------------------------------+

system host-label-assign controller-0 openstack-control-plane=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | a447d9f7-8c46-4c51-bf55-bad88a0e02e4 |
| host_uuid   | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| label_key   | openstack-control-plane              |
| label_value | enabled                              |
+-------------+--------------------------------------+

system host-label-assign controller-0 openstack-compute-node=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | 655893f9-6d7e-4cb0-85be-6a7adeca9322 |
| host_uuid   | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| label_key   | openstack-compute-node               |
| label_value | enabled                              |
+-------------+--------------------------------------+

system host-label-assign controller-0 openvswitch=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | ca0c4f79-cfef-4231-810e-fb325a0e6c69 |
| host_uuid   | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| label_key   | openvswitch                          |
| label_value | enabled                              |
+-------------+--------------------------------------+

system host-label-assign controller-0 sriov=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | 16e58151-2fee-4b88-b1cd-33fcd7e7316c |
| host_uuid   | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| label_key   | sriov                                |
| label_value | enabled                              |
+-------------+--------------------------------------+


system host-show controller-0|grep rootfs|awk '{print $4}'

/dev/disk/by-path/pci-0000:00:08.0-ata-1.0

system host-disk-list controller-0 --nowrap|grep /dev/disk/by-path/pci-0000:00:08.0-ata-1.0|awk '{print $4}'
/dev/sda

system host-disk-list controller-0|grep /dev/sda|awk '{print $2}'
d9569d69-150c-4ec9-9405-4850c963480f

system host-disk-partition-add controller-0 d9569d69-150c-4ec9-9405-4850c963480f 100 -t lvm_phys_vol
+-------------+--------------------------------------------------+
| Property    | Value                                            |
+-------------+--------------------------------------------------+
| device_path | /dev/disk/by-path/pci-0000:00:08.0-ata-1.0-part5 |
| device_node | /dev/sda5                                        |
| type_guid   | ba5eba11-0000-1111-2222-000000000001             |
| type_name   | None                                             |
| start_mib   | None                                             |
| end_mib     | None                                             |
| size_mib    | 102400                                           |
| uuid        | 46fb02c7-9071-421a-ad38-58b15e7a9358             |
| ihost_uuid  | 2860db81-72cb-4449-a63e-d7a19bf02670             |
| idisk_uuid  | d9569d69-150c-4ec9-9405-4850c963480f             |
| ipv_uuid    | None                                             |
| status      | Creating                                         |
| created_at  | 2020-03-19T05:56:08.844065+00:00                 |
| updated_at  | None                                             |
+-------------+--------------------------------------------------+

system host-disk-partition-show controller-0 46fb02c7-9071-421a-ad38-58b15e7a9358 | grep -w status | awk '{print$4}'
Creating
Ready

system host-lvg-add controller-0 nova-local
+-----------------------+--------------------------------------+
| Property              | Value                                |
+-----------------------+--------------------------------------+
| lvm_vg_name           | nova-local                           |
| vg_state              | adding                               |
| uuid                  | 57530e80-0f1d-4725-a051-f06d04495c0c |
| ihost_uuid            | 2860db81-72cb-4449-a63e-d7a19bf02670 |
| lvm_vg_access         | None                                 |
| lvm_max_lv            | 0                                    |
| lvm_cur_lv            | 0                                    |
| lvm_max_pv            | 0                                    |
| lvm_cur_pv            | 0                                    |
| lvm_vg_size_gib       | 0.0                                  |
| lvm_vg_avail_size_gib | 0.0                                  |
| lvm_vg_total_pe       | 0                                    |
| lvm_vg_free_pe        | 0                                    |
| created_at            | 2020-03-19T05:56:34.623607+00:00     |
| updated_at            | None                                 |
| parameters            | {}                                   |
+-----------------------+--------------------------------------+

system host-pv-add controller-0 nova-local 46fb02c7-9071-421a-ad38-58b15e7a9358
+--------------------------+--------------------------------------------------+
| Property                 | Value                                            |
+--------------------------+--------------------------------------------------+
| uuid                     | 236eba15-0191-4d94-8197-7d9339b03ba1             |
| pv_state                 | adding                                           |
| pv_type                  | partition                                        |
| disk_or_part_uuid        | 46fb02c7-9071-421a-ad38-58b15e7a9358             |
| disk_or_part_device_node | /dev/sda5                                        |
| disk_or_part_device_path | /dev/disk/by-path/pci-0000:00:08.0-ata-1.0-part5 |
| lvm_pv_name              | /dev/sda5                                        |
| lvm_vg_name              | nova-local                                       |
| lvm_pv_uuid              | None                                             |
| lvm_pv_size_gib          | 0.0                                              |
| lvm_pe_total             | 0                                                |
| lvm_pe_alloced           | 0                                                |
| ihost_uuid               | 2860db81-72cb-4449-a63e-d7a19bf02670             |
| created_at               | 2020-03-19T05:56:36.164387+00:00                 |
| updated_at               | None                                             |
+--------------------------+--------------------------------------------------+


system host-disk-partition-add controller-0 d9569d69-150c-4ec9-9405-4850c963480f 20 -t lvm_phys_vol
+-------------+--------------------------------------------------+
| Property    | Value                                            |
+-------------+--------------------------------------------------+
| device_path | /dev/disk/by-path/pci-0000:00:08.0-ata-1.0-part6 |
| device_node | /dev/sda6                                        |
| type_guid   | ba5eba11-0000-1111-2222-000000000001             |
| type_name   | None                                             |
| start_mib   | None                                             |
| end_mib     | None                                             |
| size_mib    | 20480                                            |
| uuid        | 64f59edb-d27b-4274-8b98-65d81f1494a4             |
| ihost_uuid  | 2860db81-72cb-4449-a63e-d7a19bf02670             |
| idisk_uuid  | d9569d69-150c-4ec9-9405-4850c963480f             |
| ipv_uuid    | None                                             |
| status      | Creating                                         |
| created_at  | 2020-03-19T05:56:37.578518+00:00                 |
| updated_at  | None                                             |
+-------------+--------------------------------------------------+

system host-disk-partition-show controller-0 64f59edb-d27b-4274-8b98-65d81f1494a4 | grep -w status | awk '{print$4}'
Creating
Ready

system host-pv-add controller-0 nova-local 64f59edb-d27b-4274-8b98-65d81f1494a4
+--------------------------+--------------------------------------------------+
| Property                 | Value                                            |
+--------------------------+--------------------------------------------------+
| uuid                     | fd44925f-0fb6-4414-a5ce-821eb28c9359             |
| pv_state                 | adding                                           |
| pv_type                  | partition                                        |
| disk_or_part_uuid        | 64f59edb-d27b-4274-8b98-65d81f1494a4             |
| disk_or_part_device_node | /dev/sda6                                        |
| disk_or_part_device_path | /dev/disk/by-path/pci-0000:00:08.0-ata-1.0-part6 |
| lvm_pv_name              | /dev/sda6                                        |
| lvm_vg_name              | nova-local                                       |
| lvm_pv_uuid              | None                                             |
| lvm_pv_size_gib          | 0.0                                              |
| lvm_pe_total             | 0                                                |
| lvm_pe_alloced           | 0                                                |
| ihost_uuid               | 2860db81-72cb-4449-a63e-d7a19bf02670             |
| created_at               | 2020-03-19T05:57:03.187250+00:00                 |
| updated_at               | None                                             |
+--------------------------+--------------------------------------------------+


system host-disk-list controller-0|grep /dev/sdb|awk '{print $2}'
e87ae78c-6f49-4948-8166-a1efc28197c4

system host-stor-add controller-0 e87ae78c-6f49-4948-8166-a1efc28197c4
+------------------+--------------------------------------------------+
| Property         | Value                                            |
+------------------+--------------------------------------------------+
| osdid            | 0                                                |
| function         | osd                                              |
| state            | configuring-on-unlock                            |
| journal_location | cc95c132-cf18-4849-99ea-1e627b6b11ff             |
| journal_size_gib | 1024                                             |
| journal_path     | /dev/disk/by-path/pci-0000:00:08.0-ata-2.0-part2 |
| journal_node     | /dev/sdb2                                        |
| uuid             | cc95c132-cf18-4849-99ea-1e627b6b11ff             |
| ihost_uuid       | 2860db81-72cb-4449-a63e-d7a19bf02670             |
| idisk_uuid       | e87ae78c-6f49-4948-8166-a1efc28197c4             |
| tier_uuid        | 857bdfea-c2c1-4fa6-9710-6cbab9883206             |
| tier_name        | storage                                          |
| created_at       | 2020-03-19T05:57:05.865827+00:00                 |
| updated_at       | None                                             |
+------------------+--------------------------------------------------+

system host-unlock controller-0

Wait for the host to come back online (takes around 15mins, depends on actual resources), once online, login again.

once it’s back online, execute:
source /etc/platform/openrc

Then wait for a few minutes until the controller is unlocked and available:
system host-show controller-0|grep -w administrative|awk '{print$4}'
locked
unlocked

system host-show controller-0|grep -w availability|awk '{print$4}'
available

Power on secondary controller, grab the mac address of management interface and add the system on primary controller
system host-add -n controller-1 -p controller -m 52:54:00:c9:ce:53
+-----------------------+-----------------------------------------+
| Property              | Value                                   |
+-----------------------+-----------------------------------------+
| action                | none                                    |
| administrative        | locked                                  |
| availability          | offline                                 |
| bm_ip                 | None                                    |
| bm_type               | none                                    |
| bm_username           | None                                    |
| boot_device           | /dev/sda                                |
| capabilities          | {u'Personality': u'Controller-Standby'} |
| clock_synchronization | ntp                                     |
| config_applied        | None                                    |
| config_status         | None                                    |
| config_target         | None                                    |
| console               | ttyS0,115200                            |
| created_at            | 2020-03-19T09:27:31.549977+00:00        |
| hostname              | controller-1                            |
| id                    | 2                                       |
| install_output        | text                                    |
| install_state         | None                                    |
| install_state_info    | None                                    |
| inv_state             | None                                    |
| invprovision          | None                                    |
| location              | {}                                      |
| mgmt_ip               | 192.168.204.12                          |
| mgmt_mac              | 52:54:00:c9:ce:53                       |
| operational           | disabled                                |
| personality           | controller                              |
| reserved              | False                                   |
| rootfs_device         | /dev/sda                                |
| serialid              | None                                    |
| software_load         | 20.01                                   |
| subfunction_avail     | not-installed                           |
| subfunction_oper      | disabled                                |
| subfunctions          | controller,worker                       |
| task                  | None                                    |
| tboot                 | false                                   |
| ttys_dcd              | None                                    |
| updated_at            | None                                    |
| uptime                | 0                                       |
| uuid                  | 92412a7e-4625-4cee-a09d-fd01299a8355    |
| vim_progress_status   | None                                    |
+-----------------------+-----------------------------------------+

Wait until the system is installed, you can monitor the progress with:
system host-show controller-1|grep -w install_state|awk '{print$4}'
None
preinstall
installing
postinstall
booting
completed


Configure secondary controller
system host-if-modify -n oam0 -c platform controller-1 ens3
+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | oam0                                 |
| iftype          | ethernet                             |
| ports           | [u'ens3']                            |
| imac            | 52:54:00:00:b5:66                    |
| imtu            | 1500                                 |
| ifclass         | platform                             |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | 0630a578-8e74-4493-9439-bc9ae47b3320 |
| ihost_uuid      | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T09:36:02.154729+00:00     |
| updated_at      | 2020-03-19T09:36:43.245534+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | None                                 |
| ipv6_mode       | None                                 |
| accelerated     | [False]                              |
+-----------------+--------------------------------------+

system interface-network-assign controller-1 oam0 oam
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| hostname     | controller-1                         |
| uuid         | 48b450cc-2ba8-418d-ba25-29e3a53e77b0 |
| ifname       | oam0                                 |
| network_name | oam                                  |
+--------------+--------------------------------------+


system host-if-modify controller-1 mgmt0
+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | mgmt0                                |
| iftype          | ethernet                             |
| ports           | [u'ens4']                            |
| imac            | 52:54:00:c9:ce:53                    |
| imtu            | 1500                                 |
| ifclass         | platform                             |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | ffd62b5c-1511-45ee-bb49-e53d77db703c |
| ihost_uuid      | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T09:36:02.295200+00:00     |
| updated_at      | 2020-03-19T09:36:46.263914+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | None                                 |
| ipv6_mode       | None                                 |
| accelerated     | [False]                              |
+-----------------+--------------------------------------+


system interface-network-assign controller-1 mgmt0 cluster-host
+--------------+--------------------------------------+
| Property     | Value                                |
+--------------+--------------------------------------+
| hostname     | controller-1                         |
| uuid         | 04814930-3527-4881-bb4f-4990e7bbbc21 |
| ifname       | mgmt0                                |
| network_name | cluster-host                         |
+--------------+--------------------------------------+


system host-port-list controller-1 --nowrap|grep eth1000|awk '{ print $2,$4,$8}'
a5ba14bf-c144-4bdf-ac8d-6dda04f97d5d eth1000 0000:00:06.0


system host-port-list controller-1 --nowrap|grep eth1001|awk '{ print $2,$4,$8}'
83f54ddc-aa67-4179-8ed7-9402833f5df6 eth1001 0000:00:07.0


system host-if-list -a controller-1|grep eth1000|awk '{print $2}'
ccce39ed-3123-4148-a821-f0ae6e833352

system host-if-list -a controller-1|grep eth1001|awk '{print $2}'
12a2d7a2-00aa-4386-b151-6eae85446eb9

system host-if-modify -m 1500 -n data0 -c data controller-1 ccce39ed-3123-4148-a821-f0ae6e833352
+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | data0                                |
| iftype          | ethernet                             |
| ports           | [u'eth1000']                         |
| imac            | 52:54:00:75:10:17                    |
| imtu            | 1500                                 |
| ifclass         | data                                 |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | ccce39ed-3123-4148-a821-f0ae6e833352 |
| ihost_uuid      | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T09:36:02.584175+00:00     |
| updated_at      | 2020-03-19T09:36:53.619501+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | disabled                             |
| ipv6_mode       | disabled                             |
| accelerated     | [True]                               |
+-----------------+--------------------------------------+

system interface-datanetwork-assign controller-1 ccce39ed-3123-4148-a821-f0ae6e833352 physnet0
+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| hostname         | controller-1                         |
| uuid             | 25ea68f7-706e-40c0-8d22-9b4c972cc166 |
| ifname           | data0                                |
| datanetwork_name | physnet0                             |
+------------------+--------------------------------------+

system host-if-modify -m 1500 -n data1 -c data controller-1 12a2d7a2-00aa-4386-b151-6eae85446eb9
+-----------------+--------------------------------------+
| Property        | Value                                |
+-----------------+--------------------------------------+
| ifname          | data1                                |
| iftype          | ethernet                             |
| ports           | [u'eth1001']                         |
| imac            | 52:54:00:84:d3:cb                    |
| imtu            | 1500                                 |
| ifclass         | data                                 |
| ptp_role        | none                                 |
| aemode          | None                                 |
| schedpolicy     | None                                 |
| txhashpolicy    | None                                 |
| uuid            | 12a2d7a2-00aa-4386-b151-6eae85446eb9 |
| ihost_uuid      | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| vlan_id         | None                                 |
| uses            | []                                   |
| used_by         | []                                   |
| created_at      | 2020-03-19T09:36:02.716415+00:00     |
| updated_at      | 2020-03-19T09:36:56.511143+00:00     |
| sriov_numvfs    | 0                                    |
| sriov_vf_driver | None                                 |
| ipv4_mode       | disabled                             |
| ipv6_mode       | disabled                             |
| accelerated     | [True]                               |
+-----------------+--------------------------------------+

system interface-datanetwork-assign controller-1 12a2d7a2-00aa-4386-b151-6eae85446eb9 physnet1

+------------------+--------------------------------------+
| Property         | Value                                |
+------------------+--------------------------------------+
| hostname         | controller-1                         |
| uuid             | dc1c6777-e05e-4131-b2d1-8fe0e727ac8e |
| ifname           | data1                                |
| datanetwork_name | physnet1                             |
+------------------+--------------------------------------+

system host-label-assign controller-1 openstack-control-plane=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | 94b04fc6-d4f8-4454-b669-a71f97791470 |
| host_uuid   | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| label_key   | openstack-control-plane              |
| label_value | enabled                              |
+-------------+--------------------------------------+

system host-label-assign controller-1 openstack-compute-node=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | 42a1922f-167b-4d0d-a24c-dc55d4fd9246 |
| host_uuid   | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| label_key   | openstack-compute-node               |
| label_value | enabled                              |
+-------------+--------------------------------------+


system host-label-assign controller-1 openvswitch=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | cf1dc1c3-fdf2-418a-a29c-b69f6d21a005 |
| host_uuid   | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| label_key   | openvswitch                          |
| label_value | enabled                              |
+-------------+--------------------------------------+


system host-label-assign controller-1 sriov=enabled
+-------------+--------------------------------------+
| Property    | Value                                |
+-------------+--------------------------------------+
| uuid        | f114eef6-4b19-46dc-a92e-ca3a1c083245 |
| host_uuid   | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| label_key   | sriov                                |
| label_value | enabled                              |
+-------------+--------------------------------------+


system host-show controller-1|grep rootfs|awk '{print $4}'
/dev/sda

system host-disk-list controller-1|grep /dev/sda|awk '{print $2}'
55c2038b-52ca-47be-a9e9-645aa41b809b



system host-disk-partition-add controller-1 55c2038b-52ca-47be-a9e9-645aa41b809b 100 -t lvm_phys_vol
+-------------+--------------------------------------------------+
| Property    | Value                                            |
+-------------+--------------------------------------------------+
| device_path | /dev/disk/by-path/pci-0000:00:08.0-ata-1.0-part5 |
| device_node | /dev/sda5                                        |
| type_guid   | ba5eba11-0000-1111-2222-000000000001             |
| type_name   | None                                             |
| start_mib   | None                                             |
| end_mib     | None                                             |
| size_mib    | 102400                                           |
| uuid        | ba076c59-1519-4467-9975-b0c600cab916             |
| ihost_uuid  | 92412a7e-4625-4cee-a09d-fd01299a8355             |
| idisk_uuid  | 55c2038b-52ca-47be-a9e9-645aa41b809b             |
| ipv_uuid    | None                                             |
| status      | Creating (on unlock)                             |
| created_at  | 2020-03-19T09:37:05.901143+00:00                 |
| updated_at  | None                                             |
+-------------+--------------------------------------------------+

system host-disk-partition-show controller-1 ba076c59-1519-4467-9975-b0c600cab916 | grep -w status | awk '{print$4}'
Creating

system host-lvg-add controller-1 nova-local
+-----------------------+--------------------------------------+
| Property              | Value                                |
+-----------------------+--------------------------------------+
| lvm_vg_name           | nova-local                           |
| vg_state              | adding                               |
| uuid                  | 62046a1d-7f62-45d4-978c-a50303a5e540 |
| ihost_uuid            | 92412a7e-4625-4cee-a09d-fd01299a8355 |
| lvm_vg_access         | None                                 |
| lvm_max_lv            | 0                                    |
| lvm_cur_lv            | 0                                    |
| lvm_max_pv            | 0                                    |
| lvm_cur_pv            | 0                                    |
| lvm_vg_size_gib       | 0.0                                  |
| lvm_vg_avail_size_gib | 0.0                                  |
| lvm_vg_total_pe       | 0                                    |
| lvm_vg_free_pe        | 0                                    |
| created_at            | 2020-03-19T09:37:07.838375+00:00     |
| updated_at            | None                                 |
| parameters            | {}                                   |
+-----------------------+--------------------------------------+

system host-pv-add controller-1 nova-local ba076c59-1519-4467-9975-b0c600cab916
+--------------------------+--------------------------------------------------+
| Property                 | Value                                            |
+--------------------------+--------------------------------------------------+
| uuid                     | e0b778a3-92b9-4aaf-baaa-f24f7c11ed56             |
| pv_state                 | adding                                           |
| pv_type                  | partition                                        |
| disk_or_part_uuid        | ba076c59-1519-4467-9975-b0c600cab916             |
| disk_or_part_device_node | /dev/sda5                                        |
| disk_or_part_device_path | /dev/disk/by-path/pci-0000:00:08.0-ata-1.0-part5 |
| lvm_pv_name              | /dev/sda5                                        |
| lvm_vg_name              | nova-local                                       |
| lvm_pv_uuid              | None                                             |
| lvm_pv_size_gib          | 0.0                                              |
| lvm_pe_total             | 0                                                |
| lvm_pe_alloced           | 0                                                |
| ihost_uuid               | 92412a7e-4625-4cee-a09d-fd01299a8355             |
| created_at               | 2020-03-19T09:37:08.918763+00:00                 |
| updated_at               | None                                             |
+--------------------------+--------------------------------------------------+

system host-disk-partition-add controller-1 55c2038b-52ca-47be-a9e9-645aa41b809b 20 -t lvm_phys_vol

system host-disk-partition-show controller-1 0c412f9e-cf6f-4d26-8847-882a25b68e16 | grep -w status | awk '{print$4}'
Creating

system host-pv-add controller-1 nova-local 0c412f9e-cf6f-4d26-8847-882a25b68e16

system host-disk-list controller-1|grep /dev/sdb|awk '{print $2}'
8608fd1e-7687-47d2-90f8-09ef9a83a45e

system storage-tier-list ceph_cluster|grep storage |awk '{print $2}'
fd4bf88b-7faf-408a-89cc-9aea449ff8ff

system host-stor-add controller-1 8608fd1e-7687-47d2-90f8-09ef9a83a45e --tier-uuid fd4bf88b-7faf-408a-89cc-9aea449ff8ff

+------------------+--------------------------------------------------+
| Property         | Value                                            |
+------------------+--------------------------------------------------+
| osdid            | 1                                                |
| function         | osd                                              |
| state            | configuring-on-unlock                            |
| journal_location | d33e45da-9127-4f5a-b764-d239e6a6a4cc             |
| journal_size_gib | 1024                                             |
| journal_path     | /dev/disk/by-path/pci-0000:00:08.0-ata-2.0-part2 |
| journal_node     | /dev/sdb2                                        |
| uuid             | d33e45da-9127-4f5a-b764-d239e6a6a4cc             |
| ihost_uuid       | 92412a7e-4625-4cee-a09d-fd01299a8355             |
| idisk_uuid       | 8608fd1e-7687-47d2-90f8-09ef9a83a45e             |
| tier_uuid        | fd4bf88b-7faf-408a-89cc-9aea449ff8ff             |
| tier_name        | storage                                          |
| created_at       | 2020-03-19T09:37:14.947472+00:00                 |
| updated_at       | None                                             |
+------------------+--------------------------------------------------+

system host-unlock controller-1
Wait until the secondary controller is available and unlocked (aroundd 30mins)

system host-show controller-1|grep -w administrative|awk '{print$4}'
unlocked

system host-show controller-1|grep -w availability|awk '{print$4}'
available

After secondary controller is available, check the status of application platform-integ-apps, it should be “applied”, before moving forward with the next step:

system application-list|grep platform-integ-apps|awk '{print $10}'
applied

Place the helm-chart manifest taken from cengn, and upload it for apply:
system application-upload stx-openstack.tgz. (Name of file will be different, depending of timestamp).

+---------------+----------------------------------+
| Property      | Value                            |
+---------------+----------------------------------+
| active        | False                            |
| app_version   | 1.0-19-centos-stable-versioned   |
| created_at    | 2020-03-19T09:58:13.395028+00:00 |
| manifest_file | stx-openstack.yaml               |
| manifest_name | armada-manifest                  |
| name          | stx-openstack                    |
| progress      | None                             |
| status        | uploading                        |
| updated_at    | None                             |
+---------------+----------------------------------+

Monitor the status:

system application-show stx-openstack
uploading
uploaded

Once uploaded, apply it:
system application-apply stx-openstack
applying

Monitor the status, this can take several minutes depending on your internet connection:

system application-list|grep stx-openstack|awk '{print $10}'
applying
applied


For online documentation about the installation process please consult the following page: https://docs.starlingx.io/deploy_install_guides/r4_release/

Make sure you have the right proxy setting to reach the docker registries in your localhost.yml file.

## Testing      

Once the configuration has been created, then you can follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to run the conformance test.
