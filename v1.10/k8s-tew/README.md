# Kubernetes - The Easier Way (k8s-tew)

## Prerequisites

- Linux Host OS (preferably Ubuntu 18.04)
- Vagrant: 2.0.2+
- VirtualBox 5.2.12+
- User SSH Key (~/.ssh/id_rsa & ~/.ssh/id_rsa.pub)

## Start Virtual Machine

```shell
wget https://raw.githubusercontent.com/darxkies/k8s-tew/2.0.2/Vagrantfile
vagrant up
```

## Download k8s-tew

```shell
wget https://github.com/darxkies/k8s-tew/releases/download/2.0.2/k8s-tew
chmod u+x k8s-tew
```

## Install Kubernetes

```shell
./k8s-tew initialize -f
./k8s-tew configure --resolv-conf=/run/systemd/resolve/resolv.conf
./k8s-tew node-add -n single-node -i 192.168.100.50 -x 0 -l controller,worker
./k8s-tew generate --deployment-directory=/
./k8s-tew deploy
```
__Note__: The last command, the deployment, will display errors because k8s-tew keeps trying to setup Kubernetes, and Kubernetes is not ready yet. Ignore the errors and wait until k8s-tew is done by itself.

# Activate Environment

```shell
eval $(./k8s-tew environment)
```

# Start Conformance Test

```shell
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

# Wait for the log message "no-exit was specified, sonobuoy is now blocking"

```shell
kubectl logs -f -n sonobuoy sonobuoy
```

Alternatively, watch the conformance tests performing with the following command:

```shell
kubectl logs -f $(kubectl get pods -n sonobuoy | awk '{ print $1 }' | grep e2e) -n sonobuoy -c e2e
```

# Download the results

```shell
kubectl -n sonobuoy cp sonobuoy:$(kubectl -n sonobuoy logs sonobuoy | grep "Results available" | grep -o '/tmp/[^"]*') sonobuoy.tar.gz
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
