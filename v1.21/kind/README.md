# Install kind

For complete options see:
https://kind.sigs.k8s.io/docs/user/quick-start/#installation

We're using the following to produce these results:
```shell
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.0/kind-$(uname)-amd64"
chmod +x ./kind
mv ./kind /usr/local/bin/kind
```

You will need to install Docker to run kind v0.11.0.

# Creating the Cluster

To create a Kubernetes v1.21.X cluster with kind v0.11.0 we're using the following
config:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.21.1@sha256:fae9a58f17f18f06aeac9772ca8b5ac680ebbed985e266f711d936e91d113bad
- role: worker
  image: kindest/node:v1.21.1@sha256:fae9a58f17f18f06aeac9772ca8b5ac680ebbed985e266f711d936e91d113bad
- role: worker
  image: kindest/node:v1.21.1@sha256:fae9a58f17f18f06aeac9772ca8b5ac680ebbed985e266f711d936e91d113bad
```

More precisely, run the following in a POSIX shell to create the test cluster:


```shell
cat <<EOF | kind create cluster --config=- --image='kindest/node:v1.21.1@sha256:fae9a58f17f18f06aeac9772ca8b5ac680ebbed985e266f711d936e91d113bad'
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

https://github.com/cncf/k8s-conformance/blob/78a0dd37e42cb493e798e2d7d5afc5b5799bdb9d/instructions.md

When the kind cluster was created your current kubeconfig was updated to point
to it, so the instructions will just work.

# Cleanup

`kind delete cluster` will perform all necessary cleanup.
