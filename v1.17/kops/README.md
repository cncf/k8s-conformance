To create cluster:

Using a kops 1.17.x release, with AWS account credentials configured:

```
kops create cluster test.k8s.local --zones us-east-2a
# See https://github.com/kubernetes/test-infra/pull/14731
export KOPS_FEATURE_FLAGS=SpecOverrideFlag
kops set cluster test.k8s.local cluster.spec.nodePortAccess=0.0.0.0/0
kops update cluster test.k8s.local --yes
kops delete cluster test.k8s.local --yes
```
