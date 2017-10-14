# To reproduce:

After installing Rancher 1.6.10, you’ll first need to create a new environment that has an environment template with the container orchestration set as Kubernetes, for more information about launching a Kubernetes environment in Rancher, please refer to http://rancher.com/docs/rancher/v1.6/en/kubernetes/

Navigate to the new environment, and then add several hosts in Rancher http://rancher.com/docs/rancher/v1.6/en/hosts/#adding-a-host.

## Get KubeConfig

To configure your own kubectl to talk to your newly created Kubernetes cluster, go to Kubernetes -> kubectl. Click on Generate Config to generate the necessary kube/config_file that you can download and add to your local directory.

## Launch E2E Conformance Tests

Launch the following command:
```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl apply -f -
```

After the test finishes you can copy the results from the test pod:

```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./results
```
