## To Reproduce:

Note: to reproduce you need a Cloud 66 account.

### Create cluster

Login to Cloud 66 and signup for a Cloud 66 Maestro trial (free).

This is a 5 min guide on creating a single cluster (please create a 5 node cluster with 8 core CPUs)

https://help.cloud66.com/maestro/quickstarts/getting_started_with_clusters.html

You can create a single cluster with 5 nodes. This will include a single master node. Once the cluster is ready, convert the "Shared Master" to a "Dedicated Master" (click on Shared Master next to the master node and select Dedicated)

### Get Credentials

Open up the firewall from your IP to the cluster for kubectl:

Head to Network Settings, add a new rule and enter your IP address (from), Kubernetes servers (to) and TCP (protocol) 6443 (port).

From the master node page, download the `kubectl` file and check the cluster and your access:

```bash
export KUBECONFIG=~/Downloads/kubeconfig
kubectl get nodes
```

### Run the tests

You can use the Sonobuoy Scanner to run the tests:

https://scanner.heptio.com/


### Destroy cluster

Click on the Delete Cluster button.
