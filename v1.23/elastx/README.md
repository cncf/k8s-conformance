# Conformance testing ELASTX Private Kubernetes

## Ordering a cluster

Sing up using our sing-up page located at https://elastx.se/en/signup. Request a
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
./sonobuoy run --mode=certified-conformance --wait
outfile=$(./sonobuoy retrieve)
tar xvzf $outfile
```

Check the results in: `plugins/e2e/results/global/{e2e.log,junit_01.xml}`.
