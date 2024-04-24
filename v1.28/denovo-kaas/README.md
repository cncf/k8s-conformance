# Conformance testing American Cloud Kubernetes Service

## Ordering a cluster

Sign up as an DeNovo Cloud customer by registering at my.denovo.ua - after registering you will get link with credentials to the CD , navigate to 'Services' using the nav bar on the left. Find the button for 'Create' under Kubernetes. Select a region, v1.27, 
and appropriate cluster size.

Choose hourly or monthly billing and then click the 'Deploy' button on the bottom right side of the portal and confirm your deployment.

## Running the conformance tests

Once the cluster state says 'Running' click the button that says 'Download Config File' and save to <path to kubeconfig>

```shell
export KUBECONFIG=<path to kubeconfig>
```

Install the appropriate Sonobuoy package

```shell
brew install sonobuoy
```

Run the conformance tests:

```shell
sonobuoy run --mode=certified-conformance
sonobuoy status
sonobuoy logs
```

Once `sonobuoy status` shows the run `completed`

```shell
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```
