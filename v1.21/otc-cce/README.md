## Kubernetes conformance test on Open Telekom Cloud - Cloud Container Engine

### Setup CCE cluster

- Login to [OTC CCE](https://console.otc.t-systems.com/cce2.0) web console and create a CCE cluster
    * Select version `v1.21` of k8s
    * Make sure to use at least two worker nodes
    * Download kubectl configuration file and setup kubectl client
- Setup the conformance test
    * Download the latest release of [sonobuoy](https://github.com/vmware-tanzu/sonobuoy/releases/) tool
    * Follow the conformance [instructions](https://github.com/cncf/k8s-conformance/blob/32dcd214d1be11b00bee560e6a45ba82f67b5595/instructions.md)

### Run the conformance test

```console
$ sonobuoy run --mode=certified-conformance --kube-conformance-image-version v1.21
$ sonobuoy status
$ sonobuoy logs
$ outfile=$(sonobuoy retrieve)
$ sonobuoy results $outfile
