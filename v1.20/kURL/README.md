# kURL 

Setting up kURL for the conformance test will require two linux machines with root access (referred to as node1 and node2). You will run a kURL script on node1 to stand up a single node Kubeternetes cluster. 

For this conformance test we used two of google's n1-standard-4 (4 vCPUs, 15 GB memory) with 100GB standard disk running Ubuntu 18.04.

# Setup

## node1 setup

ssh into node1 and run the following command with root access. 

```
curl -sSL https://k8s.kurl.sh/kurl-conformance-1-20-x | sudo bash
```

This script will download the necessary packages, run tests and configuration setup to get a single node kubernetes cluster with scripts to add additional nodes.


The final output will have a script to join a worker which will be used to setup node2.
```

To add worker nodes to this installation, run the following script on your other nodes:
    curl -fsSL https://kurl.sh/version/v2021.08.16-0/kurl-conformance-1-20-x/join.sh | sudo bash -s kubernetes-master-address=<IP>:6443 kubeadm-token=<TOKEN> kubeadm-token-ca-hash=<HASH> kubernetes-version=<VERSION> primary-host=<IP>
```
Save this script as it will be used to configure node2 in the following step.


## node2 setup

ssh into node2 and run the script to add worker nodes from the node1 setup (see above).

## Run conformance tests

On the first node open a new shell or run `bash -l` to reload the shell which will allow `kubectl` commands with permissions to run the conformance tests.

Follow the k8s-conformance
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests.

The output here was obtained with Sonobuoy 0.53.2 running on a Kubernetes 1.19.13 cluster.
