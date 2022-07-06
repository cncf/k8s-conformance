# conformance test for IKS

## Prepare environment
1. Prepare a IXcloud account that can run kubernetes Cluster.
2. Add the IP of the host to which you want to connect ssh to the security group to connect to the Connector node that is created during cluster creation.
3. Additionally, add tenant network bands to the worker nodes and connector node security groups.


## Sonobuoy Test
```
$ wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.56.8/sonobuoy_0.56.8_linux_amd64.tar.gz

$ tar -xvf sonobuoy_0.56.8_linux_amd64.tar.gz

$ mv sonobuoy /usr/local/bin/

$ sonobuoy run --mode=certified-conformance

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
