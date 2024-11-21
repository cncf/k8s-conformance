# Conformance testing UpCloud Managed Kubernetes

These instructions provide step-by-step instructions on how to run Kubernetes conformance tests in [UpCloud Managed Kubernetes](https://upcloud.com/products/managed-kubernetes).

To be able to follow these instructions, you will need to install UpCloud command-line client: [upctl](https://github.com/UpCloudLtd/upcloud-cli).

## Setup test cluster

First, you will need to configure your UpCloud credentials by setting `UPCLOUD_USERNAME` and `UPCLOUD_PASSWORD` environment variables. You can either use the main account or a subaccount with API access.

```sh
export UPCLOUD_USERNAME=${your_username}
export UPCLOUD_PASSWORD=${your_password}
```

Create a private network for your test cluster with `upctl network create` command, create the test cluster with `upctl kubernetes create` command and fetch the kubeconfig with `upctl kubernetes config` command.

```sh
upctl network create \
    --name upcloud-conformance-test-net \
    --zone de-fra1 \
    --ip-network address=172.24.0.0/24,dhcp=true;

upctl kubernetes create \
    --name upcloud-conformance-test-cluster \
    --network upcloud-conformance-test-net \
    --plan production-small \
    --zone de-fra1 \
    --node-group count=3,name=default,plan=2xCPU-4GB \
    --kubernetes-api-allow-ip 0.0.0.0/0 \
    --version 1.29 \
    --wait;

upctl kubernetes config upcloud-conformance-test-cluster \
    --write upcloud-conformance-test-cluster.kubeconfig.yaml;
```

For a more secure cluster, replace the `0.0.0.0/0` value of `--kubernetes-api-allow-ip` parameter with your IP to only allow access from your address.

Wait until all node-groups reach running state before launching the test run. You can see the node-group state in `upctl kubernetes show upcloud-conformance-test-cluster` output.

## Install sonobuoy and execute the tests

Install sonobuoy according to instructions in [sonobuoy.io](https://sonobuoy.io/) or use `go install`.

```sh
go install github.com/vmware-tanzu/sonobuoy@latest
```

Set `KUBECONFIG` environment variable to provide access to the test cluster, run the conformance tests with `sonobuoy run` command, and retrieve the results with `sonobuoy retrieve` command.

```sh
export KUBECONFIG=./upcloud-conformance-test-cluster.kubeconfig.yaml;
sonobuoy run --mode=certified-conformance --wait;

outfile=$(sonobuoy retrieve);
tar xzf $outfile;
```

## Cleanup the created resources

Delete the test cluster with `upctl kubernetes delete` and the private network with `upctl network delete` command. Note that you might have to wait a few minutes after deleting the cluster to be able to delete the test network.

```sh
upctl kubernetes delete upcloud-conformance-test-cluster;
upctl network delete upcloud-conformance-test-net;
```
