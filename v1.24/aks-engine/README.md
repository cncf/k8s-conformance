# Kubernetes conformance tests on AKS-Engine


### Setup AKS-Engine cluster

Install AKS Engine based on https://github.com/Azure/aks-engine/blob/master/docs/tutorials/quickstart.md.

```console
curl -L -o aks-engine-darwin.tar.gz https://github.com/Azure/aks-engine/releases/download/v0.74.0/aks-engine-v0.74.0-darwin-amd64.tar.gz
```

Download the Kubernetes 1.24 install cluster definition.

```console
curl -o kubernetes1.24.json https://raw.githubusercontent.com/Azure/aks-engine/master/examples/kubernetes-releases/kubernetes1.24.json
```

Get the current Azure subscription ID.

```console
$ az login

$ SUBID=`az account list --all -o table |grep True |awk -F '  ' '{print $3}'`
```

Manually create a service principal.

```console
$ az ad sp create-for-rbac --skip-assignment
```

With the output of the command above set the CLIENTID and CLIENTSECRET from the appId and password fields respectively.

``` console
$ aks-engine deploy --subscription-id $SUBID \
    --client-id $CLIENTID --client-secret $CLIENTSECRET \
    --dns-prefix conformance --location westus2 \
    --auto-suffix --api-model kubernetes1.24.json
```

### Run conformance tests

Once the AKS-Engine cluster has been provisioned, connect to the cluster and commence the conformance test by following these steps:

```console
$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance

$ sonobuoy status

$ sonobuoy logs

$ sonobuoy retrieve ./results

# untar the tarball, then add plugins/e2e/results/global/{e2e.log,junit_01.xml}
```
