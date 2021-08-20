# kURL

To get started, you'll first need to set up two linux nodes. We used Ubuntu 18.04 nodes. 

# Install kURL on 1st node

## Install 

curl -sSL https://k8s.kurl.sh/kurl-conformance-1-19-x | sudo bash

## Install Completion

The final lines should look something like... 
```
To generate new node join commands, run curl -fsSL https://kurl.sh/version/v2021.08.16-0/kurl-conformance-1-19-x/tasks.sh | sudo bash -s join_token on this node.

To add worker nodes to this installation, run the following script on your other nodes:
    curl -fsSL https://kurl.sh/version/v2021.08.16-0/kurl-conformance-1-19-x/join.sh | sudo bash -s kubernetes-master-address=10.138.15.196:6443 kubeadm-token=vifep2.uy7q1gryimm1y3w0 kubeadm-token-ca-hash=sha256:7bcd75fa2124bd367fb788b383ffd0de4690a373b59b176094169e9a8313ac1d kubernetes-version=1.19.13 primary-host=10.138.15.196
```

# Add 2nd node as worker

Run the script to add worker nodes to this instllation:
```
curl -fsSL https://kurl.sh/version/v2021.08.16-0/kurl-conformance-1-19-x/join.sh | sudo bash -s kubernetes-master-address=10.138.15.196:6443 kubeadm-token=vifep2.uy7q1gryimm1y3w0 kubeadm-token-ca-hash=sha256:7bcd75fa2124bd367fb788b383ffd0de4690a373b59b176094169e9a8313ac1d kubernetes-version=1.19.13 primary-host=10.138.15.196
```

## Run conformance tests

On the first node run `bash -l` to reload the shell which will enabled the `kubectl` commands with permissions to run the conformance tests.

Follow the k8s-conformance
[test instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)
to run the conformance tests.

The output here was obtained with Sonobuoy 0.53.2 running on a Kubernetes 1.19.13 cluster.
