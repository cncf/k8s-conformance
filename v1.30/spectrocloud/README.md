# Reproducing the test results:

## Deploy Spectro Cloud Cluster

1. Sign into Spectro Cloud console: https://console.spectrocloud.com.
2. Add your AWS cloud account
   - Navigate to _Tenant Settings_ > _Infrastructure_ > _Cloud Accounts_ from the main menu
   - Click on _Add AWS Account_
   - Specify your _AWS cloud credentials_
3. Deploy the cluster
   - Navigate to _Clusters_ from main menu
   - Click on _Add New Cluster_
   - Select _AWS IaaS_ as your _Infrastructure Provider_
   - Click on _Start AWS IaaS Configuration_		
   - For _Cluster name_ specify k8s1305 and choose your _Cloud Account_ created above for AWS. Click Next (cluster names need to be proper FQDN)
   - Click on _Add Cluster Profile_
   - Select pre-defined cluster profile _cncf_v1_30, click _Confirm_
   - Leave pack-parameters as-is, Click _Next_
   - Select _Region_ where you want to deploy. Select an _SSH Keypair Name_ available in the region. Click _Next_
   - For Master Pool - select instance type: t3.large, change _Number of nodes_ in the pool to 3
   - Select an _Instance Type_ and choose the _Availability Zones_
   - For Worker Pool - select instance type: t3.large, change _Number of nodes_ in the pool to 3
   - Select an _Instance Type_ and choose the _Availability Zones_. Click _Next_	
   - Click on _Validate_
   - If everything looks good, click on _Finish Configuration_
4. Wait for cluster running
   - Wait for Cluster status to become _Running_
   - Click on _Admin Kubeconfig file_ link in _Overview_ tab to download kubeconfig file

## Run conformance tests

Download the latest sonobuoy binary from the git releases

```
$ curl <sonobuoy_0.57.2_linux_amd64.tar.gz> -o sonobuoy_0.57.2_linux_amd64.tar.gz
$ tar zxvf sonobuoy_0.57.2_linx_amd64.tar.gz
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
