# Conformance tests for SamsungSDS-Kubernetes-Service

## Install  SamsungSDS Kubernetes Service v1.21 (base on Kubernetes v1.21.1)

SamsungSDS Kubernetes Service is a kubernetes provisioner that auto-provisions a fully functioning hosted cluster for private Cloud Environment.

### Setup Cluster

Download installer file in our private repository 
```
$ tar -xvf sdspaas-1.21-r1.tar.gz
$ cd sdspaas-1.21-r1
```

Check command for sdspaas installer
```
$ ./sdspaas --help
```

Set configutaion and start Install in private Cloud.
```
$ ./sdspaas init cluster --config=config.yaml
```

Start Install addon in cluster
```
$ ./sdspaas init addon
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
gpu:
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
  type: single
  version: 1.21.1
  podCidr: <POD_IP Range|string>
  serviceCidr: <Service_IP Range|String>  
  ingressDomain: <domain_address|string>
  ingressEndpoint: <L4_address|string>
registry:
  isPrivate: <bool>
  name: <private_registry_address|string>
  ip: <private_registry_ip|string>
```

## Run Conformance Test

On the new kubernetes cluster run the Conformance tests using the following command : 

```
download latest sonobuoy (https://github.com/vmware-tanzu/sonobuoy/releases/tag/v0.50.0)
$ tar -zxvf sonobuoy_0.50.0_linux_amd64.tar.gz
$ cp sonobuoy /usr/bin/sonobuoy
$ sonobuoy run
```

Watch Sonobuoy's logs with:

```
$ kubectl logs -f [[POD_NAME]] -n sonobuoy e2e 
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then copy the results using docker cp command
