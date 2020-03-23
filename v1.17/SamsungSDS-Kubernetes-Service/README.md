# Conformance tests for SamsungSDS-Kubernetes-Service

## Install  SamsungSDS Kubernetes Service v1.17 (base on Kubernetes v1.17.3)

SamsungSDS Kubernetes Service is a kubernetes provisioner that auto-provisions a fully functioning hosted cluster for Private Cloud Environment.

### Setup Cluster

Download installer file in our repository 
```
$ tar -xvf sdspaas-1.17-r1.tar.gz
$ cd sdspaas-1.17-r1
```

Check command for sdspaas installer
```
$ ./sdspaas --help
```

Set configutaion and start Install in private Cloud.
```
$ ./sdspaas init cluster --config=config.yaml
```

After install check cluster, node status
```
$ ./sdspaas postFlight
$ ./sdspaas nodeInfo
```

### config.yaml Description
```
masterEndpoint:
  ip: <master_l4_address|string>
master:
  ip: <address|string>
  names: <name|string>
proxy:
  ip: <address|string>
  names: <name|string>
system:
  ip: <address|string>
  names: <name|string>
worker:
  ip: <address|string>
  names: <name|string>
etcd:
  ip: <address|string>
  name: <address|string>
storage:
  ip: <address|string>
  path: <address|string>
  storageClassName: <name|string>
kubernetes:
  version: 1.17.3
  podCidr: <POD_IP Range|string>
  serviceCidr: <Service_IP Range|String>  
  ingressDomain: <domain_address|string>
registry:
  isPrivate: <bool>
  name: <private_registry_address|string>
```

### config.yaml example
```
masterEndpoint:
  ip: 70.121.224.181
master:
  ip: 70.121.224.182,70.121.224.183,70.121.224.184
  names: paasmst1,paasmst2,paasmst3
proxy:
  ip: 70.121.224.186,70.121.224.187,70.121.224.188
  names: paasprx1,paasprx2,paasprx3
system:
  ip: 70.121.224.194,70.121.224.195
  names: paassys1,paassys2
worker:
  ip: 70.121.224.189,70.121.224.190,70.121.224.191,70.121.224.192,70.121.224.193
  names: paaswkr1,paaswkr2,paaswkr3,paaswkr4,paaswkr5
etcd:
  ip: 70.121.224.182,70.121.224.183,70.121.224.184
  name: paasmst1,paasmst2,paasmst3
storage:
  ip: 70.121.224.196
  path: /mnt/nfs
  storageClassName: nfs-flex-sc-retain
kubernetes:
  version: 1.17.3
  podCidr: 10.96.0.0/12
  serviceCidr: 10.244.0.0/16  
  ingressDomain: sample.io
registry:
  isPrivate: false
  name: testRegistry.net
```


## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following command (use private yaml): 

```
kubectl apply -f sonobuoy.yaml
```

Watch Sonobuoy's logs with:

```
kubectl logs -f [[POD_NAME]] -n sonobuoy e2e 
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then copy the results using hostpath
