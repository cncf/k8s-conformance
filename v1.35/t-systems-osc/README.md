# Conformance tests for Gardener v1.x provisioned by Open Sovereign Cloud

## Sign in at the OSC Dashboard, create a User and a Project

Follow the getting started guide according to the [documentation](https://docs.osc.live/v1.0.4/osc-gardener-user-documentation/01-Get_Started/user-creation.html). 


## Shoot Creation

After creating a project, follow [Shoot creation guide](https://docs.osc.live/v1.0.4/osc-gardener-user-documentation/01-Get_Started/shoots-creation.html) to create a Shoot cluster.


## Run conformance tests

To verify that your OSC Gardener Shoot cluster is indeed conformant, you
can download sonobuoy from
[github.com/vmware-tanzu/sonobuoy/releases](https://github.com/vmware-tanzu/sonobuoy/releases)
and run the test in your cluster:

```
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

You can find the result files in `results/plugins/e2e/results/global/`.