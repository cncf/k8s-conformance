# Kubernetes Conformance Tests on Intel Distribution of OpenNESS

## Intel Distribution of OpenNESS (IDO) Setup

For access to this Intel Distribution of OpenNESS, please contact your Intel representative or request access via [link](https://www.openness.org/products/intel-distribution)

The Intel Distribution of OpenNESS Converged Edge Experience Kit [IDO CEEK](https://github.com/open-ness/ido-converged-edge-experience-kits) repository contains a set of Ansible playbooks for the easy setup of OpenNESS.

To be able to reproduce these conformance results, user need to create 1 Edge Controller (OpenNESS Kubernetes Control Plane node) and 2 Edge Node (OpenNESS Kubernetes node) setup with deployment flavor - [minimal](https://github.com/open-ness/ido-specs/blob/master/doc/flavors.md#cera-minimal-flavor). The detailed deployment instructions are available in [Quickstart Guide](https://github.com/open-ness/ido-specs/blob/master/doc/getting-started/openness-cluster-setup.md#quickstart)

## Preconditions

To use the playbooks, ensure the following preconditions are fulfilled. Detailed steps are available in github [Preconditions](https://github.com/open-ness/ido-specs/blob/master/doc/getting-started/openness-cluster-setup.md#preconditions) section

  - CentOS* 7.9.2009 must be installed on hosts where the product is deployed. It is highly recommended to install the operating system using a minimal ISO image on nodes that will take part in deployment.
  - Hosts for the Edge Controller (Kubernetes control plane) and Edge Nodes (Kubernetes nodes) must have proper and unique hostnames (i.e., not localhost). This hostname must be specified in /etc/hosts.
     ```shell
     127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 <host_name>
     ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6 <host_name>
     ```
  - SSH keys must be exchanged between hosts, [refer steps](https://github.com/open-ness/ido-specs/blob/master/doc/getting-started/openness-cluster-setup.md#exchanging-ssh-keys-between-hosts)
  
## Running Playbooks

Playbooks can be executed by running deployment script from the Ansible host.

1. Pull the Intel Distribution of OpenNESS Converged Edge Experience Kit repository in the ansible host.

   ```shell
   mkdir -p ~/conformance/
   cd ~/conformance/
   git clone --recursive https://github.com/open-ness/ido-converged-edge-experience-kits
   cd ./ido-converged-edge-experience-kits
   ```

2. Install pre-requisite tools for the the deployment script

   ```shell
   $ sudo scripts/ansible-precheck.sh
   ```

3. Configure the Ansible inventory file with information about the cluster nodes and the intended deployment flavor.\
   [Refer - Configuring the inventory file](https://github.com/open-ness/ido-specs/blob/master/doc/getting-started/openness-cluster-setup.md#configuring-the-inventory-file) \
   Example:

   ```shell
   vi inventory.yml
   ```

   ```yaml
   ---
   all:
     vars:
       cluster_name: ido_cncf         # NOTE: Use `_` instead of spaces.
       flavor: minimal                # NOTE: Flavors can be found in `flavors` directory.
       single_node_deployment: false  # Request single node deployment (true/false).
       limit:                         # Limit ansible deployment to certain inventory group or hosts
   controller_group:
     hosts:
       controller:
         ansible_host: <host ip address>
         ansible_user: openness       # non-root user and ssh keys exchanged
   edgenode_group:
     hosts:
       node01:
         ansible_host: <host ip address>
         ansible_user: openness      # non-root user and ssh keys exchanged
       node02:
         ansible_host: <host ip address>
         ansible_user: openness      # non-root user and ssh keys exchanged
   edgenode_vca_group:
     hosts:
   ptp_master:
     hosts:
   ptp_slave_group:
     hosts:
   ```

4. Update the GitHub token for private repository access in `inventory/default/group_vars/all/10-open.yml` file.

   ```shell
   git_repo_token: ""
   ```

5. If a proxy is required to connect to the internet, update `inventory/default/group_vars/all/10-open.yml` as follows:\
   [Example](https://github.com/open-ness/ido-specs/blob/master/doc/getting-started/openness-cluster-setup.md#setting-proxy)

   - Edit the proxy_ variables in the inventory/default/group_vars/all/10-open.yml file.
   - Set the proxy_enable variable in inventory/default/group_vars/all/10-open.yml file to true.
   - Append the network CIDR (e.g., 192.168.0.1/24) to the proxy_noproxy variable in inventory/default/group_vars/all/10-open.yml

6. Additional configurations should be applied to the default group_vars file as required: `inventory/default/group_vars/all/10-open.yml`\
   More details on the default values is explained in the [default values](https://github.com/open-ness/ido-specs/blob/master/doc/getting-started/converged-edge-experience-kits.md#default-values) section.

7. Get the deployment started by executing the deploy script

   ```shell
   python3 deploy.py
   ```

   Once the deployment succeeds without an error, proceed to run the K8s conformance tests with Sonobuoy.

## Run K8s Conformance Tests with Sonobuoy

The conformance tests are run according to the [instructions](https://github.com/vmware-tanzu/sonobuoy/) available on the github.

1. Download and Install Sonobuoy in host configured as Edge Controller:

   ```shell
   wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.20.0/sonobuoy_0.20.0_linux_amd64.tar.gz
   tar -xvzf sonobuoy_0.20.0_linux_amd64.tar.gz
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
