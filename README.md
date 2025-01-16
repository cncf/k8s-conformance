# Certified Kubernetes Conformance Program

All vendors are invited to submit conformance testing results for review and certification by the CNCF.
If your company provides software based on Kubernetes, we encourage you to get certified today.
For more information please checkout [cncf.io/ck](https://cncf.io/ck).

## Prepare

Learn about the [certification requirements](https://github.com/cncf/k8s-conformance/blob/master/terms-conditions/Certified_Kubernetes_Terms.md) and technical instructions to prepare your product for certification.

## Run the tests

The submission requires four files, two of which need to be generated from either of the following two applications.

### [Sonobuoy](https://sonobuoy.io/)

For a number of years Sonobuoy has been used to generate both the `e2e.log` and `junit_01.xml`.
Please follow the documentation provided in [instructions.md](https://github.com/cncf/k8s-conformance/blob/master/instructions.md).

### [Hydrophone](https://github.com/kubernetes-sigs/hydrophone)

A lightweight runner for kubernetes tests.
Uses the conformance image(s) released by the kubernetes release team to either run individual tests or the entire [Conformance suite](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/conformance-tests.md).
Check out the project [README](https://github.com/kubernetes-sigs/hydrophone/blob/main/README.md) to learn more.

## PR Submit

Please check the [instructions](https://github.com/cncf/k8s-conformance/blob/master/instructions.md#contents-of-the-pr) for details about how to prepare your PR.
Also, note that any submission made to this repo will need to first pass a number of checks that are verified by the [verify conformance bot](https://github.com/cncf-infra/verify-conformance) before its reviewed by the CNCF.

## Relocating Historical Conformance Files

In our ongoing effort to optimize the k8s-conformance repository size and enhance the user experience, we have relocated older conformance files to the [archive repository](https://github.com/cncf/k8s-conformance-archive).
This ensures smoother navigation and access to current content.
Details about how this was done can be found in the CNCF blog post, [Scaling down a Git repo. A tidy up of cncf/k8s-conformance](https://www.cncf.io/blog/2024/01/12/scaling-down-a-git-repo-a-tidy-up-of-cncf-k8s-conformance/).

## Helpful Resources

### [kubernetes/community: sig-architecture](https://github.com/kubernetes/community/tree/master/sig-architecture#conformance-definition-1)

Reviewing, approving, and driving changes to the conformance test suite; reviewing, guiding, and creating new conformance profiles.

- [Conformance Tests](https://github.com/kubernetes/kubernetes/blob/master/test/conformance/testdata/conformance.yaml)
- [Conformance Testing in Kubernetes](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/conformance-tests.md)

### [Conformance Tests per Release](https://github.com/cncf/k8s-conformance)

To help the Kubernetes community understand the range of tests required for a release to be conformant.
Each KubeConformance release document contains a list of conformance tests required for that release of Kubernetes.
Refer to [SIG-Architecture: Conformance Testing in Kubernetes](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/conformance-tests.md) for details around the testing requirements.

### [Verify conformance bot](https://github.com/cncf-infra/verify-conformance)

The bot checks several [scenarios](https://github.com/cncf-infra/verify-conformance/blob/main/kodata/features/verify-conformance.feature) and updates the PR with the results.
This automation provides timely feedback and reduces the time required by the CNCF to confirm that the PR meets all policy requirements.

### [APIsnoop](https://apisnoop.cncf.io/about)

APISnoop tracks the testing and conformance coverage of Kubernetes by analyzing the audit logs created by e2e test runs.
