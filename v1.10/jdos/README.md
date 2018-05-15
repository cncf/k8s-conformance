### How To Reproduce:

#### Introduction
JDOS is Jingdong Datacenter OS for automated management of shared container clusters and containerized applications in a scalable and elastic manner. 
The key systems include ContainerFS, ContainerDNS and ContainerLB (https://github.com/tiglabs). You need to contact us to get the product.

#### Run Conformance Test
On one of the node, run command as below:


```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -

kubectl logs -f -n sonobuoy sonobuoy
```
Watch sonobuoy's logs with above command and wait for the line no-exit was specified, sonobuoy is now blocking. If this line appeared, it means the conformance test has been finished.

Use kubectl cp to bring the results to your local machine by the following command:


```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```

Expand the tarball, and retain plugins/e2e/results/{e2e.log,junit.xml} by below command:

```
cd results
tar xfz *_sonobuoy_*.tar.gz
```

### NOTICE:

Some of the docker images from gcr.io cannot be pulled in China, you need to configure a proxy for your docker deamon.
