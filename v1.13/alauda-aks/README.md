# Alauda Kubernetes (AKS)
An Enterprise-Ready Kubernetes Distribution
## To Reproduce
- [Sign up](https://enterprise.alauda.io/landing/register) for an account with Alauda.
- [Contact Alauda](mailto:hello@alauda.io) to activate the account.
- Follow the [instructions](http://developer.alauda.cn/usermanual/features/clustercreateawsprivate.html) to create a new cluster.
- Add at least one node to the cluster.
- Follow the [instructions](http://developer.alauda.cn/usermanual/features/clusterkubernetes.html) to deploy Kubernetes onto the cluster.
- [Get scanner command from heptio](https://scanner.heptio.com/) 
- Run the conformance tests.
  ```
  kubectl apply -f https://scanner.heptio.com/52292cce76141a59ed62733f932fd89f/yaml

  ```
- [Get your result](https://scanner.heptio.com/a6ece5bcb65fe4be7b2b6e8005181709/diagnostics/)
