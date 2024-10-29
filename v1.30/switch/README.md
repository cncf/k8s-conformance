# Reproducing conformance tests on Switch Cloud Kubernetes

## Set up SCK cluster

1. Login to [https://sck.cloud.switch.ch](https://sck.cloud.switch.ch).
2. Choose your desired project.
3. Press the "Create Cluster" button.
4. Follow the wizard. Unless specified in the list below, go with the default or, if a selection/value is required but no default is provided, your own preference.
   - In step 2 ("Cluster"):
     - choose Canal instead of Cilium as the CNI, as Cilium is not currently conformant (see cilium/cilium#29913, cilium/cilium#9207, and cilium/cilium#33434 for more information - fix will be in Cilium 1.17).
     - choose "Control Plane Version" "1.30.5" (or newer)
     - choose "iptables" as the "Proxy Mode" under "Advanced Network Configuration"
   - In step 4 ("Initial Nodes"):
     - set "Replicas" to "2" (or more)
     - set "Flavor" to "c002r004" (or larger)
     - set "Disk Size in GB" to "20" (or larger)

When the cluster and all its nodes are shown with a green status indicater in the web interface, download the kubeconfig by clicking on the "Get Kubeconfig" button.
Then set the `KUBECONFIG` environment variable to point at the downloaded file.

## Run the conformance test using Sonobuoy

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
go install -v github.com/vmware-tanzu/sonobuoy@latest
```

Deploy a Sonobuoy pod to your cluster with:

```
sonobuoy run --mode certified-conformance --dns-pod-labels "app.kubernetes.io/name=kube-dns,app=coredns"
```

View actively running pods:

```
sonobuoy status
```

To inspect the logs:

```
sonobuoy logs
```

Once `sonobuoy status` shows the run as `complete` and re result as `passed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
outfile=$(sonobuoy retrieve)
```

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit_01.xml}**.

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```
