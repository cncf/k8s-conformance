## How to Reproduce

### Login

Login to [SOFAStack-CAFE](https://auth.cloud.alipay.com/) console page with your own Ant Financial Technology cloud account.

### Create Kubernetes Cluster

Navigate to SOFAStack-CAFE-APaaS-Container Service product page, Create a Kubernetes cluster. Once cluster creation has completed, copy or download environment config file to access tenant cluster.

### Deploy sonobuoy Conformance test

SSH login to your node of your cluster, the kubectl is installed by default, but it is required to replace the default $HOME/.kube/config content with the kubeconfig copied above.

Run the Conformance tests using the following command:

```sh
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance.yaml | kubectl apply -f -
```

Watch Sonobuoy's logs with:

```
kubectl logs -f -n sonobuoy sonobuoy
```

Wait for the line `no-exit was specified, sonobuoy is now blocking`, and then copy the results using `kubectl cp`