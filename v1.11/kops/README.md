To create cluster:

Using kops 1.11.1, with AWS account credentials configured:

```
kops create cluster test.k8s.local --zones eu-central-1a,eu-central-1b,eu-central-1c
kops update cluster test.k8s.local --yes
```


