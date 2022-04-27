To create cluster:

Using a kops 1.15.x release, with AWS account credentials configured:

```
kops create cluster test.k8s.local --zones us-east-2a
kops update cluster test.k8s.local --yes
```
