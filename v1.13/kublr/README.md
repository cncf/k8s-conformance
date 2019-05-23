# To reproduce

## Set up the cluster

1. Download and install Kublr Control Plane [documentation](https://kublr.com/deploy/)
1. Create new Kubernetes cluster using Kublr Control Plane.

When the cluster is up and running,

1. Download the kubeconfig file.
2. Set the `KUBECONFIG` environment variable `export KUBECONFIG=$(pwd)/kubeconfig`.

## Run the conformance test

Download a sonobuoy [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:
```bash
$ go get -u -v github.com/heptio/sonobuoy

$ sonobuoy run
```

Then the status commands `$ sonobuoy status` indicate that the execution is completed, you can download the results.
```bash
$ sonobuoy retrieve
```

untar the tarball, then add plugins/e2e/results/{e2e.log,junit_01.xml}
```bash
$ mkdir ./results; tar xzf $outfile -C ./results
```
