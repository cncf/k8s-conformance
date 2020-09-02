# Conformance testing Agile Stacks Kubernetes Stack.

## To reproduce

### Create Kubernetes Cluster

- Login to [AgileStacks Console](https://controlplane.agilestacks.io)
- Create cloud account & enviroment or reuse existing one
- Select _Stacks_ -> _Clusters_ -> _Create_ -> _Kubernetes Cluster_
- Deploy kuberentes cluster, to get more detailed info please visit document [How to create a cluster](https://docs.agilestacks.com/category/6qo6gq9hay-start-here) for more details

### Run Conformance Test

- After _kuberbetes_ stack is created, go to the _stack_ page and select created stack
- Switch to _kubernetes_ tab and download kubeconfig and save it locally
- run:

```console
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance

$ sonobuoy retrieve ./results

# tar zxvf ./results/{XXX.tar.gz}
```

- To get more detailed info follow the conformance suite [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md) to test it.
