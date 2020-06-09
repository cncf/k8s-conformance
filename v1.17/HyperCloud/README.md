# HyperCloud

## Create a Kubernetes Cluster
1. Prepare three nodes - one for `master node` and the others for `worker node`.
2. Create a Kubernetes cluster with the components below:
    * Kubernetes 1.17.6
    * CRI-O 1.17.4
    * Calico 3.13
    * Rook-Ceph 1.3.3
    * KubeVirt 0.27.0
    * CDI 1.11.0

## Run Conformance Tests
1. Download Sonobuoy(0.17.2)
```
wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.2/sonobuoy_0.17.2_linux_amd64.tar.gz
tar -xzf sonobuoy_0.17.2_linux_amd64.tar.gz
```
2. Run Sonobuoy
```
./sonobuoy run --mode=certified-conformance
```
3. Check the status
```
./sonobuoy status
```
4. Once `sonobuoy status` shows the run as `completed`, download the results tar.gz file
```
./sonobuoy retrieve
```
