# How to review conformance results

1. Verify that the list of files matches the
[expected list](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#contents-of-the-pr)

2. Note the `vX.Y` subdirectory that the PR is in, this is the version of
Kubernetes for which conformance is being claimed, referenced as the
"Conformance Version" from hereon.

3. Verify that the Conformance Version is the current or previous version of
Kubernetes.

4. Look at `version.txt`.  Verify that the `client` version matches the
Conformance Version to a minor version level (the patch version may differ).
`client` in this file represents the version of the e2e tests that were run.

5. Verify that the last line of `e2e.log` says "SUCCESS! -- `N` Passed | 0
Failed | 0 Pending | `M` Skipped PASS".  The exact value of `N` and `M` don't
matter as long as we see `0 Failed | 0 Pending`.
