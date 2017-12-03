# gopaddle

goPaddle is a DevOps platform for Kubernetes developers. It simplifies the Kubernetes Service creation and maintenance through source to image conversion, build & version management, team management, access controls and audit logs, single click provision of Kubernetes Clusters across multiple clouds from a single console.
## How to Reproduce

## Set up the Cloud Platform

Follow the instructions here http://docs.gopaddle.io/docs/registering-an-aws-cloud-account/ to register an AWS account

## Set up the cluster

Follow the instructions here http://docs.gopaddle.io/docs/creating-a-kubernetes-cluster-on-aws/ to create an AWS Account in the "ap-southeast-1" region.

Note down the KeyName specified at the time of cluster creation in the cluster creation wizard. Once the cluster is created, note down the master IP address from the cluster listing page.

## Access the cluster master inorder to run the tests

1. Using the pem file associated with the KeyName and the master IP, SSH to the cluster master server. 

 ```console
 ssh -i <KeyName>.pem ubuntu@<masterip>
 ```

2. Once logged in to the master machine, by default the KUBECONFIG file will be available under /root/.kube/ folder. In order to deploy  e2e `sonobuoy` pod by executing the command below:

 ```console
 curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
 ```
 
3. Watch sonobuoy's logs using the kubectl command and wait for the line `no-exit was specified, sonobuoy is now blocking` to appear.

 ```console
 kubectl logs -f -n sonobuoy sonobuoy
 ```
 
4. Use `kubectl cp` to bring the results to the local environment.

 ```console
 kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy /home/result
 ```