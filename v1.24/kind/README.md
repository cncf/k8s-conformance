# KIND

1. Install KIND

Download the released binary as per the documentation https://kind.sigs.k8s.io/docs/user/quick-start/#installation


```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64
chmod +x ./kind
```
`
2. Create a Kubernetes cluster

Select the image corresponding to the Kubernetes release, you can obtain the list from https://github.com/kubernetes-sigs/kind/releases. For kubernetes v1.24 type:
```
./kind create cluster --image kindest/node:v1.24.4@sha256:adfaebada924a26c2c9308edd53c6e33b3d4e453782c0063dc0028bdebaddf98
```

3. Run conformance tests

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
go get -u -v github.com/vmware-tanzu/sonobuoy
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
