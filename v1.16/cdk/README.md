# Reproducing the test results

## Deploy CDK

Follow the instructions at https://jujucharms.com/docs to get access to a Juju
controller. In this particular case the e2e tests were run on VMs on AWS, so
that involved:

```console
% juju bootstrap aws
% juju deploy cs:~containers/charmed-kubernetes-272
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
