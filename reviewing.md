# How to review conformance results

  1. Make sure the list of files matches [the one specified here](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#contents-of-the-pr)
  2. Look at `version.txt`.  Make sure the `client` and `server` versions match each other to the minor version level.  Make sure this also matches the `vX.Y` subdirectory that the PR is in. Also confirm that Y >= 7 (that is, certification is available for Kubernetes versions 1.7 and higher).
  3. Verify that the last line of `e2e.log` says "SUCCESS! -- `N` Passed | 0 Failed | 0 Pending | `M` Skipped PASS".  The exact value of `N` and `M` don't matter as long as we see `0 Failed | 0 Pending`.
