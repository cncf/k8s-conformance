# Kubernetes Conformance tests on Metal Stack Cloud

## Setup a Metal Stack Cloud account

You can directly [register for the Metal Stack Cloud](https://console.metalstack.cloud) with a GitHub account.

Starting from the dashboard you can navigate to the Kubernetes section and create new clusters.

## Run conformance tests

Download sonobuoy from [github.com/vmware-tanzu/sonobuoy/releases](https://github.com/vmware-tanzu/sonobuoy/releases)

```bash
sonobuoy run --mode=certified-conformance --wait
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```

Required files are located in `results/plugins/e2e/results/global/`