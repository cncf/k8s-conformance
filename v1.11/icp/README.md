# To reproduce:

## Create IBM Cloud Private Cluster
Install an IBM Cloud Private Enterprise Edition Cluster based on steps from [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.0/installing/installing.html).

## Config kubectl CLI

1) Config `kubectl` CLI based on steps [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.0/manage_cluster/cfc_cli.html) for how to access the IBM Cloud Private Cluster.

2) After the `kubectl` CLI configuration finished, you will find the KubeConfig under `$HOME/.kube` named as `config`.

A sample output is as following:

```
# pwd
/root/.kube
```

```
# cat config
apiVersion: v1
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://9.21.53.13:8001
  name: mycluster.icp
contexts:
- context:
    cluster: mycluster.icp
    namespace: default
    user: mycluster.icp-user
  name: mycluster.icp-context
current-context: mycluster.icp-context
kind: Config
preferences: {}
users:
- name: mycluster.icp-user
  user:
    token: eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF0X2hhc2giOiIyVVd1bV9kTEFxUWFTVHBWNUd3Sk53IiwiaXNzIjoiaHR0cHM6Ly9teWNsdXN0ZXIuaWNwOjk0NDMvb2lkYy9lbmRwb2ludC9PUCIsImF1ZCI6IjI2ZDkxOWNhZDAzYjBlMTU1NjgzZTM4NmI2ZGQ2YTY1IiwiZXhwIjoxNTA4MDczMTE1LCJpYXQiOjE1MDgwMjk5MTV9.kMD2bPATQMmwQFmyMQ2IFs0JIq0fPTtMA6qKbjGsT8euDdjqCklQMtRKuOmtxFbwn5rqJKyWtCc_BbmRnTMSjwIdL3jnOTH8JPVpQQmOlzrQMqfGk6VqMo4lSx_M-z8zbWgSzcfNDfJDbcvVIiYWVxDOmMl6bSAGmLTMCKXdXhyAacm8wsOECkiI7lQLayat2CyVz2q8ZGi_cWf0NSdo1YEUdtiuRYmiHYsY2allHsQDYQYHEPSJvLUpcpIuhZApARMQdToMgmWbllzMGGp6RKNKcwIibugumniCnmn2zj_8dq9Fgj4eZjN9is7N80ulZ5kofMDXXCKZiZ_XMjcnzQ
```

## Launch e2e Conformance Tests

1) Change default image policy of ICP cluster to allow all. Run the following command to update the image policy

```
kubectl edit clusterimagepolicy ibmcloud-default-cluster-image-policy
```

For exmaple, a wildcard (*) character is allowed in the repository name. You can also refer to [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.0/manage_images/image_security.html) for more detail.

```
    - name: "*"
```

2) Follow the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) here to run conformance test.
