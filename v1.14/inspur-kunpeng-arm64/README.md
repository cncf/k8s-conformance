# Inspur Open Platform for ARM

## Prerequisites

- Linux Host OS (UOS sp1, GNU/Linux 4.19.0, aarch64)
- User SSH Key (~/.ssh/id_rsa & ~/.ssh/id_rsa.pub)
- Product installation package (includes images like hyperkube-arm64:v1.14.3 and the deployment scripts,etc.)

## Install Inspur Cloud Kubernetes Engine

### Pull CKE image 

Pull cke installation image to master1 node which will run install scripts on.

```shell
docker pull registry-ga.inspur.live:5001/cke/ansible-arm64:3.26.4
```

### Configuration

Create config files' folder

```shell
mkdir /my_inventory
```
Custom your inventory config file

```shell
vi /my_inventory/my_inventory.cfg
```

Config the parameters for cluster deployment in all.yaml

```shell
vi /my_inventory/group_vars/all.yml
```

### Install cluster

Run install image

```shell
docker run -it -v /root/.ssh/:/root/.ssh/ -v /my_inventory/:/etc/lcm/ --net host registry-ga.inspur.live:5001/cke/ansible-arm64:3.26.4 /bin/playbook
```

This installation should complete without error.

## Run conformance tests

Wait for the cluster and all worker nodes to reach `running` state then follow the
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests.