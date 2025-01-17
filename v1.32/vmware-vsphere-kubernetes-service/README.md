# Conformance testing vSphere Kubernetes Service

## Setup Cluster

In order to run the conformance, follow below steps. For more information you may refer [this page.](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-918803BD-123E-43A5-9843-250F3E20E6F2.html)

* Authenticate with Supervisor using kubectl.
    ``` shell
    kubectl vsphere login --server=SUPERVISOR-CONTROL-PLANE-IP-ADDRESS-or-FQDN --vsphere-username USERNAME
    ```

* Set the current context to target vSphere Namespace by using
  ```kubectl config use-context cluster-namespace```.
* List the virtual machine class bindings that are available in the target vSphere Namespace.
  ```kubectl get virtualmachineclassbindings``` If you do not see any VM classes, add default VM class to vSphere Namespace.
* List the available kubernetes versions using `kubectl get kr`.
* Create a file named `cluster.yaml` referring below to deploy the Kubernetes cluster.
```yaml
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
#define the cluster
metadata:
  #user-defined name of the cluster; string
  name: vks-conformance
  #kubernetes namespace for the cluster; string
  namespace: vks-cluster-ns
#define the desired state of cluster
spec:
  #specify the cluster network; required, there is no default
  clusterNetwork:
    #network ranges from which service VIPs are allocated
    services:
      #ranges of network addresses; string array
      #CAUTION: must not overlap with Supervisor
      cidrBlocks: ["198.51.100.0/12"]
    #network ranges from which Pod networks are allocated
    pods:
      #ranges of network addresses; string array
      #CAUTION: must not overlap with Supervisor
      cidrBlocks: ["192.0.2.0/16"]
    #domain name for services; string
    serviceDomain: "cluster.local"
  #specify the topology for the cluster
  topology:
    #name of the ClusterClass object to derive the topology
    class: builtin-generic-v3.3.0
    #kubernetes version of the cluster 
    version: v1.32.0---vmware.2-fips-vkr.1
    #describe the cluster control plane
    controlPlane:
      #number of control plane nodes
      #integer value 1 or 3
      #NOTE: Production clusters require 3 control plane nodes
      replicas: 3
    #describe the cluster worker nodes
    workers:
      #specifies parameters for a set of worker nodes in the topology
      machineDeployments:
        #node pool class used to create the set of worker nodes
        - class: node-pool
          #user-defined name of the node pool; string
          name: node-pool-1
          #number of worker nodes in this pool; integer 0 or more
          replicas: 6
    #customize the cluster
    variables:
      #virtual machine class type and size for cluster nodes
      - name: vmClass
        value: guaranteed-medium
      #persistent storage class for cluster nodes
      - name: storageClass
        value: vks-storage-policy
      # default storageclass for control plane and worker node pools
      - name: defaultStorageClass
        value: vks-storage-policy
  ```
* Provision the cluster by running the following command
  ``kubectl apply -f cluster.yaml``.
* Monitor the provisioning of the cluster.
  ```shell
  $ kubectl get cluster -n vks-cluster-ns
  NAMESPACE   NAME    CLUSTERCLASS             PHASE         AGE   VERSION
  vks-cluster-ns       vks-conformance   builtin-generic-v3.3.0   Provisioned   13m   v1.32.0+vmware.2-fips
  ```
* When the cluster Phase changes to Provisioned state, log in to the cluster using the vSphere Plugin for kubectl.
  ```shell
  kubectl vsphere login --server=SUPERVISOR-CONTROL-PLANE-IP-ADDRESS-or-FQDN \
  --vsphere-username USERNAME \
  --tanzu-kubernetes-cluster-name vks-conformance\
  --tanzu-kubernetes-cluster-namespace vks-cluster-ns
  ```
* Switch to the newly created cluster context.
  ``kubectl config use-context vks-conformance``.


## Deploy Sonobuoy Conformance test

[Download](https://github.com/vmware-tanzu/sonobuoy)  Sonobuoy binary release and follow the conformance suite instructions to run sonobuoy test.


### Run Sonobuoy e2e
```
./sonobuoy run --mode=certified-conformance
results=$(./sonobuoy retrieve)
mkdir ./results
tar xzf $results -C ./results
./sonobuoy e2e ${results}
```
Result are available in `results/plugins/e2e/results/global` directory. 