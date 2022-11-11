## To reproduce:
#### Creating a cluster with KubeClipper

Step 1:Download kcctl v1.2.1.
It's recommended to install using root user.
```
curl -sfL https://oss.kubeclipper.io/kcctl.sh | KC_VERSION=v1.2.1 bash -
```

Step 2:Get Started With Installation.
It's recommended to install using root user, the /root/key is common key for deploy machines.
```
kcctl deploy --server 192.168.10.110,192.168.10.111,192.168.10.112 --agent 192.168.10.110,192.168.10.111,192.168.10.112 --etcd-port 12379 --etcd-peer-port 12380 --etcd-metric-port 12381 --pk-file /root/key --pkg https://oss.kubeclipper.io/release/v1.2.1/kc-amd64.tar.gz
 _   __      _          _____ _ _
| | / /     | |        /  __ \ (_)
| |/ / _   _| |__   ___| /  \/ |_ _ __  _ __   ___ _ __
|    \| | | | '_ \ / _ \ |   | | | '_ \| '_ \ / _ \ '__|
| |\  \ |_| | |_) |  __/ \__/\ | | |_) | |_) |  __/ |
\_| \_/\__,_|_.__/ \___|\____/_|_| .__/| .__/ \___|_|
                                 | |   | |
                                 |_|   |_|
```

Step 3:Create Cluster With KubeClipper.
It's recommended to install using root user.
```
kcctl login -H http://localhost  -u admin -p Thinkbig1
kcctl create cluster --master 192.168.10.110,192.168.10.111,192.168.10.112 --name demo --untaint-master
```

#### Deploy sonobuoy Conformance test

* Follow the conformance suite instructions to [test](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) it.