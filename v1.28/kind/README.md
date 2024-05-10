# KIND

1. Install KIND https://kind.sigs.k8s.io/docs/user/quick-start/#installation

```
go install sigs.k8s.io/kind@latest
```
`
1. Create a Kubernetes cluster

Use the following configuration to create a multi-node cluster

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

Select the appropiate image for the desired kubernetes version https://github.com/kubernetes-sigs/kind/releases

```
./kind create cluster --image kindest/node:v1.28.0
```

3. Run conformance tests

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
go install github.com/vmware-tanzu/sonobuoy@latest
```

Deploy a Sonobuoy pod to your cluster with:

```
sonobuoy run --mode=certified-conformance
```

View actively running pods:

```
sonobuoy status
```

To inspect the logs:

```
sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit_01.xml}**.


4. Clean up

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```

You can delete the cluster now with :

```
kind delete cluster
```
