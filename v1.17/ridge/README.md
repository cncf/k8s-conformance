# Conformance testing Ridge Kubernetes Service

### Create RKS cluster

To create a cluster:

```
POST https://api.ridge.co/rks/v1alpha/orgs/{org}/projects/{project}/clusters
```
`org` is the identifier of your organization

`project` is the project where you want to create the cluster.

Place your API key in the header as the token  in `Authorization: Bearer` <Token>

Example of creating a cluster in New York
```
{
    "name": "my-cluster",
    "display_name": "My Cluster",
    "desired_locations": [
        "US--New York"
    ],
    "highly_available": true,
    "node_pools": [
        {
            "desired_node_count": 1,
            "name": "my-pool",
            "display_name": "My Pool",
            "quantities": {"cpu_cores":1,"ram":2147483648,"ephemeral_storage":2147483648}
        }
    ],
    "initial_kubernetes_labels": "<object>",
    "initial_taints": [ "<string>","<string>"]
}
```
Next you will need to crate a token and download the kubeconfig to authenticate to the cluster

```
POST https://api.ridge.co/rks/v1alpha/orgs/{org}/projects/{project}/clusters/{cluster}/token
```
`org` is the identifier of your organization

`project` is the project where you want to create the cluster.

`cluster` is the cluster identifier.

The response will include a `kubeconfig` which you should use to connect to the cluster using kubectl


### Run the conformance tests

To run the conformance test:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then inspect plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
