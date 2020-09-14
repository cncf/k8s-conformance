# Conformance Testing Cloud 66 Maestro

## 1. Cluster Setup

### What you’ll need

Login to Cloud 66 and signup for a Cloud 66 Maestro trial (free).

Before you start, please check you have the following:
1. A Cloud 66 Account — If you don’t already have one, sign up for a [Cloud 66 account](https://app.cloud66.com/users/sign_up). You’ll get free unlimited access to all products for 4 weeks.
2. Application code and/or pre-built images — Application code should be hosted in a (secure) publicly accessible git repository and pre-built images should be hosted in image publicly accessible repositories.
3. A Cloud account linked to Cloud 66 or your own servers set up — See below.

**Using a Cloud Provider**
An account with your cloud provider of choice. Cloud 66 supports many different cloud providers.

**Using Your Own Server**
Registered servers are a great way for operations teams to manage and allocate physical server resources for consumption by dev teams. Registered servers are a pool of your own servers (on a private or public cloud) that can be used for any application and configuration. For more information on how to add your own registered servers, we recommend [this tutorial](https://help.cloud66.com/maestro/how-to-guides/deployment/registered-servers.html#register-a-server)

### Create a Maestro Cluster

To get started with your cluster — firstly switch to the Clusters dashboard in main navigation bar at the top of the page.
Then, click the green new cluster button.

Next, give your cluster a name that will make it easy to identify. Then, choose the deployment target for your cluster. You can choose one of your existing cloud providers, or click "Add Clouds" to add a new cloud provider.
You can also use your own server - although you will need to register it first. In our example we’re choosing to deploy to Digital Ocean.

Depending on which cloud or registered server you selected above, we can now choose options for our new cluster, such as region and capacity. In this example we’ll choose 3 servers with 2GB of RAM each in the Amsterdam 3 Region.

**NOTE:** The first server in your cluster will always be your Kubernetes master node. You can decide later if you would like this server to share application workloads or only run Kubernetes management tasks.

### Deployment of your Cluster

Once you’re happy with your choices; hit the "Create Cluster" button to start building your new Maestro cluster!
You can watch the progess of the build on your dashboard, or you can close the window and get on with other work. We will alert you via email when your cluster is up and running.

During the build and deployment process you can view the log to see what’s happening behind the scenes. You can also drill down to specific servers to see what is going on there during deployment.
When your deployment is complete you’ll have your first Maestro cluster up and running!

### Configuring your Cluster

As we have a cluster that has multiple servers, we can easily switch our master node from a shared master to a dedicated master. To do this we simply click the shared master dropdown link and select "Yes! Switch to Dedicated Master"

We can also easily add additional server nodes to this cluster or remove existing server nodes from this cluster.

**NOTE:** The master server cannot be removed without deleting the entire cluster

**For conformance testing** 
To create a sample 3 master, 2 node cluster:
1. Create a single cluster with three nodes (This will include a single dedicated master and two nodes)
2. Once the cluster is ready, click on the "+" and add two additional master nodes to the cluster.

## 2. Get Credentials

Open up the firewall from your IP to the cluster for kubectl:
Head to Network Settings, add a new rule and enter your IP address (from), Kubernetes servers (to) and TCP (protocol) 6443 (port).

From the master node page, download the `kubectl` file and check the cluster and your access:

```bash
export KUBECONFIG=~/Downloads/kubeconfig
kubectl get nodes
```

## 3. Run the tests

https://github.com/cncf/k8s-conformance/blob/master/instructions.md

## 4. Destroy the cluster

Click on the "Delete Cluster" button