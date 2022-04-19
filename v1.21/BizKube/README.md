# Conformance tests for BizKube

#### * All of the tasks below will be done only on Boot Server

## Download files before installation. Proceed online

-   **Download the file**

```
/bin/bash ${PROJECT_DIR}/pre-ansible/shell/download_files.sh
mv files ${PROJECT_DIR}/pre-ansible
```

-   **Download the container image**

```
cat ${PROJECT_DIR}/pre-ansible/shell/imgs.txt | awk '{print $2}' | xargs -i docker pull {}
cd ${PROJECT_DIR}/pre-ansible/images
docker images |  grep -v REPOSITORY | awk '{split($1":"$2,a,":"); gsub(/\//, "__", $1); system("docker save" " -o " $1"__"$2".tar " a[1]":"a[2]);}'
ls -al | grep tar$ | wc -l (images.txt.bak=92 | images.txt=71 | images.txt.minimal=59)
```

## Getting ready

-   **Declaration of environmental variables**

```
export PROJECT_DIR=${Installation root directory absolute path}
```

-   **Unzip the package file**

```
cd $PROJECT_DIR/pre-ansible/packages/centos7  //모든 노드가 centos7이어야 합니다.
tar xvf packages.tar
```

-   **Install docker and python3 (offline)**

```
yum -y install ${PROJECT_DIR}/pre-ansible/packages/${os_name}${os_major_version}/docker_rpm/*.rpm
yum -y install ${PROJECT_DIR}/pre-ansible/packages/${os_name}${os_major_version}/python3/*.rpm
```

-   **Exchange keys, swapoff**

```
ssh-keygen
ssh-copy-id root@{Nodes}IP
ssh root@각 노드IP sudo swapoff -a
ssh root@각 노드IP sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

## Pre-ansible directory operation

-   **Docker image load**

```
cd ${PROJECT_DIR}/pre-ansible/images  //Image prepared by "Downloading files before installation - Proceeding in an online environment".Tar files. Location
ls -al ${PROJECT_DIR}/pre-ansible/images | grep tar$ | awk '{print $9}' | xargs -i docker load --input {}
```

-   **pre-ansible setting**

```
vi ${PROJECT_DIR}/pre-ansible/hosts.ini (Modify)
vi ${PROJECT_DIR}/pre-ansible/group_vars/all.yml (Modify)

chmod 755 ${PROJECT_DIR}/pre-ansible/shell/*.sh
vi ${PROJECT_DIR}/pre-ansible/shell/0_makecert.sh (IP 수정 -- ${BootStrap server IP})
vi ${PROJECT_DIR}/pre-ansible/shell/1_registry.sh (IP 수정 -- ${BootStrap server IP})
vi ${PROJECT_DIR}/pre-ansible/shell/2_images.sh (REGISTRY_DNS Modify-- ${BootStrap server IP}:${registry port} , IMAGE_LIST_FILE Modify)
```

-   **pre-ansible running**

```
cd ${PROJECT_DIR}/pre-ansible/shell
./0_makecert.sh (CommonName= bootserver의 IP input)
./1_registry.sh

cd ${PROJECT_DIR}/pre-ansible
// Install Python Required Package & Distribute Image Registry Certificate & Distribute Required Legacy Package
pip3 install -r requirements.txt --no-index --find-links file://${PROJECT_DIR}/pre-ansible/packages/${os_name}${os_major_version}/pip-packages
ansible-playbook -i hosts.ini cluster.yml --become --become-user=root --tag set-auth
ansible-playbook -i hosts.ini cluster.yml --become --become-user=root --tag install-packages

// Confirm the distribution of image registry certificates
ansible -i hosts.ini all -m shell -a "curl https://${BootStrap server IP}:${registry port}/v2/_catalog"   (In case of an error, "Re-execute./1_registry.sh after restarting the docker.")
// Confirm the distribution of image registry certificates
docker ps (Check if there are two containers in the air)

// Image registry Push
cd ${PROJECT_DIR}/pre-ansible/shell
./2_images.sh
```

## k8s-ansible working on the directory

-   **Modify download path**

```
vi ${PROJECT_DIR}/k8s-ansible/roles/download/defaults/main.yml (Change the variables below appropriately)

offline: true
bootserver_ip: 192.168.0.XXX
local_img_repository: "{{ bootserver_ip }}:5000"
local_file_repository: "http://{{ bootserver_ip }}:8080"
```

-   **Create a cluster setting file**

```
cd ${PROJECT_DIR}/k8s-ansible
cp -rfp inventory/sample inventory/${CLUSTER_NAME}
declare -a IPS=(192.168.0.XXX 192.168.0.XXX 192.168.0.XXX)
CONFIG_FILE=inventory/${CLUSTER_NAME}/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

-   **Modify bizkube container settings**

```
vi ${PROJECT_DIR}/k8s-ansible/inventory/sample/group_vars/all/all.yml

## bizkube configuration
bizkube_front_tag: "1.0.0"
bizkube_bck_tag: "1.0.0"
bizkube_license_tag: "1.0.0"

bizkube_front_port: "80"
bizkube_bck_port: "8585"
bizkube_license_port: "8080"
bizkube_license_server: "bizkube-license-svc.bizkube:8080"
```


## Run Conformance Test
Follow the conformance suite instructions to test it.

**Download sonobuoy binary release.**

```
URL: "https://github.com/vmware-tanzu/sonobuoy/releases"
```

**Let's decompress**

```
tar -xvf <sonobouy.version>.tar.gz
```

**Sonobouy test**

```
./sonobuoy run --mode=certified-conformance
```

**Check the progress of sonobouy (must end with fail 0)**

```
./sonobouy status
```

**Copy the output to the local directory when you're done**

```
outfile=$(./sonobuoy retrieve)
```

**Extract the contents**

```
mkdir ./results; tar xzf $outfile -C ./results
```

**Check the 2 files you need in the path below**

```
path=plugins/e2e/results/global/{e2e.log,junit_01.xml}
```






