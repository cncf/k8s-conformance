# Stratoscale Symphony 5.1.2

Symphony is the Stratoscale private cloud stack. Symphony gives you the ability to create an AWS-compatible on-prem private or public cloud within your own datacenter and on your own hardware.

## Installing Symphony 5.1.2 to reproduce the results

1. Deploy Symphony.[details](https://www.stratoscale.com/docs/deployment-and-installation/)
2. Deploy a Kubernetes Cluster on your Symphony deployment.[details](https://www.stratoscale.com/docs/Create-a-Kubernetes-Cluster/)

## Run Conformance Test

1. Download the stable version of Sonobuoy CLI

```
$ wget -qO- https://github.com/heptio/sonobuoy/releases/download/v0.11.6/sonobuoy_0.11.6_linux_amd64.tar.gz | tar xzv
```

2. Download the kubeernetes configuratio file from Symphony


3. Edit the downloaded configuration file to point to the cluster's external IP


4. Launch the conformance tests

```
$ sonobuoy run --kubeconfig <The location of the Downloaded config file>
```

Monitor the test running status:

```
$ sonobuoy status
```

To inspect the logs:

```
$ sonobuoy logs -f
```

Wait for `sonobuoy status` indicating the run as `completed`, retrieve the Conformance test result archive to a local directory

```
$ sonobuoy retrieve /path/to/report/target/directory
```

This command copies the `.tar.gz` archive to the `/path/to/report/target/directory` directory.

Optionally it is possible to clean up the Kubernetes objects created by Sonobuoy

```
sonobuoy delete
