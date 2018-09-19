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

1) Download a binary release of the `sonobuoy` CLI,

```
go get -u -v github.com/heptio/sonobuoy
```

2) Change default image policy of ICP cluster to allow images from `gcr.io/heptio-images/*`. Run the following command to update the image policy

```
kubectl edit clusterimagepolicy ibmcloud-default-cluster-image-policy
```

For exmaple,

```
    - name: gcr.io/heptio-images/*
```

3) Launch the e2e conformance test with following command, and this will launch a pod named as `sonobuoy` under namespace `heptio-sonobuoy`.

```
sonobuoy gen | kubectl apply -f -
```

4) Check logs of `sonobuoy` to see when this can be finished.

```
kubectl logs -f -n heptio-sonobuoy sonobuoy
```

5) Watch sonobuoy's logs with above command and wait for the line `no-exit was specified, sonobuoy is now blocking`. If this line appeared, it means the conformance test has been finished.

6) Use `kubectl cp` to bring the results to your local machine by the following command:

```
kubectl cp heptio-sonobuoy/sonobuoy:/tmp/sonobuoy ./result
```

7) Delete the conformance test resources:
```
sonobuoy gen | kubectl delete -f -
```

8) Expand the tarball, and retain `plugins/e2e/results/{e2e.log,junit.xml}` by below command:

```
cd results
tar xfz *_sonobuoy_*.tar.gz
```
