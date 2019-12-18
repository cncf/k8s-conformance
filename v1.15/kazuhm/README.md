# Conformance testing of Kazuhm Kubernetes

Conformance was tested on hosts running the Kazuhm agent on CentOS Linux 7 (Core).
Make an account with Kazuhm and follow these steps to reproduce the results.

## Install the Kazuhm host agent

Visit the Host Management page, and click Add Hosts. Select the options for 
your platform, and install the Kazuhm agent on each host to be used as a kubernetes 
node.

## Install Kubernetes

Visit the Host Group page, and click Create Host Group. Select Kubernetes as the 
container orchestration type, and select the hosts you just joined to Kazuhm. 

## Connect to the master node

Click the Connect button next to the host group you have just created, and connect 
to the master node with ssh. 

## Run the conformance tests

Download sonobuoy v0.15.4 and add it to your PATH. Then run: 

```bash
sonobuoy run
```
