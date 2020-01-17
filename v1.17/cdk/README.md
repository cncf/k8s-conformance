# Reproducing the test results

## Deploy CDK on AWS

On Ubuntu or any OS that supports Snap run the following:

```console
% sudo snap install juju --classic

# With AWS credentials in a default location (ie ~/.aws/credentials)
% juju autoload-credentials

Looking for cloud and credential information on local client...

1. aws credential "default" (new)
Select a credential to save by number, or type Q to quit: 1

% juju bootstrap aws
% juju deploy cs:~containers/charmed-kubernetes-372
% juju config kubernetes-master allow-privileged=true
% juju config kubernetes-worker allow-privileged=true
```

Note that the tests require privileged containers so we need to configure the
kubernetes master and workers appropriately.

Monitor the progress of the deployment using:

```console
% juju status
```

As soon as the deployment finalises you can fetch the kubeconfig:

```console
% juju scp kubernetes-master/0:config $HOME/.kube/
```

## Trigger the tests and get back the results

We follow the [official instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md):

```console
% export RBAC_ENABLED=$(kubectl api-versions | grep "rbac.authorization.k8s.io/v1beta1" -c)
% sonobuoy run --mode=certified-conformance --wait
% sonobuoy retrieve
```
