# Reproducing the test results:

## Deploy Spectro Cloud Cluster

1. Sign into Spectro Cloud console: https://console.spectrocloud.com.
1. Add your AWS cloud account
   - Navigate to _Settings_ > _Cloud Accounts_ from the main menu
   - Click on _Create new cloud account_
   - _Specify your AWS cloud credentials_
1. Deploy the cluster
   - Navigate to _Clusters_ from main menu
   - For Name specify c1 and click Next (cluster names need to be proper FQDN)
   - Select pre-defined cluster profile _cncf_v1_21, Next
   - Leave pack-parameters as-is, Next
   - Select your cloud account and designate region, Next
   - For Master Pool - select instance type: t3.large, change pool size to 3
   - For Worker Pool - select instance type: t3.large, change pool size to 3
   - Click _Next_
   - If everything looks good, click on _Deploy_
1. Wait for cluster running
   - Wait for Cluster status to become _Running_
   - Download Kubeconfig file from _Overview_ tab

## Run conformance tests

Install the git & golang software, then build the Sonobuoy tool by myself:
Download the latest sonobuoy from the git releases

```
$ go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to the Spectro Cloud Kubernetes cluster with:

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
$ outfile=$(sonobuoy retrieve)
```

Extract the `.tar.gz` contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

Clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```

Prepare the necessary documents and submit the PR according to [official guide - uploading](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#uploading).

Done! ☺️
