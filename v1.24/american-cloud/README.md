# Conformance testing American Cloud Kubernetes Service

## Ordering a cluster

Sign up as an American Cloud customer by registering at beta.americancloud.com/register - after registering and validating an authorized credit 
card on the account, navigate to 'Services' using the nav bar on the left. Find the button for 'Create' under Kubernetes. Select a region, v1.24, 
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
