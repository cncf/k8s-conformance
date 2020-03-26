# How to reproduce

## 1. Create the Ventus Cloud account 
Open the (https://portal.ventuscloud.eu/login) and click to CREATE NEW ACCOUNT button.
Fill the form, add billing information, and your account will be granted by 100EUR credit.

Obtain more details about this step following the [Creating a new account instruction](https://ventuscloud.eu/docs/quickstarts/create-account).

## 2. Create a new API user
On the main Navigation Panel go to Cloud, choose API Users and click the (+) present in the lower right corner.
Fill the form and once a User is created, click the "Get OpenRC file" button to save this file.

Obtain more details about this steo following the [API Users instruction](https://ventuscloud.eu/docs/coretasks/api-users).

## 3. Create a new pair of SSH keys
On the main Navigation Panel go to Cloud and choose SSH Keys. 
Upload the SSH key or generate the new one using the (+) button from the bottom right.

Obtain more details about this step following the [SSH Keys instruction](https://ventuscloud.eu/docs/coretasks/ssh-keys).

## 4. Create a new cluster
On the main Navigation Panel go to Cloud, choose Clusters and click the (+) button present in the lower right corner.
Fill the form, push CREATE CLUSTER button and wait about 5 minutes for "Create Completed" status.

Obtain more details about this step following the [Kubernetes Cluster instruction](https://ventuscloud.eu/docs/Kubernetes/kubernetes-cluster).

## 5. Access the cluster
To access the cluster from your Ubuntu console install the openstack cli and run openrc file from the Step 2:
```
sudo apt install python-pip
sudo pip install python-openstackclient
sudo pip install python-magnumclient
. ./openrc
```
Now you're authorized to interact with your Ventus Cloud entities and you can get the kubeconfig file and the list of pods:
```
openstack coe cluster list
openstack coe cluster config <Name of Cluster>
export KUBECONFIG="./config"
kubectl get pods --all-namespaces
```

Obtain more details about this step following the [Access your Kubernetes Cluster using CLI instruction](https://ventuscloud.eu/docs/Kubernetes/access-by-cli).

## 6. Run the tests
Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster and instruct it to ignore master taints:

```
$ sonobuoy run --plugin-env=e2e.E2E_EXTRA_ARGS="--non-blocking-taints=CriticalAddonsOnly,dedicated" --mode=certified-conformance
```

View actively running pods:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```
$ sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local `.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf *.tar.gz -C ./results
```

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```

