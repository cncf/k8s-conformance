# ZStack Edge

Cloud-Native application platform based on Kubernetes

## Install a Kubernetes cluster using ZStack Edge installation package

1.SSH to the node

2.Configure the SSH secret key trust between this node and other nodes (including its own node)

3.Unpack the ZStack Edge installation package

4.Install ansible
```
cd /root/kubespray
chmod +x setup-ansible.sh
./setup-ansible.sh
```
5.Install the Kubernetes cluster

```cd /root/kubespray ansible-playbook -i inventory/sample/hosts.yaml cluster.yml```

## Deploy sonobuoy Conformance test
Follow the conformance suite instructions [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running) to test it.