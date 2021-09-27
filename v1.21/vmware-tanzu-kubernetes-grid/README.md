# To Reproduce:

## Deploy Tanzu Kubernetes Grid environment

Download the Tanzu CLI from vmware.com and set up a Tanzu Kubernetes Grid management cluster first:

```console
$ tanzu management-cluster create --ui
```

Set up a management cluster with the `production` plan (3 control plane, 3 worker nodes), once management cluster is up and running, deploy a workload cluster to run the CNCF conformance suite:

```console
$ tanzu cluster create tkg-conformance
```

Once the cluster is stood up, switch to the newly-created context with `kubectl config use-context <tkg-conformance context>`

## Deploy sonobuoy Conformance test

Follow the conformance suite instructions to test it.⏎
