# To Reproduce

These tests were done on a system with 2x master/worker (i.e. All-In-One) nodes, and the WRCP 22.12 candidate GA Load:
BUILD: wrcp_dev_build_2022-11-01_18-01-09
Kubernetes Version: 1.24


Set up a 2x master/worker (i.e. All-In-One) node cluster as follows:

* Create a bootable USB with the WRCP Install ISO 


* Install software on controller-0
  * Insert the bootable USB into a bootable USB port on the host you are configuring as controller-0.
  * Power on the host.
  * Attach to a console, ensure the host boots from the USB, and wait for the StarlingX Installer Menus.
  * Make the following menu selections in the installer:
    * First menu: Select ‘All-in-one Controller Configuration’
    * Second menu: Select ‘Graphical Console’ or ‘Textual Console’ depending on your terminal access to the console port
  * Wait for non-interactive install of software to complete and server to reboot. This can take 5-10 minutes, depending on the performance of the server.


* Bootstrap system on controller-0

  * Login using the username / password of “sysadmin” / “sysadmin”. When logging in for the first time, you will be forced to change the password.
    ```
      Login: sysadmin
      Password:
      Changing password for sysadmin.
      (current) UNIX Password: sysadmin
      New Password:
      (repeat) New Password:
    ```

  * Verify and/or configure IP connectivity.

    External connectivity is required to run the Ansible bootstrap playbook. The StarlingX boot image will DHCP out all interfaces so the server may have obtained an IP address and have external IP connectivity if a DHCP server is present in your environment. Verify this using the ip addr and ping 8.8.8.8 commands.

    Otherwise, manually configure an IP address and default IP route. Use the PORT, IP-ADDRESS/SUBNET-LENGTH and GATEWAY-IP-ADDRESS applicable to your deployment environment.
    ```
      sudo ip address add <IP-ADDRESS>/<SUBNET-LENGTH> dev <PORT>
      sudo ip link set up dev <PORT>
      sudo ip route add default via <GATEWAY-IP-ADDRESS> dev <PORT>
      ping 8.8.8.8
    ```
  
  * Specify user configuration overrides for the Ansible bootstrap playbook.
    ```
      cd ~

      cat <<EOF > localhost.yml

      system_mode: duplex

      dns_servers:
        - 8.8.8.8
        - 8.8.4.4

      external_oam_subnet: <OAM-IP-SUBNET>/<OAM-IP-SUBNET-LENGTH>
      external_oam_gateway_address: <OAM-GATEWAY-IP-ADDRESS>
      external_oam_floating_address: <OAM-FLOATING-IP-ADDRESS>
      external_oam_node_0_address: <OAM-CONTROLLER-0-IP-ADDRESS>
      external_oam_node_1_address: <OAM-CONTROLLER-1-IP-ADDRESS>

      admin_username: admin
      admin_password: <admin-password>
      ansible_become_pass: <sysadmin-password>

      # OPTIONALLY provide a ROOT CA certificate and key for k8s root ca,
      # if not specified, one will be auto-generated,
      # see ‘Kubernetes Root CA Certificate’ in Security Guide for details.
      k8s_root_ca_cert: < your_root_ca_cert.pem >
      k8s_root_ca_key: < your_root_ca_key.pem >
      apiserver_cert_sans:
        - < your_hostname_for_oam_floating.your_domain >

      EOF
    ```

    * Run the Ansible bootstrap playbook:
    ```
    ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml
    ```


* Configure controller-0

  * Acquire admin credentials:
    ```
      source /etc/platform/openrc
    ```
    
  * Configure the OAM interface of controller-0 and specify the attached network as “oam”.

    The following example configures the OAM interface on a physical untagged ethernet port. Use the OAM port name that is applicable to your deployment environment, for example eth0:
    ```
      OAM_IF=<OAM-PORT>
      system host-if-modify controller-0 $OAM_IF -c platform
      system interface-network-assign controller-0 $OAM_IF oam
    ```
    To configure a vlan or aggregated ethernet interface, see Node Interfaces.

  * Configure the MGMT interface of controller-0 and specify the attached networks of both “mgmt” and “cluster-host”.

    The following example configures the MGMT interface on a physical untagged ethernet port. Use the MGMT port name that is applicable to your deployment environment, for example eth1:
    ```
      MGMT_IF=<MGMT-PORT>
      system host-if-modify controller-0 lo -c none
      IFNET_UUIDS=$(system interface-network-list controller-0 | awk '{if ($6=="lo") print $4;}')
      for UUID in $IFNET_UUIDS; do
          system interface-network-remove ${UUID}
      done
      system host-if-modify controller-0 $MGMT_IF -c platform
      system interface-network-assign controller-0 $MGMT_IF mgmt
      system interface-network-assign controller-0 $MGMT_IF cluster-host
    ```
    To configure a vlan or aggregated ethernet interface, see Node Interfaces.

  * Configure NTP servers for network time synchronization:
    ```
      system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org
    ```
    To configure PTP instead of NTP, see PTP Server Configuration.

  * Initialize Ceph-based persistent storage backend

    * Add ceph backend:
    ```
      system storage-backend-add ceph --confirmed
    ```

    * Add an OSD on controller-0:
    ```
      # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
      # By default, /dev/sda is being used as system disk and can not be used for OSD.
      system host-disk-list controller-0
    
      # Add disk as an OSD storage
      system host-stor-add controller-0 osd <disk-uuid>
    
      # List OSD storage devices
      system host-stor-list controller-0* Add ceph
    ```


