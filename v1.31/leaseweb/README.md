# Conformance testing Leaseweb Managed Kubernetes

## 1. Order a cluster
Head to our [website](https://www.leaseweb.com/en/products-services/cloud/kubernetes), Click Order now, use the order form to order a Kubernetes cluster in the location of choice.
Once the account is validated and company verification checks are completed, the order will be automatically processed.

This process will allow to select

- the location of the cluster
- the subnet size of the network (/29)
- Contract & billing terms

## 2. Configure a cluster

1. Log in to the Leaseweb Customer Portal, and on the left panel, select `Kubernetes`
2. On the Clusters page,  the newly ordered cluster should be visible with the status as `NEW`
3. In the `Actions` section, use the `Configure` button and follow the instructions, this will allow to configure the following options in the Kubernetes Cluster:
  - Kubernetes version
  - Node Offering (CPU core & memory)
  - Scaling Type (Manual or Auto-scaling)
  - Number instances & autoscaling limits
  - List of IPs that allow access to the kubernetes cluster control plane
4. After submitting the configuration, the cluster will enter the `Provisioning` status
5. The cluster should be ready after a couple of minutes, the portal should display status `READY`

## 3. Setup Kubeconfig
In the `Actions` section of the newly configured Kubernetes cluster, click `Download kubeconfig`
then, Open a terminal, and Set the `KUBECONFIG` as path to the kubeconfig file of your newly created cluster

```
$ export KUBECONFIG=~/Downloads/kubeconfig-$KubernetesClusterId.yaml
```

## 4. Run the tests
Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go install github.com/vmware-tanzu/sonobuoy@latest
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
