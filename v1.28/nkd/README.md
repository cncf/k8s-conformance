## Introduce

1. NestOS is a variant of Fedora CoreOS, built on openEuler and incubated and developed in openEuler,the website is https://nestos.openeuler.org/
2.  NKD (NestOS Kubernetes Deployer) is a solution specially built for deploying and maintaining Kubernetes clusters on NestOS.

## Environmental requirements

- virtualized environment
  - /dev/kvm
  - QEMU
  - libvirt
- Required components for the host
  - opentofu
    ```
    wget https://github.com/opentofu/opentofu/releases/download/v1.6.0-rc1/tofu_1.6.0-rc1_<arch>.rpm
    rpm -ivh tofu_1.6.0-rc1_<arch>.rpm
    ```
  - kubectl (Optional)
- directory(/etc/nkd)
    ```
    mkdir /etc/nkd
    ``` 
- download NestOS qcow2 in /etc/nkd
    ```
    wget https://nestos.org.cn/nkd/NestOS-For-Container-22.03-LTS-SP3.20240229.0-qemu.x86_64.qcow2
    or
    wget https://nestos.org.cn/nkd/NestOS-For-Container-22.03-LTS-SP3.20240318.0-qemu.aarch64.qcow2
    ``` 
## Deploy NKD

Download NKD binaries
```
wget https://gitee.com/openeuler/nestos-kubernetes-deployer/releases/download/0.2.2/nkd-linux-amd64
or
wget https://gitee.com/openeuler/nestos-kubernetes-deployer/releases/download/0.2.2/nkd-linux-arm64
```

Or  compile from source code（Requires golang 1.17+）
```
git clone https://gitee.com/openeuler/nestos-kubernetes-deployer
sudo sh hack/build.sh
```

## Deploy NestOS and Kubernetes

Use the following configuration file, or customize and add other configurations according to the documentation

```
cluster_id: cluster
platform: libvirt
infraplatform:
  uri: ""
  osimage: "/etc/nkd/NestOS-For-Container-22.03-LTS-SP3.20240229.0-qemu.x86_64.qcow2"
  cidr: "192.168.132.0/24"
  gateway: "192.168.132.1"
master:
- hostname: k8s-master01
  hardwareinfo:
    cpu: 4
    ram: 8096
    disk: 50
  username: root
  password: "$1$yoursalt$UGhjCXAJKpWWpeN8xsF.c/"
  ip: "192.168.132.11"
worker:
- hostname: k8s-worker01
  hardwareinfo:
    cpu: 4
    ram: 8096
    disk: 50
  username: root
  password: "$1$yoursalt$UGhjCXAJKpWWpeN8xsF.c/"
  ip: "192.168.132.14"
- hostname: k8s-worker02
  hardwareinfo:
    cpu: 4
    ram: 8096
    disk: 50
  username: root
  password: "$1$yoursalt$UGhjCXAJKpWWpeN8xsF.c/"
  ip: "192.168.132.15"
runtime: crio
kubernetes:
  kubernetes-version: "v1.28.0"
  kubernetes-apiversion: "v1beta3"
  apiserver-endpoint: "192.168.132.11:6443"
  image-registry: "registry.k8s.io"
  pause-image: "pause:3.9"
  token: o0tztj.kjsvjzha417yk5oo
  certificatekey: "a301c9c55596c54c5d4c7173aa1e3b6fd304130b0c703bb23149c0c69f94b8e0"
  network:
    service-subnet: 10.96.0.0/16
    pod-subnet: 10.244.0.0/16
    plugin: "https://projectcalico.docs.tigera.io/archive/v3.25/manifests/calico.yaml"
housekeeper:
  deployhousekeeper: false
```
Information such as IP, gateway, username and password can be modified according to actual conditions.
After the configuration is complete, run the following command

```
nkd deploy -f xxx.yaml
```
After waiting for a few minutes, you will see the message "cluster deployment completed successfully".
Execute the following prompts to operate the cluster on the host machine
```
export KUBECONFIG = /etc/nkd/cluster/admin.config
```
Or you can also connect to the cluster through libvirt or IP address, check the cluster health status, and use the cluster.

## Running e2e tests

Download a binary release

```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.1/sonobuoy_0.57.1_linux_amd64.tar.gz
tar -zxvf ./sonobuoy_0.57.1_linux_amd64.tar.gz
```
Since pulling the image will get stuck in many cases
we downloaded the image in advance and configured the local image harbor, and modified it here.

```
sonobuoy gen default-image-config > custom-repo-config.yaml
```

Deploy a Sonobuoy pod to your cluster with

```
sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v" --mode=certified-conformance -f custom-repo-config.yaml
```


Once sonobuoy status shows the run as completed, copy the output directory from the main Sonobuoy pod to
a local directory:

```
sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local `.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```