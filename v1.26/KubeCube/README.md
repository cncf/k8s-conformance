# Conformance tests for KubeCube

## Install KubeCube & K8s

Install KubeCube according to the [documentation](https://www.kubecube.io/docs/installation-guide/all-in-one/#%E5%9C%A8-linux-%E4%B8%8A%E9%83%A8%E7%BD%B2-kubecube).

Step 1: Download Installer and run it.

```shell
$ KUBECUBE_VERSION=v1.8
$ export CUSTOMIZE="true";curl -fsSL https://kubecube.nos-eastchina1.126.net/kubecube-installer/${KUBECUBE_VERSION}/entry.sh | bash
```

Step 2: Modify the config file  `/etc/kubecube/manifests/install.conf`

```
# k8s version you want to install
KUBERNETES_VERSION="1.26.0"
```

Step 3: Run the installer

`$ bash /etc/kubecube/manifests/install.sh`

Step 4: Waiting for installation to complete. The installation is complete when you see the following information

```shell
========================================================
========================================================
               Welcome to KubeCube!
         Please use 'admin/admin123' to access
                '123.58.176.150:30080'
         You must change password after login
========================================================
========================================================
```

Step 5: Delete the validatingwebhook of Nginx-Ingress, due to [this K8s issue](https://github.com/kubernetes/kubernetes/pull/100449#issuecomment-804788806). 

`kubectl delete validatingwebhookconfiguration ingress-nginx-admission`

## Add Node

Add Node according to the [documentation](https://www.kubecube.io/docs/installation-guide/add-k8s-node/).

**Be attention:** the node need to be able to access k8s master node through ssh.

Step 1: Download installer

```shell
$ KUBECUBE_VERSION=v1.8
$ export CUSTOMIZE="true";curl -fsSL https://kubecube.nos-eastchina1.126.net/kubecube-installer/${KUBECUBE_VERSION}/entry.sh | bash
```

Step 2: Modify the config file  `/etc/kubecube/manifests/install.conf`

```
INSTALL_KUBECUBE_PIVOT="false"
NODE_MODE="node-join-master"
MASTER_IP="<the master node IP>"
KUBERNETES_VERSION="1.26.0"

# +optional
# the user who can access master node, it can be empty
SSH_USER="root"

# +optional
# the port specified to access master node, it can be empty
# when NODE_MODE="master" or "control-plane-master"
SSH_PORT=22

# +optional
# must be empty when ACCESS_PRIVATE_KEY_PATH set
# password for master user to access master node
ACCESS_PASSWORD=""

# +optional
# must be empty when ACCESS_PASSWORD set
# ACCESS_PRIVATE_KEY for master user to access master node
ACCESS_PRIVATE_KEY_PATH="<path of ssh private key>"
```

Step 3: Run the installer

`$ bash /etc/kubecube/manifests/install.sh`

Step 4: Waiting for installation to complete. The installation is complete when you see the following information.

```shell
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

## Run Conformance Test

Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.

1. Download sonobuoy  [binary release](https://github.com/vmware-tanzu/sonobuoy/releases).

   ````shell
   $ go get -u -v github.com/vmware-tanzu/sonobuoy
   ````

1. Run sonobuoy

   ```shell
   $ sonobuoy run --mode=certified-conformance
   ```

1. Check the status

   ```shell
   $ sonobuoy status
   ```
   
1. Once the status commands shows the run as completed, you can download the results tar.gz file

   ```shell
   $ sonobuoy retrieve
   ```

