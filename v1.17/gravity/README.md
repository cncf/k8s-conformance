# Running conformance tests against Gravity

Get two nodes or VM which meets the gravity requirements: https://gravitational.com/telekube/docs/requirements/


Get Gravity Tools
```console
$ curl https://get.gravitational.io/telekube/install | bash
$ tele pull gravity:6.3.6
$ tar -xvf gravity-6.3.6.tar
```

Install Gravity
```console
$ sudo ./gravity install --cloud-provider=generic
```

Expand the cluster to 2 nodes since the conformance suite requires at least 2 nodes.
```console
$ sudo ./gravity join --token=<token> --role=knode
```

Enter the gravity container on node 1, which holds our kubernetes installation
```console
$ sudo gravity enter
```

Delete all the jobs used during installation so they don't conflict with the testing
```console
18:55:16 root@cncf-conformance-1:/# kubectl get jobs --all-namespaces | awk '{ print $2, "--namespace", $1 }' | while read line; do kubectl delete jobs $line; done
```


Run the conformance tests
```
gravity-conformance-2:/$ curl -L https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.2/sonobuoy_0.17.2_linux_amd64.tar.gz -o sonobuoy.tar.gz
gravity-conformance-2:/$ tar -zxvf sonobuoy.tar.gz
gravity-conformance-2:/$ ./sonobuoy run --mode=certified-conformance
```
