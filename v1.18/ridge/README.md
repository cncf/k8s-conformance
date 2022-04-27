# Conformance testing Ridge Kubernetes Service

### Create RKS cluster

To create a cluster:

```
POST https://api.ridge.co/rks/v1alpha/orgs/{org}/projects/{project}/clusters
```
`org` is the identifier of your organization

`project` is the project where you want to create the cluster.

Place your API key in the header as the token  in `Authorization: Bearer` <Token>

Create a cluster by submitting the following JSON
```
{
    "node_pools": [
        {
            "name": "my-pool",
             "display_name": "My Pool",
            "desired_node_count": 2,
            "quantities": {"cpu_cores":2,"ram":2147483648,"ephemeral_storage":2147483648}
        }
    ],
    "initial_max_cost" :"Unlimited",
    "name": "my-cluster",
    "display_name": "my-cluster",
    "desired_locations": [
        "US--New York"
    ],
    "highly_available": true
}
```

for more details and api referance refer to https://docs.ridge.co/reference/getting-started-1

### Run conformance tests

Once the RKS cluster has been provisioned, connect to the cluster and commence the conformance test by following these steps:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```

