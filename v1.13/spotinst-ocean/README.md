# To reproduce:

## Create a kuberenetes cluster with Ocean

1. Sign up and log in to https://console.spotinst.com/#/ocean/aws/list
2. Click on "Create Cluster"
3. Choose the method you would like to create your cluster (ECS not applicable)
4. Follow the UI instructions until your ocean cluster is created.
5. Make sure to add inbound ports 1-1024 to your ocean cluster security group.
6. Run the conformance test

## Running the Sonobuoy conformance test

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself according to the Sonobuoy instructions.

Start the conformance test

```
sonobuoy run
```

Monitor the conformance test by either running

```
sonobuoy logs -f
```

or

```
watch sonobuoy status
```

Once the test completes, retrieve & analyze the results

```
sonobuoy results $(sonobuoy retrieve)
```
