# Alauda Cloud Enterprise (ACE) 
An Enterprise Platform-as-a-Service based on Kubernetes
## To Reproduce
- [Sign up](https://enterprise.alauda.io/landing/register) for an account with Alauda.
- [Contact Alauda](mailto:hello@alauda.io) to activate the account.
- Follow the [instructions](http://developer.alauda.cn/usermanual/features/clustercreateawsprivate.html) to create a new cluster.
- Add at least one node to the cluster.
- Follow the [instructions](http://developer.alauda.cn/usermanual/features/clusterkubernetes.html) to deploy Kubernetes onto the cluster.
- [Get scanner command from heptio](https://scanner.heptio.com/) 
- Run the conformance tests.
  ```
  kubectl apply -f https://scanner.heptio.com/b2396adffabaa957cffb5ea5286bca81/yaml/

  ```
- [Get your result](https://scanner.heptio.com/b2396adffabaa957cffb5ea5286bca81/diagnostics/)
