# **CNCF Conformance Certification: Comarch Infraspace Managed Kubernetes**

This document provides step-by-step instructions on how to provision a conforming Kubernetes cluster on the Comarch Infraspace Cloud (CIC) platform and run the CNCF conformance test suite using Sonobuoy.

## **1\. Comarch Infraspace Cloud Signup and Login**

1. Sign up for a Comarch Infraspace Cloud account by visiting the official contact page:  
   [https://www.comarch.com/trade-and-services/ict/contact/](https://www.comarch.com/trade-and-services/ict/contact/).  
2. Once your enterprise account is verified, log in to your designated Comarch Infraspace platform deployment portal.  
3. Access the cloud API credentials or download your OpenStack clouds.yaml file from the API Access tab. Ensure your environment variables are set up correctly:bash source openstack.rc

## **2\. Cluster Creation**

Comarch Infraspace Managed Kubernetes leverages the OpenStack Container Orchestration Engine (COE) API for highly efficient provisioning.  
Run the following commands to create your conforming cluster:

### **Step 2.1: Create the Cluster Template**

Before instantiating the cluster, ensure you have a valid, registered cluster template matching the target Kubernetes version.

Bash  
\# Export the target Kubernetes version tag  
export KUBE\_TAG="v1.34.6"

\# Create the cluster using the template's UUID  
openstack coe cluster create \\  
  \--cluster-template $(openstack coe cluster template show \-c uuid \-f value k8s-${KUBE\_TAG}) \\  
  \--master-count 1 \\  
  \--node-count 2 \\  
  \--merge-labels \\  
  \--label audit\_log\_enabled=true \\  
  k8s-cluster

### **Step 2.2: Monitor Cluster Deployment**

Wait for the Comarch Infraspace infrastructure to completely provision and reach the active state :

Bash  
watch openstack coe cluster show k8s-cluster \-c status \-f value

*Wait until the command output displays CREATE\_COMPLETE before proceeding.*

### **Step 2.3: Retrieve Cluster Credentials**

Configure your local environment to interact with the freshly provisioned workload cluster:

Bash  
eval $(openstack coe cluster config k8s-cluster)

Verify cluster access and check node readiness:

Bash  
kubectl get nodes \-o wide

## **3\. Running the CNCF Conformance Test Suite**

Once the cluster is ready and functional, follow the instructions to run the conformance tests from CNCF:k8s-conformance [repo](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#running)

## **4\. Cleanup**

To clean up the temporary namespace and testing pods created by Sonobuoy :

Bash  
sonobuoy delete \--wait  

