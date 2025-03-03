# Conformance testing ELASTX Private Kubernetes

## Ordering a cluster

Sign up using our sign-up page located at https://elastx.se/en/signup. Request a
"ELASTX Private Kubernetes cluster" in the free text field or in
communcations with our sales team.

Addons are not tested for conformance, make sure to mention that all addons
should be disabled if you wish to test for conformance. Besides addons all other
supported configuration options should pass conformance tests.

Once the cluster has been created you will receive instructions as to where you
can find the "cluster-admin" kubeconfig.

## Running the conformance tests

Fetch the "cluster-admin" kubeconfig as instructed and configure _kubectl_ to
use it:

```shell
export KUBECONFIG=<path to kubeconfig>
```

Download the appropriate [Sonobuoy
](https://github.com/vmware-tanzu/sonobuoy/releases/) release and unpack it:

```shell
tar xvzf sonobuoy_*.tar.gz
```

Run the conformance tests:

```shell
<<<<<<< HEAD
<<<<<<< HEAD
./sonobuoy run --mode=certified-conformance
=======
./sonobuoy run --mode=certified-conformance --wait
>>>>>>> 9188485b (Add conformance results for v1.31/elastx)
=======
./sonobuoy run --mode=certified-conformance
>>>>>>> 4ae108ca (added plugin var specification)
outfile=$(./sonobuoy retrieve)
tar xvzf $outfile
```

<<<<<<< HEAD
<<<<<<< HEAD
Check the results in: `plugins/e2e/results/global/{e2e.log,junit_01.xml}`..
=======
Check the results in: `plugins/e2e/results/global/{e2e.log,junit_01.xml}`.
>>>>>>> 9188485b (Add conformance results for v1.31/elastx)
=======
Check the results in: `plugins/e2e/results/global/{e2e.log,junit_01.xml}`..
>>>>>>> 4ae108ca (added plugin var specification)
