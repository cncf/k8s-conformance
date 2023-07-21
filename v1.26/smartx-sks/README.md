# Conformance tests for SMTX Kubernetes Service

## Install SMTX Kubernetes Service

1. First purchase and install `SMTX OS` and `SMTX CloudTower`, and prepare the `SMTX Kubernetes Service` installation package.
1. Log in to the `CloudTower` UI through a browser, and jump to the `Kubernetes Service` page.
1. According to the prompt on the page, upload the `SMTX Kubernetes Service` installation package and start the installation.
1. Wait for the `SMTX Kubernetes Service` installation to complete.

## Create a Workload Cluster

After installing SMTX Kubernetes Service, follow the steps below to create a workload cluster using `v1.26.x` K8s version:

1. Log in to the `CloudTower` UI through a browser, and jump to the `Kubernetes Service` page.
1. Click `Workload Cluster`, then click `+ Create Workload Cluster`.
1. Fill in the cluster information one by one, pay attention to select `v1.26.x` version when selecting `Kubernetes Version` in `Basic Information`, such as `v1.26.4(rocky-8.7-amd64-v1)`.
1. Finally click `Create` to create the workload cluster.
1. Wait for the workload cluster to become ready.

## Prepare for Conformance Test

After the Workload Cluster is ready, we need to do some preparatory work:

1. Log in to the `CloudTower` UI through a browser, and jump to the `Kubernetes Service` page. Find your cluster in `Workload Cluster`.
1. Click `···`, then click `Suspend Reconciliation` to Pause the reconciliation of the Workload Cluster.
1. Click `SKS Management`, `Management Cluster`, `Download Kubeconfig` in turn to Download Management Cluster kubeconfig file.
4. Connect to the Management Cluster and delete `k8tz` Addon. Take the cluster name as `sks-cluster` as an example:
```sh
$ kubectl delete addon sks-cluster-k8tz
```


## Run Conformance Test

1. Fetch Workload Cluster kubeconfig file and save it locally. Configure KUBECONFIG env:
```sh
$ export KUBECONFIG="/path/to/your/workload/cluster/kubeconfig/file"
```

2. Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the sonobuoy CLI, or build it yourself by running:
```sh
$ go get -u -v github.com/heptio/sonobuoy
```

3. Run sonobuoy:
```sh
$ sonobuoy run --mode=certified-conformance
```

4. Check the status:
```sh
$ sonobuoy status
```

5. Once the `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:
```sh
$ outfile=$(sonobuoy retrieve)
```

6. Extract the contents into `./results` with:
```sh
$ mkdir ./results; tar xzf $outfile -C ./results
```

7. Clean up Kubernetes objects created by Sonobuoy:
```sh
$ sonobuoy delete
```

## Recover the Workload Cluster

Unpause the reconciliation of the Workload Cluster on UI.
