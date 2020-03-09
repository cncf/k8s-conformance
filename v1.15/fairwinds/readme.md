To reproduce the test results, please perform the following on your cluster via kubectl. 

You must be on a 1.15.x cluster to perform these tests.

Installation Summary:
Infrastructure as Code deployed using KOPS using our best practices into a GKE/AWS/AZURE cluster - No special considerations or configurations to allow the conformance testing to pass. 

Once the cluster is deployed and in a ready state, you can run the conformance tests using kubectl: curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f - or Deploy with the sonobouy executable 