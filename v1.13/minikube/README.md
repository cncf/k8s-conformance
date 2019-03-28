Download and install minikube 0.35
```shell
$ curl -LO https://storage.googleapis.com/minikube/releases/v0.35.0/minikube-linux-amd64 && sudo install minikube-linux-amd64 /usr/local/bin/minikube
```
Instructions for running minikube on macOS and Windows are also
[here](https://github.com/kubernetes/minikube)

Start minikube and make sure it's up.
```shell
$ minikube start
$ minikube status
```

Run [Sonobuoy](https://github.com/heptio/sonobuoy) as instructed

[here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).
