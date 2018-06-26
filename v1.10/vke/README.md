# VMware Kubernetes Engine (VKE)

[VMware Kubernetes Engine](https://cloud.vmware.com/vmware-kubernetes-engine/resources) is a cloud service that provides managed Kubernetes clusters. 


## Creating a VKE Kubernetes Cluster
```
vke cluster create --name my-cluster --template production --region us-west-2
```

Note: It is required that privileged pods for your cluster are enabled to pass conformance tests.

## Creating a Kubernetes configuration file
```
vke cluster merge-kubectl-auth my-cluster
```

## Running the Kubernetes conformance tests
```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f –
```
