# How to reproduce

## 1. Create an account
Create a European OVH Account on [https://www.ovh.com/auth/signup/#/?ovhCompany=ovh&ovhSubsidiary=FR](https://www.ovh.com/auth/signup/#/?ovhCompany=ovh&ovhSubsidiary=FR).

## 2. Request a private beta access
Request a private beta access on [OVH Labs](https://labs.ovh.com/kubernetes-k8s/).
A few weeks later you will be whitelisted to order a Private cluster.

## 3. Wait
Wait 10 minutes after your order, then you can connect to [https://www.ovh.com/auth/?action=gotomanager&from=https://www.ovh.com/fr/&ovhSubsidiary=fr](https://www.ovh.com/auth/?action=gotomanager&from=https://www.ovh.com/fr/&ovhSubsidiary=fr).
You will find the Kubernetes service under the "Platform and Services" section in the "Cloud" universe.

## 4. Get credentials and add some nodes to your cluster
From the previous UI, download the kubeconfig file from the bottom of the 'Service' tab.
Then add some nodes from the 'Nodes' tab. We personnaly tested with 2 'B2-7' instances.

## 5. Run the tests
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