# How to submit conformance results

## The tests

The standard set of conformance tests is currently those defined by the
`[Conformance]` tag in the
[kubernetes e2e](https://github.com/kubernetes/kubernetes/tree/master/test/e2e)
suite.

## Running

The standard tool for running these tests is
[sonobuoy](https://github.com/heptio/sonobuoy), and the standard way to run
these in your cluster is with `curl -L https://raw.githubusercontent.com/cncf/k8s-conformance/master/sonobuoy-conformance-1.7.yaml | kubectl apply -f -`.

Watch sonobuoy's logs with `kubectl logs -f -n sonobuoy sonobuoy` and wait for
the line `no-exit was specified, sonobuoy is now blocking`.  At this point, use
`kubectl cp` to bring the results to your local machine, expand the tarball, and
retain `plugins/e2e/results/{e2e.log,junit.xml}`.

## Uploading

Prepare a PR to
[https://github.com/cncf/k8s-conformance](https://github.com/cncf/k8s-conformance).
In the descriptions below, `X.Y` refers to the kubernetes major and minor
version, and `$dir` is a short subdirectory name to hold the results for your
product.  Examples would be `gke` or `openshift`.

Description: `Conformance results for vX.Y/$dir`

### Contents of the PR

```
vX.Y/$dir/README.md: A script or human-readable description of how to reproduce
your results.
vX.Y/$dir/version.txt: Test and cluster versions.
vX.Y/$dir/e2e.log: Test log output.
vX.Y/$dir/junit_01.xml: Machine-readable test log.
vX.Y/$dir/PRODUCT.yaml: See below.
```

#### PRODUCT.yaml

This file describes your product.  Please fill in these fields as appropriate.
Examples below are for a fictional Kubernetes implementation called _Turbo
Encabulator_ produced by a company named _Yoyodyne_.

```yaml
vendor: Yoyodyne
name: Turbo Encabulator
version: v1.7.4
website_url: https://yoyo.dyne/turbo-encabulator
documentation_url: https://yoyo.dyne/turbo-encabulator/docs
product_logo_url: https://yoyo.dyne/assets/turbo-encabulator.svg
```

Note: the `version` property is the version of your product, not the version of
Kubernetes being used.

### Sample PR

See https://github.com/mml/k8s-conformance/pull/1 for a sample.

## Amendment for Private Review

If you need a private review, please contact info@cncf.io.

## Review

A reviewer should be assigned to your PR shortly.  If you seek faster service,
please contact info@cncf.io.

## Issues

If you have problems certifying that you feel are an issue with the conformance
program itself (and not just your own configuration), you can file an issue in
the [repository](https://github.com/cncf/k8s-conformance). Questions and
comments can also be sent to the working group's 
[mailing list and slack channel](https://github.com/cncf/k8s-conformance/blob/master/README.md).
[SIG Architecture](https://github.com/kubernetes/community/tree/master/sig-architecture)
is the change controller of the conformance definition, we track a
[list of issue resolutions](issues.md) with SIG Architecture.
