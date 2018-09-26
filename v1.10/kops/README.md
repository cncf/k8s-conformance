To create cluster:

Using kops 1.10.0, with AWS account credentials configured:

```
kops create cluster test.k8s.local --zones us-east-1c --kubernetes-version 1.10.3
kops update cluster test.k8s.local
```


