# To reproduce:

## Create IBM Cloud Private Cluster
Install an IBM Cloud Private Community Edition Cluster based on steps from [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/installing/install_containers_CE.html).

## Get KubeConfig

Retrieve a `.config` file with administrator credentials on the cluster and set the environment variable `KUBECONFIG` following below steps:

1) Config `kubectl` CLI based on steps [here](https://www.ibm.com/support/knowledgecenter/SSBS6K_2.1.0/manage_cluster/cfc_cli.html) for how to access the IBM Cloud Private Cluster.

2) After the `kubectl` CLI configuration finished, you will find the KubeConfig under `$HOME/.kube` named as `config`.

A sample output is as following:

```
[root@ib17b03 .kube]# pwd
/root/.kube
```

```
[root@ib17b03 .kube]# cat config
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
3) Set the `KUBECONFIG` environment variable as `export KUBECONFIG=PATH_TO_KUBECONFIG`, for the above case, we can config it as:
```
export KUBECONFIG=/root/.kube/config
```

## Launch e2e Conformance Tests

1) Launch the e2e conformance test with following command, and this will launch a pod named as `sonobuoy` under namespace `sonobuoy`.
```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl apply -f -
```

2) Check logs of `sonobuoy` to see when this can be finished.

```
kubectl logs -f -n sonobuoy sonobuoy
```

3) Watch sonobuoy's logs with above command and wait for the line `no-exit was specified, sonobuoy is now blocking`. If this line appeared, it means the conformance test has been finished.

4) Use `kubectl cp` to bring the results to your local machine by the following command:
```
kubectl cp sonobuoy/sonobuoy:/tmp/sonobuoy ./result
```

5) Delete the conformance test resources:
```
curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl delete -f -
```

6) Expand the tarball, and retain `plugins/e2e/results/{e2e.log,junit.xml}` by below command:
```
cd results
tar xfz *_sonobuoy_*.tar.gz
```
