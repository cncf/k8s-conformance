# Alauda EE
An Enterprise DevOps Success Platform based on Kubernetes.
## To Reproduce
- [Sign up](https://enterprise.alauda.io/landing/register) for an account with Alauda.
- [Contact Alauda](mailto:hello@alauda.io) to activate the account.
- Follow the [instructions](http://developer.alauda.cn/usermanual/features/clustercreateawsprivate.html) to create a new cluster.
- Add at least one node to the cluster.
- Follow the [instructions](http://developer.alauda.cn/usermanual/features/clusterkubernetes.html) to deploy Kubernetes onto the cluster.
- Run the conformance tests.
  ```
  curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl apply -f -
  ```
