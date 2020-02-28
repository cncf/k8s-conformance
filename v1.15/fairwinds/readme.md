To reproduce the test results, please perform the following on your cluster via kubectl. 

You must be on a 1.15.x cluster to perform these tests.

Once the cluster is deployed and in a ready state, you can run the conformance tests using kubectl: curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f - or Deploy with the sonobouy executable 