# Running conformance tests against Telekube

Get a node or VM which meets the following requirements: https://gravitational.com/telekube/docs/requirements/

Ensure required kernel modules are loaded / sysctl's are set
```console
$ sudo modprobe overlay
$ sudo modprobe ebtables
$ sudo modprobe br_netfilter
$ sudo sysctl -w net.ipv4.ip_forward=1

# On Redhat/Centos only:
$ sudo sysctl -w fs.may_detach_mounts=1
```

Get Telekube
```console
$ curl https://get.gravitational.io/telekube/install | bash
$ tele pull telekube:5.0.0
$ tar -xvf installer.tar
```

Get the IPv4 Address of the node
```console
$ ip a
```

Install Telekube
```console
$ sudo ./gravity install --advertise-addr <ipv4 addr>
```

Enter the gravity container, which holds our kubernetes installation
```console
$ sudo gravity enter
```

Delete all the jobs used during installation so they don't conflict with the testing
```console
18:55:16 root@cncf-conformance-1:/# kubectl get jobs --all-namespaces | awk '{ print $2, "--namespace", $1 }' | while read line; do kubectl delete jobs $line; done
```

k8s conformance tests currently require privileged containers
https://github.com/kubernetes/kubernetes/issues/59978
```console
18:55:16 root@cncf-conformance-1:/# sed -i 's/allow-privileged=false/allow-privileged=true/g' /lib/systemd/system/kube-*
18:55:16 root@cncf-conformance-1:/# systemctl daemon-reload
18:55:16 root@cncf-conformance-1:/# systemctl restart 'kube-*'
```

Run the conformance tests
```
18:55:16 root@cncf-conformance-1:/# curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```
