# How to reproduce

## 1. Create an account

Create a new MyNWS account at [my.nws.netways.de](https://my.nws.netways.de)

## 2. Order a new cluster

1. Once you signed up and provided the required information, click on *Kubernetes* in the *New Products* section of the sidebar menu.
2. Click on *Create* in the bottom right corner of the page.
3. Click on *Kubernetes* in the *Your Products* section of the sidebar menu.
4. Navigate to *Clusters* in the Kubernetes view and click on *Create Cluster*.
5. Fill in the following information, leave the others as is:
   - **Cluster Name**: e.g. `conformance-test`
   - **Kubernetes Version**: 1.32.X
   - **Control Plane Flavor**: General purpose s1.medium
   - **Worker Nodes**: General purpose s1.medium
6. Click on *Create*.

## 3. Wait

Wait 5-7 minutes. MyNWS will notify you in the web UI and by email once the cluster has been provisioned.

## 4. Get the kubeconfig

1. In the cluster list, click on the cluster's context menu. 
2. Select *Download Kubeconfig*
3. Select *Admin Certificate*
4. Click on the download link *Kubeconfig*

## 5. Run the tests

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the sonobuoy CLI, or build it yourself by running:

```shell
go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```shell
export KUBECONFIG=/path/to/kubeconfig.yml
sonobuoy run --mode=certified-conformance --timeout 10800
```

View actively running pods:

```shell
sonobuoy status
```

To inspect the logs:

```shell
sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to
a local directory:

```shell
sonobuoy retrieve .
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local `.` directory. Extract the contents into `./results` with:

```shell
mkdir ./results; tar xzf *.tar.gz -C ./results
```

To clean up Kubernetes objects created by Sonobuoy, run:

```shell
sonobuoy delete
```

