# To Reproduce:

## Deploy Tanzu Kubernetes Grid environment

Download the Tanzu Kubernetes Grid CLI from vmware.com and set up a Tanzu Kubernetes Grid management cluster first:

```console
$ tkg init --ui
```

Once the management cluster is set up, create a workload cluster with the `prod` plan (3 control plane, 3 worker nodes) to run the CNCF conformance suite:

```console
tkg create cluster tkg-conformance --plan prod
```

Once the cluster is stood up, switch to the newly-created context with `kubectl config use-context <tkg-conformance context>`

## Deploy sonobuoy Conformance test

Follow the conformance suite instructions to test it.