# Conformance Testing CKS v1.33

To reproduce the test run:

## Create a CKS Cluster

To create a cluster:

### UI
To create a cluster via the UI, sign into [console.coreweave.com/login](https://console.coreweave.com/login). On the Clusters view, click `Create Cluster` on the top right, type a name, select `v1.33`, (keep exposed to public internet enabled), hit next, select the desired zone, use default VPC, and then click next through the rest and submit. You can generate a kubeconfig with this cluster in the `Tokens` menu, by creating a token and specifying your cluster when downloading the kubeconfig.

### API
You will need to log into the [console.coreweave.com/login](https://console.coreweave.com/login), navigate to `Tokens` and create a an API token. You can then create a cluster against the API with the following:

contents of `create-vpc.json`:
```
{
    "name": "my-vpc",
    "zone": "<insert zone you have quota for>",
    "vpcPrefixes": [
        {
            "name": "pod-cidr",
            "value": "10.0.0.0/13"
        },
        {
            "name": "service-cidr",
            "value": "10.16.4.0/22"
        },
        {
            "name": "internal-lb-cidr",
            "value": "10.32.4.0/22"
        }
    ]
}
```
Creation command:
```
$ export API_ACCESS_TOKEN="<insert the api token you created>"
# you will need to create a VPC first, which in the UI is taken care of by default
$ curl -X POST https://api.coreweave.com/v1beta1/networking/vpcs -H "Content-Type: application/json" -H "Authorization: Bearer $API_ACCESS_TOKEN" -i -d @create-vpc.json 
```
Contents of `create-cluster.json`, for which you'll need to paste in the vpc id that will be provided in the response of the creation request above:
```
{
    "name": "my-cluster-name",
    "zone": "<zone you are using>",
    "vpcId": "<vpc id from response above>",
    "public": true,
    "version": "v1.33",
    "network": {
        "podCidrName": "pod-cidr",
        "serviceCidrName": "service-cidr",
        "internalLbCidrNames": ["internal-lb-cidr"]
    }
}
```
Creation command:
```
$ curl -X POST https://api.coreweave.com/v1beta1/cks/clusters -H "Content-Type: application/json" -H "Authorization: Bearer $API_ACCESS_TOKEN" -i -d @create-cluster.json
```
Afterwards, you can get a kubeconfig from the UI, as described above.

Documentation on this process can also be found [here](https://docs.coreweave.com/docs/products/cks/clusters/create).

You will need to add some nodes to the cluster as well for pods to run:

### UI
After logging into [console.coreweave.com/login](https://console.coreweave.com/login), navigate to `Node Pools` in the menu. Select your cluster in the dropdown, and click `Create Node Pool` on the top right. Make sure you add at least two nodes for an instance type you have quota for. Nodes joining can take up to 20 minutes.

### Kubectl
Use the kubeconfig from above to `kubectl apply -f <file name>` the below file contents:
```
---
apiVersion: compute.coreweave.com/v1alpha1
kind: NodePool
metadata:
  name: my-node-pool
spec:
  instanceType: <insert an instance type name you have quota for>
  targetNodes: 2
```
Nodes joining can take up to 20 minutes.

## Run Tests with Hydrophone

Install [hydrophone](https://github.com/kubernetes-sigs/hydrophone?tab=readme-ov-file#install).

Make sure your `$KUBECONFIG` env var points to configuration for the created cluster, or provide the kubeconfig as an additional flag to the below commands with `--kubeconfig <insert path>`.

Run the test:
`hydrophone --conformance`

Cleanup after the test:
`hydrophone --cleanup`

`e2e.log` and `junit_01.xml` will be written to the current working directory.