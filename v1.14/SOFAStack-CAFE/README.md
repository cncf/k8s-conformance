## How to Reproduce

### Public Cloud - Hosted 

Login to [SOFAStack-CAFE](https://auth.cloud.alipay.com/) console page with your own Ant Financial Technology cloud account. In this case, the Kubernetes master & etcd are managed by the cloud.

Navigate to SOFAStack-CAFE-APaaS-Container Service product page, Create a Kubernetes cluster. Once cluster initialization has completed, copy or download environment config file to access tenant cluster. 

### Private Cloud - Distribution

SOFAStack-CAFE could be shipped in the form of distribution into private cloud or data-center. In this case, a Kubernetes-on-Kubernetes (KOK) architecture could be applied - Multiple "tenant clusters (K8S that running user workloads)" are managed and hosted by one "meta cluster (K8S that running tenant clusters' masters and ETCDs)".

In this type of distribution, the "tenant cluster" should be able to pass the conformance test with a latest version (v1.14 for this certification), but the "meta cluster" could be deployed with an internal stable version (e.g. v1.12).

This e2e test log was generated from a "tenant cluster".


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