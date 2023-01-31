![Rafay_Logo](Rafay_Logo.svg)

# Rafay Certification Results

A SaaS-first Kubernetes Operations Platform with enterprise-class scalability, zero-trust security and interoperability for managing applications across public clouds, data centers & edge.
It manages the distribution and scaling of containerized microservices across one or many Kubernetes clusters. It supports intent-based
placement to simplify day-2 operations for distributed applications.

# Rafay Installation Steps:-

Non-HA (Single Node) Cluster

A single node, converged cluster (single node, single master node) that can be expanded with additional worker nodes if required. This configuration is suited for a wide variety of production and non-production workload profiles where managing costs may be important.

Single Node, Non-HA Cluster

Requirements

Resource	Minimum Specifications
Number of Nodes	One (1) Node
Operating System	Ubuntu Linux (64-bit), 18.0.4 LTS
Memory per Node	64GB
vCPUs per Node	Sixteen (16)
GPU (OPTIONAL)	NVIDIA
Storage	>500GB (raw, unformatted)
Note that it is not possible to upgrade a "Non HA Cluster" to a "HA Cluster" and vice versa.

### STEP 1: Prepare Infrastructure

Create an instance compliant with the single node infrastructure requirements. Configure and test SSH access to the instance.

### STEP 2: Create a Cluster

Login into the Ops Console. When you access for the very first time into the Ops Console, you will notice that there are no clusters available.

Click on New Cluster
Provide a unique name for the cluster
Select a location for the cluster from the drop down list
Enable "Approve Nodes Automatically" if you have a controlled environment and do not wish to have an "approval gate" for nodes to join a cluster.
NOTE: Auto Approval of nodes can help streamline cluster provisioning and expansion workflows by eliminating the "manual" approval gate.

Select the GPU option ONLY if you intend to provide GPUs in the cluster nodes
Do not Select the High Availability option because we are deploying a single node, non HA cluster
Click Save.
Create On Prem Cluster

Faq
Admins can add custom locations by clicking on Cluster Locations on the bottom left panel and then select from the dropdown

### STEP 3: Download Installer

Review the Node Installation Instructions section on the right.
Download the Installer, Passphrase and Credential files
SCP the three (3) files to the instance you created in Step 1
Note that the passphrase and credentials are unique per cluster and you cannot reuse this for other clusters.

An illustrative example is provided below. This assumes that you have the three downloaded files in the current working directory. The three files will be securely uploaded to the “/tmp” folder on the instance.

```shell
$ scp -i <keypairfile.pem> * ubuntu@<Node's External IP Address>:/tmp
```

### STEP 4: Run Preflight Checks

Customers are strongly recommended to run a preflight check on every node to ensure that the node has "compatible" hardware, software and network settings. The checks that are run are as follows:

#	Description and Type of Preflight Checks
1.	Compatible OS and Version
2.	Minimum CPU Resources
3.	Minimum Memory Resources
4.	Outbound Internet Connectivity
5.	Ability to Connect to the Controller
6.	DNS Lookup of Controller
7.	MTLS to Controller
8.	Is Time Synchronized
9.	Minimum and Compatible Storage
10.	Containerd Already Installed
11.	Kubernetes Already Installed
SSH into the node and run the installer using the provided passphrase and credentials.
From the node installation instructions, copy the preflight check command and run it
An illustrative example is shown below where the "preflight checks" detected an incompatible node for provisioning.

```shell
tar -xjf conjurer-linux-amd64.tar.bz2 && sudo ./conjurer -edge-name="onpremcluster" -passphrase-file="onpremcluster-passphrase.txt" -creds-file="onpremcluster-credentials.pem" -t
```

[+] Performing pre-tests
    [+] Operating System check
    [+] CPU check
    [+] Memory check
    [+] Internet connectivity check
    [+] Connectivity check to rafay registry
    [+] DNS Lookup to the controller
    [+] Connectivity check to the Controller
    !INFO: Attempting mTLS connection to salt.core.stage.rafay-edge.net:443
    [+] Multiple default routes check
    [+] Time Sync check
    [+] Storage check
    !WARNING: No raw unformatted volume detected with more than 50GB. Cannot configure node as a master or storage node.

[+] Detected following errors during the above checks
    !ERROR: System Memory 28GB is less than the required 32GB.
    !ERROR: Detected a previously installed version of Docker on this node. Please remove the prior Docker package and retry.
    !ERROR: Detected a previously installed version of Kubernetes on this node. Please remove the prior Kubernetes packages (kubectl, kubeadm, kubelet,kubernetes-cni, etc.) and retry.

### STEP 5: Run Installer

From the node installation instructions, copy the provided command
SSH into the node and run the installer using the provided passphrase and credentials.
An illustrative example provided below

```shell
sudo ./conjurer -edge-name="onpremcluster" -passphrase-file="onpremcluster-passphrase.txt" -creds-file="onpremcluster.pem -t
```
[+]  Initiating edge node install

[+] Provisioning node
      [+] Step 1. Installing node-agent
      [+] Step 2. Setting hostname to node-72djl2g-192-168-0-20-onpremcluster
      [+] Step 3. Installing credentials on node
      [+] Step 4. Configuring node-agent
      [+] Step 5. Starting node-agent

[+] Successfully provisioned node
The Rafay installer deploys a “bootstrap agent” onto the Linux instance. This bootstrap agent connects to the Rafay Controller, authenticates and registers itself with the provided credentials.

Once this step is complete, the node will show up on the Ops Console as DISCOVERED.

### STEP 6: Approve Node

This approval process is a security control to ensure that operators are in the approval loop before nodes can register themselves as part of a Rafay cluster.

Click on Approve button to approve the node to this cluster.
Notice that this will update the status to “Approved" in a few seconds.
Once approved, the agent automatically probes and populates all information about the node on the Ops-Console.

### STEP 7: Configure Node

This configuration step allows the infrastructure administrator to specify the “role” for the node. They will also provide critical information such as Internet IP address and storage details for the node.

For a single node, non HA cluster, the same node will assume both roles i.e. Ingress and Storage roles.

Click on Configure
Select the “Ingress” role and provide the node’s Public IP address
Select the “Storage” role and select the storage location (unformatted, raw block device) from the drop down list.
Click Save

### STEP 8: Provision Node

At this point, we have provided everything necessary to deploy and configure the necessary software to operationalize the cluster.

Click on Provision
A progress bar is displayed showing progress as the installer automatically downloads and installs all required components on the node. The entire provisioning process can take ~15 minutes end to end.

Once provisioning is complete, the cluster will report itself as “READY" to accept workloads.

The Rafay system manages the distribution and scaling of containerized
microservices across one or many Kubernetes clusters. It supports intent-based
placement to simplify day-2 operations for distributed applications.

You can use your own private clusters or a Rafay sandbox of clusters. To
reproduce the certification results you will need kubectl access (and more), so
you must use a private cluster (not the sandbox, which are Rafay-managed).
Instructions for joining a cluster to the Rafay system is in the [product
documentation](https://docs.rafay.co/)



## Steps to Reproduce

``` shell
ssh # to a K8S master node in your Rafay cluster
```

Install and run [sonobuoy](https://github.com/heptio/sonobuoy) as instructed on
[k8s-conformance](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).

Submit the results.
