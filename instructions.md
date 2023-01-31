# How to submit conformance results

## The tests

The standard set of conformance tests is currently those defined by the
`[Conformance]` tag in the
[kubernetes e2e](https://github.com/kubernetes/kubernetes/tree/master/test/e2e)
suite.

## Running

The standard tool for running these tests is
[Sonobuoy](https://github.com/vmware-tanzu/sonobuoy).  Sonobuoy is
regularly built and kept up to date to execute against all
currently supported versions of kubernetes.

Download a [binary release](https://github.com/vmware-tanzu/sonobuoy/releases) of the CLI, or build it yourself by running:

```
go get -u -v github.com/vmware-tanzu/sonobuoy
```

Deploy a Sonobuoy pod to your cluster with:

```
sonobuoy run --mode=certified-conformance
```

**NOTES:** 
 - The `--mode=certified-conformance` flag is required for certification runs since Kubernetes v1.16 (and Sonobuoy v0.16). Without this flag, tests which may be disruptive to your other workloads may be skipped. A valid certification run may not skip any conformance tests. If you're setting the test focus/skip values manually, certification runs require `E2E_FOCUS=\[Conformance\]` and no value for `E2E_SKIP`.

 - You can run the command synchronously by adding the flag `--wait` but be aware that running the conformance tests can take an hour or more.

 - There was an issue with versions v0.53.0 and v0.53.1. Details can be found in the Sonobuoy [docs](https://sonobuoy.io/docs/v0.53.1/issue1388/) on how to avoid or work around the issue.

View actively running pods:

```
sonobuoy status
```

To inspect the logs:

```
sonobuoy logs
```

Once `sonobuoy status` shows the run as `completed`, copy the output directory from the main Sonobuoy pod to a local directory:

```
outfile=$(sonobuoy retrieve)
```

This copies a single `.tar.gz` snapshot from the Sonobuoy pod into your local
`.` directory. Extract the contents into `./results` with:

```
mkdir ./results; tar xzf $outfile -C ./results
```

**NOTE:** The two files required for submission are located in the tarball under **plugins/e2e/results/global/{e2e.log,junit_01.xml}**.

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

If submitting test results for multiple versions, submit a PR for each product, ie. one PR for vX.Y results and a second PR for vX.Z

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

| Field                   | Description                                                                                                                                                                                                                               |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `vendor`                | Name of the legal entity that is certifying. This entity must have a signed participation form on file with the CNCF                                                                                                                      |
| `name`                  | Name of the product being certified.                                                                                                                                                                                                      |
| `version`               | The version of the product being certified (not the version of Kubernetes it runs).                                                                                                                                                       |
| `website_url`           | URL to the product information website                                                                                                                                                                                                    |
| `repo_url`              | If your product is open source, this field is necessary to point to the primary GitHub repo containing the source. It's OK if this is a mirror. OPTIONAL                                                                                  |
| `documentation_url`     | URL to the product documentation                                                                                                                                                                                                          |
| `product_logo_url`      | URL to the product's logo, (must be in SVG, AI or EPS format -- not a PNG -- and include the product name). OPTIONAL. If not supplied, we'll use your company logo. Please see logo [guidelines](https://github.com/cncf/landscape#logos) |
| `type`                  | Is your product a distribution, hosted platform, or installer (see [definitions](https://github.com/cncf/k8s-conformance/blob/master/faq.md#what-is-a-distribution-and-what-is-a-platform))                                               |
| `description`           | One sentence description of your offering                                                                                                                                                                                                 |
| `contact_email_address` | An email address which can be used to contact maintainers regarding the product submitted and updates to the submission process                                                                                                           |

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
description: "The Yoyodyne Turbo Encabulator is a superb Kubernetes distribution for all of your Encabulating needs."
contact_email_address : yoyodyne@turbo-encabulator.org
```

### Requirements

| No. | Scenario                                                                         | Updated Fail message                                                                                                                                                                                                                              | Fail           | Pass                                                                                           | Comments                                                                                                                           |
| --- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| 1   | PR title is not empty                                                            | it seems that there is no title set                                                                                                                                                                                                               | not-verifiable |                                                                                                | No further explanation needed                                                                                                      |
| 2   | submission contains all required files                                           | there seems to be some required files missing (https://github.com/cncf/k8s-conformance/blob/master/instructions.md#contents-of-the-pr)                                                                                                            | not-verifiable |                                                                                                | All the necessary files for the submission are present                                                                             |
| 3   | submission has files in structure of releaseversion/productname/                 | the submission file directory does not seem to match the Kubernetes release version in the files                                                                                                                                                  | not-verifiable |                                                                                                | Files are submitted to a unique directory for the specific product under a Kubernetes release version                              |
| 4   | submission is only one product                                                   | the submission seems to contain files of multiple Kubernetes release versions or products. Each Kubernetes release version and products should be submitted in a separate PRs                                                                     | not-verifiable |                                                                                                | No further explanation needed                                                                                                      |
| 5   | submission release version in title matches release version in folder structure  | the title of the submission does not seem to contain a Kubernetes release version that matches the release version in the submitted files                                                                                                         | not-verifiable |                                                                                                | The Kubernetes release version in the title of the PR should match the release version file directory to which the PR is submitted |
| 6   | the PRODUCT.yaml metadata contains all required fields                           | it appears that the PRODUCT.yaml file does not contain all the required fields (https://github.com/cncf/k8s-conformance/blob/master/instructions.md#productyaml)                                                                                  | not-verifiable |                                                                                                | The PRODUCT.yaml contain all required fields                                                                                       |
| 7   | the URL and email fields in the PRODUCT.yaml are valid                           | it appears that fields(s) in the PRODUCT.yaml aren't correctly formatted                                                                                                                                                                          | not-verifiable |                                                                                                | One or more URL keys in the PRODUCT.yaml are not valid formatted URLs                                                              |
| 8   | the URL fields in the PRODUCT.yaml resolve to their specified data types         | URL field 'FIELD' in PRODUCT.yaml resolving content type 'CONTENT_TYPE' must be (REQUIRED_CONTENT_TYPE)", field (https://github.com/cncf/k8s-conformance/blob/master/instructions.md#productyaml)                                                 | not-verifiable |                                                                                                | The URLs are resolving to the correct content                                                                                      |
| 9   | title of product submission contains Kubernetes release version and product name | the submission title is missing either a Kubernetes release version (v1.xx) or product name                                                                                                                                                       | not-verifiable |                                                                                                | Checking the PR title format                                                                                                       |
| 10  | the e2e.log output contains the Kubernetes release version                       | it seems the e2e.log does not contain the Kubernetes release version that match the submission title                                                                                                                                              | not-verifiable |                                                                                                | Matching the e2e.log release version with the PR title release version                                                             |
| 11  | the submission release version is a supported version of Kubernetes              | the Kubenetes release version in this pull request does not qualify for conformance submission anymore (https://github.com/cncf/k8s-conformance/blob/master/terms-conditions/Certified_Kubernetes_Terms.md#qualifying-offerings-and-self-testing) | not-verifiable |                                                                                                | Only the curre[nt release version and two version prior is supported for conformance certification                                 |
| 12  | all required conformance tests in the junit_01.xml are present                   | it appears that some tests are missing from the product submission                                                                                                                                                                                | not-verifiable | tests-verified-+KubernetesReleaseVersion                                                       |                                                                                                                                    |
| 13  | all tests pass in e2e.log                                                        | it appears that some tests failed in the product submission                                                                                                                                                                                       | not-verifiable | no-failed-tests-+KubernetesReleaseVersion                                                      |                                                                                                                                    |
| 14  | the tests in junit_01.xml and e2e.log match                                      | it appears that there is a mismatch of tests in junit_01.xml and e2e.log                                                                                                                                                                          | not-verifiable |                                                                                                | Verify that the junit_01.xml file and e2e.log file contain the same tests                                                          |
| 15  | there is only one commit                                                         | it appears that there is not exactly one commit. Please rebase and squash with `git rebase -i HEAD` (https://git-scm.com/docs/git-rebase)                                                                                                         | not-verifiable |                                                                                                | squash your commits and rebase                                                                                                     |
|     |                                                                                  |                                                                                                                                                                                                                                                   |                |                                                                                                |                                                                                                                                    |
|     | All requirements ($NUMBER) have passed for the submission!                       |                                                                                                                                                                                                                                                   | not-verifiable | - release-+KubernetesReleaseVersion, release-documents-checked, conformance-product-submission | The step will add the release+version & release-documents-checked labels once all $NUMBER check have passed                        |

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

$ go get -u -v github.com/vmware-tanzu/sonobuoy

$ sonobuoy run --mode=certified-conformance --wait
$ outfile=$(sonobuoy retrieve)
$ mkdir ./results; tar xzf $outfile -C ./results

$ mkdir -p ./${k8s_version}/${prod_name}
$ cp ./results/plugins/e2e/results/global/* ./${k8s_version}/${prod_name}/

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
