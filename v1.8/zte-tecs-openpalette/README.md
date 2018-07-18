## To Reproduce:

### Provision kubernetes cluster

To create these results, first we need to create a kubernetes cluster in ZTE TECS OpenPalette platform:

```bash
$ pdm-cli deploy
```

Wait a few minutes, when the Kubernetes cluster is up and running, proceed to run the conformance tests according to the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).

### Run conformance tests

Start the conformance tests:

```bash
$ curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

Watch Sonobuoy's logs with:

```bash
$ kubectl logs -f -n sonobuoy sonobuoy
```

and wait for the line:

>no-exit was specified, sonobuoy is now blocking


At this point, use kubectl cp to bring the results to local machine, expand the tarball, and retain the 2 files `plugins/e2e/results/{e2e.log,junit.xml}`:

```bash
$ kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
$ cd ./results/
$ tar zxf *_sonobuoy_*.tar.gz
```
