# Provision a Kubernetes cluster with 1 master node and 3 worker nodes

# Log into the Kubernetes master node via SSH.

# Install Portworx based on https://docs.portworx.com/portworx-install-with-kubernetes/

# While logged into the Kubernetes master node, Run sonobuoy by doing the following:

```
curl -L -O https://github.com/heptio/sonobuoy/releases/download/v0.14.2/sonobuoy_0.14.2_linux_amd64.tar.gz

tar xvfz sonobuoy_0.14.2_linux_amd64.tar.gz

./sonobuoy run

./sonobuoy status

./sonobuoy retrieve
```

# Extract the plugins/e2e/results directory from the tarball.

```
tar xvfz 201905110024_sonobuoy_21e0427b-4950-4160-bb8f-606037cad22a.tar.gz plugins/e2e/results
```

# Submit e2e.log and junit_01.xml
