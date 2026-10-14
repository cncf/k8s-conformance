## To reproduce:
#### Creating a cluster with KubeClipper

Step 1: Download kcctl.
It's recommended to install using root user.
```
curl -sfL https://oss.kubeclipper.io/kcctl.sh | KC_VERSION=master bash -
```

Step 2: Get Started With Installation.
It's recommended to install using root user, the /root/key is common key for deploy machines.
```
kcctl deploy --server 172.18.187.220,172.18.187.221,172.18.187.222 --agent 172.18.187.220,172.18.187.221,172.18.187.222 --passwd Thinkbig1 --pkg https://oss.kubeclipper.io/release/master/kc-amd64.tar.gz
```

Step 3: Push Kubernetes v1.35.0 resource package.
```
kcctl login -H https://localhost:8080 -u admin -p Thinkbig1
kcctl resource push --type k8s /root/k8s-v1.35.0-amd64.tar.gz
```

Step 4: Create Cluster With KubeClipper.
```
kcctl create cluster --master 172.18.187.220,172.18.187.221,172.18.187.222 --name conformance --untaint-master --k8s-version v1.35.0
```

#### Deploy sonobuoy Conformance test

* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.

```
sonobuoy run --mode=certified-conformance --kubernetes-version=v1.35.0
sonobuoy status
sonobuoy retrieve
```
