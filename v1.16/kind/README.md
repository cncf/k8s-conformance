# Install kind

For complete options see:
https://kind.sigs.k8s.io/docs/user/quick-start/#installation

We're using the following to produce these results:
```shell
git clone https://github.com/kubernetes-sigs/kind.git
cd ./kind
git checkout v0.7.0
make build
export PATH="${PWD}/bin:${PATH}"
```

This install method requires GNU make and docker.

You will need to install Docker to run kind v0.7.0.

# Creating the Cluster

To create a Kubernetes v1.16.X cluster for wtih kind v0.7.0 we're using the following
config:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55
- role: worker
  image: kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55
- role: worker
  image: kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55
```

More precisely, run the following in a POSIX shell to create the test cluster:


```shell
cat <<EOF | kind create cluster --config=- --image='kindest/node:v1.16.4@sha256:b91a2c2317a000f3a783489dfb755064177dbc3a0b2f4147d50f04825d016f55'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF
```

# Testing

To test, following the standard instructions here using sonobuoy:

https://github.com/cncf/k8s-conformance/blob/95e904c99d6a0777db2e99a4787247118db8ed4e/instructions.md

When the kind cluster was created your current kubeconfig was updated to point
to it, so the instructions will just work.

# Cleanup

`kind delete cluster` will perform all necessary cleanup.
