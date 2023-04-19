# Chinatelecom Cloud Container Cloud Service Engine

## Create a CCSE cluster

Sign in Chinatelecom Cloud and navigate to [container service web console](https://www.ctyun.cn/products/10082691).
Select `Standard Kubernetes` cluster type and `v1.25.6` version, fill other required fields in the form and submit.


## Deploy sonobuoy Conformance test 

- After the creation completed, ssh to any node of cluster
- Download a binary release of the CLI, Refer to the following command to run：

```shell
sonobuoy run --mode=certified-conformance
```

See more in conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to test it.