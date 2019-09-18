# How to submit conformance results

## The tests

The standard set of conformance tests is currently those defined by the
`[Conformance]` tag in the
[kubernetes e2e](https://github.com/kubernetes/kubernetes/tree/master/test/e2e)
suite.

## Running

The standard tool for running these tests is
[Sonobuoy](https://github.com/heptio/sonobuoy).  Sonobuoy is 
regularly built and kept up to date to execute against all 
currently supported versions of kubernetes.

Download a [binary release](https://github.com/heptio/sonobuoy/releases) of the CLI, or build it yourself by running:

```
$ go get -u -v github.com/heptio/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
$ sonobuoy run --mode=certified-conformance
```

**NOTE:** The `--mode=certified-conformance` flag is required for certification runs since Kubernetes v1.16 (and Sonobuoy v0.16). Without this flag, tests which may be disruptive to your other workloads may be skipped. A valid certification run may not skip any conformance tests. If you're setting the test focus/skip values manually, certification runs require `E2E_FOCUS=\[Conformance\]` and no value for `E2E_SKIP`.

**NOTE:** You can run the command synchronously by adding the flag `--wait` but be aware that running the conformance tests can take an hour or more.

View actively running pods:

```
$ sonobuoy status 
```

To inspect the logs:

```
$ sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
$ outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/{e2e.log,junit.xml}**. 

To clean up Kubernetes objects created by Sonobuoy, run:

```
sonobuoy delete
```

## Uploading

Prepare a PR to
[https://github.com/cncf/k8s-conformance](https://github.com/cncf/k8s-conformance).
Here are [directions](https://help.github.com/en/articles/creating-a-pull-request-from-a-fork) to
prepare a pull request from a fork.
In the descriptions below, `X.Y` refers to the kubernetes major and minor
version, and `$dir` is a short subdirectory name to hold the results for your
product.  Examples would be `gke` or `openshift`.

Description: `Conformance results for vX.Y/$dir`

### Contents of the PR

For simplicity you can submit the tarball or extract the relevant information from the tarball to compose your submission. 

```
vX.Y/$dir/README.md: A script or human-readable description of how to reproduce
your results.
vX.Y/$dir/sonobuoy.tar.gz: Raw output from sonobuoy. (optional)
vX.Y/$dir/e2e.log: Test log output (from Sonobuoy).
vX.Y/$dir/junit_01.xml: Machine-readable test log (from Sonobuoy).
vX.Y/$dir/PRODUCT.yaml: See below.
```

#### PRODUCT.yaml

This file describes your product. It is YAML formatted with the following root-level fields. Please fill in as appropriate.

| Field               | Description |
| ------------------- | ----------- |
| `vendor`            | Name of the legal entity that is certifying. This entity must have a signed participation form on file with the CNCF  |
| `name`              | Name of the product being certified. |
| `version`           | The version of the product being certified (not the version of Kubernetes it runs). |
| `website_url`       | URL to the product information website |
| `repo_url`          | If your product is open source, this field is necessary to point to the primary GitHub repo containing the source. It's OK if this is a mirror. OPTIONAL  |
| `documentation_url` | URL to the product documentation |
| `product_logo_url`  | URL to the product's logo, (must be in SVG, AI or EPS format -- not a PNG -- and include the product name). OPTIONAL. If not supplied, we'll use your company logo. Please see logo [guidelines](https://github.com/cncf/landscape#logos) |
| `type`              | Is your product a distribution, hosted platform, or installer (see [definitions](https://github.com/cncf/k8s-conformance/blob/master/faq.md#what-is-a-distribution-and-what-is-a-platform)) |
| `description` | One sentence description of your offering |

Examples below are for a fictional Kubernetes implementation called _Turbo
Encabulator_ produced by a company named _Yoyodyne_.

```yaml
vendor: Yoyodyne
name: Turbo Encabulator
version: v1.7.4
website_url: https://yoyo.dyne/turbo-encabulator
repo_url: https://github.com/yoyo.dyne/turbo-encabulator
documentation_url: https://yoyo.dyne/turbo-encabulator/docs
product_logo_url: https://yoyo.dyne/assets/turbo-encabulator.svg
type: distribution
description: 'The Yoyodyne Turbo Encabulator is a superb Kubernetes distribution for all of your Encabulating needs.'
```

## Amendment for Private Review

If you need a private review for an unreleased product, please email a zip file containing what you would otherwise submit
as a pull request to conformance@cncf.io. We'll review and confirm that you are ready to be Certified Kubernetes
as soon as you open the pull request. We can then often arrange to accept your pull request soon after you make it, at which point you become Certified Kubernetes.

## Review

A reviewer will shortly comment on and/or accept your pull request, following this [process](reviewing.md).
If you don't see a response within 3 business days, please contact conformance@cncf.io.

## Example Script

Combining the steps provided here, the process looks like this:

```
$ k8s_version=vX.Y
$ prod_name=example

$ go get -u -v github.com/heptio/sonobuoy

$ sonobuoy run --mode=certified-conformance --wait
$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results

$ mkdir -p ./${k8s_version}/${prod_name}
$ cp ./results/plugins/e2e/results/* ./${k8s_version}/${prod_name}/ 

$ cat << EOF > ./${k8s_version}/${prod_name}/PRODUCT.yaml
vendor: Yoyodyne
name: Turbo Encabulator
version: v1.7.4
website_url: https://yoyo.dyne/turbo-encabulator
repo_url: https://github.com/yoyo.dyne/turbo-encabulator
documentation_url: https://yoyo.dyne/turbo-encabulator/docs
product_logo_url: https://yoyo.dyne/assets/turbo-encabulator.svg
type: distribution
description: 'The Yoyodyne Turbo Encabulator is a superb Kubernetes distribution for all of your Encabulating needs.'
EOF
```

## Issues

If you have problems certifying that you feel are an issue with the conformance
program itself (and not just your own implementation), you can file an issue in
the [repository](https://github.com/cncf/k8s-conformance). Questions and
comments can also be sent to the working group's 
[mailing list and slack channel](README-WG.md).
[SIG Architecture](https://github.com/kubernetes/community/tree/master/sig-architecture)
is the change controller of the conformance definition. We track a
[list of issue resolutions](https://github.com/cncf/k8s-conformance/issues/27) with SIG Architecture.
