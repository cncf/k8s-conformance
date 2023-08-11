# HyperCloud

## HyperCloud Infra
### Prerequisites
- HyperLinux 9.0

### Setup master node
Install Kubernetes, CRI-O, Calico and HyperCloud
1. Download installer file in our repository
    ```
    git clone https://github.com/tmax-cloud/hypercloud_infra_installer.git
    ```
2. Modify `k8s.config` to suit your environment
    * `crioVersion` : cri-o runtime version
    * `k8sVersion` : kubeadm, kubelet, kubectl version
      * CRI-O major and minor versions must match Kubernetes major and minor versions.
      * ex : crioVersion=1.17 k8sVersion=1.17.6        
      * ex : crioVersion=1.18 k8sVersion=1.18.3
      * ex : crioVersion=1.19 k8sVersion=1.19.4
      * ex : crioVersion=1.22 k8sVersion=1.22.2
      * ex : crioVersion=1.25 k8sVersion=1.25.0
    * `apiServer` : The IP address the API Server will advertise it's listening on.
      * ex : apiServer={Kubernetes master IP}
      * ex : apiServer=172.22.5.2
    * `podSubnet` : Pod IPs will be chosen from this range. This should fall within `--cluster-cidr`.
      * ex : podSubnet={POD_IP_POOL}/{CIDR}
      * ex : podSubnet=10.244.0.0/16
    * `calicoVersion` : calico network plugin version(OPTIONAL)
      * If nothing is specified, the default version(v3.24.1) is installed.
      * ex : calicoVersion=3.24.1
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
### Setup worker nodes
Install Kubernetes and CRI-O
1. Download installer file in our repository
    ```
    git clone https://github.com/tmax-cloud/hypercloud_infra_installer.git
    ```
2. Modify `k8s.config` to suit your environment
    * `crioVersion` : cri-o runtime version
    * `k8sVersion` : kubeadm, kubelet, kubectl version
      * CRI-O major and minor versions must match Kubernetes major and minor versions.
      * ex : crioVersion=1.17 k8sVersion=1.17.6        
      * ex : crioVersion=1.18 k8sVersion=1.18.3
      * ex : crioVersion=1.19 k8sVersion=1.19.4
      * ex : crioVersion=1.22 k8sVersion=1.22.2
      * ex : crioVersion=1.25 k8sVersion=1.25.0
3. Execute installer script
    ```
    ./k8s_node_install.sh
    ```
4. Execute the join command
    ```
    kubeadm join 192.168.122.50:6443 --token mnp5b8.u7tl2cruk73gh0zh     --discovery-token-ca-cert-hash sha256:662a697f67ecbb8b376898dcd5bf4df806249175ea4a90c2d3014be399c6c18a
    ```
5. If the installation process fails, execute uninstaller script then installer script again
    ```
    ./k8s_uninstall.sh
    ./k8s_node_install.sh
    ```
## HyperCloud Storage (hcsctl)

`hcsctl` provides installation, removal and management of HyperCloud Storage.

### Prerequisite

- kubectl (>= 1.20)
- kubernetes Cluster
- `lvm2` package (should be installed on storage node)

### Default installed version

- Rook-Ceph v1.9.10

### Getting Started

- Rook-Ceph yaml files are required to install hypercloud-storage. You can easily create them by using hcsctl.

   ``` shell
   $ hcsctl create-inventory {$inventory_name}
   # Ex) hcsctl create-inventory myInventory
   ```
- Then, a directory is created on the current path with the given inventory name. Inside of the inventory directory, a directory is created named as rook.
  - `./myInventory/rook/*.yaml` are yaml files for Rook-Ceph installation
- Please note that all the generated yamls are just for example. Go through each files and change values to suit your host environment
  - **Do not modify the name of folders and files.**
  - Take a look at [rook documentation](https://rook.github.io/docs/rook/v1.7/ceph-cluster-crd.html) before modify each fields under `./myInventory/rook/` path
- After modifying the inventory files to suit the environment, install hypercloud-storage with hcsctl
   ``` shell
   $ hcsctl install {$inventory_name}
   # Ex) hcsctl install myInventory
   ```
    - After installation is completed, you can use HyperCloud Block Storage and Shared Filesystem.

### Uninstall

- Remove hypercloud-storage with hcsctl. You need the same exact inventory name that you installed with hcsctl

    ``` shell
    $ hcsctl uninstall {$inventory_name}
    # Ex) hcsctl uninstall myInventory
    ```
    - You may need additional work to do depends on the message that is displayed when the uninstallation is completed to clean up remaining ceph related data

### Additional features
- In addition to installation and uninstallation, various additional functions are also provided with hcsctl for convenience
- You can set default storageclass following commands
    ```shell
    kubectl patch storageclass {$storageClassName} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
    ```

You can execute following ceph commands with hcsctl.

``` shell
$ hcsctl ceph status
$ hcsctl ceph exec {$ceph_cmd}
# Commands frequently used to check the status are as follows.
$ hcsctl ceph status
$ hcsctl ceph exec ceph osd status
$ hcsctl ceph exec ceph df
```

### Compatibility
- This project has been verified in the following versions.
    - Kubernetes
        - `kubectl` version compatible with each kubernetes server version is required.
        - v1.25
        - v1.22
        - v1.21
        - v1.20
    - OS
        - HyperLinux 9.0
        - Ubuntu 20.04, 18.04
        - CentOS 8.5, 8.1, 7.7
        - ProLinux 7.5, 8.2

## HyperCloud App

### Install HyperCloud application
Install hyperauth, hypercloud-api-server, hypercloud-single-operator, hypercloud-console
1. Modify k8s.config to suit your environment
    * MAIN_MASTER_IP : Your master node's ip address
      * ex : MAIN_MASTER_IP=172.21.7.7
    * MASTER_NODE_ROOT_PASSWORD : Your master node's root password
      * ex : MASTER_NODE_ROOT_PASSWORD=1234
    * MASTER_NODE_ROOT_USER : Your master node's root user
      * ex : Your master node's root password=root
    * HYPERAUTH_VERSION : Hyperauth server version 
      * ref : https://hub.docker.com/r/tmaxcloudck/hyperauth
      * ex : latest

2. Execute installer script in master node
    ```
    ./hypercloud_app_install.sh
    ```


## HyperCloud NFS Storage
### Prerequisites

- All nodes in the k8s cluster require the  `nfs-utils` package to be installed

### Setup all nodes
Install nfs packages

1. install nfs-utils packages
    ```
    sudo yum install -y nfs-utils
    ``` 

### Setup master node
Install NFS-Server, NFS-Provisioning

1. Modify nfs_install.sh 

    - NFS_PATH : NFS directory path
        - ex : NFS_PATH=/mnt/nfs-shared-dir
    - If no directory is specified, the default path is /mnt/nfs-shared-dir

2. Execute NFS installer script

    ```
    ./nfs_install.sh
    ```

3. Enter Master Node IP after Execute NFS installer script

    ```
    ./nfs_install.sh
    Enter Master IP: ex)172.21.7.5
    ```
