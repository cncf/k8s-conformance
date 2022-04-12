# Kubernetes Conformance Tests on Intel® Smart Edge Open

## Intel® Smart Edge Open

Intel® Smart Edge Open simplifies the process of creating edge solutions capable of hosting network functions alongside AI, media processing, and security workloads. It also brings together tools from across the cloud-native landscape that have been extended, and optimized into blueprints for building edge platforms. This toolkit is designed to meet the challenges of edge computing, such as resource constraints, network performance, and security.

## Developer Experience Kit

The Intel® Smart Edge Open Developer Experience Kit [SEO DEK](https://github.com/smart-edge-open/open-developer-experience-kits) lets you explore the toolkit under an Apache 2.0 license. This foundational kit can be used to create solutions for any edge location. The detailed deployment instructions for DEK single node cluster using [Edge Software Provisioner](https://github.com/intel/Edge-Software-Provisioner) are available in [Get Started](https://smart-edge-open.github.io/docs/experience-kits/developer-experience-kit/) section. 

To be able to reproduce these conformance results, user need to create 1 Edge Controller (DEK Kubernetes Control Plane node) and 2 Edge Node (DEK Kubernetes node) setup with Intel® SEO Developer Experience Kit using deployment script [deploy.sh](https://github.com/smart-edge-open/open-developer-experience-kits/blob/main/deploy.sh).

## Preconditions

To use the playbooks, ensure the following preconditions are fulfilled.

  - Ubuntu 20.04.2 LTS must be installed on hosts where the product is deployed. <br>It is highly recommended to install the operating system using a minimal ISO image on nodes that will take part in deployment.
  - Hosts for the Edge Controller (Kubernetes control plane) and Edge Nodes (Kubernetes nodes) must have proper and unique hostnames (i.e., not localhost). This hostname must be specified in /etc/hosts.
     ```shell
     127.0.0.1  localhost <host_name>
     127.0.1.1  <host_name>
     ::1        ip6-localhost ip6-loopback <host_name>
     ```
  - SSH keys must be exchanged between hosts 
  
## Running Playbooks

Playbooks can be executed by running deployment script from the Ansible host.

1. Pull the Intel® SEO Developer Experience Kit repository in the ansible host.

   ```shell
   mkdir -p ~/conformance/
   cd ~/conformance/
   git clone --branch smart-edge-open-21.12 https://github.com/smart-edge-open/open-developer-experience-kits.git
   cd ./open-developer-experience-kits/
   ```

2. Install pre-requisite tools in ansible host for the the deployment script

   ```shell
   $ sudo scripts/ansible-precheck.sh
   ```

3. Configure the Ansible [inventory file](https://github.com/smart-edge-open/open-developer-experience-kits/blob/main/inventory.yml) with information about the cluster nodes - \
   Example:

   ```shell
   vi inventory.yml
   ```

   ```yaml
   ---
   all:
      vars:
         cluster_name: dek_test        # NOTE: Use `_` instead of spaces.
         deployment: dek               # NOTE: Available deployment type: Developer expirience kits (dek).
         single_node_deployment: false # Request single node deployment (true/false).
         limit:                        # Limit ansible deployment to certain inventory group or hosts
   controller_group:
      hosts:
         controller:
            ansible_host: <host ip address>
            ansible_user: smartedge-open
   edgenode_group:
      hosts:
         node01:
            ansible_host: <host ip address>
            ansible_user: smartedge-open
         node02:
            ansible_host: <host ip address>
            ansible_user: smartedge-open
   ```

4. If a proxy is required to connect to the internet, update `inventory/default/group_vars/all/10-default.yml` as required.

   - Edit the `proxy_env` section variables in the `inventory/default/group_vars/all/10-default.yml` file.
   - Append the network CIDR (e.g., 192.168.0.1/24) to the no_proxy variable in inventory/default/group_vars/all/10-default.yml.   

5. Additional configurations may be applied to the default group_vars file as required: `inventory/default/group_vars/all/10-default.yml`

   - Enable/Disable target host time synchronization with NTP server `ntp_servers: []`
   - Configure docker registry mirrors via options `docker_registry_mirrors` and `docker_insecure_registries`
   - Disable SR-IOV Network Operator configuration, If the target edge nodes are not provisioned with SR-IOV capable NICs.
      ```yaml
      sriov_network_operator_enable: false
      ```
      If the NIC adapter provisioned in target node different than the [Validated NIC](https://smart-edge-open.github.io/docs/experience-kits/developer-experience-kit/#target-system-requirements), User may update the SR-IOV interface names in `inventory/default/group_vars/all/10-default.yml`
      ```yaml
      # Nic names for the SR-IOV Network Operator
      cvl_sriov_nics:
      Debian:
         c0p0:
         ...
      ```

6. Disable optional security features in edge node as it requires DEK cluster in the cloud that hosts Intel® IsecL and Intel® SGX control plane services.
   ```yaml
   sgx_enabled: false
   platform_attestation_node: false
   ```

7. Get the deployment started by executing the deploy script

   ```shell
   ./deploy.sh
   ```

   Once the deployment succeeds without an error, proceed to run the K8s conformance test suite with Sonobuoy.

## Run K8s Conformance Tests with Sonobuoy

The conformance tests are run according to the [instructions](https://github.com/vmware-tanzu/sonobuoy/) available on the github.

1. Download and Install Sonobuoy in host configured as Edge Controller:

   ```shell
   wget wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.55.1/sonobuoy_0.55.1_linux_amd64.tar.gz
   tar -xvzf sonobuoy_0.55.1_linux_amd64.tar.gz
   mv sonobuoy /usr/bin/
   chmod +x /usr/bin/sonobuoy
   ```

2. Run Conformance with Sonobuoy:
   ```shell
   sonobuoy run --mode certified-conformance
   ```

3. Check the test run status:
   ```shell
   sonobuoy status
   ```

4. Once the test status prompts 'Complete', download the sonobuoy results file:
   ```shell
   sonobuoy retrieve
   sonobuoy results <tar.gz file>
   ```
   add e2e.log & junit_01.xml files from ./plugins/e2e/results/global/

5. Cleanup the sonobuoy pods
   ```shell
   sonobuoy delete
   ```