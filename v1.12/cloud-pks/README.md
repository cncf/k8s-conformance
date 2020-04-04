# VMware Cloud PKS

[VMware Cloud PKS](https://cloud.vmware.com/vmware-cloud-pks) is a cloud service that provides managed Kubernetes clusters. 

## Creating a VMware Cloud PKS Cluster
```
vke cluster create --name my-cluster --cluster-type PRODUCTION --region us-west-2 --privilegedMode 
```

## Creating a Kubernetes configuration file
```
vke cluster auth setup my-cluster
```

## Running the Kubernetes conformance tests
```
sonobuoy run --skip-preflight
```

The preflight checks are skipped because CoreDNS is run in a different
namespace (vke-system) than expected by the preflight checks. 
