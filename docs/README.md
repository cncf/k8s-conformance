# Conformance Tests per Release

## Summary

Each `KubeConformance` release document contains a list of conformance tests required for that release of Kubernetes.
The goal of these files is to help the Kubernetes community understand the range of tests required for a release to be conformant.
Refer to [SIG-Architecture: Conformance Testing in Kubernetes](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/conformance-tests.md) for details around the testing requirements.

## Generating Release Documents

The conformance test documentation can be generated using the script [gen-conformance-release-docs.sh](gen-conformance-release-docs.sh).
This script uses the code under [test/conformance](https://github.com/kubernetes/kubernetes/tree/master/test/conformance) in combination with a release branch of [kubernetes/kubernetes](https://github.com/kubernetes/kubernetes) to generate the final release document in this folder.
Only releases from 1.18 onwards can be created this way.

Before you run this, make sure your local Kubernetes repo is on a clean branch as the script will need to switch to the requested release branch.

An example of creating the documentation for release 1.21.

``` bash
cd k8s-conformance/docs
export KUBE_ROOT=$HOME/go/src/k8s.io/kubernetes
export VERSION=1.21
./gen-conformance-release-docs.sh 
```

Script output

```
KUBE_ROOT=/home/ii/go/src/k8s.io/kubernetes
VERSION=1.21
Note: switching to 'v1.21.0'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at cb303e613a1 Release commit for Kubernetes v1.21.0
* (HEAD detached at v1.21.0)
  master
+++ [0506 09:55:59] Building go targets for linux/amd64:
    vendor/github.com/onsi/ginkgo/ginkgo
    test/e2e/e2e.test
```
