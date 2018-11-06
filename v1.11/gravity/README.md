# Running conformance tests against Gravity

Get a node or VM which meets the following requirements: https://gravitational.com/telekube/docs/requirements/


Get Gravity
```console
$ curl https://get.gravitational.io/telekube/install | bash
$ tele pull telekube:5.2.3
$ tar -xvf telekube-5.2.3.tar
```

Install Gravity
```console
$ sudo ./gravity install
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
gravity-conformance-2:/$ curl -L https://github.com/heptio/sonobuoy/releases/download/v0.12.0/sonobuoy_0.12.0_linux_amd64.tar.gz -o sonobuoy.tar.gz
gravity-conformance-2:/$ tar -zxvf sonobuoy.tar.gz
gravity-conformance-2:/$ ./sonobuoy run
```
