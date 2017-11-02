# How to review conformance results

## Technical Requirements

1. Verify that the list of files matches the
[expected list](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#contents-of-the-pr).

2. Note the `vX.Y` subdirectory that the PR is in, this is the version of
Kubernetes for which conformance is being claimed, referenced as the
"Conformance Version" from hereon.

3. Verify that the Conformance Version is the current or previous version of
Kubernetes.

4. Look at `version.txt`.  Verify that the `major.minor` component of the 
`server` version exactly matches the Conformance Version.

5. Look at `version.txt`.  Verify that the `major.minor` component of the 
`client` version (which represents the Kubernetes version of the e2e tests that
were run) is equal to or greater than the Conformance Version.

6. Verify that the last line of `e2e.log` says "SUCCESS! -- `N` Passed | 0
Failed | 0 Pending | `M` Skipped PASS".  The exact value of `N` and `M` don't
matter as long as we see `0 Failed | 0 Pending`.

When a submission meets all technical requirements, reply to the pull request
with a `+1` to indicate that the technical review is complete.

## Policy Requirements

Review the `PRODUCT.yaml` file, and:

1. Verify that there is a Participation Form on file for the `vendor`, and that
the vendor is in good standing in the program.

2. Verify the product `name` and `website_url` are listed in the
"Qualifying Offerings" section of the vendor's Participation Form, i.e. that
the `name` and `website_url` are listed. 

3. Review the `name`. If it contains the word "Kubernetes" in a non-descriptive
fashion, verify that the `name` is listed in "Participant Kubernetes
Combinations" section of the vendor's Participation Form.

When a submission meets all policy requirements, label the pull request
`participation-form-signed-yes` to indicate that the policy review is complete.

