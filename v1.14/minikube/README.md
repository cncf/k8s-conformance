Download and install minikube 1.0
```shell
$ curl -LO https://storage.googleapis.com/minikube/releases/v1.0.0/minikube-linux-amd64 && sudo install minikube-linux-amd64 /usr/local/bin/minikube
```
Instructions for running minikube on macOS and Windows are also [here](https://github.com/kubernetes/minikube)

Start minikube and make sure it's up.
```shell
$ minikube start --vm-driver=kvm2
$ minikube status
```

Run [Sonobuoy](https://github.com/heptio/sonobuoy) as instructed [here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).
