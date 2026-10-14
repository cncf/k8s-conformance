# Reproducing the test results:

Gardener is using [hydrophone](https://github.com/kubernetes-sigs/hydrophone) to run Kubernetes conformance tests!

## Requirements
A valid installation of Gardener is required. 

Some of the many ways of installation Gardener can be found in the Gardener Deployment documentation at https://gardener.cloud/docs/gardener/deployment/. 
Some of them include https://gardener.cloud/docs/gardener/deployment/getting_started_locally/ and https://gardener.cloud/docs/gardener/deployment/getting_started_remotely/.

After Gardener is installed, a shoot cluster should be created either via the Gardener Dashboard or directly interacting with the Gardener Cluster API.

## Launch E2E Conformance Tests

Set the `KUBECONFIG` as path to the kubeconfig file of your newly created (shoot) cluster. 
One way is to create a temporary one using the [shoots/adminkubeconfig Subresource](https://gardener.cloud/docs/gardener/shoot/shoot_access/#shoots-adminkubeconfig-subresource). 

Run a docker container that mounts the shoot's kubeconfig inside it
```bash
docker run -ti --rm -v $SHOOT_KUBECONFIG:/mye2e/shoot.config golang:1.26 bash
```

Within the container do the following:

Checkout the repo [github.com/gardener/test-infra](https://github.com/gardener/test-infra) and cd into it

Run the tests:

```bash
export E2E_EXPORT_PATH=/tmp/export; export KUBECONFIG=/mye2e/shoot.config; export GINKGO_PARALLEL=false

go run -mod=mod ./conformance-tests/ --k8sVersion=1.34.3 --cloudprovider=gcp --kubeconfig=$KUBECONFIG
```

> [!NOTE]
> Adjust values for arguments `k8sVersion` and `cloudprovider` respective to your cluster!