* Unlock controller-0

  * Unlock controller-0 to bring it into service:
    ```
      system host-unlock controller-0
    ```
    Controller-0 will reboot in order to apply configuration changes and come into service. This can take 5-10 minutes, depending on the performance of the host machine.


* Install software on controller-1 node

  * Power on the controller-1 server and force it to network boot with the appropriate BIOS boot options for your particular server.

  * As controller-1 boots, a message appears on its console instructing you to configure the personality of the node.

  * On the console of controller-0, list hosts to see newly discovered controller-1 host (hostname=None):
    ```
      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | None         | None        | locked         | disabled    | offline      |
      +----+--------------+-------------+----------------+-------------+--------------+
    ```

  * Using the host id, set the personality of this host to ‘controller’:
    ```
      system host-update 2 personality=controller
    ```

  * Wait for the software installation on controller-1 to complete, for controller-1 to reboot, and for controller-1 to show as locked/disabled/online in ‘system host-list’.

    This can take 5-10 minutes, depending on the performance of the host machine.
    ```
      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | locked         | disabled    | online       |
      +----+--------------+-------------+----------------+-------------+--------------+
    ```


* Configure controller-1

  * Configure the OAM interface of controller-1 and specify the attached network of “oam”.

    The following example configures the OAM interface on a physical untagged ethernet port, use the OAM port name that is applicable to your deployment environment, for example eth0:
    ```
      OAM_IF=<OAM-PORT>
      system host-if-modify controller-1 $OAM_IF -c platform
      system interface-network-assign controller-1 $OAM_IF oam
    ```
    To configure a vlan or aggregated ethernet interface, see Node Interfaces.

  * The MGMT interface is partially set up by the network install procedure; configuring the port used for network install as the MGMT port and specifying the attached network of “mgmt”.

    Complete the MGMT interface configuration of controller-1 by specifying the attached network of “cluster-host”.
    ```
      system interface-network-assign controller-1 mgmt0 cluster-host
    ```

  * Add an OSD on controller-1:
    ```
      # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
      # By default, /dev/sda is being used as system disk and can not be used for OSD.
      system host-disk-list controller-1

      # Add disk as an OSD storage
      system host-stor-add controller-1 osd <disk-uuid>

      # List OSD storage devices
      system host-stor-list controller-1
    ```


* Unlock controller-1

  * Unlock controller-1 in order to bring it into service:
    ```
      system host-unlock controller-1
    ```
    Controller-1 will reboot in order to apply configuration changes and come into service. This can take 5-10 minutes, depending on the performance of the host machine.





Remove nginx controller validating webhook, see https://github.com/kubernetes/kubernetes/pull/100449 for background.
```
$ kubectl delete ValidatingWebhookConfiguration ic-nginx-ingress-ingress-nginx-admission
```



Make sure your KUBECONFIG environment variable is set correctly for communicating with your cluster.

Download sonobuoy_<VERSION>_linux_amd64.tar.gz from https://github.com/vmware-tanzu/sonobuoy/releases.

Run:
```
$ sonobuoy run --mode=certified-conformance
```

Wait for sonobuoy status to indicate complete.
```
$ sonobuoy status 
```
Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to a local directory:
```
$ outfile=$(sonobuoy retrieve)
```
This copies a single .tar.gz snapshot from the Sonobuoy pod into your local . directory. Extract the contents into ./results with:
```
mkdir ./results; tar xzf $outfile -C ./results
```
NOTE: The two files required for submission are located in the tarball under plugins/e2e/results/{e2e.log,junit.xml}.

To clean up Kubernetes objects created by Sonobuoy, run:
```
sonobuoy delete
```
