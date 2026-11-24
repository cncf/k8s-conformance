# Kubernetes Cluster Setup

This guide outlines the steps to install necessary components on the master and worker nodes of a CKP cluster, verify the cluster status, and run Sonobuoy tests for cluster conformance and diagnostics.

## 1. Prerequisites
1. 3 Virtual Nodes with Ubuntu 22.04 LTS installed and connectivity with each other.
2. Kubernetes Cluster Hardware used for this run (per node):
   - CPU 4
   - Memory 8 GB with SWAP disabled
   - Disk 100 GB
   - 1 NIC card
3. Internet Connectivity to download the installers on Master and Worker node.
4. Passwordless sudo access in the VMs.
5. Update the packages on every node first and reboot if asked, so that the automatic update service does not hold the package lock while the installer runs:
```bash
sudo apt update && sudo apt upgrade -y
```

## 2. Master Node Setup
### Download the Installer on the Master Node

Use `curl` to download the installer.
```bash
curl -o master-installer.sh https://coredgerepo.blob.core.windows.net/ckp-scripts/master-init.sh
```
### Provide Execute Access to the Installer
```bash
chmod +x master-installer.sh
```
### Execute the Installer

Follow the provided steps to execute the installer. This is an example command; your actual command might differ.

```bash
./master-installer.sh "v1.37.2" "<master-node-ip>"
```
The cluster network is Flannel, installed by the script.

## 3. Adding Worker Nodes

Perform these steps on each worker node.

```bash
curl -o worker_installer.sh https://coredgerepo.blob.core.windows.net/ckp-scripts/worker-addition.sh
```

### Provide Execute Permission

```bash
chmod +x worker_installer.sh
```

### Update the join environment variables.
The master init script executed in the control-plane node will generate a env file in path `/tmp/join_env` , copy it to the `/tmp` in the worker node

### Execute the Installer

Follow the provided steps to execute the installer. This is an example command; your actual command might differ.

```bash
./worker_installer.sh
```

## 4. Check the Kubernetes Cluster Status

Verify the status of your Kubernetes cluster by checking the nodes.

```bash
kubectl get nodes
```

## 5. Sonobuoy Conformance Test

Download and unpack the release of sonobuoy with:
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.5/sonobuoy_0.57.5_linux_amd64.tar.gz
tar -xzvf sonobuoy_0.57.5_linux_amd64.tar.gz -C /tmp
sudo cp  /tmp/sonobuoy  /usr/local/bin/
```

Start sonobuoy tests - these will take >1hr to complete:

```
sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/control-plane --ginkgo.v" --mode=certified-conformance --kubernetes-version="v1.37.2"
```

Check test status:

```
sonobuoy status
```

The tests should all pass:
```
sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT   PROGRESS
            e2e   complete   passed       1           
   systemd-logs   complete   passed       3           

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```
Result of this run: Ran 462 of 3206 Specs in 7125.127 seconds SUCCESS! -- 462 Passed | 0 Failed | 0 Pending | 2744 Skipped

Retrieve the results:
```
sonobuoy retrieve
```

Untar the results:
```
tar xvf <the retrieved archive>.tar.gz
```

Go to the results folder:
```
cd plugins/e2e/results/global
```

Make sure the following two files are there:
```
ls
e2e.log  junit_01.xml
```

