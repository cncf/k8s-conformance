# HyperCloud

## Create a Kubernetes Cluster
### Prerequisites
Prepare three nodes with CentOS 7 - one for `master node` and the others for `worker node`
### Setup master node
#### Install Kubernetes, CRI-O, Calico, Kubevirt and HyperCloud
1. Download installer file in our repository
    ```
    git clone https://github.com/tmax-cloud/hypercloud_infra_installer.git
    ```
2. Modify `k8s.config` to suit your environment
You need to change the value of `apiServer` to the IP address of master node
    ```
    # skip
    apiServer=172.22.5.2
    # skip
    ```
3. Execute installer script
    ```
    ./k8s_master_install.sh
    ```
4.  Get the join command for worker node
    ```
    kubeadm token create --print-join-command
    ```
    You can get the result in this format:
    ```
    kubeadm join 192.168.122.50:6443 --token mnp5b8.u7tl2cruk73gh0zh     --discovery-token-ca-cert-hash sha256:662a697f67ecbb8b376898dcd5bf4df806249175ea4a90c2d3014be399c6c18a
    ```
5. If you create a single node Kubernetes cluster, you have to untaint the master node
    ```
    kubectl taint nodes --all node-role.kubernetes.io/master-
    ```
6. If the installation process fails, execute uninstaller script then installer script again
    ```
    ./k8s_uninstall.sh
    ./k8s_master_install.sh
    ```
#### Install HyperCloud Storage
- Before installing hypercloud-storage with hcsctl, create yaml files is required for installation and change it to suit your environment.

   ``` shell
   $ hcsctl create-inventory {$inventory_name}
   # Ex) hcsctl create-inventory myInventory
   ```
- Two directories of rook and cdi are created in the created inventory. `./myInventory/rook/*.yaml` are yaml files used for Rook-Ceph installation, and `./myInventory/cdi/*.yaml` are yaml files used for KubeVirt-CDI installation.
- Since all the generated yaml files are for sample provision, you have to use the contents of each yaml file after **modifying to your environment**.<strong> Do not modify the folder and file name. </strong>
- Modify yaml contents created under `./myInventory/rook/` path to fit your environment. Refer to https://rook.github.io/docs/rook/v1.3/ceph-cluster-crd.html
- For yaml files created under the path `./myInventory/cdi/`, you need to change the version of `OPERATOR_VERSION` and container image in the `operator.yaml` file only if you need to change the KubeVirt-CDI version to install.
- After modifying the inventory files to suit the environment, install hypercloud-storage with hcsctl.
   ``` shell
   $ hcsctl install {$inventory_name}
   # Ex) hcsctl install myInventory
   ```

    - When installation is completed normally, you can use hypercloud-storage. After installation, you can use Block Storage and Shared Filesystem.
- Verify whether hypercloud-storage is properly installed with hcsctl.test.
    ``` shell
    $ hcsctl.test
    ```
    - To check whether hypercloud-storage can be used normally, various scenario tests are performed.

### Setup worker nodes
#### Install Kubernetes and CRI-O
1. Download installer file in our repository
    ```
    git clone https://github.com/tmax-cloud/hypercloud_infra_installer.git
    ```
2. Execute installer script
    ```
    ./k8s_node_install.sh
    ```
3. Execute the join command
    ```
    kubeadm join 192.168.122.50:6443 --token mnp5b8.u7tl2cruk73gh0zh     --discovery-token-ca-cert-hash sha256:662a697f67ecbb8b376898dcd5bf4df806249175ea4a90c2d3014be399c6c18a
    ```
4. If the installation process fails, execute uninstaller script then installer script again
    ```
    ./k8s_uninstall.sh
    ./k8s_node_install.sh
    ```

## Run Conformance Tests
1. Download Sonobuoy(0.17.2)
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.2/sonobuoy_0.17.2_linux_amd64.tar.gz
tar -xzf sonobuoy_0.17.2_linux_amd64.tar.gz
```
2. Run Sonobuoy
```
./sonobuoy run --mode=certified-conformance
```
3. Check the status
```
./sonobuoy status
```
4. Once `sonobuoy status` shows the run as `completed`, download the results tar.gz file
```
./sonobuoy retrieve
```
