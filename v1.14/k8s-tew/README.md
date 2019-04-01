# Kubernetes - The Easier Way (k8s-tew)

## Prerequisites

- Linux Host OS (preferably Ubuntu 18.04)
- Vagrant: 2.0.2+
- VirtualBox 5.2.12+
- User SSH Key (~/.ssh/id_rsa & ~/.ssh/id_rsa.pub)

## Start Virtual Machine

```shell
wget https://raw.githubusercontent.com/darxkies/k8s-tew/2.3.0/Vagrantfile
vagrant up
```

## Download k8s-tew

```shell
wget https://github.com/darxkies/k8s-tew/releases/download/2.3.0/k8s-tew
chmod u+x k8s-tew
```

## Install Kubernetes

```shell
./k8s-tew initialize 
./k8s-tew configure --resolv-conf=/run/systemd/resolve/resolv.conf
./k8s-tew node-add -n single-node -i 192.168.100.50 -x 0 -l controller,worker
./k8s-tew generate
./k8s-tew deploy --skip-storage-setup
```

# Activate Environment

```shell
eval $(./k8s-tew environment)
```

# Start Conformance Test

```shell
wget https://github.com/heptio/sonobuoy/releases/download/v0.14.0/sonobuoy_0.14.0_linux_amd64.tar.gz
tar xzfv sonobuoy_0.14.0_linux_amd64.tar.gz
./sonobuoy run
```

# Wait for the log message "no-exit was specified, sonobuoy is now blocking"

```shell
./sonobuoy logs -f
```

# Download the results

```shell
kubectl -n heptio-sonobuoy cp sonobuoy:$(kubectl -n heptio-sonobuoy logs sonobuoy | grep "Results available" | grep -o '/tmp/[^"]*') sonobuoy.tar.gz
```

# Generate Conformance Artefacts

```shell
mkdir conformance-results
kubectl version > conformance-results/version.txt
tar xzfv sonobuoy.tar.gz -C /tmp/
cp /tmp/plugins/e2e/results/e2e.log conformance-results/
cp /tmp/plugins/e2e/results/junit_01.xml conformance-results/
```

# Destroy Virtual Machine

```shell
vagrant destroy -f
```
