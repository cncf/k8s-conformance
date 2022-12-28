# KIND

1. Install KIND

Download the released binary as per the documentation https://kind.sigs.k8s.io/docs/user/quick-start/#installation


```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64
chmod +x ./kind
```
`
2. Create a Kubernetes cluster

kind v0.15.0  installs a Kubernetes cluster with version v1.25.0 by default, to create the cluster just type:

```
./kind create cluster
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
