### ArcherKE

ArcherKE is a cloud-native platform based on Kubernetes which developed by [ArcherOS](https://www.archeros.com/).

### How to Reproduce

#### Create Cluster

First install ArcherKE, and login to the console.
After successful login, select "Kubernetes Clusters > create" and config the create page.
The "Kubernetes Clusters" page will display all the kubernetes clusters created and managed by ArcherKE.

#### Run conformance Test by Sonobuoy

Login to the control-plant of the kubernetes cluster created by ArcherKE.

Start the conformance tests:

```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.10/sonobuoy_0.56.10_linux_amd64.tar.gz
tar -xvf sonobuoy_0.56.10_linux_amd64.tar.gz
mv sonobuoy /usr/bin
sonobuoy run --mode=certified-conformance
````

Monitor the conformance tests by tracking the sonobuoy logs, and wait for the line: "no-exit was specified, sonobuoy is now blocking"

```
sonobuoy logs -f
```

Retrieve result:

```
outfile=$(sonobuoy retrieve)
mkdir ./results;
tar xzf $outfile -C ./results
```
