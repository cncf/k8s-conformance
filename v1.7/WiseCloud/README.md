+## To Reporduce: 
+
+ Install WiseCloud (base on Kubernetes 1.7.3)
+
+ Once installed, ssh into the cluster and run:
+
+'curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl apply -f -'
+
+ Watch Sonobuoy's logs with 'kubectl logs -f -n sonobuoy sonobuoy' follow the instruction.
+
+ Result is avaliable after we see the line 'no-exit was specified, sonobuoy is now blocking'
