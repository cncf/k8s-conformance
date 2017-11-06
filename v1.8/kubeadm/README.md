### kubeadm

Official documentation:
 - https://kubernetes.io/docs/setup/independent/install-kubeadm/
 - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

#### How to reproduce:

Operating System used for these sample reproduction steps: Ubuntu 17.10

```console
$ whoami
root
$ apt-get update && apt-get install -y apt-transport-https
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
$ echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
$ apt-get update && apt-get install -y kubelet kubeadm kubectl docker.io
$ kubeadm init
$ export KUBECONFIG=/etc/kubernetes/admin.conf
$ kubectl apply -f https://git.io/weave-kube-1.6
$ kubectl taint nodes --all node-role.kubernetes.io/master-
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
$ # Wait for `kubectl -n sonobuoy logs sonobuoy` to display "no-exit was specified, sonobuoy is now blocking"
$ kubectl -n sonobuoy cp sonobuoy:${UNIQUELY_GENERATED_PATH_FROM_LOGS}.tar.gz sonobuoy.tar.gz
$ tar -xzf sonobuoy.tar.gz
$ # Sonobuoy results available!
```
