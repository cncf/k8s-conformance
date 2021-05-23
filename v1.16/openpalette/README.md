## To Reproduce:

### Provision kubernetes cluster

To create these results, first we need to create a kubernetes cluster in ZTE TECS OpenPalette platform:

```bash
$ pdm-cli deploy
```

Wait a few minutes, when the Kubernetes cluster is up and running, proceed to run the conformance tests according to [official guide - running](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running).

### Run conformance tests

Install the git & golang software, then build the Sonobuoy tool by myself:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to the OpenPalette Kubernetes cluster with:

```
$ sonobuoy run
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

Extract the `.tar.gz` contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

Clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```

Prepare the necessary documents and submit the PR according to [official guide - uploading](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#uploading).

Done! ☺️
