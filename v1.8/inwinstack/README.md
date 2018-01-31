To reproduce:

```shell
#
$ git clone https://github.com/inwinstack/kube-ansible.git
$ cd inwinkube-ansible
$ ./tools/setup --memory 2048 --network calico -i eth1 --worker 3 --boss 1 --combine-master 0 --combine-etcd 0
Cluster Size: 1 master, 3 worker.
     VM Size: 1 vCPU, 2048 MB
     VM Info: ubuntu16, virtualbox
         CNI: calico, Binding iface: eth1
Start deploying?(y): y
...
# wait for clustr setup

# Launch e2e pod and sonobuoy master.
$ vagrant ssh master1
$ sudo su -
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

# Wait for completion, signified by
# no-exit was specified, sonobuoy is now blocking
$ kubectl logs -f -n sonobuoy sonobuoy

# Copy results from pod
$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results --namespace=sonobuoy
$ tar xfz results/*.tar.gz
```
