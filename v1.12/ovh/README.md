# How to reproduce

## 1. Prepare tests
As our Kubernetes product is still in private alpha, we created for you a cluster in version 1.12.
Connect to the [OVH Manager](https://www.ovh.com/manager/cloud) with your OVH account: tc160318-ovh.

You will find your Kubernetes service named "My 1.12 cluster" under the "Platform and Services" section in the "Cloud" universe. Download the kubeconfig file from the bottom of the 'Service' tab.

Then add some nodes from the 'Nodes' tab. We personnaly tested with 2 'B2-7'(General Purpose family) instances.


## 2. Run the tests
Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run
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