# EKS (EasyStack Kubernetes Service)
EasyStack Kubernetes Service (EKS) Enterprise container platform contains the best of bred capability of an integrated Kubernetes and OpenStack solutions. Capabilities such as orchestration, scheduling, security, operations and maintenance, including many other aspects of management to achieve integration of application and infrastructure resources, enable last mile of cloud data center next generation application delivery, amplifying the resulting equation where 1 + 1 > 2
## Running the k8s conformance tests
Set your kubectl to point your CLI to the deployed EKS cluster or SSH to the node of EKS.
You can then run the k8s conformance test by running the following command:

```console
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance

$ sonobuoy retrieve ./results

# tar zxvf ./results/{XXX.tar.gz}
```
