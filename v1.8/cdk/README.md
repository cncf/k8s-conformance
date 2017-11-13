# Reproducing the test results

## Deploy CDK

Follow the instructions at https://jujucharms.com/docs to get access to a Juju controller.
In this particular case the e2e tests were run on VMs on AWS, so that involved:

```console
% juju bootstrap aws
% juju deploy canonical-kubernetes-117
% juju config kubernetes-master allow-privileged=true 
% juju config kubernetes-worker allow-privileged=true 
```

Note that the tests require privileged containers so we need to configure the kubernetes master and workers appropriately.

Monitor the progress of the deployment using:

```console
% juju status
```

As soon as the deployment finalises you can fetch the kubeconfig:

```console
% juju scp kubernetes-master/0:config ~/.kube/
```


## Prepare sonobuoy

We build the sonobuoy manifest from source, following the instructions https://github.com/heptio/sonobuoy

```console
% git clone git@github.com:heptio/sonobuoy.git
% export RBAC_ENABLED=$(kubectl api-versions | grep "rbac.authorization.k8s.io/v1beta1" -c)
% cd sonobuoy
% make generate
```

Edit `examples/quickstart.yaml` so as to include the conformance e2e tests (set E2E_FOCUS to: '\\[Conformance\\]').

## Trigger the tests and get back the results

Starting the tests is done by:

```console
% kubectl apply -f examples/quickstart.yaml
```

You can monitor the logs of the sonobuoy pod to see when the tests have finished:

```console
% kubectl logs sonobuoy -n heptio-sonobuoy -f
```

When the tests are over you can fetch the results:

```console
% kubectl cp heptio-sonobuoy/sonobuoy:/tmp/sonobuoy ./results
``` 
