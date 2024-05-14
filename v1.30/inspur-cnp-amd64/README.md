# Inspur Cloud Naive Platform For AMD64

## Install Inspur Cloud Kubernetes Engine

### Upload CKE package 

Upload cke installation package to master1 node  which will run ansible scripts on.

```shell
scp products.tar.gz master1:/root/

tar -zvxf products.tar.gz
```

### Configuration

Navigate to the deploy folder

```shell
cd /root/products/kubernetes-deploy
```

Custom your inventory config file

```shell
vi my_inventory/my_inventory.cfg
```

Config the parameters for cluster deployment in all.yaml

```shell
vi my_inventory/group_vars/all.yml
```

### Install cluster

Run install scripts

```shell
./install.sh
```

Check out the installation logs

```shell
tail –f /var/log/clustermanage.log
```

This installation should complete without error.

## Run conformance tests

Wait for the cluster and all worker nodes to reach `running` state then follow the
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) and  [installation and configuration instructions](https://github.com/cncf/k8s-conformance/blob/master/faq.md#can-i-provide-a-link-to-the-installation-directions)
to run the conformance tests.
