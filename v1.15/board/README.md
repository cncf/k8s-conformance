# To reproduce

## Build Kubernetes on MIPS

### Build Environment

Software                  | Version
----------------------|--------------------------
OS                    | NeoKylin Linux Server 7.0
docker-ce             | v18.09.8-ce
git                   | 1.8.3 +

### Step 1: git clone the source of kubernetes-mips project

   ```sh
      $ git clone https://github.com/inspursoft/kubernetes-mips.git
   ```

### Step 2: git clone the source of kubernetes and checkout to v1.15.3

   ```sh
      $ git clone https://github.com/kubernetes/kubernetes.git
      $ cd kubernetes  && git checkout v1.15.3
   ```

### Step 3: In kubernetes project home directory, copy the patch 0001-build-mips-k8s.patch in the kubernetes-mips project to the current directory and apply the patch

   ```sh
      $ cp ../kubernetes-mips/0001-build-mips-k8s.patch  .
      $ git apply 0001-build-mips-k8s.patch
   ```

### Step 4: Pull golang image for compiling kubernetes source code

   ```sh
      $ docker pull inspursoft/golang-mips:1.12.9
   ```

### Step 5: Run docker container to compile kubernetes source code

   ```sh
      $ docker run -it --rm -v `pwd`/kubernetes:/go/src/k8s.io/kubernetes --workdir /go/src/k8s.io/kubernetes  inspursoft/golang-mips:1.12.9 bash -c  "yum install -y make which && make"
   ```

The kubernetes binary file is placed in the _output/local/go/bin folder of the project home directory after building.

## Deploy Kubernetes cluster

Create new Kubernetes cluster using kubeadm.
   ```sh
      $ kubeadm init --config kubeadm-config.yaml
   ```

Here is the kubeadm-config.yaml.

    apiVersion: kubeadm.k8s.io/v1beta2
    bootstrapTokens:
    - groups:
      - system:bootstrappers:kubeadm:default-node-token
      token: abcdef.0123456789abcdef
      ttl: 24h0m0s
      usages:
      - signing
      - authentication
    kind: InitConfiguration
    localAPIEndpoint:
      advertiseAddress: 10.110.1.218
      bindPort: 6443
    nodeRegistration:
      criSocket: /var/run/dockershim.sock
      name: indata-10-9-11-201.indata.com
      taints:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
      kubeletExtraArgs:
        root-dir: "/indata/kubelet"
    ---
    apiServer:
      timeoutForControlPlane: 4m0s
    apiVersion: kubeadm.k8s.io/v1beta2
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controllerManager: {}
    dns:
      type: CoreDNS
    etcd:
      local:
        dataDir: /var/lib/etcd
    imageRepository: 10.110.25.227:6000/inspursoft
    kind: ClusterConfiguration
    kubernetesVersion: v1.15.3
    networking:
      dnsDomain: cluster.local
      serviceSubnet: 10.96.0.0/12
      podSubnet: 10.253.0.0/16
    scheduler: {}

## Run conformance tests

Follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
$ sonobuoy run --wait
$ sonobuoy status
$ sonobuoy retrieve
```
