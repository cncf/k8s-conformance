# To reproduce

## Provision Cluster

Log into admin control dashboard using admin credentials.

**Procedure**

1.  In the left pane, click **Clusters**, and then click the **vSphere** tab. 

1. Click **NEW CLUSTER**.

1.  In the **Basic Information** screen, specify the following information:

    1. From the **INFRASTRUCTURE PROVIDER** drop-down list, choose the provider related to your Kubernetes cluster. 

    1. In the **KUBERNETES CLUSTER NAME** field, enter a name for your Kubernetes tenant cluster.
    
    1. In the **DESCRIPTION** field, enter a description for your cluster.
    
    1. From the **KUBERNETES VERSION** drop-down list, choose the version of Kubernetes that you want to use for creating the cluster. 

    1. If you are using ACI, specify the ACI profile. 

    1. Click **NEXT**. 


1.  In the **Provider Settings** screen, specify the following information: 

    1. From the **DATA CENTER** drop-down list, choose the data center that you want to use.

    1. From the **CLUSTERS** drop-down list, choose a  cluster. 
    
    1. From the **DATASTORE** drop-down list, choose a datastore.
    
        **Note:** Ensure that the datastore is accessible to the hosts in the cluster.

    1. From the **VM TEMPLATE** drop-down list, choose a VM template. 

    1. From the **NETWORK** drop-down list, choose a network.

        **Note:** 

        - Ensure that you select a subnet with an adequate number of free IP addresses. The selected network must have access to vCenter.

    1. From the **RESOURCE POOL** drop-down list, choose a resource pool.

    1. Click **NEXT**.

1.  In the **Node Configuration** screen, specify the following information:

    1. For v3 clusters, under **MASTER**, choose the number of master nodes, and their VCPU and memory configurations.

        **Note:** You may skip this step for v2 clusters. You can configure the number of master nodes only for v3 clusters. 

    1. Under **WORKER**, choose the number of worker nodes, and their VCPU and memory configurations.

    1. In the **SSH USER** field, enter the ssh user name. 
    
    1. In the **SSH KEY** field, enter the SSH public key that you want to use for creating the cluster. 

        **Note:** Ensure that you use the Ed25519 or ECDSA format for the public key. As RSA and DSA are less secure formats, Cisco prevents the use of these formats.

    1. In the **NUMBER OF LOAD BALANCERS** field, enter  the number of load balancer IP addresses for this cluster. 

    1. From the **SUBNET** drop-down list, choose the subnet that you want to use for this cluster.

    1. In the **POD CIDR** field, enter the IP addresses  for the pod subnet in the CIDR notation.

    1. In the **DOCKER HTTP PROXY** field, enter a proxy for the docker.

    1. In the **DOCKER HTTPS PROXY** field, enter an https proxy for the docker.

    1. In the **DOCKER BRIDGE IP** field, enter a valid CIDR to override the default Docker bridge.

    1. Under **DOCKER NO PROXY**, click **ADD NO PROXY**, and then specify a comma-separated list of hosts that you want to exclude from proxying.
    
    1. In the **VM USERNAME** field, enter the VM username that you want to use as the login for the VM.
         
    1. Under **NTP POOLS**, click **ADD POOL** to add a pool.

    1. Under **NTP SERVERS**, click **ADD SERVER** to add an NTP server.

    1. Under **ROOT CA REGISTRIES**, click **ADD REGISTRY** to add a root CA certificate to allow tenant clusters to securely connect to additional services.

    1. Under **INSECURE REGISTRIES**, click **ADD REGISTRY** to add docker registries created with unsigned certificates.

    1. For v2 clusters, under **ISTIO**, use the toggle button to enable or disable Istio.

    1. Click **NEXT**.

1. In the **Summary** screen, verify the configuration, and then click **FINISH**.

The cluster deployment takes a few minutes to complete. The newly created cluster is displayed on the **Clusters** screen.  Once cluster creation has completed, download environment config file to access tenant cluster.


## Launch E2E Conformance Tests

- SSH to the master node of the Kubernetes cluster
- Download sonobuoy and extract the binary
  - `wget https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.17.2/sonobuoy_0.17.2_linux_amd64.tar.gz`
  - `tar xvfz sonobuoy_0.17.2_linux_amd64.tar.gz`
- Run conformance tests
  - `./sonobuoy run --mode=certified-conformance`
- Check on test status
  - `./sonobuoy status`

