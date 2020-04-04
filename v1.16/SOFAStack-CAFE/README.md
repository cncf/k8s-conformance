## How to Reproduce

### Create Kubernetes Cluster - Public Cloud - Hosted 

Login to [SOFAStack-CAFE](https://auth.cloud.alipay.com/) console page with your own Ant Financial Technology cloud account. In this case, the Kubernetes master & etcd are managed by the cloud.

To create a cluster:
1. Navigate to SOFAStack-CAFE-APaaS-Container Service product page
2. Select the target workspace
3. Create a Kubernetes cluster. 

### Create Kubernetes Cluster - Private Cloud - Distribution

SOFAStack-CAFE could be shipped in the form of distribution into private cloud or data-center. In this case, a Kubernetes-on-Kubernetes (KOK) architecture could be applied - Multiple "tenant clusters (K8S that running user workloads)" are managed and hosted by one "meta cluster (K8S that running tenant clusters' masters and ETCDs)".

In this type of distribution, the "tenant cluster" should be able to pass the conformance test with a latest version (v1.16 for this certification), but the "meta cluster" could be deployed with an internal stable version (e.g. v1.14).This e2e test log was generated from a "tenant cluster".

To create a tenant cluster:

1. Navigate to the Cluster View ("Captain") - Cluster Managerment
2. Create new "KOK" tenant cluster
3. Fill the required field like cluster name, dns setting, service subnet, network mode and etc.
4. Complete the node configurations and complete the cluster init process.

### Deploy sonobuoy Conformance test

Once cluster initialization has completed, copy or download environment config file to access tenant cluster. 

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