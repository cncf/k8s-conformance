# How to reproduce

## 1. Create an account
Create a European OVH Account on [http://www.ovh.ie/auth/signup/#/?ovhCompany=ovh&ovhSubsidiary=IE](http://www.ovh.ie/auth/signup/#/?ovhCompany=ovh&ovhSubsidiary=IE).

## 2. Order a new free cluster
Click on the "Get started for free" on [https://www.ovh.ie/kubernetes/](https://www.ovh.ie/kubernetes/).
If you still don't have a Public Cloud project, you will need to create one first.
Once you created/chose your project, on the left menu, under the "Orchestration / Industrialization" category, click on "Managed Kubernetes Service".
Then click on "Create a cluster" and choose the appropriate version.

## 3. Wait
Wait approximately 2 minutes, once your cluster is ready it should redirect you to your Kubernetes cluster list.

## 4. Get credentials and add some nodes to your cluster
From the previous UI, click on the cluster you juste created and download the kubeconfig file from the bottom of the 'Service' tab.
Then add some nodes from the 'Nodes' tab. We personnaly tested with 2 'B2-7' instances.

## 5. Run the tests
Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance
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