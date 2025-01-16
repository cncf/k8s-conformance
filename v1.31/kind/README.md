# KIND

1. Install KIND v0.24.0 https://kind.sigs.k8s.io/docs/user/quick-start/#installation

```
go install sigs.k8s.io/kind@v0.24.0
```

2. Create a Kubernetes cluster

On kind v0.24.0, Kubernetes v1.31.0 is the default image.

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

```
kind create cluster --config=./kind.yml
```

3. Install hydrophone to run the tests

https://github.com/kubernetes-sigs/hydrophone


```
go install sigs.k8s.io/hydrophone@latest
```

4. Run the conformance tests

```
hydrophone --conformance
```

This will take about two hours. When it is complete the results will be in the current directory at ./e2e.log and ./junit_01.xml


4. Clean up

To clean up Kubernetes objects created by Hydrophone, run:

```
hydrophone --cleanup
```

You can delete the cluster now with:

```
kind delete cluster
```
