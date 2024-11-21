# Conformance testing De Novo's Kubernetes as a Service

## Ordering Cloud resources 

Sign up as an De Novo Cloud customer by registering at my.denovo.ua - after registering you will get the link with credentials to the CD organization.
Log in to your CD organization, navigate to 'More > Kubernetes Container Clusters' using the nav bar on the top.
Use the button 'NEW' to create Kubernetes cluster. Select v1.29 and appropriate cluster size.

## Running the conformance tests

Once the cluster state says 'Available' click the button that says 'Download Kube Config' and save to <path to kubeconfig>

```shell
export KUBECONFIG=<path to kubeconfig>
```

Download the latest release Sonobuoy package for your client platform.

Extract the tarball:
```shell
tar -xvf <RELEASE_TARBALL_NAME>.tar.gz
```

Move the extracted sonobuoy executable to somewhere on your PATH.

Run the conformance tests:

```shell
sonobuoy run --mode=certified-conformance
sonobuoy status
sonobuoy logs
```

Once `sonobuoy status` shows the run `completed`

```shell
outfile=$(sonobuoy retrieve)
mkdir ./results; tar xzf $outfile -C ./results
```
