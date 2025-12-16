# Kubernetes - The Easier Way (k8s-tew)

## Prerequisites

- Linux Host OS (preferably Ubuntu 24.04)
- Vagrant: 2.4.1+
- VirtualBox 7.0+
- User SSH Key (~/.ssh/id_rsa & ~/.ssh/id_rsa.pub)

## Start Virtual Machines

```shell
wget https://raw.githubusercontent.com/darxkies/k8s-tew/2.4.12/Vagrantfile
export IP_PREFIX=192.168.58
export MULTI_NODE=true
export CONTROLLERS=0
export WORKERS=2
vagrant up
```

## Download k8s-tew

```shell
wget https://github.com/darxkies/k8s-tew/releases/download/2.4.12/k8s-tew
chmod u+x k8s-tew
```

## Install Kubernetes

```shell
./k8s-tew initialize
./k8s-tew configure --version-kube-apiserver=registry.k8s.io/kube-apiserver:v1.33.0
./k8s-tew configure --version-kube-controller-manager=registry.k8s.io/kube-controller-manager:v1.33.0
./k8s-tew configure --version-kube-proxy=registry.k8s.io/kube-proxy:v1.33.0
./k8s-tew configure --version-kube-scheduler=registry.k8s.io/kube-scheduler:v1.33.0
./k8s-tew configure --public-network=$IP_PREFIX.0/24
./k8s-tew configure --resolv-conf=/run/systemd/resolve/resolv.conf
./k8s-tew node-add -n worker00 -i $IP_PREFIX.100 -x 0 -l controller,worker
./k8s-tew node-add -n worker01 -i $IP_PREFIX.101 -x 1 -l worker,storage
./k8s-tew generate
./k8s-tew deploy --skip-backup-setup --skip-logging-setup --skip-monitoring-setup --skip-showcase-setup --skip-ingress-setup --wait=5
```

# Activate Environment

```shell
source <(./k8s-tew environment)
```

# Start Conformance Test

```shell
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.57.3/sonobuoy_0.57.3_linux_amd64.tar.gz
tar xzfv sonobuoy_0.57.3_linux_amd64.tar.gz
./sonobuoy run --mode=certified-conformance --plugin-env=e2e.E2E_EXTRA_ARGS="--ginkgo.v" --kubernetes-version=v1.33.0
```

# Wait for the log message "no-exit was specified, sonobuoy is now blocking"

```shell
./sonobuoy logs -f -p e2e
```

# Download the results

```shell
outfile=$(./sonobuoy retrieve)
```

# Generate Conformance Artefacts

```shell
mkdir conformance-results
tar xzfv $outfile -C /tmp/
cp /tmp/plugins/e2e/results/global/e2e.log conformance-results/
cp /tmp/plugins/e2e/results/global/junit_01.xml conformance-results/
```

# Destroy Virtual Machine

```shell
vagrant destroy -f
```
