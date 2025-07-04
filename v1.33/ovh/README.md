# How to reproduce

## 1. Create an account
Create a European OVHcloud Account on [https://www.ovh.com/auth/signup/#/?ovhCompany=ovh](https://www.ovh.com/auth/signup/#/?ovhCompany=ovh).

## 2. Order a new free cluster
Click on the "Get started" on [https://www.ovhcloud.com/en-gb/public-cloud/kubernetes/](https://www.ovhcloud.com/en-gb/public-cloud/kubernetes/).
If you still don't have a Public Cloud project, you will need to create one first.
Once you created/chose your project, on the left menu, under the "Orchestration / Industrialization" category, click on "Managed Kubernetes Service".
Then click on "Create a cluster" and follow the form:
- Select the location of your cluster
- Select the minor version of Kubernetes
- Choose a private network if necessary (we validated the conformance with no private network)
- Configure a node pool (we validated the conformance with a pool of 2 "B2-7" instances)
- Choose the billing type
- Choose the name of your cluster

## 3. Wait
Wait approximately 2 minutes, once your cluster is ready it should redirect you to your Kubernetes cluster list.

## 4. Get the kubeconfig
From the clusters list, click on the cluster you just created and download the kubeconfig file from the bottom-right of the "Service" tab.
You should also ensure that your nodes are READY by checking that your node pool status reads "OK" under the "Node pools" tab.

## 5. Run the tests
Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
export KUBECONFIG=/path/to/kubeconfig.yml
$ sonobuoy run --mode=certified-conformance --timeout 10800
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

Have fun testing !
