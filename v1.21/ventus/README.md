# How to reproduce

## 1. Create the Ventus Cloud account 
Open the https://console.ventuscloud.eu/ and register new account.

Follow the [Creating a new account instruction](https://kb.ventuscloud.eu/knowledge/create-new-account) to get more details about this step.

## 2. Create a new organization
Open the https://console.ventuscloud.eu/ and create new Organization.

Follow the [Organizations instruction](https://kb.ventuscloud.eu/knowledge/organizations) to obtain more details about this step.

## 3. Create a new project
On the main Navigation Panel go to your Organization and create new project in desired region.

Follow the [Projects instruction](https://kb.ventuscloud.eu/knowledge/projects) to get more details about this step.

## 4. Create a new cluster and download kubeconfig
On the main Navigation Panel go to your Project, choose Clusters and create new Kubernetes cluster.
You will be asked to generate new SSH key to allow the SSH access to your k8s nodes. 
Wait for about 5 minutes and download kubeconfig using the cluster's action button.

Follow the [Kubernetes Cluster instruction](https://kb.ventuscloud.eu/knowledge/kubernetes-cluster) to obtain more details about this step.

## 5. Access the cluster
To access the cluster export kubeconfig file from step 4, for example:
```
export KUBECONFIG=~/cncf/kubeconfig
```
Now you're authorized to interact with your cluster:
```
kubectl get pods --all-namespaces
```

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

