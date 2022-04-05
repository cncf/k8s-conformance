# Conformance testing Ridge Kubernetes Service

### Create RKS cluster

To create a cluster:

```
POST https://api.ridge.co/rks/unstable/orgs/{org}/projects/{project}/clusters
```
`org` is the identifier of your organization

`project` is the project where you want to create the cluster.

Place your API key in the header as the token  in `Authorization: Bearer` <Token>


1. Create a network (you can skip this if you want to create the cluster on an existing network):
```
{

    "name": "my-network",
    "display_name": "my-network",
    "highly_available_gateway": true,
    "data_center_id": "<data-center-id>",

}
```

2. Create a cluster:
```
{
    "name": "my-cluster",
    "display_name": "my-cluster",
    "highly_available": true,
    "desired_version": "1.22.6,
    "network_id" : "<network_id>" // the id of the network you want your cluster to be created on
    "node_pools": [
	    {
	      "name": "pool1",
	      "display_name": "Pool 1",
	      "catalog_item_id" : "<catalog_id>" // the id of the instance catalog item
	      "auto_scaling": false,
	      "initial_kubernetes_labels": {},
	      "initial_taints": [],
	      "max_nodes": 5,
	      "min_nodes": 5,
	      "initial_node_count" : 5
	    }
  ]
}
```

for more details and api referance refer to https://dev.ridge.co

### Run conformance tests

Once the RKS cluster has been provisioned, connect to the cluster and commence the conformance test by following these steps:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```

