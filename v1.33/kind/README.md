# KIND

1. Install KIND v0.27.0 https://kind.sigs.k8s.io/docs/user/quick-start/#installation

```shell
go install sigs.k8s.io/kind@v0.27.0
```

2. Create a Kubernetes cluster

On kind v0.27.0, Kubernetes v1.32.2 is the default image.
We will need to select the 1.33 image.
We will use the image from the release notes: `kindest/node:v1.33.0@sha256:02f73d6ae3f11ad5d543f16736a2cb2a63a300ad60e81dac22099b0b04784a4e`

To run other versions you can set --image, see our release notes for available images
and our docs for instructions to build your own.
For this conformance run, we'll use the default.

Use the following configuration to create a multi-node cluster, which is necessary
for conformance tests.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

Place it in a file `kind.yml` in the current directory.

Then create a cluster with it like:

```shell
kind create cluster --config=./kind.yml --image=kindest/node:v1.33.0@sha256:02f73d6ae3f11ad5d543f16736a2cb2a63a300ad60e81dac22099b0b04784a4e
```

3. Install hydrophone to run the tests

https://github.com/kubernetes-sigs/hydrophone


```shell
go install sigs.k8s.io/hydrophone@v0.7.0
```

4. Run the conformance tests

```shell
hydrophone --conformance
```

This will take about two hours. When it is complete the results will be in the current directory at ./e2e.log and ./junit_01.xml


4. Clean up

To clean up Kubernetes objects created by Hydrophone, run:

```shell
hydrophone --cleanup
```

You can delete the cluster now with:

```shell
kind delete cluster
```
