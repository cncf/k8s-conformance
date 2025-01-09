# Kubernetes Cluster Setup 

This guide outlines the steps to install necessary components on the master and worker nodes of a CKP cluster, verify the cluster status, and run Sonobuoy tests for cluster conformance and diagnostics.

## 1. Prerequisites
1. 3 Virtual Nodes with Ubuntu 22.04 LTS installed and connectivity with each other.
3. Kubernetes Cluster Hardware Recommendations :
   - CPU 8 
   - Memory 32 GB  with SWAP disabled
   - Disk 40 GB
   - 1 NIC card - 100 MBPS
5. Internet Connectivity to download the installers on Master and Worker node.
6. Passwordless sudo access in the VMs

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
./master-installer.sh "v1.30.6" "<master-node-ip>"
```

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

Download and unpack the latest release of sonobuoy with:
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz
tar -xzvf sonobuoy_0.57.1_linux_amd64.tar.gz -C /tmp
sudo cp  /tmp/sonobuoy  /usr/local/bin/
```

Start sonobuoy tests - these will take >1hr to complete:

```
sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=node-role.kubernetes.io/control-plane --ginkgo.v" --mode=certified-conformance --kubernetes-version="v1.30.6"
```

Check test status:

```
sonobuoy status
PLUGIN     STATUS   RESULT   COUNT                 PROGRESS
            e2e    running                1   Passed:230, Failed:  0
   systemd-logs   complete                2                         

Sonobuoy is still running. Runs can take 60 minutes or more depending on cluster and plugin configuration.
```

The tests should all pass:
```
sonobuoy status
         PLUGIN     STATUS   RESULT   COUNT   PROGRESS
            e2e   complete   passed       1           
   systemd-logs   complete   passed       3           

Sonobuoy has completed. Use `sonobuoy retrieve` to get results.
```

Retrieve the results:
```
sonobuoy retrieve
202412031902_sonobuoy_5e4dae00-68b1-4fb1-b460-f3e10e389c12.tar.gz
```

Untar the results:
```
tar xvf 202412031902_sonobuoy_5e4dae00-68b1-4fb1-b460-f3e10e389c12.tar.gz
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
