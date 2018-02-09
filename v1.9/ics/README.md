To reproduce:

You'll first need to get access to the IBM Cloud Container Service and acquire the appropriate CLIs.
1) Sign up at https://bluemix.net
2) Follow this guide to set up your CLI environment: https://console.bluemix.net/docs/containers/cs_cli_install.html#cs_cli_install_steps
3) Follow the instructions below to create a cluster and run conformance tests.

```
% bx cs cluster-create --name conformance --kube-version 1.9
% bx cs cluster-get conformance

# Wait for the cluster and all worker nodes to reach "normal" state ...

% $(bx cs cluster-config conformance | grep export)
% curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
% kubectl logs -f -n sonobuoy sonobuoy

# Wait for "no-exit was specified, sonobuoy is now blocking" ...

% kubectl cp sonobuoy/sonobuoy:tmp/sonobuoy ./results
```
